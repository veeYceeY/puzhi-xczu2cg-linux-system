#!/usr/bin/env python3
"""Generate Vivado board files for the Puzhi PZ-ZU2CG development board.

Source of truth: docs/ZYNQ UltraScale+ MPSOC ZU2CG FPGA Board User Manual.pdf
(Puzhi ZU2/3/4/5 user manual).  Only ZU2/ZU3 bank numbering is used here
(HD banks 24/25/26/44, HP banks 64/65/66).  ZU4/5-only features (SFP, PCIe on
the gold fingers, 125 MHz GTH clock) do not exist on the XCZU2CG.

Outputs (written next to this script's ../board_files/pz_zu2cg/1.0):
  board.xml, part0_pins.xml, preset.xml, and ../../../constraints/pz_zu2cg_master.xdc
"""
import os
from xml.sax.saxutils import escape

PART = "xczu2cg-sfvc784-2-i"
ROOT = os.path.normpath(os.path.join(os.path.dirname(__file__), ".."))
OUT = os.path.join(ROOT, "board_files", "pz_zu2cg", "1.0")
XDC = os.path.join(ROOT, "constraints", "pz_zu2cg_master.xdc")

# ---------------------------------------------------------------------------
# PL pin definitions (manual section in comment)
# ---------------------------------------------------------------------------
# 3.6 System clock: 200 MHz differential on bank 65 (VCCO 1.2 V, shared with PL DDR4)
SYS_CLK = [("sys_clk_p", "L3"), ("sys_clk_n", "L2")]

# 4.2 Reset: IO_T1U_66 (D2), active low, bank 66 @ 1.8 V
RESET = [("reset_n", "D2")]

# 3.12 Core-board LEDs, bank 64 @ 1.8 V, active high
LED_CORE = ["AH6", "AB5", "AE4"]
# 4.14 Carrier LEDs, bank 44 @ 3.3 V, active high
LED_CARRIER = ["AD10", "AD11", "AF12", "AB10", "AB9"]
# 4.15 Carrier keys, bank 44 @ 3.3 V, active low
KEYS = ["AE10", "AH10", "AG10", "AG11", "AF11"]
# 4.7 EEPROM AT24C64 on I2C, bank 44 @ 3.3 V
IIC_SCL, IIC_SDA = "AC12", "AD12"

# 4.10 PL Ethernet (KSZ9031, PHY addr 2), RGMII on bank 66 @ 1.8 V
RGMII_TD = ["A4", "B4", "A3", "B3"]
RGMII_TX_CTL, RGMII_TXC = "D9", "E9"
RGMII_RD = ["B9", "C8", "B8", "C6"]
RGMII_RX_CTL, RGMII_RXC = "C9", "D4"
MDIO_MDC, MDIO_IO = "G5", "C4"
PHY_RST_N = "B6"

# 4.8 Mini DP AUX (PS DisplayPort routed through EMIO), bank 26 @ 3.3 V
DP_AUX = [("dp_aux_out", "A15"), ("dp_aux_oe", "B15"),
          ("dp_aux_in", "H14"), ("dp_hpd", "H13")]

# 3.14 PL DDR4: 1x MT40A512M16LY-062E (x16, 1 GB) on bank 65
DDR_DQ = ["J6", "H9", "J7", "K9", "H7", "J9", "H6", "H8",
          "M6", "N8", "N6", "N7", "L8", "N9", "L5", "M8"]
DDR_DM = ["J5", "L7"]
DDR_DQS_T = ["K8", "P7"]
DDR_DQS_C = ["K7", "P6"]
DDR_ADR = ["H1", "U8", "J1", "V8", "K4", "R8", "J2", "U9", "K2", "W8",
           "T8", "K1", "T6", "Y8", "K3", "R7", "P9"]       # A0..A16
DDR_BA = ["H2", "T7"]
DDR_BG = ["V9"]
DDR_CS_N, DDR_ACT_N, DDR_ODT, DDR_RESET_N = "R6", "L6", "J4", "L1"
DDR_CK_T, DDR_CK_C, DDR_CKE = "H4", "H3", "K5"

# 4.16 40-pin header JM1 (banks 44/24 @ 3.3 V): header pin -> FPGA pin
JM1 = {5: "W10", 7: "Y10", 9: "AB11", 11: "AC11", 13: "Y14", 15: "Y13",
       17: "AA13", 19: "AB13", 21: "W12", 23: "W11", 25: "AG14", 27: "AH14",
       29: "AD15", 31: "AD14", 37: "Y12", 39: "AA12",
       6: "AA11", 8: "AA10", 10: "AH12", 12: "AH11", 14: "AC14", 16: "AC13",
       18: "W14", 20: "W13", 22: "AB15", 24: "AB14", 26: "AE13", 28: "AF13",
       30: "AE15", 32: "AE14", 38: "AG13", 40: "AH13"}

# 4.17 120-pin board-to-board J19 (bank 66 @ 1.8 V default)
J19 = {9: "B5", 11: "A5", 15: "A7", 17: "A6", 21: "G1", 23: "F1",
       27: "E1", 29: "D1", 33: "E4", 35: "E3", 39: "G3", 41: "F3",
       45: "D7", 47: "D6", 51: "G6", 53: "F6",
       10: "A9", 12: "A8", 16: "F8", 18: "E8", 22: "C3", 24: "C2",
       28: "C1", 30: "B1", 34: "F2", 36: "E2", 40: "G8", 42: "F7",
       46: "A2", 48: "A1", 52: "E5", 54: "D5"}
