// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2026 Advanced Micro Devices, Inc. All Rights Reserved.
// -------------------------------------------------------------------------------
// This file contains confidential and proprietary information
// of AMD and is protected under U.S. and international copyright
// and other intellectual property laws.
//
// DISCLAIMER
// This disclaimer is not a license and does not grant any
// rights to the materials distributed herewith. Except as
// otherwise provided in a valid license issued to you by
// AMD, and to the maximum extent permitted by applicable
// law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
// WITH ALL FAULTS, AND AMD HEREBY DISCLAIMS ALL WARRANTIES
// AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
// BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
// INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
// (2) AMD shall not be liable (whether in contract or tort,
// including negligence, or under any other theory of
// liability) for any loss or damage of any kind or nature
// related to, arising under or in connection with these
// materials, including for any direct, or any indirect,
// special, incidental, or consequential loss or damage
// (including loss of data, profits, goodwill, or any type of
// loss or damage suffered as a result of any action brought
// by a third party) even if such damage or loss was
// reasonably foreseeable or AMD had been advised of the
// possibility of the same.
//
// CRITICAL APPLICATIONS
// AMD products are not designed or intended to be fail-
// safe, or for use in any application requiring fail-safe
// performance, such as life-support or safety devices or
// systems, Class III medical devices, nuclear facilities,
// applications related to the deployment of airbags, or any
// other applications that could lead to death, personal
// injury, or severe property or environmental damage
// (individually and collectively, "Critical
// Applications"). Customer assumes the sole risk and
// liability of any use of AMD products in Critical
// Applications, subject only to applicable laws and
// regulations governing limitations on product liability.
//
// THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
// PART OF THIS FILE AT ALL TIMES.
//
// DO NOT MODIFY THIS FILE.

// MODULE VLNV: amd.com:blockdesign:system:1.0

`timescale 1ps / 1ps

`include "vivado_interfaces.svh"

