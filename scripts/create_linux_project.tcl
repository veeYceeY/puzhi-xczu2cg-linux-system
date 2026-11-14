# Linux-capable reference project for the PZ-ZU2CG with every board peripheral connected.
# Usage:  vivado -mode batch -source scripts/create_linux_project.tcl              # create project
#         vivado -mode batch -source scripts/create_linux_project.tcl -tclargs impl # + bitstream + XSA
# Project: projects/pz_zu2cg_linux (re-created on every run).
#
# PS (board preset): 4 GB DDR4, QSPI, eMMC, SD, GEM0 (MIO), USB 2.0/3.0, DisplayPort, PCIe/NVMe,
#   UART0/1, CAN0, TTC, watchdogs, MIO GPIO.  Added here: GEM1 over EMIO, 1 EMIO GPIO, 375 MHz PL clock 1.
# PL:
#   gmii_to_rgmii   PS GEM1 -> KSZ9031 PL PHY (RGMII/MDIO on bank 66). Core MDIO address 8, PHY address 2.
#   EMIO GPIO 0     PL PHY reset (active low)
#   axi_gpio        carrier LEDs, core LEDs, keys (irq), JM1 / J19 / J20 headers (tri-state, irq)
#   axi_iic         EEPROM I2C (irq)
#   ddr4            1 GB PL DDR4 MIG at 0x4_0000_0000
#   DP AUX          PS DisplayPort AUX/HPD over EMIO
# Interrupts go to pl_ps_irq0 in this order: keys, iic, jm1, j19, j20.

set here [file normalize [file dirname [info script]]]
set root [file normalize $here/..]
set_param board.repoPaths [list $root/board_files]

set proj_name pz_zu2cg_linux
set proj_dir $root/projects/$proj_name
create_project -force $proj_name $proj_dir -part xczu2cg-sfvc784-2-i
set_property board_part puzhitech.com:pz_zu2cg:part0:1.0 [current_project]
create_bd_design system

proc board_rule {iface pin} {
    set disp [get_property DISPLAY_NAME [get_board_part_interfaces $iface]]
    apply_bd_automation -rule xilinx.com:bd_rule:board -config [list Board_Interface "$iface ( $disp ) "] $pin
}

# --- PS ----------------------------------------------------------------------------
set ps [create_bd_cell -type ip -vlnv xilinx.com:ip:zynq_ultra_ps_e zynq_ultra_ps_e_0]
apply_bd_automation -rule xilinx.com:bd_rule:zynq_ultra_ps_e -config {apply_board_preset "1"} $ps
set_property -dict {
    CONFIG.PSU__ENET1__PERIPHERAL__ENABLE      1
    CONFIG.PSU__ENET1__PERIPHERAL__IO          EMIO
    CONFIG.PSU__ENET1__GRP_MDIO__ENABLE        1
    CONFIG.PSU__ENET1__GRP_MDIO__IO            EMIO
    CONFIG.PSU__GPIO_EMIO__PERIPHERAL__ENABLE  1
    CONFIG.PSU__GPIO_EMIO__PERIPHERAL__IO      1
    CONFIG.PSU__FPGA_PL1_ENABLE                1
    CONFIG.PSU__CRL_APB__PL1_REF_CTRL__FREQMHZ 375
    CONFIG.PSU__CRL_APB__PL1_REF_CTRL__SRCSEL  IOPLL
} $ps

# --- Board-interface peripherals ---------------------------------------------------
foreach {name iface irq} {
    gpio_led      led_5bits          0
    gpio_led_core led_core           0
    gpio_key      push_buttons_5bits 1
} {
    set c [create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio $name]
    set_property CONFIG.GPIO_BOARD_INTERFACE $iface $c
    board_rule $iface [get_bd_intf_pins $c/GPIO]
    if {$irq} { set_property CONFIG.C_INTERRUPT_PRESENT 1 $c }
}

set iic [create_bd_cell -type ip -vlnv xilinx.com:ip:axi_iic axi_iic_eeprom]
set_property CONFIG.IIC_BOARD_INTERFACE iic_eeprom $iic
board_rule iic_eeprom [get_bd_intf_pins $iic/IIC]

set mig [create_bd_cell -type ip -vlnv xilinx.com:ip:ddr4 ddr4_0]
board_rule ddr4_sdram     [get_bd_intf_pins ddr4_0/C0_DDR4]
board_rule sys_diff_clock [get_bd_intf_pins ddr4_0/C0_SYS_CLK]
board_rule reset          [get_bd_pins ddr4_0/sys_rst]