# 4.17 120-pin board-to-board J20 (bank 64 @ 1.8 V default)
J20 = {9: "AB2", 11: "AC2", 15: "AF1", 17: "AG1", 21: "AB6", 23: "AC6",
       27: "AG6", 29: "AG5", 33: "AH8", 35: "AH7", 39: "AE3", 41: "AF3",
       45: "AG4", 47: "AH4", 51: "AF8", 53: "AG8", 57: "AC4", 59: "AC3",
       63: "AG9", 65: "AH9", 69: "AE5", 71: "AF5", 75: "AE9", 77: "AE8",
       10: "AB1", 12: "AC1", 16: "AB4", 18: "AB3", 22: "AF7", 24: "AF6",
       28: "AB7", 30: "AC7", 34: "AC9", 36: "AD9", 40: "AB8", 42: "AC8",
       46: "AH2", 48: "AH1", 52: "AD2", 54: "AD1", 58: "AE2", 60: "AF2",
       64: "AD5", 66: "AD4", 70: "AD7", 72: "AE7", 76: "AG3", 78: "AH3"}
# J19/J20 ball -> XCZU2CG-SFVC784 pin name (PIN_FUNC from Vivado 2026.1 package data).
# Every P ball pairs with the N ball two connector pins later, e.g. J19-9/11.
EXP_PIN_FUNC = {
    "B5": "IO_L19P_T3L_N0_DBC_AD9P_66", "A9": "IO_L23P_T3U_N8_66", "A5": "IO_L19N_T3L_N1_DBC_AD9N_66",
    "A8": "IO_L23N_T3U_N9_66", "A7": "IO_L21P_T3L_N4_AD8P_66", "F8": "IO_L17P_T2U_N8_AD10P_66",
    "A6": "IO_L21N_T3L_N5_AD8N_66", "E8": "IO_L17N_T2U_N9_AD10N_66", "G1": "IO_L1P_T0L_N0_DBC_66",
    "C3": "IO_L12P_T1U_N10_GC_66", "F1": "IO_L1N_T0L_N1_DBC_66", "C2": "IO_L12N_T1U_N11_GC_66",
    "E1": "IO_L2P_T0L_N2_66", "C1": "IO_L7P_T1L_N0_QBC_AD13P_66", "D1": "IO_L2N_T0L_N3_66",
    "B1": "IO_L7N_T1L_N1_QBC_AD13N_66", "E4": "IO_L5P_T0U_N8_AD14P_66", "F2": "IO_L3P_T0L_N4_AD15P_66",
    "E3": "IO_L5N_T0U_N9_AD14N_66", "E2": "IO_L3N_T0L_N5_AD15N_66", "G3": "IO_L4P_T0U_N6_DBC_AD7P_66",
    "G8": "IO_L16P_T2U_N6_QBC_AD3P_66", "F3": "IO_L4N_T0U_N7_DBC_AD7N_66",
    "F7": "IO_L16N_T2U_N7_QBC_AD3N_66", "D7": "IO_L13P_T2L_N0_GC_QBC_66", "A2": "IO_L8P_T1L_N2_AD5P_66",
    "D6": "IO_L13N_T2L_N1_GC_QBC_66", "A1": "IO_L8N_T1L_N3_AD5N_66", "G6": "IO_L15P_T2L_N4_AD11P_66",
    "E5": "IO_L14P_T2L_N2_GC_66", "F6": "IO_L15N_T2L_N5_AD11N_66", "D5": "IO_L14N_T2L_N3_GC_66",
    "AB2": "IO_L17P_T2U_N8_AD10P_64", "AB1": "IO_L18P_T2U_N10_AD2P_64", "AC2": "IO_L17N_T2U_N9_AD10N_64",
    "AC1": "IO_L18N_T2U_N11_AD2N_64", "AF1": "IO_L24P_T3U_N10_64", "AB4": "IO_L15P_T2L_N4_AD11P_64",
    "AG1": "IO_L24N_T3U_N11_64", "AB3": "IO_L15N_T2L_N5_AD11N_64", "AB6": "IO_L6P_T0U_N10_AD6P_64",
    "AF7": "IO_L11P_T1U_N8_GC_64", "AC6": "IO_L6N_T0U_N11_AD6N_64", "AF6": "IO_L11N_T1U_N9_GC_64",
    "AG6": "IO_L10P_T1U_N6_QBC_AD4P_64", "AB7": "IO_L5P_T0U_N8_AD14P_64",
    "AG5": "IO_L10N_T1U_N7_QBC_AD4N_64", "AC7": "IO_L5N_T0U_N9_AD14N_64", "AH8": "IO_L9P_T1L_N4_AD12P_64",
    "AC9": "IO_L1P_T0L_N0_DBC_64", "AH7": "IO_L9N_T1L_N5_AD12N_64", "AD9": "IO_L1N_T0L_N1_DBC_64",
    "AE3": "IO_L21P_T3L_N4_AD8P_64", "AB8": "IO_L3P_T0L_N4_AD15P_64", "AF3": "IO_L21N_T3L_N5_AD8N_64",
    "AC8": "IO_L3N_T0L_N5_AD15N_64", "AG4": "IO_L19P_T3L_N0_DBC_AD9P_64", "AH2": "IO_L23P_T3U_N8_64",
    "AH4": "IO_L19N_T3L_N1_DBC_AD9N_64", "AH1": "IO_L23N_T3U_N9_64", "AF8": "IO_L8P_T1L_N2_AD5P_64",
    "AD2": "IO_L16P_T2U_N6_QBC_AD3P_64", "AG8": "IO_L8N_T1L_N3_AD5N_64", "AD1": "IO_L16N_T2U_N7_QBC_AD3N_64",
    "AC4": "IO_L14P_T2L_N2_GC_64", "AE2": "IO_L22P_T3U_N6_DBC_AD0P_64", "AC3": "IO_L14N_T2L_N3_GC_64",
    "AF2": "IO_L22N_T3U_N7_DBC_AD0N_64", "AG9": "IO_L7P_T1L_N0_QBC_AD13P_64",
    "AD5": "IO_L13P_T2L_N0_GC_QBC_64", "AH9": "IO_L7N_T1L_N1_QBC_AD13N_64",
    "AD4": "IO_L13N_T2L_N1_GC_QBC_64", "AE5": "IO_L12P_T1U_N10_GC_64", "AD7": "IO_L4P_T0U_N6_DBC_AD7P_64",
    "AF5": "IO_L12N_T1U_N11_GC_64", "AE7": "IO_L4N_T0U_N7_DBC_AD7N_64", "AE9": "IO_L2P_T0L_N2_64",
    "AG3": "IO_L20P_T3L_N2_AD1P_64", "AE8": "IO_L2N_T0L_N3_64", "AH3": "IO_L20N_T3L_N3_AD1N_64"}


