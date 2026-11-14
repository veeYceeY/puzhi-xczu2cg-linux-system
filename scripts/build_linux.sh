#!/usr/bin/env bash
# Build a bootable SD card image for the PZ-ZU2CG Linux reference design with Buildroot,
# without PetaLinux or Yocto.
#
# Usage:  scripts/build_linux.sh [design.xsa]
#         (default projects/pz_zu2cg_linux/pz_zu2cg_linux.xsa, from
#          vivado -mode batch -source scripts/create_linux_project.tcl -tclargs impl)
#
# Environment: OUT         output directory            (default build/linux)
#              BR_VERSION  Buildroot release           (default 2026.02.3, LTS)
#              XILINX      AMD tools install           (default /opt/xilinx/2026.1)
#              JOBS        parallel jobs, 0 = automatic (default 0)
#
# Steps:
#   1. From the XSA: psu_init_gpl.c (PS clocks/DDR/MIO for U-Boot SPL), the bitstream, and,
#      through sdtgen + lopper, the PMU firmware configuration object (pm_cfg_obj.c).
#   2. Device trees: dts/pz-zu2cg.dts (PS + PL, for Linux) and a PS-only one for U-Boot.
#      The PL fragments are regenerated from the XSA by tools/gen_pl_dts.py.
#   3. Buildroot, starting from its ZCU102 configuration: U-Boot SPL (first-stage loader),
#      PMU firmware, ARM Trusted Firmware, U-Boot, AMD's Linux kernel and a root filesystem.
#   4. sdcard.img: FAT partition (boot.bin, u-boot.itb, system.bit, Image, system.dtb,
#      extlinux.conf) and an ext4 root partition. U-Boot loads system.bit, then Linux.
#
# The first build downloads ~1 GB and takes roughly an hour; later builds reuse $OUT/dl.

set -euo pipefail

here=$(cd "$(dirname "$0")" && pwd)
root=$(dirname "$here")
xsa=$(readlink -f "${1:-$root/projects/pz_zu2cg_linux/pz_zu2cg_linux.xsa}")
out=$(readlink -m "${OUT:-$root/build/linux}")
br_version=${BR_VERSION:-2026.02.3}
xilinx=${XILINX:-/opt/xilinx/2026.1}
jobs=${JOBS:-0}
brd=$root/buildroot

step() { printf '\n=== %s\n' "$*"; }
die() { echo "ERROR: $*" >&2; exit 1; }

[ -f "$xsa" ] || die "no XSA at $xsa (build it with create_linux_project.tcl -tclargs impl)"
[ -x "$xilinx/Vivado/bin/sdtgen" ] || die "sdtgen not found under $xilinx/Vivado/bin (set XILINX)"

# --- 1. Hardware files from the XSA ---------------------------------------------------
step "Hardware files from $xsa"
hw=$out/hw
rm -rf "$hw"
mkdir -p "$hw"
unzip -q -o -j "$xsa" psu_init_gpl.c psu_init_gpl.h '*.bit' -d "$hw"
bits=("$hw"/*.bit)
((${#bits[@]} == 1)) || die "expected one bitstream in the XSA, found ${#bits[@]}"
mv "${bits[0]}" "$hw/system.bit"

# sdtgen and lopper run in a subshell with the AMD environment, which must not leak into
# Buildroot (it refuses to run with LD_LIBRARY_PATH set).
(
    cd "$hw"
    printf 'sdtgen set_dt_param -xsa %s -dir sdt\nsdtgen generate_sdt\n' "$xsa" > sdt.tcl
    "$xilinx/Vivado/bin/sdtgen" sdt.tcl > sdtgen.log 2>&1 || { tail -20 sdtgen.log; exit 1; }
    "$xilinx/Vivado/bin/lopper" -f --enhanced -O . sdt/system-top.dts \
        -- generate_config_object pm_cfg_obj.c zynqmp > lopper.log 2>&1 || { tail -20 lopper.log; exit 1; }
) || die "PMU configuration object generation failed (logs in $hw)"
[ -s "$hw/pm_cfg_obj.c" ] || die "lopper did not write $hw/pm_cfg_obj.c"
echo "psu_init_gpl.c, pm_cfg_obj.c, system.bit -> $hw"

# --- 2. Device trees ------------------------------------------------------------------
step "Device trees"
python3 "$root/tools/gen_pl_dts.py" "$xsa"
dts=$out/dts
rm -rf "$dts"
mkdir -p "$dts/linux/xilinx" "$dts/uboot"
cp "$root"/dts/{pz-zu2cg.dts,pz-zu2cg-ps.dtsi,pz_zu2cg_pl.dtsi,pz_zu2cg_board.dtsi} "$dts/linux/xilinx/"
# U-Boot gets the PS only: the PL peripherals don't exist until it has loaded the bitstream.
cp "$root/dts/pz-zu2cg-ps.dtsi" "$dts/uboot/"
printf '/dts-v1/;\n\n#include "pz-zu2cg-ps.dtsi"\n' > "$dts/uboot/pz-zu2cg.dts"

# --- Host tools -----------------------------------------------------------------------
missing=()
for t in make gcc g++ patch perl rsync cpio unzip file bc wget diff find awk which python3 tar xz bzip2; do
    command -v "$t" >/dev/null || missing+=("$t")
done
if ((${#missing[@]})); then
    echo "Missing host tools: ${missing[*]}"
    echo "On Fedora:"
    echo "  sudo dnf install make gcc gcc-c++ patch perl rsync cpio unzip file bc wget diffutils \\"
    echo "      findutils gawk which python3 tar xz bzip2 perl-ExtUtils-MakeMaker perl-Thread-Queue \\"
    echo "      perl-FindBin perl-IPC-Cmd perl-English"
    exit 1
fi

# --- 3. Buildroot ---------------------------------------------------------------------
step "Buildroot $br_version"
mkdir -p "$out/dl"
src=$out/buildroot-$br_version
if [ ! -d "$src" ]; then
    tarball=$out/dl/buildroot-$br_version.tar.xz
    if [ ! -f "$tarball" ]; then
        wget -q --show-progress -O "$tarball.part" \
            "https://buildroot.org/downloads/buildroot-$br_version.tar.xz"
        mv "$tarball.part" "$tarball"
    fi
    tar -xJf "$tarball" -C "$out"
fi
base=$src/configs/zynqmp_zcu102_defconfig
[ -f "$base" ] || die "$base not found; this Buildroot release has no ZynqMP ZCU102 configuration"

# Ubuntu 26.04+ uses uutils (Rust) coreutils as the default, and it is stricter than GNU in
# places that build systems rely on: U-Boot's SPL step runs `dd conv=block,sync bs=4` with
# no cbs=, which GNU ignores and uutils rejects. When GNU coreutils is installed under
# gnu* names, put plain-named links to it first on PATH for the build.
if dd --version 2>/dev/null | grep -q uutils; then
    gnubin=$out/gnu-coreutils
    rm -rf "$gnubin"
    mkdir -p "$gnubin"
    if command -v dpkg >/dev/null && dpkg -s gnu-coreutils >/dev/null 2>&1; then
        while IFS= read -r f; do
            [ -x "$f" ] && ln -s "$f" "$gnubin/${f##*/gnu}"
        done < <(dpkg -L gnu-coreutils | grep '^/usr/bin/gnu')
    fi
    [ -e "$gnubin/dd" ] || die "dd is uutils coreutils; install GNU coreutils (apt install gnu-coreutils)"
    export PATH=$gnubin:$PATH
    echo "uutils coreutils detected; building with GNU coreutils from $gnubin"