# --- Expansion headers as tri-state GPIO -------------------------------------------
# Bit i of <hdr>_tri_io is the i-th lowest constrained pin of that header in the
# master XDC; the generated pz_zu2cg_linux.xdc lists the mapping.
foreach {name width2} {jm1 0 j19 0 j20 16} {
    set c [create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio gpio_$name]
    set_property -dict [list CONFIG.C_GPIO_WIDTH 32 CONFIG.C_INTERRUPT_PRESENT 1] $c
    create_bd_intf_port -mode Master -vlnv xilinx.com:interface:gpio_rtl:1.0 $name
    connect_bd_intf_net [get_bd_intf_pins $c/GPIO] [get_bd_intf_ports $name]
    if {$width2} {
        set_property -dict [list CONFIG.C_IS_DUAL 1 CONFIG.C_GPIO2_WIDTH $width2] $c
        create_bd_intf_port -mode Master -vlnv xilinx.com:interface:gpio_rtl:1.0 ${name}_hi
        connect_bd_intf_net [get_bd_intf_pins $c/GPIO2] [get_bd_intf_ports ${name}_hi]
    }
}

# --- AXI-Lite / memory-mapped slaves on HPM0_FPD -----------------------------------
foreach {c s} {
    gpio_led       S_AXI
    gpio_led_core  S_AXI
    gpio_key       S_AXI
    axi_iic_eeprom S_AXI
    gpio_jm1       S_AXI
    gpio_j19       S_AXI
    gpio_j20       S_AXI
    ddr4_0         C0_DDR4_S_AXI
} {
    apply_bd_automation -rule xilinx.com:bd_rule:axi4 \
        -config [list Master /zynq_ultra_ps_e_0/M_AXI_HPM0_FPD Clk_master Auto Clk_slave Auto Clk_xbar Auto] \
        [get_bd_intf_pins $c/$s]
}

# --- PL Ethernet: PS GEM1 (EMIO) -> gmii_to_rgmii -> KSZ9031 -------------------------
set g2r [create_bd_cell -type ip -vlnv xilinx.com:ip:gmii_to_rgmii gmii_to_rgmii_0]
set_property -dict {CONFIG.SupportLevel Include_Shared_Logic_in_Core CONFIG.C_PHYADDR 8} $g2r
connect_bd_intf_net [get_bd_intf_pins $ps/GMII_ENET1] [get_bd_intf_pins $g2r/GMII]
connect_bd_intf_net [get_bd_intf_pins $ps/MDIO_ENET1] [get_bd_intf_pins $g2r/MDIO_GEM]
create_bd_intf_port -mode Master -vlnv xilinx.com:interface:rgmii_rtl:1.0 rgmii
create_bd_intf_port -mode Master -vlnv xilinx.com:interface:mdio_rtl:1.0 mdio
connect_bd_intf_net [get_bd_intf_pins $g2r/RGMII] [get_bd_intf_ports rgmii]
connect_bd_intf_net [get_bd_intf_pins $g2r/MDIO_PHY] [get_bd_intf_ports mdio]

# On ZU+ the core's MMCM and IDELAYCTRL expect clkin = 375 MHz (200 MHz puts the VCO out of range).
set rst_375 [create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset rst_pl_clk1_375M]
connect_bd_net [get_bd_pins $ps/pl_clk1] [get_bd_pins $g2r/clkin] [get_bd_pins $rst_375/slowest_sync_clk]
connect_bd_net [get_bd_pins $ps/pl_resetn0] [get_bd_pins $rst_375/ext_reset_in]
connect_bd_net [get_bd_pins $rst_375/peripheral_reset] [get_bd_pins $g2r/tx_reset] [get_bd_pins $g2r/rx_reset]

# PL PHY reset from EMIO GPIO 0 (Linux: reset-gpios = <&gpio 78 GPIO_ACTIVE_LOW>)
create_bd_port -dir O phy_reset_n
connect_bd_net [get_bd_pins $ps/emio_gpio_o] [get_bd_ports phy_reset_n]

# --- DisplayPort AUX over EMIO ------------------------------------------------------
foreach {port dir pin} {
    dp_aux_out O dp_aux_data_out
    dp_aux_oe  O dp_aux_data_oe_n
    dp_aux_in  I dp_aux_data_in
    dp_hpd     I dp_hot_plug_detect
} {
    create_bd_port -dir $dir $port
    connect_bd_net [get_bd_ports $port] [get_bd_pins $ps/$pin]
}

# --- Interrupts -----------------------------------------------------------------------
set irqs {gpio_key/ip2intc_irpt axi_iic_eeprom/iic2intc_irpt gpio_jm1/ip2intc_irpt gpio_j19/ip2intc_irpt gpio_j20/ip2intc_irpt}
set cc [create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat irq_concat]
set_property CONFIG.NUM_PORTS [llength $irqs] $cc
set i 0
foreach p $irqs { connect_bd_net [get_bd_pins $p] [get_bd_pins $cc/In$i]; incr i }
connect_bd_net [get_bd_pins $cc/dout] [get_bd_pins $ps/pl_ps_irq0]

assign_bd_address
validate_bd_design
save_bd_design