module system_sv (
  (* X_INTERFACE_IGNORE = "true" *)
  output wire [4:0] led_5bits_tri_o,
  (* X_INTERFACE_IGNORE = "true" *)
  output wire [2:0] led_core_tri_o,
  (* X_INTERFACE_IGNORE = "true" *)
  input wire [4:0] push_buttons_5bits_tri_i,
  (* X_INTERFACE_IGNORE = "true" *)
  input wire iic_eeprom_scl_i,
  (* X_INTERFACE_IGNORE = "true" *)
  output wire iic_eeprom_scl_o,
  (* X_INTERFACE_IGNORE = "true" *)
  output wire iic_eeprom_scl_t,
  (* X_INTERFACE_IGNORE = "true" *)
  input wire iic_eeprom_sda_i,
  (* X_INTERFACE_IGNORE = "true" *)
  output wire iic_eeprom_sda_o,
  (* X_INTERFACE_IGNORE = "true" *)
  output wire iic_eeprom_sda_t,
  (* X_INTERFACE_IGNORE = "true" *)
  output wire ddr4_sdram_act_n,
  (* X_INTERFACE_IGNORE = "true" *)
  output wire [16:0] ddr4_sdram_adr,
  (* X_INTERFACE_IGNORE = "true" *)
  output wire [1:0] ddr4_sdram_ba,
  (* X_INTERFACE_IGNORE = "true" *)
  output wire ddr4_sdram_bg,
  (* X_INTERFACE_IGNORE = "true" *)
  output wire ddr4_sdram_ck_c,
  (* X_INTERFACE_IGNORE = "true" *)
  output wire ddr4_sdram_ck_t,
  (* X_INTERFACE_IGNORE = "true" *)
  output wire ddr4_sdram_cke,
  (* X_INTERFACE_IGNORE = "true" *)
  output wire ddr4_sdram_cs_n,
  (* X_INTERFACE_IGNORE = "true" *)
  inout wire [1:0] ddr4_sdram_dm_n,
  (* X_INTERFACE_IGNORE = "true" *)
  inout wire [15:0] ddr4_sdram_dq,
  (* X_INTERFACE_IGNORE = "true" *)
  inout wire [1:0] ddr4_sdram_dqs_c,
  (* X_INTERFACE_IGNORE = "true" *)
  inout wire [1:0] ddr4_sdram_dqs_t,
  (* X_INTERFACE_IGNORE = "true" *)
  output wire ddr4_sdram_odt,
  (* X_INTERFACE_IGNORE = "true" *)
  output wire ddr4_sdram_reset_n,
  (* X_INTERFACE_IGNORE = "true" *)
  input wire sys_diff_clock_clk_n,
  (* X_INTERFACE_IGNORE = "true" *)
  input wire sys_diff_clock_clk_p,
  (* X_INTERFACE_IGNORE = "true" *)
  input wire reset,
  (* X_INTERFACE_IGNORE = "true" *)
  input wire [31:0] jm1_tri_i,
  (* X_INTERFACE_IGNORE = "true" *)
  output wire [31:0] jm1_tri_o,
  (* X_INTERFACE_IGNORE = "true" *)
  output wire [31:0] jm1_tri_t,
  (* X_INTERFACE_IGNORE = "true" *)
  input wire [31:0] j19_tri_i,
  (* X_INTERFACE_IGNORE = "true" *)
  output wire [31:0] j19_tri_o,
  (* X_INTERFACE_IGNORE = "true" *)
  output wire [31:0] j19_tri_t,
  (* X_INTERFACE_IGNORE = "true" *)
  input wire [31:0] j20_tri_i,
  (* X_INTERFACE_IGNORE = "true" *)
  output wire [31:0] j20_tri_o,
  (* X_INTERFACE_IGNORE = "true" *)
  output wire [31:0] j20_tri_t,
  (* X_INTERFACE_IGNORE = "true" *)
  input wire [15:0] j20_hi_tri_i,
  (* X_INTERFACE_IGNORE = "true" *)
  output wire [15:0] j20_hi_tri_o,
  (* X_INTERFACE_IGNORE = "true" *)
  output wire [15:0] j20_hi_tri_t,
  (* X_INTERFACE_IGNORE = "true" *)
  input wire [3:0] rgmii_rd,
  (* X_INTERFACE_IGNORE = "true" *)
  input wire rgmii_rxc,
  (* X_INTERFACE_IGNORE = "true" *)
  input wire rgmii_rx_ctl,
  (* X_INTERFACE_IGNORE = "true" *)
  output wire [3:0] rgmii_td,
  (* X_INTERFACE_IGNORE = "true" *)
  output wire rgmii_txc,
  (* X_INTERFACE_IGNORE = "true" *)
  output wire rgmii_tx_ctl,
  (* X_INTERFACE_IGNORE = "true" *)
  output wire mdio_mdc,
  (* X_INTERFACE_IGNORE = "true" *)
  input wire mdio_mdio_i,
  (* X_INTERFACE_IGNORE = "true" *)
  output wire mdio_mdio_o,
  (* X_INTERFACE_IGNORE = "true" *)
  output wire mdio_mdio_t,
  (* X_INTERFACE_IGNORE = "true" *)
  output wire [0:0] phy_reset_n,
  (* X_INTERFACE_IGNORE = "true" *)
  output wire dp_aux_out,
  (* X_INTERFACE_IGNORE = "true" *)
  output wire dp_aux_oe,
  (* X_INTERFACE_IGNORE = "true" *)
  input wire dp_aux_in,
  (* X_INTERFACE_IGNORE = "true" *)
  input wire dp_hpd
);

  system inst (
    .led_5bits_tri_o(led_5bits_tri_o),
    .led_core_tri_o(led_core_tri_o),
    .push_buttons_5bits_tri_i(push_buttons_5bits_tri_i),
    .iic_eeprom_scl_i(iic_eeprom_scl_i),
    .iic_eeprom_scl_o(iic_eeprom_scl_o),
    .iic_eeprom_scl_t(iic_eeprom_scl_t),
    .iic_eeprom_sda_i(iic_eeprom_sda_i),
    .iic_eeprom_sda_o(iic_eeprom_sda_o),
    .iic_eeprom_sda_t(iic_eeprom_sda_t),
    .ddr4_sdram_act_n(ddr4_sdram_act_n),
    .ddr4_sdram_adr(ddr4_sdram_adr),
    .ddr4_sdram_ba(ddr4_sdram_ba),
    .ddr4_sdram_bg(ddr4_sdram_bg),
    .ddr4_sdram_ck_c(ddr4_sdram_ck_c),
    .ddr4_sdram_ck_t(ddr4_sdram_ck_t),
    .ddr4_sdram_cke(ddr4_sdram_cke),
    .ddr4_sdram_cs_n(ddr4_sdram_cs_n),
    .ddr4_sdram_dm_n(ddr4_sdram_dm_n),
    .ddr4_sdram_dq(ddr4_sdram_dq),
    .ddr4_sdram_dqs_c(ddr4_sdram_dqs_c),
    .ddr4_sdram_dqs_t(ddr4_sdram_dqs_t),
    .ddr4_sdram_odt(ddr4_sdram_odt),
    .ddr4_sdram_reset_n(ddr4_sdram_reset_n),
    .sys_diff_clock_clk_n(sys_diff_clock_clk_n),
    .sys_diff_clock_clk_p(sys_diff_clock_clk_p),
    .reset(reset),
    .jm1_tri_i(jm1_tri_i),
    .jm1_tri_o(jm1_tri_o),
    .jm1_tri_t(jm1_tri_t),
    .j19_tri_i(j19_tri_i),
    .j19_tri_o(j19_tri_o),
    .j19_tri_t(j19_tri_t),
    .j20_tri_i(j20_tri_i),
    .j20_tri_o(j20_tri_o),
    .j20_tri_t(j20_tri_t),
    .j20_hi_tri_i(j20_hi_tri_i),
    .j20_hi_tri_o(j20_hi_tri_o),
    .j20_hi_tri_t(j20_hi_tri_t),
    .rgmii_rd(rgmii_rd),
    .rgmii_rxc(rgmii_rxc),
    .rgmii_rx_ctl(rgmii_rx_ctl),
    .rgmii_td(rgmii_td),
    .rgmii_txc(rgmii_txc),
    .rgmii_tx_ctl(rgmii_tx_ctl),
    .mdio_mdc(mdio_mdc),
    .mdio_mdio_i(mdio_mdio_i),
    .mdio_mdio_o(mdio_mdio_o),
    .mdio_mdio_t(mdio_mdio_t),
    .phy_reset_n(phy_reset_n),
    .dp_aux_out(dp_aux_out),
    .dp_aux_oe(dp_aux_oe),
    .dp_aux_in(dp_aux_in),
    .dp_hpd(dp_hpd)
  );

endmodule
