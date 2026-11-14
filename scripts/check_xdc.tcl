# Check the master XDC by building a design that uses every pin in it.
# Usage:  vivado -mode batch -source scripts/check_xdc.tcl [-tclargs other.xdc]
# Uncomments every set_property/create_clock line of constraints/pz_zu2cg_master.xdc,
# generates a top level with one port per constrained pin (the differential system
# clock through IBUFDS/BUFG, all inputs XORed into a shift register that drives the
# outputs), runs the flow through write_bitstream and then checks that:
#   - no package pin is assigned twice
#   - every port is placed on its XDC ball with its XDC I/O standard
#   - report_drc is clean and timing is met
# Exits with status 1 on any failure.  Output goes to build/xdc_check.

set here [file normalize [file dirname [info script]]]
set xdc_in [file normalize $here/../constraints/pz_zu2cg_master.xdc]
if {[llength $argv]} { set xdc_in [file normalize [lindex $argv 0]] }
set out [file normalize $here/../build/xdc_check]
file mkdir $out

# Port names (without index) that the board drives from the FPGA; everything else is an input.
set outputs {led_core led rgmii_td rgmii_tx_ctl rgmii_txc mdio_mdc mdio_mdio_io phy_reset_n
             dp_aux_out dp_aux_oe iic_scl iic_sda}
set clk_p sys_clk_p
set clk_n sys_clk_n

# --- Parse the XDC -----------------------------------------------------------
set errors 0
set xdc_lines {}
set expected {}
array set ball_owner {}
array set width {}
set names {}
set f [open $xdc_in]
while {[gets $f l] >= 0} {
    if {[regexp {^#(set_property|create_clock) } $l]} { lappend xdc_lines [string range $l 1 end] }
    if {![regexp {^#set_property -dict \{PACKAGE_PIN (\S+)\s+IOSTANDARD (\S+)\} \[get_ports \{(\S+)\}\]} $l -> ball std port]} { continue }
    if {[info exists ball_owner($ball)]} {
        puts "CHECK FAIL: ball $ball used by both $ball_owner($ball) and $port"
        incr errors
    }
    set ball_owner($ball) $port
    lappend expected [list $port $ball $std]
    if {[regexp {^(\w+)\[(\d+)\]$} $port -> name idx]} {
        if {![info exists width($name)] || $idx + 1 > $width($name)} { set width($name) [expr {$idx + 1}] }
    } else {
        set name $port
        set width($name) 0
    }
    if {[lsearch -exact $names $name] < 0} { lappend names $name }
}
close $f
puts "CHECK: [llength $expected] pin assignments, [llength $xdc_lines] constraint lines"

set fx [open $out/full.xdc w]
puts $fx [join $xdc_lines \n]
close $fx

# --- Generate the test top level -----------------------------------------------
set decl [list "  input  $clk_p" "  input  $clk_n"]
set in_bits {}
set out_bits {}
foreach name $names {
    if {$name eq $clk_p || $name eq $clk_n} { continue }
    set rng [expr {$width($name) ? "\[[expr {$width($name) - 1}]:0\] " : ""}]
    set bits {}
    foreach e $expected {
        set p [lindex $e 0]
        if {$p eq $name || [string match "${name}\\\[*" $p]} { lappend bits $p }
    }
    if {[lsearch -exact $outputs $name] >= 0} {
        lappend decl "  output $rng$name"
        lappend out_bits {*}$bits
    } else {
        lappend decl "  input  $rng$name"
        lappend in_bits {*}$bits
    }
}
set n_out [llength $out_bits]
set v [list "module top(" [join $decl ",\n"] ");" \
    "  wire clk_ibuf, clk;" \
    "  IBUFDS u_ibufds (.I($clk_p), .IB($clk_n), .O(clk_ibuf));" \
    "  BUFG   u_bufg   (.I(clk_ibuf), .O(clk));" \
    "  reg \[[expr {$n_out - 1}]:0\] r;" \
    "  wire x = ^{[join $in_bits {, }]};" \
    "  always @(posedge clk) r <= {r\[[expr {$n_out - 2}]:0\], x};"]
set i 0
foreach b $out_bits { lappend v "  assign $b = r\[$i\];"; incr i }
lappend v "endmodule"
set fv [open $out/top.v w]
puts $fv [join $v \n]
close $fv
puts "CHECK: test top has [llength $in_bits] inputs, $n_out outputs, differential clock $clk_p/$clk_n"

# --- Build ---------------------------------------------------------------------
read_verilog $out/top.v
read_xdc $out/full.xdc
synth_design -top top -part xczu2cg-sfvc784-2-i -quiet
opt_design -quiet
place_design -quiet
route_design -quiet

# --- Check -----------------------------------------------------------------------
foreach e $expected {
    lassign $e p ball std
    set q [get_ports -quiet $p]
    if {$q eq ""} { puts "CHECK FAIL: port $p missing from the design"; incr errors; continue }
    set got_ball [get_property PACKAGE_PIN $q]
    set got_std [get_property IOSTANDARD $q]
    if {$got_ball ne $ball || $got_std ne $std} {
        puts "CHECK FAIL: $p wants $ball/$std, got $got_ball/$got_std"
        incr errors
    }
}

report_drc -file $out/drc.rpt
report_io -file $out/io.rpt
report_timing_summary -file $out/timing.rpt
set drc [get_drc_violations -quiet]
if {[llength $drc]} {
    puts "CHECK FAIL: [llength $drc] DRC findings, see $out/drc.rpt"
    incr errors
}
set wns [get_property SLACK [get_timing_paths -max_paths 1 -setup]]
set whs [get_property SLACK [get_timing_paths -max_paths 1 -hold]]
if {$wns < 0 || $whs < 0} { puts "CHECK FAIL: timing not met (WNS $wns, WHS $whs)"; incr errors }

array set bank_stds {}
foreach e $expected {
    set bank [get_property BANK [get_package_pins [lindex $e 1]]]
    lappend bank_stds($bank) [lindex $e 2]
}
foreach bank [lsort -integer [array names bank_stds]] {
    puts [format "CHECK: bank %-3s %3d pins  %s" $bank [llength $bank_stds($bank)] [lsort -unique $bank_stds($bank)]]
}

if {[catch {write_bitstream -force $out/xdc_check.bit} msg]} {
    puts "CHECK FAIL: write_bitstream: $msg"
    incr errors
}

if {$errors} {
    puts "CHECK RESULT: FAIL ($errors problems)"
    exit 1
}
puts "CHECK RESULT: PASS ([llength $expected] pins, WNS $wns ns)"