# ---------------------------------------------------------------------------
# part0_pins.xml
# ---------------------------------------------------------------------------
pins = []          # (name, loc, iostandard)
pin_index = {}


def pin(name, loc, iostd):
    assert name not in pin_index, name
    pin_index[name] = len(pins)
    pins.append((name, loc, iostd))
    return name


for n, l in SYS_CLK:
    pin(n, l, "DIFF_SSTL12")
pin("reset_n", RESET[0][1], "LVCMOS18")
for i, l in enumerate(LED_CORE):
    pin(f"led_core_tri_o_{i}", l, "LVCMOS18")
for i, l in enumerate(LED_CARRIER):
    pin(f"led_5bits_tri_o_{i}", l, "LVCMOS33")
for i, l in enumerate(KEYS):
    pin(f"push_buttons_5bits_tri_i_{i}", l, "LVCMOS33")
pin("iic_eeprom_scl_io", IIC_SCL, "LVCMOS33")
pin("iic_eeprom_sda_io", IIC_SDA, "LVCMOS33")
for i, l in enumerate(RGMII_TD):
    pin(f"rgmii_td_{i}", l, "LVCMOS18")
pin("rgmii_tx_ctl", RGMII_TX_CTL, "LVCMOS18")
pin("rgmii_txc", RGMII_TXC, "LVCMOS18")
for i, l in enumerate(RGMII_RD):
    pin(f"rgmii_rd_{i}", l, "LVCMOS18")
pin("rgmii_rx_ctl", RGMII_RX_CTL, "LVCMOS18")
pin("rgmii_rxc", RGMII_RXC, "LVCMOS18")
pin("mdio_mdc", MDIO_MDC, "LVCMOS18")
pin("mdio_mdio_io", MDIO_IO, "LVCMOS18")
pin("phy_reset_n", PHY_RST_N, "LVCMOS18")
for i, l in enumerate(DDR_ADR):
    pin(f"c0_ddr4_adr{i}", l, None)
for i, l in enumerate(DDR_BA):
    pin(f"c0_ddr4_ba{i}", l, None)
for i, l in enumerate(DDR_BG):
    pin(f"c0_ddr4_bg{i}", l, None)
pin("c0_ddr4_act_n", DDR_ACT_N, None)
pin("c0_ddr4_ck_t", DDR_CK_T, None)
pin("c0_ddr4_ck_c", DDR_CK_C, None)
pin("c0_ddr4_cke", DDR_CKE, None)
pin("c0_ddr4_cs_n", DDR_CS_N, None)
pin("c0_ddr4_odt", DDR_ODT, None)
pin("c0_ddr4_reset_n", DDR_RESET_N, "LVCMOS12")
for i, l in enumerate(DDR_DM):
    pin(f"c0_ddr4_dm_n{i}", l, None)
for i, l in enumerate(DDR_DQ):
    pin(f"c0_ddr4_dq{i}", l, None)
for i, l in enumerate(DDR_DQS_T):
    pin(f"c0_ddr4_dqs_t{i}", l, None)
for i, l in enumerate(DDR_DQS_C):
    pin(f"c0_ddr4_dqs_c{i}", l, None)

# sanity: no FPGA pin used twice
locs = [p[1] for p in pins] + [l for _, l in DP_AUX] + list(JM1.values()) \
    + list(J19.values()) + list(J20.values())
dups = {l for l in locs if locs.count(l) > 1}
assert not dups, f"duplicate pin locations: {dups}"


def part0_pins_xml():
    out = ['<?xml version="1.0" encoding="UTF-8" standalone="no"?>',
           f'<part_info part_name="{PART}">',
           '  <pins>']
    for i, (n, l, s) in enumerate(pins):
        std = f' iostandard="{s}"' if s else ""
        out.append(f'    <pin index="{i}" name="{n}"{std} loc="{l}"/>')
    out += ['  </pins>', '</part_info>', '']
    return "\n".join(out)


# ---------------------------------------------------------------------------
# board.xml
# ---------------------------------------------------------------------------
def pmap(logical, physical, direction, names, vector=False):
    """port_map element; names = list of component pins (LSB first)."""
    rng = f' left="{len(names) - 1}" right="0"' if vector else ""
    s = [f'            <port_map logical_port="{logical}" physical_port="{physical}" dir="{direction}"{rng}>',
         '              <pin_maps>']
    for i, n in enumerate(names):
        assert n in pin_index, n
        s.append(f'                <pin_map port_index="{i}" component_pin="{n}"/>')
    s += ['              </pin_maps>', '            </port_map>']
    return "\n".join(s)


def iface(name, itype, comp, preset, ips, port_maps, desc, mode="master", params=None):
    s = [f'        <interface mode="{mode}" name="{name}" type="{itype}" of_component="{comp}"'
         + (f' preset_proc="{preset}"' if preset else "") + '>']
    if params:
        s.append('          <parameters>')
        for k, v in params:
            s.append(f'            <parameter name="{k}" value="{v}"/>')
        s.append('          </parameters>')
    s += [f'          <description>{escape(desc)}</description>',
          '          <preferred_ips>']
    for order, ip in enumerate(ips):
        s.append(f'            <preferred_ip vendor="xilinx.com" library="ip" name="{ip}" order="{order}"/>')
    s.append('          </preferred_ips>')
    if port_maps:
        s.append('          <port_maps>')
        s += port_maps
        s.append('          </port_maps>')
    s.append('        </interface>')
    return "\n".join(s)