fi

br=$out/br
mkdir -p "$br"
cat > "$out/local.config" <<EOF
BR2_DL_DIR="$out/dl"
BR2_JLEVEL=$jobs
BR2_ROOTFS_POST_IMAGE_SCRIPT="$brd/post-image.sh"
BR2_ROOTFS_POST_SCRIPT_ARGS="ttyPS0,115200 mmcblk1p2 $hw/system.bit"
BR2_LINUX_KERNEL_CUSTOM_DTS_DIR="$dts/linux"
BR2_LINUX_KERNEL_CONFIG_FRAGMENT_FILES="$brd/linux.fragment"
BR2_TARGET_UBOOT_CUSTOM_DTS_PATH="$dts/uboot/pz-zu2cg.dts $dts/uboot/pz-zu2cg-ps.dtsi"
BR2_TARGET_UBOOT_CONFIG_FRAGMENT_FILES="$brd/uboot.fragment"
BR2_TARGET_UBOOT_ZYNQMP_PSU_INIT_FILE="$hw/psu_init_gpl.c"
BR2_TARGET_UBOOT_ZYNQMP_PM_CFG="$hw/pm_cfg_obj.c"
EOF
# Later files override earlier ones
cat "$base" "$brd/pz_zu2cg.config" "$out/local.config" > "$br/defconfig.merged"
make -C "$src" O="$br" BR2_DEFCONFIG="$br/defconfig.merged" defconfig > "$br/defconfig.log"

# Retired options only select BR2_LEGACY, and the build then refuses to start
if grep -qx 'BR2_LEGACY=y' "$br/.config"; then
    die "the configuration uses options retired in Buildroot $br_version (see Config.in.legacy)"
fi
# olddefconfig silently drops options that don't exist or whose dependencies aren't met.
# Check the last assignment of each option we set.
lost=0
while IFS= read -r line; do
    if ! grep -qxF "$line" "$br/.config"; then
        echo "WARNING: not in the final configuration: $line"
        lost=1
    fi
done < <(grep -h '^BR2_.*=' "$brd/pz_zu2cg.config" "$out/local.config" |
         awk -F= '{ last[$1] = $0 } END { for (k in last) print last[k] }')
((lost == 0)) || echo "(check the option names and their dependencies in Buildroot $br_version)"

step "Building (log: $br/build.log)"
# Buildroot doesn't track the device trees, psu_init_gpl.c or pm_cfg_obj.c given to it from
# outside. Once the kernel and U-Boot have been built, rebuild them (incrementally) so a
# changed DTS or XSA is picked up; the following make then regenerates the images.
rebuild=()
[ -d "$br/build/linux-custom" ] && rebuild+=(linux-rebuild)
[ -d "$br/build/uboot-custom" ] && rebuild+=(uboot-rebuild)
if ((${#rebuild[@]})) && ! make -C "$src" O="$br" "${rebuild[@]}" > "$br/rebuild.log" 2>&1; then
    tail -40 "$br/rebuild.log"
    die "kernel/U-Boot rebuild failed, full log in $br/rebuild.log"
fi
if ! make -C "$src" O="$br" > "$br/build.log" 2>&1; then
    tail -40 "$br/build.log"
    die "Buildroot build failed, full log in $br/build.log"
fi

# --- 4. Result ------------------------------------------------------------------------
img=$br/images/sdcard.img
[ -f "$img" ] || die "no $img"
step "Done"
ls -l "$br/images"
cat <<EOF

SD card image: $img
  Write it:   sudo dd if=$img of=/dev/sdX bs=4M conv=fsync status=progress
  Boot mode:  SD card (set the board's boot switches to SD).
  Console:    UART0 (USB-UART), 115200 8N1; log in as root (no password).
EOF
