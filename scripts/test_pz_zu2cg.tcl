# Smoke test for the PZ-ZU2CG board files.
# Usage:  vivado -mode batch -source scripts/test_pz_zu2cg.tcl
# Creates a throw-away project, applies the PS preset, connects the board
# interfaces (GPIO, I2C EEPROM, PL DDR4 MIG) and runs validate_bd_design.  Pass "impl" as tclarg to also build a bitstream:
#   vivado -mode batch -source scripts/test_pz_zu2cg.tcl -tclargs impl

set here [file normalize [file dirname [info script]]]
set_param board.repoPaths [list [file normalize $here/../board_files]]

set proj_dir [file normalize $here/../build/pz_zu2cg_test]
create_project -force pz_zu2cg_test $proj_dir -part xczu2cg-sfvc784-2-i
set_property board_part puzhitech.com:pz_zu2cg:part0:1.0 [current_project]

create_bd_design system

# PS with board preset
set ps [create_bd_cell -type ip -vlnv xilinx.com:ip:zynq_ultra_ps_e zynq_ultra_ps_e_0]
apply_bd_automation -rule xilinx.com:bd_rule:zynq_ultra_ps_e \
    -config {apply_board_preset "1"} $ps

# PL peripherals from board interfaces
foreach {name iface} {
    gpio_led      led_5bits
    gpio_led_core led_core
    gpio_key      push_buttons_5bits
} {
    set c [create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio $name]
    set_property CONFIG.GPIO_BOARD_INTERFACE $iface $c
    apply_bd_automation -rule xilinx.com:bd_rule:board -config [list Board_Interface "$iface ( [get_property DISPLAY_NAME [get_board_part_interfaces $iface]] ) "] [get_bd_intf_pins $c/GPIO]
}

set iic [create_bd_cell -type ip -vlnv xilinx.com:ip:axi_iic axi_iic_eeprom]
set_property CONFIG.IIC_BOARD_INTERFACE iic_eeprom $iic
apply_bd_automation -rule xilinx.com:bd_rule:board -config {Board_Interface "iic_eeprom ( EEPROM (I2C) ) "} [get_bd_intf_pins $iic/IIC]

# PL DDR4 (MIG): pins, 200 MHz system clock and reset all come from board interfaces
set mig [create_bd_cell -type ip -vlnv xilinx.com:ip:ddr4 ddr4_0]
foreach {iface pin} {
    ddr4_sdram     ddr4_0/C0_DDR4
    sys_diff_clock ddr4_0/C0_SYS_CLK
} {
    apply_bd_automation -rule xilinx.com:bd_rule:board -config [list Board_Interface "$iface ( [get_property DISPLAY_NAME [get_board_part_interfaces $iface]] ) "] [get_bd_intf_pins $pin]
}
apply_bd_automation -rule xilinx.com:bd_rule:board -config [list Board_Interface "reset ( [get_property DISPLAY_NAME [get_board_part_interfaces reset]] ) "] [get_bd_pins ddr4_0/sys_rst]

# Hook everything up to the PS over AXI
foreach c {gpio_led gpio_led_core gpio_key axi_iic_eeprom ddr4_0} {
    if {$c eq "ddr4_0"} { set s C0_DDR4_S_AXI } else { set s S_AXI }
    apply_bd_automation -rule xilinx.com:bd_rule:axi4 \
        -config [list Master /zynq_ultra_ps_e_0/M_AXI_HPM0_FPD Clk_master Auto Clk_slave Auto Clk_xbar Auto] \
        [get_bd_intf_pins $c/$s]
}

# DisplayPort AUX goes over EMIO: export the PS pins so the master XDC can place them
foreach p {dp_aux_data_in dp_aux_data_out dp_aux_data_oe_n dp_hot_plug_detect} {
    if {[llength [get_bd_pins -quiet $ps/$p]]} { make_bd_pins_external [get_bd_pins $ps/$p] }
}

validate_bd_design
save_bd_design

puts "PL DDR4: [get_property CONFIG.C0.DDR4_MemoryPart $mig] @ [get_property CONFIG.C0.DDR4_TimePeriod $mig] ps, x[get_property CONFIG.C0.DDR4_DataWidth $mig]"
puts "PS DDR: [get_property CONFIG.PSU__DDRC__DEVICE_CAPACITY $ps] x [get_property CONFIG.PSU__DDRC__BUS_WIDTH $ps]"
puts "PS MIO peripherals:"
foreach p {QSPI SD0 SD1 ENET0 UART0 UART1 CAN0 USB0} {
    puts [format "  %-6s %s" $p [get_property CONFIG.PSU__${p}__PERIPHERAL__IO $ps]]
}
puts [format "  %-6s root port, PERST# %s" PCIE [get_property CONFIG.PSU__PCIE__PERIPHERAL__ROOTPORT_IO $ps]]

if {[lindex $argv 0] eq "impl"} {
    make_wrapper -files [get_files system.bd] -top -import
    # Constrain the exported DP AUX ports
    set xdc [file normalize $proj_dir/dp_aux.xdc]
    set f [open $xdc w]
    puts $f {set_property -dict {PACKAGE_PIN H14 IOSTANDARD LVCMOS33} [get_ports dp_aux_data_in_0]}
    puts $f {set_property -dict {PACKAGE_PIN A15 IOSTANDARD LVCMOS33} [get_ports dp_aux_data_out_0]}
    puts $f {set_property -dict {PACKAGE_PIN B15 IOSTANDARD LVCMOS33} [get_ports dp_aux_data_oe_n_0]}
    puts $f {set_property -dict {PACKAGE_PIN H13 IOSTANDARD LVCMOS33} [get_ports dp_hot_plug_detect_0]}
    close $f
    add_files -fileset constrs_1 $xdc
    launch_runs impl_1 -to_step write_bitstream -jobs 2
    wait_on_run impl_1
    write_hw_platform -fixed -include_bit -force $proj_dir/pz_zu2cg_test.xsa
}