def rng(prefix, n):
    return [f"{prefix}{i}" for i in range(n)]


interfaces = []

interfaces.append(
    '        <interface mode="master" name="ps8_fixedio" type="xilinx.com:zynq_ultra_ps_e:fixedio_rtl:1.0" '
    'of_component="ps8_fixedio" preset_proc="zynq_ultra_ps_e_preset">\n'
    '          <description>Zynq UltraScale+ PS configuration (DDR4, QSPI, eMMC, SD, GEM0, USB3, DP, PCIe/NVMe, UART, CAN)</description>\n'
    '          <preferred_ips>\n'
    '            <preferred_ip vendor="xilinx.com" library="ip" name="zynq_ultra_ps_e" order="0"/>\n'
    '          </preferred_ips>\n'
    '        </interface>')

interfaces.append(iface(
    "sys_diff_clock", "xilinx.com:interface:diff_clock_rtl:1.0", "sys_diff_clock",
    "sys_diff_clock_preset", ["clk_wiz", "ddr4", "util_ds_buf"],
    [pmap("CLK_P", "sys_clk_p", "in", ["sys_clk_p"]),
     pmap("CLK_N", "sys_clk_n", "in", ["sys_clk_n"])],
    "200 MHz differential system clock (bank 65)", mode="slave",
    params=[("frequency", "200000000")]))

interfaces.append(iface(
    "reset", "xilinx.com:signal:reset_rtl:1.0", "reset", "reset_preset",
    ["proc_sys_reset", "clk_wiz", "ddr4"],
    [pmap("RESET", "reset_n", "in", ["reset_n"])],
    "Global reset (core + carrier reset keys / MAX811 output), active low",
    mode="slave", params=[("rst_polarity", "0")]))

interfaces.append(iface(
    "led_5bits", "xilinx.com:interface:gpio_rtl:1.0", "led_5bits", "led_5bits_preset",
    ["axi_gpio"],
    [pmap("TRI_O", "led_5bits_tri_o", "out", rng("led_5bits_tri_o_", 5), True)],
    "Carrier board LEDs 1-5, active high (bank 44, 3.3 V)"))

interfaces.append(iface(
    "led_core", "xilinx.com:interface:gpio_rtl:1.0", "led_core", "led_core_preset",
    ["axi_gpio"],
    [pmap("TRI_O", "led_core_tri_o", "out", rng("led_core_tri_o_", 3), True)],
    "Core board LEDs 1-3, active high (bank 64, 1.8 V)"))

interfaces.append(iface(
    "push_buttons_5bits", "xilinx.com:interface:gpio_rtl:1.0", "push_buttons_5bits",
    "push_buttons_5bits_preset", ["axi_gpio"],
    [pmap("TRI_I", "push_buttons_5bits_tri_i", "in", rng("push_buttons_5bits_tri_i_", 5), True)],
    "Carrier board keys 1-5, active low (bank 44, 3.3 V)"))

interfaces.append(iface(
    "iic_eeprom", "xilinx.com:interface:iic_rtl:1.0", "iic_eeprom", None,
    ["axi_iic"],
    [pmap("SCL_I", "iic_eeprom_scl_i", "in", ["iic_eeprom_scl_io"]),
     pmap("SCL_O", "iic_eeprom_scl_o", "out", ["iic_eeprom_scl_io"]),
     pmap("SCL_T", "iic_eeprom_scl_t", "out", ["iic_eeprom_scl_io"]),
     pmap("SDA_I", "iic_eeprom_sda_i", "in", ["iic_eeprom_sda_io"]),
     pmap("SDA_O", "iic_eeprom_sda_o", "out", ["iic_eeprom_sda_io"]),
     pmap("SDA_T", "iic_eeprom_sda_t", "out", ["iic_eeprom_sda_io"])],
    "I2C bus to AT24C64 EEPROM (7-bit address 0x50)"))

interfaces.append(iface(
    "rgmii", "xilinx.com:interface:rgmii_rtl:1.0", "phy_pl", "rgmii_preset",
    ["axi_ethernet", "gmii_to_rgmii"],
    [pmap("TD", "rgmii_td", "out", rng("rgmii_td_", 4), True),
     pmap("TX_CTL", "rgmii_tx_ctl", "out", ["rgmii_tx_ctl"]),
     pmap("TXC", "rgmii_txc", "out", ["rgmii_txc"]),
     pmap("RD", "rgmii_rd", "in", rng("rgmii_rd_", 4), True),
     pmap("RX_CTL", "rgmii_rx_ctl", "in", ["rgmii_rx_ctl"]),
     pmap("RXC", "rgmii_rxc", "in", ["rgmii_rxc"])],
    "PL Gigabit Ethernet RGMII to KSZ9031 (bank 66, 1.8 V)"))

interfaces.append(iface(
    "mdio_mdc", "xilinx.com:interface:mdio_rtl:1.0", "phy_pl", None,
    ["axi_ethernet", "gmii_to_rgmii"],
    [pmap("MDC", "mdio_mdc", "out", ["mdio_mdc"]),
     pmap("MDIO_I", "mdio_mdio_i", "in", ["mdio_mdio_io"]),
     pmap("MDIO_O", "mdio_mdio_o", "out", ["mdio_mdio_io"]),
     pmap("MDIO_T", "mdio_mdio_t", "out", ["mdio_mdio_io"])],
    "PL Ethernet PHY management (MDIO/MDC)"))

interfaces.append(iface(
    "phy_reset_out", "xilinx.com:signal:reset_rtl:1.0", "phy_pl", None,
    ["axi_ethernet"],
    [pmap("RESET", "phy_reset_n", "out", ["phy_reset_n"])],
    "PL Ethernet PHY reset, active low",
    params=[("rst_polarity", "0")]))

