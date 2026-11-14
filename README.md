# PZ-ZU2CG: build and run Linux

Build flow for the Puzhi PZ-ZU2CG board (XCZU2CG): Vivado design → bitstream/XSA → Buildroot SD card
image (U-Boot SPL, PMU firmware, ATF, U-Boot, Linux, root filesystem).

## Requirements

- Vivado 2026.1 in `/opt/xilinx/2026.1` (otherwise pass `XILINX=/path`).
- Buildroot host tools:
  `make gcc g++ patch perl rsync cpio unzip file bc wget diff find awk which python3 tar xz bzip2`.
- Ubuntu 26.04+ only: `sudo apt install gnu-coreutils` (the build uses GNU `dd`, not the default uutils).
- About 1 GB of downloads and 1 hour for the first build. Later builds are incremental.

## One-time setup

```sh
make drivers
```

This installs the JTAG cable udev rules and adds you to the `dialout` group. Replug the board's USB
cables and log in again.

## Build

```sh
make linux
```

| Step | Command it runs | Output |
|---|---|---|
| Vivado project, bitstream, XSA (~10 min) | `make xsa` | `projects/pz_zu2cg_linux/pz_zu2cg_linux.xsa` |
| Device trees, Buildroot image | `scripts/build_linux.sh` | `build/linux/br/images/sdcard.img` |

Logs go to `build/logs/`. `make` only reruns what changed:

- Editing `scripts/create_linux_project.tcl`, `constraints/` or `board_files/` reruns Vivado, then Buildroot.
- Editing `dts/`, `buildroot/`, `tools/gen_pl_dts.py` or `scripts/build_linux.sh` reruns Buildroot only.

## Write the SD card

```sh
lsblk                          # find the card, e.g. /dev/sdb
make sdcard DEV=/dev/sdX
```

It refuses anything that isn't a removable, whole disk and asks before writing. On another machine, use
`dd if=sdcard.img of=<card> bs=4M` or a tool such as balenaEtcher.

## Boot

1. Set the boot switches **M2/M1/M0 = OFF/OFF/OFF** (SD boot).
2. Insert the card, connect the micro-USB **UART** port to the PC, and power on.
3. Open the console:

   ```sh
   make console                   # /dev/ttyUSB0, 115200 8N1; quit with Ctrl-A then K
   make console TTY=/dev/ttyUSB1  # if the UART enumerated as another port
   ```

   `ls -l /dev/serial/by-id/` shows which port is which.
4. Log in as `root` (no password).

Ethernet on the PS port (`eth0`) comes up with DHCP. Set a root password (`passwd`) before using SSH.

## Updating a running board without rewriting the card

The boot files are on the card's first (FAT) partition. To replace only the kernel, device tree or
bitstream, copy the new files from `build/linux/br/images/` onto it and reboot:

```sh
mount /dev/mmcblk1p1 /mnt
cp Image system.dtb system.bit /mnt/
umount /mnt && reboot
```

Files can reach the board over the network, for example with `python3 -m http.server` on the PC and
`wget` on the board.

## Make targets

| Target | What it does |
|---|---|
| `make help` | list the targets |
| `make drivers` | JTAG udev rules + `dialout` group (sudo, once) |
| `make xsa` | Vivado project, bitstream and XSA |
| `make linux` / `make all` | XSA if needed, then the SD card image |
| `make sdcard DEV=/dev/sdX` | write the image to an SD card |
| `make console [TTY=...] [BAUD=...]` | serial console |

Variables: `XILINX` (Vivado install), `TTY` (default `/dev/ttyUSB0`), `BAUD` (default 115200).