# --- Project constraints, generated from the master XDC -----------------------------
# Board interfaces (LEDs, keys, EEPROM, reset, PL DDR4, sys clock) are placed by the board flow.
# Here: RGMII/MDIO/PHY reset, DP AUX, and the headers renamed to GPIO bits.
set rename {dp_aux_out dp_aux_out dp_aux_oe dp_aux_oe dp_aux_in dp_aux_in dp_hpd dp_hpd
            phy_reset_n phy_reset_n mdio_mdc mdio_mdc mdio_mdio_io mdio_mdio_io}
set hdr {}
set lines {}
set f [open $root/constraints/pz_zu2cg_master.xdc]
while {[gets $f l] >= 0} {
    if {![regexp {^#(set_property -dict \{PACKAGE_PIN \S+\s+IOSTANDARD \S+\}) \[get_ports \{(\S+)\}\]} $l -> props port]} { continue }
    if {[regexp {^(jm1|j19|j20)\[(\d+)\]$} $port -> h pin]} {
        dict lappend hdr $h [list $pin $props]
    } elseif {[regexp {^rgmii_} $port] || [dict exists $rename $port]} {
        lappend lines "$props \[get_ports {$port}\]"
    }
}
close $f
foreach h {jm1 j19 j20} {
    lappend lines "" "## $h header: GPIO bit -> header pin"
    set i 0
    foreach e [lsort -integer -index 0 [dict get $hdr $h]] {
        lassign $e pin props
        if {$i < 32} { set p "${h}_tri_io\[$i\]" } else { set p "${h}_hi_tri_io\[[expr {$i - 32}]\]" }
        lappend lines "$props \[get_ports {$p}\]  ;# [string toupper $h]-$pin"
        # J19-9 (B5) is BITSLICE_0 of the bank-66 byte holding the RGMII RX IDELAYs, so it is
        # unavailable only during their start-up calibration (PDRC-203). Fine for a GPIO.
        if {$h eq "j19" && $pin == 9} {
            lappend lines "set_property UNAVAILABLE_DURING_CALIBRATION TRUE \[get_ports {$p}\]"
        }
        incr i
    }
}
set xdc $proj_dir/$proj_name.xdc
set fx [open $xdc w]
puts $fx "## Generated by scripts/create_linux_project.tcl from constraints/pz_zu2cg_master.xdc"
puts $fx [join $lines \n]
close $fx
add_files -fileset constrs_1 $xdc

# The gmii_to_rgmii core oversamples MDC on clkin; MDIO data is held for hundreds of ns around
# each MDC edge, so its path to the PS (mdio1_mdc_clock) is asynchronous, not a 4 ps transfer.
set timing_xdc $proj_dir/${proj_name}_timing.xdc
set fx [open $timing_xdc w]
puts $fx "## Generated by scripts/create_linux_project.tcl"
# The PS IP truncates the 374.996 MHz pl_clk1 to a 2.666 ns period (375.094 MHz). That mismatches the
# core's IDELAYE3 REFCLK_FREQUENCY (374.953 MHz, Timing 38-470) and puts the derived 125 MHz GMII TX
# clock 2 ps under the PS pin's 8.000 ns minimum period. 2.667 ns is the real period, rounded.
puts $fx {create_clock -name clk_pl_1 -period 2.667 [get_pins -hierarchical -filter {NAME =~ */zynq_ultra_ps_e_0/inst/PS8_i/PLCLK[1]}]}
puts $fx {set_clock_groups -asynchronous -group [get_clocks clk_pl_1] -group [get_clocks mdio1_mdc_clock]}
close $fx
add_files -fileset constrs_1 $timing_xdc
set_property PROCESSING_ORDER LATE [get_files $timing_xdc]
# Clocks it refers to only exist once the IP netlists are linked, so skip it in synthesis
set_property USED_IN_SYNTHESIS false [get_files $timing_xdc]

make_wrapper -files [get_files system.bd] -top -import

# IOPLL (1500 MHz) / 4 gives the 375 MHz gmii_to_rgmii needs; Vivado's default RPLL only reaches 355.6 MHz.
foreach c {pl_clk0 pl_clk1} {
    puts [format "%s: %.3f MHz" $c [expr {[get_property CONFIG.FREQ_HZ [get_bd_pins $ps/$c]] / 1e6}]]
}
if {abs([get_property CONFIG.FREQ_HZ [get_bd_pins $ps/pl_clk1]] - 375e6) > 0.5e6} { error "pl_clk1 is not 375 MHz" }

puts "PL address map:"
foreach s [lsort [get_bd_addr_segs -of [get_bd_addr_spaces $ps/Data]]] {
    puts [format "  %-40s 0x%010X  %s" [file tail $s] [get_property OFFSET $s] [get_property RANGE $s]]
}

if {[lindex $argv 0] eq "impl"} {
    launch_runs impl_1 -to_step write_bitstream -jobs 2
    wait_on_run impl_1
    if {[get_property PROGRESS [get_runs impl_1]] ne "100%"} { error "impl_1 failed" }
    write_hw_platform -fixed -include_bit -force $proj_dir/$proj_name.xsa
}