ddr_maps = [
    pmap("ACT_N", "c0_ddr4_act_n", "out", ["c0_ddr4_act_n"]),
    pmap("ADR", "c0_ddr4_adr", "out", rng("c0_ddr4_adr", 17), True),
    pmap("BA", "c0_ddr4_ba", "out", rng("c0_ddr4_ba", 2), True),
    pmap("BG", "c0_ddr4_bg", "out", rng("c0_ddr4_bg", 1)),
    pmap("CK_C", "c0_ddr4_ck_c", "out", ["c0_ddr4_ck_c"]),
    pmap("CK_T", "c0_ddr4_ck_t", "out", ["c0_ddr4_ck_t"]),
    pmap("CKE", "c0_ddr4_cke", "out", ["c0_ddr4_cke"]),
    pmap("CS_N", "c0_ddr4_cs_n", "out", ["c0_ddr4_cs_n"]),
    pmap("DM_N", "c0_ddr4_dm_n", "inout", rng("c0_ddr4_dm_n", 2), True),
    pmap("DQ", "c0_ddr4_dq", "inout", rng("c0_ddr4_dq", 16), True),
    pmap("DQS_C", "c0_ddr4_dqs_c", "inout", rng("c0_ddr4_dqs_c", 2), True),
    pmap("DQS_T", "c0_ddr4_dqs_t", "inout", rng("c0_ddr4_dqs_t", 2), True),
    pmap("ODT", "c0_ddr4_odt", "out", ["c0_ddr4_odt"]),
    pmap("RESET_N", "c0_ddr4_reset_n", "out", ["c0_ddr4_reset_n"]),
]
interfaces.append(iface(
    "ddr4_sdram", "xilinx.com:interface:ddr4_rtl:1.0", "ddr4_sdram", "ddr4_sdram_preset",
    ["ddr4"], ddr_maps, "PL DDR4 SDRAM, 1 GB, 16-bit, 2400 MT/s (bank 65)"))


components = f'''    <component name="part0" display_name="PZ-ZU2CG" type="fpga" part_name="{PART}" pin_map_file="part0_pins.xml" vendor="xilinx" spec_url="www.puzhitech.com">
      <description>XCZU2CG-2SFVC784I on the Puzhi ZU2/3/4/5 core board</description>
      <interfaces>
{chr(10).join(interfaces)}
      </interfaces>
    </component>
    <component name="ps8_fixedio" display_name="PS8 fixed IO" type="chip" sub_type="fixed_io" major_group=""/>
    <component name="sys_diff_clock" display_name="System differential clock 200 MHz" type="chip" sub_type="system_clock" major_group="Clock Sources">
      <description>200 MHz active differential oscillator on the core board, bank 65 L3/L2</description>
      <parameters>
        <parameter name="frequency" value="200000000"/>
      </parameters>
    </component>
    <component name="reset" display_name="FPGA Reset" type="chip" sub_type="system_reset" major_group="Reset">
      <description>Global reset, active low (IO_T1U_66, D2)</description>
    </component>
    <component name="led_5bits" display_name="Carrier LEDs" type="chip" sub_type="led" major_group="General Purpose Input or Output">
      <description>Carrier board LEDs 1-5, active high</description>
    </component>
    <component name="led_core" display_name="Core board LEDs" type="chip" sub_type="led" major_group="General Purpose Input or Output">
      <description>Core board LEDs 1-3, active high</description>
    </component>
    <component name="push_buttons_5bits" display_name="Push buttons" type="chip" sub_type="push_button" major_group="General Purpose Input or Output">
      <description>Carrier board keys 1-5, active low</description>
    </component>
    <component name="iic_eeprom" display_name="EEPROM (I2C)" type="chip" sub_type="memory" major_group="Miscellaneous" part_name="AT24C64D-SSHM-T" vendor="Microchip">
      <description>64 Kbit I2C EEPROM, 7-bit address 0x50</description>
    </component>
    <component name="phy_pl" display_name="PL Ethernet PHY" type="chip" sub_type="ethernet" major_group="Ethernet Configurations" part_name="KSZ9031RNX" vendor="Microchip">
      <description>KSZ9031 RGMII Gigabit PHY connected to PL bank 66, PHY address 2</description>
      <parameters>
        <parameter name="phy_addr" value="2"/>
      </parameters>
    </component>
    <component name="ddr4_sdram" display_name="PL DDR4 SDRAM" type="chip" sub_type="ddr" major_group="External Memory" part_name="MT40A512M16LY-062E" vendor="Micron" spec_url="www.micron.com">
      <description>1 GB DDR4 component, 16-bit, connected to PL bank 65</description>
      <parameters>
        <parameter name="ddr_type" value="ddr4"/>
        <parameter name="size" value="1GB"/>
      </parameters>
    </component>'''


def conn(comp, first_pin, count):
    st = pin_index[first_pin]
    return (f'    <connection name="part0_{comp}" component1="part0" component2="{comp}">\n'
            f'      <connection_map name="part0_{comp}_1" typical_delay="5" c1_st_index="{st}" '
            f'c1_end_index="{st + count - 1}" c2_st_index="0" c2_end_index="{count - 1}"/>\n'
            f'    </connection>')


ddr_first = "c0_ddr4_adr0"
ddr_count = pin_index["c0_ddr4_dqs_c1"] - pin_index[ddr_first] + 1
eth_first = "rgmii_td_0"
eth_count = pin_index["phy_reset_n"] - pin_index[eth_first] + 1
connections = "\n".join([
    conn("sys_diff_clock", "sys_clk_p", 2),
    conn("reset", "reset_n", 1),
    conn("led_core", "led_core_tri_o_0", 3),
    conn("led_5bits", "led_5bits_tri_o_0", 5),
    conn("push_buttons_5bits", "push_buttons_5bits_tri_i_0", 5),
    conn("iic_eeprom", "iic_eeprom_scl_io", 2),
    conn("phy_pl", eth_first, eth_count),
    conn("ddr4_sdram", ddr_first, ddr_count),
])

