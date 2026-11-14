#!/bin/sh
# Buildroot post-image script: $1 = images dir, $2/$3 = console/root (used by
# board/zynqmp/post-build.sh), $4 = bitstream to put on the boot partition.
set -e

BOARD_DIR="$(dirname "$0")"

cp "$4" "${BINARIES_DIR}/system.bit"
ln -fs pz-zu2cg.dtb "${BINARIES_DIR}/system.dtb"

support/scripts/genimage.sh -c "${BOARD_DIR}/genimage.cfg"
