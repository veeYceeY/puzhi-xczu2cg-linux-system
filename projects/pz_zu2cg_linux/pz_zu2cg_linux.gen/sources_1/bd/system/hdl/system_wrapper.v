//Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
//Copyright 2022-2026 Advanced Micro Devices, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2026.1 (lin64) Build 6511674 Tue Jun 16 11:01:26 MDT 2026
//Date        : Fri Nov 13 23:45:08 2026
//Host        : scimos-System-Product-Name running 64-bit Ubuntu 26.04.1 LTS
//Command     : generate_target system_wrapper.bd
//Design      : system_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module system_wrapper
   (ddr4_sdram_act_n,
    ddr4_sdram_adr,
    ddr4_sdram_ba,
    ddr4_sdram_bg,
    ddr4_sdram_ck_c,
    ddr4_sdram_ck_t,
    ddr4_sdram_cke,
    ddr4_sdram_cs_n,
    ddr4_sdram_dm_n,
    ddr4_sdram_dq,
    ddr4_sdram_dqs_c,
    ddr4_sdram_dqs_t,
    ddr4_sdram_odt,
    ddr4_sdram_reset_n,
    dp_aux_in,
    dp_aux_oe,
    dp_aux_out,
    dp_hpd,
    iic_eeprom_scl_io,
    iic_eeprom_sda_io,
    j19_tri_io,
    j20_hi_tri_io,
    j20_tri_io,
    jm1_tri_io,
    led_5bits_tri_o,
    led_core_tri_o,
    mdio_mdc,
    mdio_mdio_io,
    phy_reset_n,
    push_buttons_5bits_tri_i,
    reset,
    rgmii_rd,
    rgmii_rx_ctl,
    rgmii_rxc,
    rgmii_td,
    rgmii_tx_ctl,
    rgmii_txc,
    sys_diff_clock_clk_n,
    sys_diff_clock_clk_p);
  output ddr4_sdram_act_n;
  output [16:0]ddr4_sdram_adr;
  output [1:0]ddr4_sdram_ba;
  output ddr4_sdram_bg;
  output ddr4_sdram_ck_c;
  output ddr4_sdram_ck_t;
  output ddr4_sdram_cke;
  output ddr4_sdram_cs_n;
  inout [1:0]ddr4_sdram_dm_n;
  inout [15:0]ddr4_sdram_dq;
  inout [1:0]ddr4_sdram_dqs_c;
  inout [1:0]ddr4_sdram_dqs_t;
  output ddr4_sdram_odt;
  output ddr4_sdram_reset_n;
  input dp_aux_in;
  output dp_aux_oe;
  output dp_aux_out;
  input dp_hpd;
  inout iic_eeprom_scl_io;
  inout iic_eeprom_sda_io;
  inout [31:0]j19_tri_io;
  inout [15:0]j20_hi_tri_io;
  inout [31:0]j20_tri_io;
  inout [31:0]jm1_tri_io;
  output [4:0]led_5bits_tri_o;
  output [2:0]led_core_tri_o;
  output mdio_mdc;
  inout mdio_mdio_io;
  output [0:0]phy_reset_n;
  input [4:0]push_buttons_5bits_tri_i;
  input reset;
  input [3:0]rgmii_rd;
  input rgmii_rx_ctl;
  input rgmii_rxc;
  output [3:0]rgmii_td;
  output rgmii_tx_ctl;
  output rgmii_txc;
  input sys_diff_clock_clk_n;
  input sys_diff_clock_clk_p;

  wire ddr4_sdram_act_n;
  wire [16:0]ddr4_sdram_adr;
  wire [1:0]ddr4_sdram_ba;
  wire ddr4_sdram_bg;
  wire ddr4_sdram_ck_c;
  wire ddr4_sdram_ck_t;
  wire ddr4_sdram_cke;
  wire ddr4_sdram_cs_n;
  wire [1:0]ddr4_sdram_dm_n;
  wire [15:0]ddr4_sdram_dq;
  wire [1:0]ddr4_sdram_dqs_c;
  wire [1:0]ddr4_sdram_dqs_t;
  wire ddr4_sdram_odt;
  wire ddr4_sdram_reset_n;
  wire dp_aux_in;
  wire dp_aux_oe;
  wire dp_aux_out;
  wire dp_hpd;
  wire iic_eeprom_scl_i;
  wire iic_eeprom_scl_io;
  wire iic_eeprom_scl_o;
  wire iic_eeprom_scl_t;
  wire iic_eeprom_sda_i;
  wire iic_eeprom_sda_io;
  wire iic_eeprom_sda_o;
  wire iic_eeprom_sda_t;
  wire [0:0]j19_tri_i_0;
  wire [1:1]j19_tri_i_1;
  wire [10:10]j19_tri_i_10;
  wire [11:11]j19_tri_i_11;
  wire [12:12]j19_tri_i_12;
  wire [13:13]j19_tri_i_13;
  wire [14:14]j19_tri_i_14;
  wire [15:15]j19_tri_i_15;
  wire [16:16]j19_tri_i_16;
  wire [17:17]j19_tri_i_17;
  wire [18:18]j19_tri_i_18;
  wire [19:19]j19_tri_i_19;
  wire [2:2]j19_tri_i_2;
  wire [20:20]j19_tri_i_20;
  wire [21:21]j19_tri_i_21;
  wire [22:22]j19_tri_i_22;
  wire [23:23]j19_tri_i_23;
  wire [24:24]j19_tri_i_24;
  wire [25:25]j19_tri_i_25;
  wire [26:26]j19_tri_i_26;
  wire [27:27]j19_tri_i_27;
  wire [28:28]j19_tri_i_28;
  wire [29:29]j19_tri_i_29;
  wire [3:3]j19_tri_i_3;
  wire [30:30]j19_tri_i_30;
  wire [31:31]j19_tri_i_31;
  wire [4:4]j19_tri_i_4;
  wire [5:5]j19_tri_i_5;
  wire [6:6]j19_tri_i_6;
  wire [7:7]j19_tri_i_7;
  wire [8:8]j19_tri_i_8;
  wire [9:9]j19_tri_i_9;
  wire [0:0]j19_tri_io_0;
  wire [1:1]j19_tri_io_1;
  wire [10:10]j19_tri_io_10;
  wire [11:11]j19_tri_io_11;
  wire [12:12]j19_tri_io_12;
  wire [13:13]j19_tri_io_13;
  wire [14:14]j19_tri_io_14;
  wire [15:15]j19_tri_io_15;
  wire [16:16]j19_tri_io_16;
  wire [17:17]j19_tri_io_17;
  wire [18:18]j19_tri_io_18;
  wire [19:19]j19_tri_io_19;
  wire [2:2]j19_tri_io_2;
  wire [20:20]j19_tri_io_20;
  wire [21:21]j19_tri_io_21;
  wire [22:22]j19_tri_io_22;
  wire [23:23]j19_tri_io_23;
  wire [24:24]j19_tri_io_24;
  wire [25:25]j19_tri_io_25;
  wire [26:26]j19_tri_io_26;
  wire [27:27]j19_tri_io_27;
  wire [28:28]j19_tri_io_28;
  wire [29:29]j19_tri_io_29;
  wire [3:3]j19_tri_io_3;
  wire [30:30]j19_tri_io_30;
  wire [31:31]j19_tri_io_31;
  wire [4:4]j19_tri_io_4;
  wire [5:5]j19_tri_io_5;
  wire [6:6]j19_tri_io_6;
  wire [7:7]j19_tri_io_7;
  wire [8:8]j19_tri_io_8;
  wire [9:9]j19_tri_io_9;
  wire [0:0]j19_tri_o_0;
  wire [1:1]j19_tri_o_1;
  wire [10:10]j19_tri_o_10;
  wire [11:11]j19_tri_o_11;
  wire [12:12]j19_tri_o_12;
  wire [13:13]j19_tri_o_13;
  wire [14:14]j19_tri_o_14;
  wire [15:15]j19_tri_o_15;
  wire [16:16]j19_tri_o_16;
  wire [17:17]j19_tri_o_17;
  wire [18:18]j19_tri_o_18;
  wire [19:19]j19_tri_o_19;
  wire [2:2]j19_tri_o_2;
  wire [20:20]j19_tri_o_20;
  wire [21:21]j19_tri_o_21;
  wire [22:22]j19_tri_o_22;
  wire [23:23]j19_tri_o_23;
  wire [24:24]j19_tri_o_24;
  wire [25:25]j19_tri_o_25;
  wire [26:26]j19_tri_o_26;
  wire [27:27]j19_tri_o_27;
  wire [28:28]j19_tri_o_28;
  wire [29:29]j19_tri_o_29;
  wire [3:3]j19_tri_o_3;
  wire [30:30]j19_tri_o_30;
  wire [31:31]j19_tri_o_31;
  wire [4:4]j19_tri_o_4;
  wire [5:5]j19_tri_o_5;
  wire [6:6]j19_tri_o_6;
  wire [7:7]j19_tri_o_7;
  wire [8:8]j19_tri_o_8;
  wire [9:9]j19_tri_o_9;
  wire [0:0]j19_tri_t_0;
  wire [1:1]j19_tri_t_1;
  wire [10:10]j19_tri_t_10;
  wire [11:11]j19_tri_t_11;
  wire [12:12]j19_tri_t_12;
  wire [13:13]j19_tri_t_13;
  wire [14:14]j19_tri_t_14;
  wire [15:15]j19_tri_t_15;
  wire [16:16]j19_tri_t_16;
  wire [17:17]j19_tri_t_17;
  wire [18:18]j19_tri_t_18;
  wire [19:19]j19_tri_t_19;
  wire [2:2]j19_tri_t_2;
  wire [20:20]j19_tri_t_20;
  wire [21:21]j19_tri_t_21;
  wire [22:22]j19_tri_t_22;
  wire [23:23]j19_tri_t_23;
  wire [24:24]j19_tri_t_24;
  wire [25:25]j19_tri_t_25;
  wire [26:26]j19_tri_t_26;
  wire [27:27]j19_tri_t_27;
  wire [28:28]j19_tri_t_28;
  wire [29:29]j19_tri_t_29;
  wire [3:3]j19_tri_t_3;
  wire [30:30]j19_tri_t_30;
  wire [31:31]j19_tri_t_31;
  wire [4:4]j19_tri_t_4;
  wire [5:5]j19_tri_t_5;
  wire [6:6]j19_tri_t_6;
  wire [7:7]j19_tri_t_7;
  wire [8:8]j19_tri_t_8;
  wire [9:9]j19_tri_t_9;
  wire [0:0]j20_hi_tri_i_0;
  wire [1:1]j20_hi_tri_i_1;
  wire [10:10]j20_hi_tri_i_10;
  wire [11:11]j20_hi_tri_i_11;
  wire [12:12]j20_hi_tri_i_12;
  wire [13:13]j20_hi_tri_i_13;
  wire [14:14]j20_hi_tri_i_14;
  wire [15:15]j20_hi_tri_i_15;
  wire [2:2]j20_hi_tri_i_2;
  wire [3:3]j20_hi_tri_i_3;
  wire [4:4]j20_hi_tri_i_4;
  wire [5:5]j20_hi_tri_i_5;
  wire [6:6]j20_hi_tri_i_6;
  wire [7:7]j20_hi_tri_i_7;
  wire [8:8]j20_hi_tri_i_8;
  wire [9:9]j20_hi_tri_i_9;
  wire [0:0]j20_hi_tri_io_0;
  wire [1:1]j20_hi_tri_io_1;
  wire [10:10]j20_hi_tri_io_10;
  wire [11:11]j20_hi_tri_io_11;
  wire [12:12]j20_hi_tri_io_12;
  wire [13:13]j20_hi_tri_io_13;
  wire [14:14]j20_hi_tri_io_14;
  wire [15:15]j20_hi_tri_io_15;
  wire [2:2]j20_hi_tri_io_2;
  wire [3:3]j20_hi_tri_io_3;
  wire [4:4]j20_hi_tri_io_4;
  wire [5:5]j20_hi_tri_io_5;
  wire [6:6]j20_hi_tri_io_6;
  wire [7:7]j20_hi_tri_io_7;
  wire [8:8]j20_hi_tri_io_8;
  wire [9:9]j20_hi_tri_io_9;
  wire [0:0]j20_hi_tri_o_0;
  wire [1:1]j20_hi_tri_o_1;
  wire [10:10]j20_hi_tri_o_10;
  wire [11:11]j20_hi_tri_o_11;
  wire [12:12]j20_hi_tri_o_12;
  wire [13:13]j20_hi_tri_o_13;
  wire [14:14]j20_hi_tri_o_14;
  wire [15:15]j20_hi_tri_o_15;
  wire [2:2]j20_hi_tri_o_2;
  wire [3:3]j20_hi_tri_o_3;
  wire [4:4]j20_hi_tri_o_4;
  wire [5:5]j20_hi_tri_o_5;
  wire [6:6]j20_hi_tri_o_6;
  wire [7:7]j20_hi_tri_o_7;
  wire [8:8]j20_hi_tri_o_8;
  wire [9:9]j20_hi_tri_o_9;
  wire [0:0]j20_hi_tri_t_0;
  wire [1:1]j20_hi_tri_t_1;
  wire [10:10]j20_hi_tri_t_10;
  wire [11:11]j20_hi_tri_t_11;
  wire [12:12]j20_hi_tri_t_12;
  wire [13:13]j20_hi_tri_t_13;
  wire [14:14]j20_hi_tri_t_14;
  wire [15:15]j20_hi_tri_t_15;
  wire [2:2]j20_hi_tri_t_2;
  wire [3:3]j20_hi_tri_t_3;
  wire [4:4]j20_hi_tri_t_4;
  wire [5:5]j20_hi_tri_t_5;
  wire [6:6]j20_hi_tri_t_6;
  wire [7:7]j20_hi_tri_t_7;
  wire [8:8]j20_hi_tri_t_8;
  wire [9:9]j20_hi_tri_t_9;
  wire [0:0]j20_tri_i_0;
  wire [1:1]j20_tri_i_1;
  wire [10:10]j20_tri_i_10;
  wire [11:11]j20_tri_i_11;
  wire [12:12]j20_tri_i_12;
  wire [13:13]j20_tri_i_13;
  wire [14:14]j20_tri_i_14;
  wire [15:15]j20_tri_i_15;
  wire [16:16]j20_tri_i_16;
  wire [17:17]j20_tri_i_17;
  wire [18:18]j20_tri_i_18;
  wire [19:19]j20_tri_i_19;
  wire [2:2]j20_tri_i_2;
  wire [20:20]j20_tri_i_20;
  wire [21:21]j20_tri_i_21;
  wire [22:22]j20_tri_i_22;
  wire [23:23]j20_tri_i_23;
  wire [24:24]j20_tri_i_24;
  wire [25:25]j20_tri_i_25;
  wire [26:26]j20_tri_i_26;
  wire [27:27]j20_tri_i_27;
  wire [28:28]j20_tri_i_28;
  wire [29:29]j20_tri_i_29;
  wire [3:3]j20_tri_i_3;
  wire [30:30]j20_tri_i_30;
  wire [31:31]j20_tri_i_31;
  wire [4:4]j20_tri_i_4;
  wire [5:5]j20_tri_i_5;
  wire [6:6]j20_tri_i_6;
  wire [7:7]j20_tri_i_7;
  wire [8:8]j20_tri_i_8;
  wire [9:9]j20_tri_i_9;
  wire [0:0]j20_tri_io_0;
  wire [1:1]j20_tri_io_1;
  wire [10:10]j20_tri_io_10;
  wire [11:11]j20_tri_io_11;
  wire [12:12]j20_tri_io_12;
  wire [13:13]j20_tri_io_13;
  wire [14:14]j20_tri_io_14;
  wire [15:15]j20_tri_io_15;
  wire [16:16]j20_tri_io_16;
  wire [17:17]j20_tri_io_17;
  wire [18:18]j20_tri_io_18;
  wire [19:19]j20_tri_io_19;
  wire [2:2]j20_tri_io_2;
  wire [20:20]j20_tri_io_20;
  wire [21:21]j20_tri_io_21;
  wire [22:22]j20_tri_io_22;
  wire [23:23]j20_tri_io_23;
  wire [24:24]j20_tri_io_24;
  wire [25:25]j20_tri_io_25;
  wire [26:26]j20_tri_io_26;
  wire [27:27]j20_tri_io_27;
  wire [28:28]j20_tri_io_28;
  wire [29:29]j20_tri_io_29;
  wire [3:3]j20_tri_io_3;
  wire [30:30]j20_tri_io_30;
  wire [31:31]j20_tri_io_31;
  wire [4:4]j20_tri_io_4;
  wire [5:5]j20_tri_io_5;
  wire [6:6]j20_tri_io_6;
  wire [7:7]j20_tri_io_7;
  wire [8:8]j20_tri_io_8;
  wire [9:9]j20_tri_io_9;
  wire [0:0]j20_tri_o_0;
  wire [1:1]j20_tri_o_1;
  wire [10:10]j20_tri_o_10;
  wire [11:11]j20_tri_o_11;
  wire [12:12]j20_tri_o_12;
  wire [13:13]j20_tri_o_13;
  wire [14:14]j20_tri_o_14;
  wire [15:15]j20_tri_o_15;
  wire [16:16]j20_tri_o_16;
  wire [17:17]j20_tri_o_17;
  wire [18:18]j20_tri_o_18;
  wire [19:19]j20_tri_o_19;
  wire [2:2]j20_tri_o_2;
  wire [20:20]j20_tri_o_20;
  wire [21:21]j20_tri_o_21;
  wire [22:22]j20_tri_o_22;
  wire [23:23]j20_tri_o_23;
  wire [24:24]j20_tri_o_24;
  wire [25:25]j20_tri_o_25;
  wire [26:26]j20_tri_o_26;
  wire [27:27]j20_tri_o_27;
  wire [28:28]j20_tri_o_28;
  wire [29:29]j20_tri_o_29;
  wire [3:3]j20_tri_o_3;
  wire [30:30]j20_tri_o_30;
  wire [31:31]j20_tri_o_31;
  wire [4:4]j20_tri_o_4;
  wire [5:5]j20_tri_o_5;
  wire [6:6]j20_tri_o_6;
  wire [7:7]j20_tri_o_7;
  wire [8:8]j20_tri_o_8;
  wire [9:9]j20_tri_o_9;
  wire [0:0]j20_tri_t_0;
  wire [1:1]j20_tri_t_1;
  wire [10:10]j20_tri_t_10;
  wire [11:11]j20_tri_t_11;
  wire [12:12]j20_tri_t_12;
  wire [13:13]j20_tri_t_13;
  wire [14:14]j20_tri_t_14;
  wire [15:15]j20_tri_t_15;
  wire [16:16]j20_tri_t_16;
  wire [17:17]j20_tri_t_17;
  wire [18:18]j20_tri_t_18;
  wire [19:19]j20_tri_t_19;
  wire [2:2]j20_tri_t_2;
  wire [20:20]j20_tri_t_20;
  wire [21:21]j20_tri_t_21;
  wire [22:22]j20_tri_t_22;
  wire [23:23]j20_tri_t_23;
  wire [24:24]j20_tri_t_24;
  wire [25:25]j20_tri_t_25;
  wire [26:26]j20_tri_t_26;
  wire [27:27]j20_tri_t_27;
  wire [28:28]j20_tri_t_28;
  wire [29:29]j20_tri_t_29;
  wire [3:3]j20_tri_t_3;
  wire [30:30]j20_tri_t_30;
  wire [31:31]j20_tri_t_31;
  wire [4:4]j20_tri_t_4;
  wire [5:5]j20_tri_t_5;
  wire [6:6]j20_tri_t_6;
  wire [7:7]j20_tri_t_7;
  wire [8:8]j20_tri_t_8;
  wire [9:9]j20_tri_t_9;
  wire [0:0]jm1_tri_i_0;
  wire [1:1]jm1_tri_i_1;
  wire [10:10]jm1_tri_i_10;
  wire [11:11]jm1_tri_i_11;
  wire [12:12]jm1_tri_i_12;
  wire [13:13]jm1_tri_i_13;
  wire [14:14]jm1_tri_i_14;
  wire [15:15]jm1_tri_i_15;
  wire [16:16]jm1_tri_i_16;
  wire [17:17]jm1_tri_i_17;
  wire [18:18]jm1_tri_i_18;
  wire [19:19]jm1_tri_i_19;
  wire [2:2]jm1_tri_i_2;
  wire [20:20]jm1_tri_i_20;
  wire [21:21]jm1_tri_i_21;
  wire [22:22]jm1_tri_i_22;
  wire [23:23]jm1_tri_i_23;
  wire [24:24]jm1_tri_i_24;
  wire [25:25]jm1_tri_i_25;
  wire [26:26]jm1_tri_i_26;
  wire [27:27]jm1_tri_i_27;
  wire [28:28]jm1_tri_i_28;
  wire [29:29]jm1_tri_i_29;
  wire [3:3]jm1_tri_i_3;
  wire [30:30]jm1_tri_i_30;
  wire [31:31]jm1_tri_i_31;
  wire [4:4]jm1_tri_i_4;
  wire [5:5]jm1_tri_i_5;
  wire [6:6]jm1_tri_i_6;
  wire [7:7]jm1_tri_i_7;
  wire [8:8]jm1_tri_i_8;
  wire [9:9]jm1_tri_i_9;
  wire [0:0]jm1_tri_io_0;
  wire [1:1]jm1_tri_io_1;
  wire [10:10]jm1_tri_io_10;
  wire [11:11]jm1_tri_io_11;
  wire [12:12]jm1_tri_io_12;
  wire [13:13]jm1_tri_io_13;
  wire [14:14]jm1_tri_io_14;
  wire [15:15]jm1_tri_io_15;
  wire [16:16]jm1_tri_io_16;
  wire [17:17]jm1_tri_io_17;
  wire [18:18]jm1_tri_io_18;
  wire [19:19]jm1_tri_io_19;
  wire [2:2]jm1_tri_io_2;
  wire [20:20]jm1_tri_io_20;
  wire [21:21]jm1_tri_io_21;
  wire [22:22]jm1_tri_io_22;
  wire [23:23]jm1_tri_io_23;
  wire [24:24]jm1_tri_io_24;
  wire [25:25]jm1_tri_io_25;
  wire [26:26]jm1_tri_io_26;
  wire [27:27]jm1_tri_io_27;
  wire [28:28]jm1_tri_io_28;
  wire [29:29]jm1_tri_io_29;
  wire [3:3]jm1_tri_io_3;
  wire [30:30]jm1_tri_io_30;
  wire [31:31]jm1_tri_io_31;
  wire [4:4]jm1_tri_io_4;
  wire [5:5]jm1_tri_io_5;
  wire [6:6]jm1_tri_io_6;
  wire [7:7]jm1_tri_io_7;
  wire [8:8]jm1_tri_io_8;
  wire [9:9]jm1_tri_io_9;
  wire [0:0]jm1_tri_o_0;
  wire [1:1]jm1_tri_o_1;
  wire [10:10]jm1_tri_o_10;
  wire [11:11]jm1_tri_o_11;
  wire [12:12]jm1_tri_o_12;
  wire [13:13]jm1_tri_o_13;
  wire [14:14]jm1_tri_o_14;
  wire [15:15]jm1_tri_o_15;
  wire [16:16]jm1_tri_o_16;
  wire [17:17]jm1_tri_o_17;
  wire [18:18]jm1_tri_o_18;
  wire [19:19]jm1_tri_o_19;
  wire [2:2]jm1_tri_o_2;
  wire [20:20]jm1_tri_o_20;
  wire [21:21]jm1_tri_o_21;
  wire [22:22]jm1_tri_o_22;
  wire [23:23]jm1_tri_o_23;
  wire [24:24]jm1_tri_o_24;
  wire [25:25]jm1_tri_o_25;
  wire [26:26]jm1_tri_o_26;
  wire [27:27]jm1_tri_o_27;
  wire [28:28]jm1_tri_o_28;
  wire [29:29]jm1_tri_o_29;
  wire [3:3]jm1_tri_o_3;
  wire [30:30]jm1_tri_o_30;
  wire [31:31]jm1_tri_o_31;
  wire [4:4]jm1_tri_o_4;
  wire [5:5]jm1_tri_o_5;
  wire [6:6]jm1_tri_o_6;
  wire [7:7]jm1_tri_o_7;
  wire [8:8]jm1_tri_o_8;
  wire [9:9]jm1_tri_o_9;
  wire [0:0]jm1_tri_t_0;
  wire [1:1]jm1_tri_t_1;
  wire [10:10]jm1_tri_t_10;
  wire [11:11]jm1_tri_t_11;
  wire [12:12]jm1_tri_t_12;
  wire [13:13]jm1_tri_t_13;
  wire [14:14]jm1_tri_t_14;
  wire [15:15]jm1_tri_t_15;
  wire [16:16]jm1_tri_t_16;
  wire [17:17]jm1_tri_t_17;
  wire [18:18]jm1_tri_t_18;
  wire [19:19]jm1_tri_t_19;
  wire [2:2]jm1_tri_t_2;
  wire [20:20]jm1_tri_t_20;
  wire [21:21]jm1_tri_t_21;
  wire [22:22]jm1_tri_t_22;
  wire [23:23]jm1_tri_t_23;
  wire [24:24]jm1_tri_t_24;
  wire [25:25]jm1_tri_t_25;
  wire [26:26]jm1_tri_t_26;
  wire [27:27]jm1_tri_t_27;
  wire [28:28]jm1_tri_t_28;
  wire [29:29]jm1_tri_t_29;
  wire [3:3]jm1_tri_t_3;
  wire [30:30]jm1_tri_t_30;
  wire [31:31]jm1_tri_t_31;
  wire [4:4]jm1_tri_t_4;
  wire [5:5]jm1_tri_t_5;
  wire [6:6]jm1_tri_t_6;
  wire [7:7]jm1_tri_t_7;
  wire [8:8]jm1_tri_t_8;
  wire [9:9]jm1_tri_t_9;
  wire [4:0]led_5bits_tri_o;
  wire [2:0]led_core_tri_o;
  wire mdio_mdc;
  wire mdio_mdio_i;
  wire mdio_mdio_io;
  wire mdio_mdio_o;
  wire mdio_mdio_t;
  wire [0:0]phy_reset_n;
  wire [4:0]push_buttons_5bits_tri_i;
  wire reset;
  wire [3:0]rgmii_rd;
  wire rgmii_rx_ctl;
  wire rgmii_rxc;
  wire [3:0]rgmii_td;
  wire rgmii_tx_ctl;
  wire rgmii_txc;
  wire sys_diff_clock_clk_n;
  wire sys_diff_clock_clk_p;

  IOBUF iic_eeprom_scl_iobuf
       (.I(iic_eeprom_scl_o),
        .IO(iic_eeprom_scl_io),
        .O(iic_eeprom_scl_i),
        .T(iic_eeprom_scl_t));
  IOBUF iic_eeprom_sda_iobuf
       (.I(iic_eeprom_sda_o),
        .IO(iic_eeprom_sda_io),
        .O(iic_eeprom_sda_i),
        .T(iic_eeprom_sda_t));
  IOBUF j19_tri_iobuf_0
       (.I(j19_tri_o_0),
        .IO(j19_tri_io[0]),
        .O(j19_tri_i_0),
        .T(j19_tri_t_0));
  IOBUF j19_tri_iobuf_1
       (.I(j19_tri_o_1),
        .IO(j19_tri_io[1]),
        .O(j19_tri_i_1),
        .T(j19_tri_t_1));
  IOBUF j19_tri_iobuf_10
       (.I(j19_tri_o_10),
        .IO(j19_tri_io[10]),
        .O(j19_tri_i_10),
        .T(j19_tri_t_10));
  IOBUF j19_tri_iobuf_11
       (.I(j19_tri_o_11),
        .IO(j19_tri_io[11]),
        .O(j19_tri_i_11),
        .T(j19_tri_t_11));
  IOBUF j19_tri_iobuf_12
       (.I(j19_tri_o_12),
        .IO(j19_tri_io[12]),
        .O(j19_tri_i_12),
        .T(j19_tri_t_12));
  IOBUF j19_tri_iobuf_13
       (.I(j19_tri_o_13),
        .IO(j19_tri_io[13]),
        .O(j19_tri_i_13),
        .T(j19_tri_t_13));
  IOBUF j19_tri_iobuf_14
       (.I(j19_tri_o_14),
        .IO(j19_tri_io[14]),
        .O(j19_tri_i_14),
        .T(j19_tri_t_14));
  IOBUF j19_tri_iobuf_15
       (.I(j19_tri_o_15),
        .IO(j19_tri_io[15]),
        .O(j19_tri_i_15),
        .T(j19_tri_t_15));
  IOBUF j19_tri_iobuf_16
       (.I(j19_tri_o_16),
        .IO(j19_tri_io[16]),
        .O(j19_tri_i_16),
        .T(j19_tri_t_16));
  IOBUF j19_tri_iobuf_17
       (.I(j19_tri_o_17),
        .IO(j19_tri_io[17]),
        .O(j19_tri_i_17),
        .T(j19_tri_t_17));
  IOBUF j19_tri_iobuf_18
       (.I(j19_tri_o_18),
        .IO(j19_tri_io[18]),
        .O(j19_tri_i_18),
        .T(j19_tri_t_18));
  IOBUF j19_tri_iobuf_19
       (.I(j19_tri_o_19),
        .IO(j19_tri_io[19]),
        .O(j19_tri_i_19),
        .T(j19_tri_t_19));
  IOBUF j19_tri_iobuf_2
       (.I(j19_tri_o_2),
        .IO(j19_tri_io[2]),
        .O(j19_tri_i_2),
        .T(j19_tri_t_2));
  IOBUF j19_tri_iobuf_20
       (.I(j19_tri_o_20),
        .IO(j19_tri_io[20]),
        .O(j19_tri_i_20),
        .T(j19_tri_t_20));
  IOBUF j19_tri_iobuf_21
       (.I(j19_tri_o_21),
        .IO(j19_tri_io[21]),
        .O(j19_tri_i_21),
        .T(j19_tri_t_21));
  IOBUF j19_tri_iobuf_22
       (.I(j19_tri_o_22),
        .IO(j19_tri_io[22]),
        .O(j19_tri_i_22),
        .T(j19_tri_t_22));
  IOBUF j19_tri_iobuf_23
       (.I(j19_tri_o_23),
        .IO(j19_tri_io[23]),
        .O(j19_tri_i_23),
        .T(j19_tri_t_23));
  IOBUF j19_tri_iobuf_24
       (.I(j19_tri_o_24),
        .IO(j19_tri_io[24]),
        .O(j19_tri_i_24),
        .T(j19_tri_t_24));
  IOBUF j19_tri_iobuf_25
       (.I(j19_tri_o_25),
        .IO(j19_tri_io[25]),
        .O(j19_tri_i_25),
        .T(j19_tri_t_25));
  IOBUF j19_tri_iobuf_26
       (.I(j19_tri_o_26),
        .IO(j19_tri_io[26]),
        .O(j19_tri_i_26),
        .T(j19_tri_t_26));
  IOBUF j19_tri_iobuf_27
       (.I(j19_tri_o_27),
        .IO(j19_tri_io[27]),
        .O(j19_tri_i_27),
        .T(j19_tri_t_27));
  IOBUF j19_tri_iobuf_28
       (.I(j19_tri_o_28),
        .IO(j19_tri_io[28]),
        .O(j19_tri_i_28),
        .T(j19_tri_t_28));
  IOBUF j19_tri_iobuf_29
       (.I(j19_tri_o_29),
        .IO(j19_tri_io[29]),
        .O(j19_tri_i_29),
        .T(j19_tri_t_29));
  IOBUF j19_tri_iobuf_3
       (.I(j19_tri_o_3),
        .IO(j19_tri_io[3]),
        .O(j19_tri_i_3),
        .T(j19_tri_t_3));
  IOBUF j19_tri_iobuf_30
       (.I(j19_tri_o_30),
        .IO(j19_tri_io[30]),
        .O(j19_tri_i_30),
        .T(j19_tri_t_30));
  IOBUF j19_tri_iobuf_31
       (.I(j19_tri_o_31),
        .IO(j19_tri_io[31]),
        .O(j19_tri_i_31),
        .T(j19_tri_t_31));
  IOBUF j19_tri_iobuf_4
       (.I(j19_tri_o_4),
        .IO(j19_tri_io[4]),
        .O(j19_tri_i_4),
        .T(j19_tri_t_4));
  IOBUF j19_tri_iobuf_5
       (.I(j19_tri_o_5),
        .IO(j19_tri_io[5]),
        .O(j19_tri_i_5),
        .T(j19_tri_t_5));
  IOBUF j19_tri_iobuf_6
       (.I(j19_tri_o_6),
        .IO(j19_tri_io[6]),
        .O(j19_tri_i_6),
        .T(j19_tri_t_6));
  IOBUF j19_tri_iobuf_7
       (.I(j19_tri_o_7),
        .IO(j19_tri_io[7]),
        .O(j19_tri_i_7),
        .T(j19_tri_t_7));
  IOBUF j19_tri_iobuf_8
       (.I(j19_tri_o_8),
        .IO(j19_tri_io[8]),
        .O(j19_tri_i_8),
        .T(j19_tri_t_8));
  IOBUF j19_tri_iobuf_9
       (.I(j19_tri_o_9),
        .IO(j19_tri_io[9]),
        .O(j19_tri_i_9),
        .T(j19_tri_t_9));
  IOBUF j20_hi_tri_iobuf_0
       (.I(j20_hi_tri_o_0),
        .IO(j20_hi_tri_io[0]),
        .O(j20_hi_tri_i_0),
        .T(j20_hi_tri_t_0));
  IOBUF j20_hi_tri_iobuf_1
       (.I(j20_hi_tri_o_1),
        .IO(j20_hi_tri_io[1]),
        .O(j20_hi_tri_i_1),
        .T(j20_hi_tri_t_1));
  IOBUF j20_hi_tri_iobuf_10
       (.I(j20_hi_tri_o_10),
        .IO(j20_hi_tri_io[10]),
        .O(j20_hi_tri_i_10),
        .T(j20_hi_tri_t_10));
  IOBUF j20_hi_tri_iobuf_11
       (.I(j20_hi_tri_o_11),
        .IO(j20_hi_tri_io[11]),
        .O(j20_hi_tri_i_11),
        .T(j20_hi_tri_t_11));
  IOBUF j20_hi_tri_iobuf_12
       (.I(j20_hi_tri_o_12),
        .IO(j20_hi_tri_io[12]),
        .O(j20_hi_tri_i_12),
        .T(j20_hi_tri_t_12));
  IOBUF j20_hi_tri_iobuf_13
       (.I(j20_hi_tri_o_13),
        .IO(j20_hi_tri_io[13]),
        .O(j20_hi_tri_i_13),
        .T(j20_hi_tri_t_13));
  IOBUF j20_hi_tri_iobuf_14
       (.I(j20_hi_tri_o_14),
        .IO(j20_hi_tri_io[14]),
        .O(j20_hi_tri_i_14),
        .T(j20_hi_tri_t_14));
  IOBUF j20_hi_tri_iobuf_15
       (.I(j20_hi_tri_o_15),
        .IO(j20_hi_tri_io[15]),
        .O(j20_hi_tri_i_15),
        .T(j20_hi_tri_t_15));
  IOBUF j20_hi_tri_iobuf_2
       (.I(j20_hi_tri_o_2),
        .IO(j20_hi_tri_io[2]),
        .O(j20_hi_tri_i_2),
        .T(j20_hi_tri_t_2));
  IOBUF j20_hi_tri_iobuf_3
       (.I(j20_hi_tri_o_3),
        .IO(j20_hi_tri_io[3]),
        .O(j20_hi_tri_i_3),
        .T(j20_hi_tri_t_3));
  IOBUF j20_hi_tri_iobuf_4
       (.I(j20_hi_tri_o_4),
        .IO(j20_hi_tri_io[4]),
        .O(j20_hi_tri_i_4),
        .T(j20_hi_tri_t_4));
  IOBUF j20_hi_tri_iobuf_5
       (.I(j20_hi_tri_o_5),
        .IO(j20_hi_tri_io[5]),
        .O(j20_hi_tri_i_5),
        .T(j20_hi_tri_t_5));
  IOBUF j20_hi_tri_iobuf_6
       (.I(j20_hi_tri_o_6),
        .IO(j20_hi_tri_io[6]),
        .O(j20_hi_tri_i_6),
        .T(j20_hi_tri_t_6));
  IOBUF j20_hi_tri_iobuf_7
       (.I(j20_hi_tri_o_7),
        .IO(j20_hi_tri_io[7]),
        .O(j20_hi_tri_i_7),
        .T(j20_hi_tri_t_7));
  IOBUF j20_hi_tri_iobuf_8
       (.I(j20_hi_tri_o_8),
        .IO(j20_hi_tri_io[8]),
        .O(j20_hi_tri_i_8),
        .T(j20_hi_tri_t_8));
  IOBUF j20_hi_tri_iobuf_9
       (.I(j20_hi_tri_o_9),
        .IO(j20_hi_tri_io[9]),
        .O(j20_hi_tri_i_9),
        .T(j20_hi_tri_t_9));
  IOBUF j20_tri_iobuf_0
       (.I(j20_tri_o_0),
        .IO(j20_tri_io[0]),
        .O(j20_tri_i_0),
        .T(j20_tri_t_0));
  IOBUF j20_tri_iobuf_1
       (.I(j20_tri_o_1),
        .IO(j20_tri_io[1]),
        .O(j20_tri_i_1),
        .T(j20_tri_t_1));
  IOBUF j20_tri_iobuf_10
       (.I(j20_tri_o_10),
        .IO(j20_tri_io[10]),
        .O(j20_tri_i_10),
        .T(j20_tri_t_10));
  IOBUF j20_tri_iobuf_11
       (.I(j20_tri_o_11),
        .IO(j20_tri_io[11]),
        .O(j20_tri_i_11),
        .T(j20_tri_t_11));
  IOBUF j20_tri_iobuf_12
       (.I(j20_tri_o_12),
        .IO(j20_tri_io[12]),
        .O(j20_tri_i_12),
        .T(j20_tri_t_12));
  IOBUF j20_tri_iobuf_13
       (.I(j20_tri_o_13),
        .IO(j20_tri_io[13]),
        .O(j20_tri_i_13),
        .T(j20_tri_t_13));
  IOBUF j20_tri_iobuf_14
       (.I(j20_tri_o_14),
        .IO(j20_tri_io[14]),
        .O(j20_tri_i_14),
        .T(j20_tri_t_14));
  IOBUF j20_tri_iobuf_15
       (.I(j20_tri_o_15),
        .IO(j20_tri_io[15]),
        .O(j20_tri_i_15),
        .T(j20_tri_t_15));
  IOBUF j20_tri_iobuf_16
       (.I(j20_tri_o_16),
        .IO(j20_tri_io[16]),
        .O(j20_tri_i_16),
        .T(j20_tri_t_16));
  IOBUF j20_tri_iobuf_17
       (.I(j20_tri_o_17),
        .IO(j20_tri_io[17]),
        .O(j20_tri_i_17),
        .T(j20_tri_t_17));
  IOBUF j20_tri_iobuf_18
       (.I(j20_tri_o_18),
        .IO(j20_tri_io[18]),
        .O(j20_tri_i_18),
        .T(j20_tri_t_18));
  IOBUF j20_tri_iobuf_19
       (.I(j20_tri_o_19),
        .IO(j20_tri_io[19]),
        .O(j20_tri_i_19),
        .T(j20_tri_t_19));
  IOBUF j20_tri_iobuf_2
       (.I(j20_tri_o_2),
        .IO(j20_tri_io[2]),
        .O(j20_tri_i_2),
        .T(j20_tri_t_2));
  IOBUF j20_tri_iobuf_20
       (.I(j20_tri_o_20),
        .IO(j20_tri_io[20]),
        .O(j20_tri_i_20),
        .T(j20_tri_t_20));
  IOBUF j20_tri_iobuf_21
       (.I(j20_tri_o_21),
        .IO(j20_tri_io[21]),
        .O(j20_tri_i_21),
        .T(j20_tri_t_21));
  IOBUF j20_tri_iobuf_22
       (.I(j20_tri_o_22),
        .IO(j20_tri_io[22]),
        .O(j20_tri_i_22),
        .T(j20_tri_t_22));
  IOBUF j20_tri_iobuf_23
       (.I(j20_tri_o_23),
        .IO(j20_tri_io[23]),
        .O(j20_tri_i_23),
        .T(j20_tri_t_23));
  IOBUF j20_tri_iobuf_24
       (.I(j20_tri_o_24),
        .IO(j20_tri_io[24]),
        .O(j20_tri_i_24),
        .T(j20_tri_t_24));
  IOBUF j20_tri_iobuf_25
       (.I(j20_tri_o_25),
        .IO(j20_tri_io[25]),
        .O(j20_tri_i_25),
        .T(j20_tri_t_25));
  IOBUF j20_tri_iobuf_26
       (.I(j20_tri_o_26),
        .IO(j20_tri_io[26]),
        .O(j20_tri_i_26),
        .T(j20_tri_t_26));
  IOBUF j20_tri_iobuf_27
       (.I(j20_tri_o_27),
        .IO(j20_tri_io[27]),
        .O(j20_tri_i_27),
        .T(j20_tri_t_27));
  IOBUF j20_tri_iobuf_28
       (.I(j20_tri_o_28),
        .IO(j20_tri_io[28]),
        .O(j20_tri_i_28),
        .T(j20_tri_t_28));
  IOBUF j20_tri_iobuf_29
       (.I(j20_tri_o_29),
        .IO(j20_tri_io[29]),
        .O(j20_tri_i_29),
        .T(j20_tri_t_29));
  IOBUF j20_tri_iobuf_3
       (.I(j20_tri_o_3),
        .IO(j20_tri_io[3]),
        .O(j20_tri_i_3),
        .T(j20_tri_t_3));
  IOBUF j20_tri_iobuf_30
       (.I(j20_tri_o_30),
        .IO(j20_tri_io[30]),
        .O(j20_tri_i_30),
        .T(j20_tri_t_30));
  IOBUF j20_tri_iobuf_31
       (.I(j20_tri_o_31),
        .IO(j20_tri_io[31]),
        .O(j20_tri_i_31),
        .T(j20_tri_t_31));
  IOBUF j20_tri_iobuf_4
       (.I(j20_tri_o_4),
        .IO(j20_tri_io[4]),
        .O(j20_tri_i_4),
        .T(j20_tri_t_4));
  IOBUF j20_tri_iobuf_5
       (.I(j20_tri_o_5),
        .IO(j20_tri_io[5]),
        .O(j20_tri_i_5),
        .T(j20_tri_t_5));
  IOBUF j20_tri_iobuf_6
       (.I(j20_tri_o_6),
        .IO(j20_tri_io[6]),
        .O(j20_tri_i_6),
        .T(j20_tri_t_6));
  IOBUF j20_tri_iobuf_7
       (.I(j20_tri_o_7),
        .IO(j20_tri_io[7]),
        .O(j20_tri_i_7),
        .T(j20_tri_t_7));
  IOBUF j20_tri_iobuf_8
       (.I(j20_tri_o_8),
        .IO(j20_tri_io[8]),
        .O(j20_tri_i_8),
        .T(j20_tri_t_8));
  IOBUF j20_tri_iobuf_9
       (.I(j20_tri_o_9),
        .IO(j20_tri_io[9]),
        .O(j20_tri_i_9),
        .T(j20_tri_t_9));
  IOBUF jm1_tri_iobuf_0
       (.I(jm1_tri_o_0),
        .IO(jm1_tri_io[0]),
        .O(jm1_tri_i_0),
        .T(jm1_tri_t_0));
  IOBUF jm1_tri_iobuf_1
       (.I(jm1_tri_o_1),
        .IO(jm1_tri_io[1]),
        .O(jm1_tri_i_1),
        .T(jm1_tri_t_1));
  IOBUF jm1_tri_iobuf_10
       (.I(jm1_tri_o_10),
        .IO(jm1_tri_io[10]),
        .O(jm1_tri_i_10),
        .T(jm1_tri_t_10));
  IOBUF jm1_tri_iobuf_11
       (.I(jm1_tri_o_11),
        .IO(jm1_tri_io[11]),
        .O(jm1_tri_i_11),
        .T(jm1_tri_t_11));
  IOBUF jm1_tri_iobuf_12
       (.I(jm1_tri_o_12),
        .IO(jm1_tri_io[12]),
        .O(jm1_tri_i_12),
        .T(jm1_tri_t_12));
  IOBUF jm1_tri_iobuf_13
       (.I(jm1_tri_o_13),
        .IO(jm1_tri_io[13]),
        .O(jm1_tri_i_13),
        .T(jm1_tri_t_13));
  IOBUF jm1_tri_iobuf_14
       (.I(jm1_tri_o_14),
        .IO(jm1_tri_io[14]),
        .O(jm1_tri_i_14),
        .T(jm1_tri_t_14));
  IOBUF jm1_tri_iobuf_15
       (.I(jm1_tri_o_15),
        .IO(jm1_tri_io[15]),
        .O(jm1_tri_i_15),
        .T(jm1_tri_t_15));
  IOBUF jm1_tri_iobuf_16
       (.I(jm1_tri_o_16),
        .IO(jm1_tri_io[16]),
        .O(jm1_tri_i_16),
        .T(jm1_tri_t_16));
  IOBUF jm1_tri_iobuf_17
       (.I(jm1_tri_o_17),
        .IO(jm1_tri_io[17]),
        .O(jm1_tri_i_17),
        .T(jm1_tri_t_17));
  IOBUF jm1_tri_iobuf_18
       (.I(jm1_tri_o_18),
        .IO(jm1_tri_io[18]),
        .O(jm1_tri_i_18),
        .T(jm1_tri_t_18));
  IOBUF jm1_tri_iobuf_19
       (.I(jm1_tri_o_19),
        .IO(jm1_tri_io[19]),
        .O(jm1_tri_i_19),
        .T(jm1_tri_t_19));
  IOBUF jm1_tri_iobuf_2
       (.I(jm1_tri_o_2),
        .IO(jm1_tri_io[2]),
        .O(jm1_tri_i_2),
        .T(jm1_tri_t_2));
  IOBUF jm1_tri_iobuf_20
       (.I(jm1_tri_o_20),
        .IO(jm1_tri_io[20]),
        .O(jm1_tri_i_20),
        .T(jm1_tri_t_20));
  IOBUF jm1_tri_iobuf_21
       (.I(jm1_tri_o_21),
        .IO(jm1_tri_io[21]),
        .O(jm1_tri_i_21),
        .T(jm1_tri_t_21));
  IOBUF jm1_tri_iobuf_22
       (.I(jm1_tri_o_22),
        .IO(jm1_tri_io[22]),
        .O(jm1_tri_i_22),
        .T(jm1_tri_t_22));
  IOBUF jm1_tri_iobuf_23
       (.I(jm1_tri_o_23),
        .IO(jm1_tri_io[23]),
        .O(jm1_tri_i_23),
        .T(jm1_tri_t_23));
  IOBUF jm1_tri_iobuf_24
       (.I(jm1_tri_o_24),
        .IO(jm1_tri_io[24]),
        .O(jm1_tri_i_24),
        .T(jm1_tri_t_24));
  IOBUF jm1_tri_iobuf_25
       (.I(jm1_tri_o_25),
        .IO(jm1_tri_io[25]),
        .O(jm1_tri_i_25),
        .T(jm1_tri_t_25));
  IOBUF jm1_tri_iobuf_26
       (.I(jm1_tri_o_26),
        .IO(jm1_tri_io[26]),
        .O(jm1_tri_i_26),
        .T(jm1_tri_t_26));
  IOBUF jm1_tri_iobuf_27
       (.I(jm1_tri_o_27),
        .IO(jm1_tri_io[27]),
        .O(jm1_tri_i_27),
        .T(jm1_tri_t_27));
  IOBUF jm1_tri_iobuf_28
       (.I(jm1_tri_o_28),
        .IO(jm1_tri_io[28]),
        .O(jm1_tri_i_28),
        .T(jm1_tri_t_28));
  IOBUF jm1_tri_iobuf_29
       (.I(jm1_tri_o_29),
        .IO(jm1_tri_io[29]),
        .O(jm1_tri_i_29),
        .T(jm1_tri_t_29));
  IOBUF jm1_tri_iobuf_3
       (.I(jm1_tri_o_3),
        .IO(jm1_tri_io[3]),
        .O(jm1_tri_i_3),
        .T(jm1_tri_t_3));
  IOBUF jm1_tri_iobuf_30
       (.I(jm1_tri_o_30),
        .IO(jm1_tri_io[30]),
        .O(jm1_tri_i_30),
        .T(jm1_tri_t_30));
  IOBUF jm1_tri_iobuf_31
       (.I(jm1_tri_o_31),
        .IO(jm1_tri_io[31]),
        .O(jm1_tri_i_31),
        .T(jm1_tri_t_31));
  IOBUF jm1_tri_iobuf_4
       (.I(jm1_tri_o_4),
        .IO(jm1_tri_io[4]),
        .O(jm1_tri_i_4),
        .T(jm1_tri_t_4));
  IOBUF jm1_tri_iobuf_5
       (.I(jm1_tri_o_5),
        .IO(jm1_tri_io[5]),
        .O(jm1_tri_i_5),
        .T(jm1_tri_t_5));
  IOBUF jm1_tri_iobuf_6
       (.I(jm1_tri_o_6),
        .IO(jm1_tri_io[6]),
        .O(jm1_tri_i_6),
        .T(jm1_tri_t_6));
  IOBUF jm1_tri_iobuf_7
       (.I(jm1_tri_o_7),
        .IO(jm1_tri_io[7]),
        .O(jm1_tri_i_7),
        .T(jm1_tri_t_7));
  IOBUF jm1_tri_iobuf_8
       (.I(jm1_tri_o_8),
        .IO(jm1_tri_io[8]),
        .O(jm1_tri_i_8),
        .T(jm1_tri_t_8));
  IOBUF jm1_tri_iobuf_9
       (.I(jm1_tri_o_9),
        .IO(jm1_tri_io[9]),
        .O(jm1_tri_i_9),
        .T(jm1_tri_t_9));
  IOBUF mdio_mdio_iobuf
       (.I(mdio_mdio_o),
        .IO(mdio_mdio_io),
        .O(mdio_mdio_i),
        .T(mdio_mdio_t));
  system system_i
       (.ddr4_sdram_act_n(ddr4_sdram_act_n),
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
        .dp_aux_in(dp_aux_in),
        .dp_aux_oe(dp_aux_oe),
        .dp_aux_out(dp_aux_out),
        .dp_hpd(dp_hpd),
        .iic_eeprom_scl_i(iic_eeprom_scl_i),
        .iic_eeprom_scl_o(iic_eeprom_scl_o),
        .iic_eeprom_scl_t(iic_eeprom_scl_t),
        .iic_eeprom_sda_i(iic_eeprom_sda_i),
        .iic_eeprom_sda_o(iic_eeprom_sda_o),
        .iic_eeprom_sda_t(iic_eeprom_sda_t),
        .j19_tri_i({j19_tri_i_31,j19_tri_i_30,j19_tri_i_29,j19_tri_i_28,j19_tri_i_27,j19_tri_i_26,j19_tri_i_25,j19_tri_i_24,j19_tri_i_23,j19_tri_i_22,j19_tri_i_21,j19_tri_i_20,j19_tri_i_19,j19_tri_i_18,j19_tri_i_17,j19_tri_i_16,j19_tri_i_15,j19_tri_i_14,j19_tri_i_13,j19_tri_i_12,j19_tri_i_11,j19_tri_i_10,j19_tri_i_9,j19_tri_i_8,j19_tri_i_7,j19_tri_i_6,j19_tri_i_5,j19_tri_i_4,j19_tri_i_3,j19_tri_i_2,j19_tri_i_1,j19_tri_i_0}),
        .j19_tri_o({j19_tri_o_31,j19_tri_o_30,j19_tri_o_29,j19_tri_o_28,j19_tri_o_27,j19_tri_o_26,j19_tri_o_25,j19_tri_o_24,j19_tri_o_23,j19_tri_o_22,j19_tri_o_21,j19_tri_o_20,j19_tri_o_19,j19_tri_o_18,j19_tri_o_17,j19_tri_o_16,j19_tri_o_15,j19_tri_o_14,j19_tri_o_13,j19_tri_o_12,j19_tri_o_11,j19_tri_o_10,j19_tri_o_9,j19_tri_o_8,j19_tri_o_7,j19_tri_o_6,j19_tri_o_5,j19_tri_o_4,j19_tri_o_3,j19_tri_o_2,j19_tri_o_1,j19_tri_o_0}),
        .j19_tri_t({j19_tri_t_31,j19_tri_t_30,j19_tri_t_29,j19_tri_t_28,j19_tri_t_27,j19_tri_t_26,j19_tri_t_25,j19_tri_t_24,j19_tri_t_23,j19_tri_t_22,j19_tri_t_21,j19_tri_t_20,j19_tri_t_19,j19_tri_t_18,j19_tri_t_17,j19_tri_t_16,j19_tri_t_15,j19_tri_t_14,j19_tri_t_13,j19_tri_t_12,j19_tri_t_11,j19_tri_t_10,j19_tri_t_9,j19_tri_t_8,j19_tri_t_7,j19_tri_t_6,j19_tri_t_5,j19_tri_t_4,j19_tri_t_3,j19_tri_t_2,j19_tri_t_1,j19_tri_t_0}),
        .j20_hi_tri_i({j20_hi_tri_i_15,j20_hi_tri_i_14,j20_hi_tri_i_13,j20_hi_tri_i_12,j20_hi_tri_i_11,j20_hi_tri_i_10,j20_hi_tri_i_9,j20_hi_tri_i_8,j20_hi_tri_i_7,j20_hi_tri_i_6,j20_hi_tri_i_5,j20_hi_tri_i_4,j20_hi_tri_i_3,j20_hi_tri_i_2,j20_hi_tri_i_1,j20_hi_tri_i_0}),
        .j20_hi_tri_o({j20_hi_tri_o_15,j20_hi_tri_o_14,j20_hi_tri_o_13,j20_hi_tri_o_12,j20_hi_tri_o_11,j20_hi_tri_o_10,j20_hi_tri_o_9,j20_hi_tri_o_8,j20_hi_tri_o_7,j20_hi_tri_o_6,j20_hi_tri_o_5,j20_hi_tri_o_4,j20_hi_tri_o_3,j20_hi_tri_o_2,j20_hi_tri_o_1,j20_hi_tri_o_0}),
        .j20_hi_tri_t({j20_hi_tri_t_15,j20_hi_tri_t_14,j20_hi_tri_t_13,j20_hi_tri_t_12,j20_hi_tri_t_11,j20_hi_tri_t_10,j20_hi_tri_t_9,j20_hi_tri_t_8,j20_hi_tri_t_7,j20_hi_tri_t_6,j20_hi_tri_t_5,j20_hi_tri_t_4,j20_hi_tri_t_3,j20_hi_tri_t_2,j20_hi_tri_t_1,j20_hi_tri_t_0}),
        .j20_tri_i({j20_tri_i_31,j20_tri_i_30,j20_tri_i_29,j20_tri_i_28,j20_tri_i_27,j20_tri_i_26,j20_tri_i_25,j20_tri_i_24,j20_tri_i_23,j20_tri_i_22,j20_tri_i_21,j20_tri_i_20,j20_tri_i_19,j20_tri_i_18,j20_tri_i_17,j20_tri_i_16,j20_tri_i_15,j20_tri_i_14,j20_tri_i_13,j20_tri_i_12,j20_tri_i_11,j20_tri_i_10,j20_tri_i_9,j20_tri_i_8,j20_tri_i_7,j20_tri_i_6,j20_tri_i_5,j20_tri_i_4,j20_tri_i_3,j20_tri_i_2,j20_tri_i_1,j20_tri_i_0}),
        .j20_tri_o({j20_tri_o_31,j20_tri_o_30,j20_tri_o_29,j20_tri_o_28,j20_tri_o_27,j20_tri_o_26,j20_tri_o_25,j20_tri_o_24,j20_tri_o_23,j20_tri_o_22,j20_tri_o_21,j20_tri_o_20,j20_tri_o_19,j20_tri_o_18,j20_tri_o_17,j20_tri_o_16,j20_tri_o_15,j20_tri_o_14,j20_tri_o_13,j20_tri_o_12,j20_tri_o_11,j20_tri_o_10,j20_tri_o_9,j20_tri_o_8,j20_tri_o_7,j20_tri_o_6,j20_tri_o_5,j20_tri_o_4,j20_tri_o_3,j20_tri_o_2,j20_tri_o_1,j20_tri_o_0}),
        .j20_tri_t({j20_tri_t_31,j20_tri_t_30,j20_tri_t_29,j20_tri_t_28,j20_tri_t_27,j20_tri_t_26,j20_tri_t_25,j20_tri_t_24,j20_tri_t_23,j20_tri_t_22,j20_tri_t_21,j20_tri_t_20,j20_tri_t_19,j20_tri_t_18,j20_tri_t_17,j20_tri_t_16,j20_tri_t_15,j20_tri_t_14,j20_tri_t_13,j20_tri_t_12,j20_tri_t_11,j20_tri_t_10,j20_tri_t_9,j20_tri_t_8,j20_tri_t_7,j20_tri_t_6,j20_tri_t_5,j20_tri_t_4,j20_tri_t_3,j20_tri_t_2,j20_tri_t_1,j20_tri_t_0}),
        .jm1_tri_i({jm1_tri_i_31,jm1_tri_i_30,jm1_tri_i_29,jm1_tri_i_28,jm1_tri_i_27,jm1_tri_i_26,jm1_tri_i_25,jm1_tri_i_24,jm1_tri_i_23,jm1_tri_i_22,jm1_tri_i_21,jm1_tri_i_20,jm1_tri_i_19,jm1_tri_i_18,jm1_tri_i_17,jm1_tri_i_16,jm1_tri_i_15,jm1_tri_i_14,jm1_tri_i_13,jm1_tri_i_12,jm1_tri_i_11,jm1_tri_i_10,jm1_tri_i_9,jm1_tri_i_8,jm1_tri_i_7,jm1_tri_i_6,jm1_tri_i_5,jm1_tri_i_4,jm1_tri_i_3,jm1_tri_i_2,jm1_tri_i_1,jm1_tri_i_0}),
        .jm1_tri_o({jm1_tri_o_31,jm1_tri_o_30,jm1_tri_o_29,jm1_tri_o_28,jm1_tri_o_27,jm1_tri_o_26,jm1_tri_o_25,jm1_tri_o_24,jm1_tri_o_23,jm1_tri_o_22,jm1_tri_o_21,jm1_tri_o_20,jm1_tri_o_19,jm1_tri_o_18,jm1_tri_o_17,jm1_tri_o_16,jm1_tri_o_15,jm1_tri_o_14,jm1_tri_o_13,jm1_tri_o_12,jm1_tri_o_11,jm1_tri_o_10,jm1_tri_o_9,jm1_tri_o_8,jm1_tri_o_7,jm1_tri_o_6,jm1_tri_o_5,jm1_tri_o_4,jm1_tri_o_3,jm1_tri_o_2,jm1_tri_o_1,jm1_tri_o_0}),
        .jm1_tri_t({jm1_tri_t_31,jm1_tri_t_30,jm1_tri_t_29,jm1_tri_t_28,jm1_tri_t_27,jm1_tri_t_26,jm1_tri_t_25,jm1_tri_t_24,jm1_tri_t_23,jm1_tri_t_22,jm1_tri_t_21,jm1_tri_t_20,jm1_tri_t_19,jm1_tri_t_18,jm1_tri_t_17,jm1_tri_t_16,jm1_tri_t_15,jm1_tri_t_14,jm1_tri_t_13,jm1_tri_t_12,jm1_tri_t_11,jm1_tri_t_10,jm1_tri_t_9,jm1_tri_t_8,jm1_tri_t_7,jm1_tri_t_6,jm1_tri_t_5,jm1_tri_t_4,jm1_tri_t_3,jm1_tri_t_2,jm1_tri_t_1,jm1_tri_t_0}),
        .led_5bits_tri_o(led_5bits_tri_o),
        .led_core_tri_o(led_core_tri_o),
        .mdio_mdc(mdio_mdc),
        .mdio_mdio_i(mdio_mdio_i),
        .mdio_mdio_o(mdio_mdio_o),
        .mdio_mdio_t(mdio_mdio_t),
        .phy_reset_n(phy_reset_n),
        .push_buttons_5bits_tri_i(push_buttons_5bits_tri_i),
        .reset(reset),
        .rgmii_rd(rgmii_rd),
        .rgmii_rx_ctl(rgmii_rx_ctl),
        .rgmii_rxc(rgmii_rxc),
        .rgmii_td(rgmii_td),
        .rgmii_tx_ctl(rgmii_tx_ctl),
        .rgmii_txc(rgmii_txc),
        .sys_diff_clock_clk_n(sys_diff_clock_clk_n),
        .sys_diff_clock_clk_p(sys_diff_clock_clk_p));
endmodule