board_xml = f'''<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<board schema_version="2.2" vendor="puzhitech.com" name="pz_zu2cg" display_name="Puzhi PZ-ZU2CG Development Board" url="www.puzhitech.com" preset_file="preset.xml">
  <images>
    <image name="pz_zu2cg_board.jpg" display_name="PZ-ZU2CG Board" sub_type="board">
      <description>PZ-ZU2CG board image</description>
    </image>
  </images>
  <compatible_board_revisions>
    <revision id="0">1.0</revision>
  </compatible_board_revisions>
  <file_version>1.0</file_version>
  <description>Puzhi ZYNQ UltraScale+ MPSoC development board with XCZU2CG-2SFVC784I SOM: 4 GB PS DDR4, 1 GB PL DDR4, 8 GB eMMC, 32 MB QSPI, PS + PL Gigabit Ethernet, USB 3.0, Mini DP, M.2 NVMe, SD, UART, RS485, CAN.</description>
  <components>
{components}
  </components>
  <jtag_chains>
    <jtag_chain name="chain1">
      <position name="0" component="part0"/>
    </jtag_chain>
  </jtag_chains>
  <connections>
{connections}
  </connections>
</board>
'''

# ---------------------------------------------------------------------------
# preset.xml
# ---------------------------------------------------------------------------
PS = [
    # Clocking
    ("PSU__PSS_REF_CLK__FREQMHZ", "33.333"),
    ("PSU__CRF_APB__DDR_CTRL__FREQMHZ", "1200"),
    ("PSU__FPGA_PL0_ENABLE", "1"),
    ("PSU__CRL_APB__PL0_REF_CTRL__FREQMHZ", "100"),
    # MIO bank voltages (all PS MIO banks are 1.8 V on this SOM)
    ("PSU_BANK_0_IO_STANDARD", "LVCMOS18"),
    ("PSU_BANK_1_IO_STANDARD", "LVCMOS18"),
    ("PSU_BANK_2_IO_STANDARD", "LVCMOS18"),
    ("PSU_BANK_3_IO_STANDARD", "LVCMOS18"),
    # PS DDR4: 4x MT40A512M16LY-062E, 64-bit, 4 GB, run at DDR4-2400
    ("PSU__DDRC__ENABLE", "1"),
    ("PSU__DDRC__MEMORY_TYPE", "DDR 4"),
    ("PSU__DDRC__COMPONENTS", "Components"),
    ("PSU__DDRC__SPEED_BIN", "DDR4_2400R"),
    ("PSU__DDRC__SB_TARGET", "16-16-16"),
    ("PSU__DDRC__CL", "16"),
    ("PSU__DDRC__CWL", "12"),
    ("PSU__DDRC__T_RCD", "16"),
    ("PSU__DDRC__T_RP", "16"),
    ("PSU__DDRC__T_RAS_MIN", "32"),
    ("PSU__DDRC__T_RC", "45.32"),
    ("PSU__DDRC__T_FAW", "30.0"),
    ("PSU__DDRC__BUS_WIDTH", "64 Bit"),
    ("PSU__DDRC__DRAM_WIDTH", "16 Bits"),
    ("PSU__DDRC__DEVICE_CAPACITY", "8192 MBits"),
    ("PSU__DDRC__RANK_ADDR_COUNT", "0"),
    ("PSU__DDRC__BG_ADDR_COUNT", "1"),
    ("PSU__DDRC__BANK_ADDR_COUNT", "2"),
    ("PSU__DDRC__ROW_ADDR_COUNT", "16"),
    ("PSU__DDRC__COL_ADDR_COUNT", "10"),
    ("PSU__DDRC__ECC", "Disabled"),
    ("PSU__DDRC__DM_DBI", "DM_NO_DBI"),
    ("PSU__DDRC__PARITY_ENABLE", "0"),
    ("PSU__DDRC__BRC_MAPPING", "ROW_BANK_COL"),
    # QSPI0: W25Q256JW, single x4 on MIO0-5, feedback clock MIO6
    ("PSU__QSPI__PERIPHERAL__ENABLE", "1"),
    ("PSU__QSPI__PERIPHERAL__MODE", "Single"),
    ("PSU__QSPI__PERIPHERAL__IO", "MIO 0 .. 5"),
    ("PSU__QSPI__PERIPHERAL__DATA_MODE", "x4"),
    ("PSU__QSPI__GRP_FBCLK__ENABLE", "1"),
    ("PSU__QSPI__GRP_FBCLK__IO", "MIO 6"),
    # SD0: 8 GB eMMC on MIO13-22 (MIO23 eMMC reset is a GPIO)
    ("PSU__SD0__PERIPHERAL__ENABLE", "1"),
    ("PSU__SD0__PERIPHERAL__IO", "MIO 13 .. 22"),
    ("PSU__SD0__SLOT_TYPE", "eMMC"),
    ("PSU__SD0__DATA_TRANSFER_MODE", "8Bit"),
    # SD1: TF card on MIO46-51 behind a TXS02612 level shifter
    ("PSU__SD1__PERIPHERAL__ENABLE", "1"),
    ("PSU__SD1__PERIPHERAL__IO", "MIO 46 .. 51"),
    ("PSU__SD1__SLOT_TYPE", "SD 2.0"),
    ("PSU__SD1__DATA_TRANSFER_MODE", "4Bit"),
    ("PSU__SD1__GRP_CD__ENABLE", "1"),
    ("PSU__SD1__GRP_CD__IO", "MIO 45"),
    # GEM0: KSZ9031 RGMII on MIO26-37, MDIO on MIO76-77, PHY addr 1
    ("PSU__ENET0__PERIPHERAL__ENABLE", "1"),
    ("PSU__ENET0__PERIPHERAL__IO", "MIO 26 .. 37"),
    ("PSU__ENET0__GRP_MDIO__ENABLE", "1"),
    ("PSU__ENET0__GRP_MDIO__IO", "MIO 76 .. 77"),
    # UART0 (USB-UART CP2102): RX MIO42, TX MIO43
    ("PSU__UART0__PERIPHERAL__ENABLE", "1"),
    ("PSU__UART0__PERIPHERAL__IO", "MIO 42 .. 43"),
    # UART1 (RS485 SP3485): TX MIO40, RX MIO41
    ("PSU__UART1__PERIPHERAL__ENABLE", "1"),
    ("PSU__UART1__PERIPHERAL__IO", "MIO 40 .. 41"),
    # CAN0 (SN65HVD230): RX MIO38, TX MIO39
    ("PSU__CAN0__PERIPHERAL__ENABLE", "1"),
    ("PSU__CAN0__PERIPHERAL__IO", "MIO 38 .. 39"),
    # USB0: USB3320 ULPI on MIO52-63 (reset on MIO44 GPIO) + USB3 on GTR lane 1
    ("PSU__USB0__PERIPHERAL__ENABLE", "1"),
    ("PSU__USB0__PERIPHERAL__IO", "MIO 52 .. 63"),
    ("PSU__USB3_0__PERIPHERAL__ENABLE", "1"),
    ("PSU__USB3_0__PERIPHERAL__IO", "GT Lane1"),
    ("PSU__USB0__REF_CLK_SEL", "Ref Clk1"),
    ("PSU__USB0__REF_CLK_FREQ", "26"),
    # DisplayPort: GTR lanes 3 (ML0) and 2 (ML1), 27 MHz on refclk2, AUX via EMIO
    ("PSU__DISPLAYPORT__PERIPHERAL__ENABLE", "1"),
    ("PSU__DP__LANE_SEL", "Dual Higher"),
    ("PSU__DP__REF_CLK_SEL", "Ref Clk2"),
    ("PSU__DP__REF_CLK_FREQ", "27"),
    ("PSU__DPAUX__PERIPHERAL__IO", "EMIO"),
    # PCIe root port x1 on GTR lane 0 for M.2 NVMe, 100 MHz on refclk0, PERST# MIO75
    ("PSU__PCIE__PERIPHERAL__ENABLE", "1"),
    ("PSU__PCIE__DEVICE_PORT_TYPE", "Root Port"),
    ("PSU__PCIE__PERIPHERAL__ROOTPORT_IO", "MIO 75"),
    ("PSU__PCIE__LANE0__ENABLE", "1"),
    ("PSU__PCIE__LANE0__IO", "GT Lane0"),
    ("PSU__PCIE__MAXIMUM_LINK_WIDTH", "x1"),
    ("PSU__PCIE__REF_CLK_SEL", "Ref Clk0"),
    ("PSU__PCIE__REF_CLK_FREQ", "100"),
    ("PSU__PCIE__CLASS_CODE_BASE", "0x06"),
    ("PSU__PCIE__CLASS_CODE_SUB", "0x4"),
    ("PSU__PCIE__CRS_SW_VISIBILITY", "1"),
    # GPIO over MIO (eMMC reset MIO23, USB PHY reset MIO44) and EMIO
    ("PSU__GPIO0_MIO__PERIPHERAL__ENABLE", "1"),
    ("PSU__GPIO1_MIO__PERIPHERAL__ENABLE", "1"),
    ("PSU__GPIO2_MIO__PERIPHERAL__ENABLE", "1"),
    # Timers / watchdog for Linux & standalone
    ("PSU__TTC0__PERIPHERAL__ENABLE", "1"),
    ("PSU__TTC1__PERIPHERAL__ENABLE", "1"),
    ("PSU__TTC2__PERIPHERAL__ENABLE", "1"),
    ("PSU__TTC3__PERIPHERAL__ENABLE", "1"),
    ("PSU__SWDT0__PERIPHERAL__ENABLE", "1"),
    ("PSU__SWDT1__PERIPHERAL__ENABLE", "1"),
    # PS-PL interfaces
    ("PSU__USE__M_AXI_GP0", "1"),
    ("PSU__USE__M_AXI_GP1", "0"),
    ("PSU__USE__M_AXI_GP2", "0"),
    ("PSU__USE__IRQ0", "1"),
]


