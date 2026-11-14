# PZ-ZU2CG: build and run Linux.
#
#   make drivers           one-time: JTAG cable udev rules + dialout group (sudo)
#   make xsa               Vivado project, bitstream and XSA         (~10 min)
#   make linux             Buildroot SD card image                   (~1 h first time)
#   make sdcard DEV=/dev/sdX   write the image to an SD card          (sudo)
#   make console           serial console on the board's UART
#   make all               xsa + linux
#
# Then set the boot switches M2/M1/M0 = OFF/OFF/OFF (SD boot), insert the card, power on.

XILINX  ?= /opt/xilinx/2026.1
VIVADO  ?= $(XILINX)/Vivado/bin/vivado
TTY     ?= /dev/ttyUSB0
BAUD    ?= 115200
DEV     ?=
SHELL   := /bin/bash

XSA     := projects/pz_zu2cg_linux/pz_zu2cg_linux.xsa
IMG     := build/linux/br/images/sdcard.img
LOGS    := build/logs

HW_SRCS := scripts/create_linux_project.tcl $(wildcard constraints/*.xdc) \
           $(shell find board_files -type f 2>/dev/null)
SW_SRCS := scripts/build_linux.sh tools/gen_pl_dts.py $(wildcard buildroot/*) $(wildcard dts/*)

.PHONY: all xsa linux sdcard console drivers help

all: linux

help:
	@sed -n '3,10p' Makefile | sed 's/^# \{0,1\}//'

xsa: $(XSA)
$(XSA): $(HW_SRCS)
	@mkdir -p $(LOGS)
	$(VIVADO) -mode batch -nojournal -log $(LOGS)/linux_project.log \
	    -source scripts/create_linux_project.tcl -tclargs impl
	@test -f $@ && touch $@

linux: $(IMG)
$(IMG): $(XSA) $(SW_SRCS)
	@mkdir -p $(LOGS)
	XILINX=$(XILINX) scripts/build_linux.sh $(XSA) 2>&1 | tee $(LOGS)/build_linux.log; \
	    exit $${PIPESTATUS[0]}

# Refuses anything that isn't a removable, whole, unmounted disk, and asks before writing.
sdcard:
	@test -n "$(DEV)" || { echo "usage: make sdcard DEV=/dev/sdX   (find it with lsblk)"; exit 1; }
	@test -f $(IMG) || { echo "no $(IMG); run 'make linux' first"; exit 1; }
	@test -b "$(DEV)" || { echo "$(DEV) is not a block device"; exit 1; }
	@d=$$(basename $(DEV)); \
	    test -e /sys/block/$$d || { echo "$(DEV) is a partition; give the whole disk"; exit 1; }; \
	    test "$$(cat /sys/block/$$d/removable)" = 1 || { echo "$(DEV) is not removable; refusing"; exit 1; }; \
	    ! lsblk -no MOUNTPOINT $(DEV) | grep -q '^/$$' || { echo "$(DEV) holds /; refusing"; exit 1; }
	@lsblk -o NAME,SIZE,MODEL,TRAN,MOUNTPOINT $(DEV)
	@read -p "Erase $(DEV) and write $(IMG)? [y/N] " a && [ "$$a" = y ]
	-@sudo umount $(DEV)?* 2>/dev/null || true
	sudo dd if=$(IMG) of=$(DEV) bs=4M conv=fsync status=progress
	sync
	@echo "Done. Boot switches M2/M1/M0 = OFF/OFF/OFF, insert the card, power on, 'make console'."

console:
	@echo "Exit with Ctrl-A then K."
	screen $(TTY) $(BAUD)

drivers:
	sudo $(XILINX)/data/xicom/cable_drivers/lin64/install_script/install_drivers/install_drivers
	sudo usermod -aG dialout $(USER)
	@echo "Replug the board's USB cable; the dialout group applies from your next login."