def ip_preset(name, ip, params, ip_interface=None):
    attr = f' ip_interface="{ip_interface}"' if ip_interface else ""
    s = [f'    <ip vendor="xilinx.com" library="ip" name="{ip}"{attr}>',
         '      <user_parameters>']
    s += [f'        <user_parameter name="CONFIG.{k}" value="{escape(v)}"/>' for k, v in params]
    s += ['      </user_parameters>', '    </ip>']
    return name, "\n".join(s)


presets = {}


def add(name, ip, params, ip_interface=None):
    presets.setdefault(name, []).append(ip_preset(name, ip, params, ip_interface)[1])


add("zynq_ultra_ps_e_preset", "zynq_ultra_ps_e", PS)
add("sys_diff_clock_preset", "clk_wiz",
    [("PRIM_IN_FREQ", "200"), ("PRIM_SOURCE", "Differential_clock_capable_pin")], "CLK_IN1_D")
add("sys_diff_clock_preset", "util_ds_buf", [("C_BUF_TYPE", "IBUFDS"), ("C_SIZE", "1")])
add("reset_preset", "proc_sys_reset", [("C_EXT_RESET_HIGH", "0")], "ext_reset")
add("reset_preset", "clk_wiz", [("RESET_TYPE", "ACTIVE_LOW"), ("RESET_PORT", "resetn")], "reset")
add("led_5bits_preset", "axi_gpio", [("C_GPIO_WIDTH", "5"), ("C_ALL_OUTPUTS", "1")], "GPIO")
add("led_core_preset", "axi_gpio", [("C_GPIO_WIDTH", "3"), ("C_ALL_OUTPUTS", "1")], "GPIO")
add("push_buttons_5bits_preset", "axi_gpio", [("C_GPIO_WIDTH", "5"), ("C_ALL_INPUTS", "1")], "GPIO")
add("rgmii_preset", "axi_ethernet", [("PHY_TYPE", "RGMII")], "rgmii")
# MT40A512M16LY-062E isn't in the MIG part list (Vivado 2026.1); TB-062E is the same 8 Gb x16 -062E bin.
# 200 MHz input clock = 4998 ps, the nearest value MIG allows for an 833 ps memory clock.
add("ddr4_sdram_preset", "ddr4", [
    ("C0.DDR4_MemoryPart", "MT40A512M16TB-062E"),
    ("C0.DDR4_TimePeriod", "833"),
    ("C0.DDR4_InputClockPeriod", "4998"),
    ("System_Clock", "Differential"),
    ("C0.DDR4_DataWidth", "16"),
    ("C0.DDR4_AxiDataWidth", "128"),
    ("C0.DDR4_AxiAddressWidth", "30"),
])

preset_xml = ['<?xml version="1.0" encoding="UTF-8" standalone="no"?>', '<ip_presets schema="1.0">']
for name, ips in presets.items():
    preset_xml.append(f'  <ip_preset preset_proc_name="{name}">')
    preset_xml += ips
    preset_xml.append('  </ip_preset>')
preset_xml += ['</ip_presets>', '']

# ---------------------------------------------------------------------------
# Master XDC
# ---------------------------------------------------------------------------
x = ["## Master constraints for Puzhi PZ-ZU2CG (XCZU2CG-2SFVC784I)",
     "## Generated by tools/gen_pz_zu2cg.py from the Puzhi ZU2/3/4/5 user manual.",
     "## Uncomment the lines you need and rename ports to match your top level.",
     "## Bank voltages: 64/66 = 1.8 V (default, 1.2 V option), 65 = 1.2 V (PL DDR4),",
     "##                24/25/26/44 = 3.3 V (default, 1.8/2.5 V option).", ""]


def xl(port, loc, std, comment=""):
    c = f"  ;# {comment}" if comment else ""
    x.append(f"#set_property -dict {{PACKAGE_PIN {loc:<4} IOSTANDARD {std}}} [get_ports {{{port}}}]{c}")


x.append("## 200 MHz system clock (bank 65)")
xl("sys_clk_p", "L3", "DIFF_SSTL12")
xl("sys_clk_n", "L2", "DIFF_SSTL12")
x.append("#create_clock -period 5.000 -name sys_clk [get_ports sys_clk_p]")
x += ["", "## Global reset, active low"]
xl("reset_n", "D2", "LVCMOS18")
x += ["", "## Core board LEDs (active high, bank 64)"]
for i, l in enumerate(LED_CORE):
    xl(f"led_core[{i}]", l, "LVCMOS18", f"LED{i + 1} core")
x += ["", "## Carrier board LEDs (active high, bank 44)"]
for i, l in enumerate(LED_CARRIER):
    xl(f"led[{i}]", l, "LVCMOS33", f"LED{i + 1} carrier")
x += ["", "## Carrier board keys (active low, bank 44)"]
for i, l in enumerate(KEYS):
    xl(f"key[{i}]", l, "LVCMOS33", f"KEY{i + 1}")
x += ["", "## EEPROM I2C (bank 44)"]
xl("iic_scl", IIC_SCL, "LVCMOS33")
xl("iic_sda", IIC_SDA, "LVCMOS33")
x += ["", "## PL Gigabit Ethernet, KSZ9031 RGMII, PHY address 2 (bank 66)"]
for i, l in enumerate(RGMII_TD):
    xl(f"rgmii_td[{i}]", l, "LVCMOS18")
xl("rgmii_tx_ctl", RGMII_TX_CTL, "LVCMOS18")
xl("rgmii_txc", RGMII_TXC, "LVCMOS18")
for i, l in enumerate(RGMII_RD):
    xl(f"rgmii_rd[{i}]", l, "LVCMOS18")
xl("rgmii_rx_ctl", RGMII_RX_CTL, "LVCMOS18")
xl("rgmii_rxc", RGMII_RXC, "LVCMOS18")
xl("mdio_mdc", MDIO_MDC, "LVCMOS18")
xl("mdio_mdio_io", MDIO_IO, "LVCMOS18")
xl("phy_reset_n", PHY_RST_N, "LVCMOS18")
x += ["", "## Mini DP AUX channel for PS DisplayPort (EMIO, bank 26)",
      "## Connect PS dp_aux_data_out/dp_aux_data_oe_n/dp_aux_data_in/dp_hot_plug_detect.",
      "## Check the carrier schematic for the OE polarity of the AUX buffer."]
for n, l in DP_AUX:
    xl(n, l, "LVCMOS33")
x += ["", "## 40-pin header JM1 (3.3 V, banks 44/24). Port index = header pin number."]
for p in sorted(JM1):
    xl(f"jm1[{p}]", JM1[p], "LVCMOS33", f"JM1-{p}")
x += ["", "## 120-pin expansion J19 (bank 66, 1.8 V default). Port index = connector pin."]
for p in sorted(J19):
    xl(f"j19[{p}]", J19[p], "LVCMOS18", f"J19-{p:<3} {EXP_PIN_FUNC[J19[p]]}")
x += ["", "## 120-pin expansion J20 (bank 64, 1.8 V default). Port index = connector pin."]
for p in sorted(J20):
    xl(f"j20[{p}]", J20[p], "LVCMOS18", f"J20-{p:<3} {EXP_PIN_FUNC[J20[p]]}")
x += ["", "## Bitstream", "#set_property BITSTREAM.GENERAL.COMPRESS TRUE [current_design]", ""]


def write(path, text):
    os.makedirs(os.path.dirname(path), exist_ok=True)
    with open(path, "w") as f:
        f.write(text)
    print("wrote", os.path.relpath(path, ROOT))


write(os.path.join(OUT, "part0_pins.xml"), part0_pins_xml())
write(os.path.join(OUT, "board.xml"), board_xml)
write(os.path.join(OUT, "preset.xml"), "\n".join(preset_xml))
write(XDC, "\n".join(x))
