ARCH ?= $(shell uname -m)
LINUX_VERSION ?= 5.12.5

ifeq ($(shell uname),Linux)
ACCEL ?= "kvm"
else ifeq ($(shell uname),Darwin)
ACCEL ?= "hvf"
else
ACCEL ?= "tcg"
endif

.PHONY: all
all: tateru-pba-$(ARCH).img

.DELETE_ON_ERROR:

include kernel.mk
include rootfs.mk
include image.mk

.PHONY: qemu-x86_64
qemu-x86_64: tateru-pba-x86_64.img arch/x86_64/ovmf.fd
	qemu-system-x86_64 \
		-m 1024 \
		-device virtio-scsi-pci,id=scsi0 \
		-device "scsi-hd,bus=scsi0.0,drive=hd0" \
		-drive "id=hd0,if=none,format=raw,readonly=on,file=$<" \
		-drive if=pflash,format=raw,readonly,file=arch/x86_64/ovmf.fd \
		-accel "$(ACCEL)" \
		-machine type=q35,smm=on,usb=on \
		-serial mon:stdio \
		-no-reboot \
		-nographic

.PHONY: clean
clean:
	\rm -vf tateru-pba-*.img tateru-pba-*.fs rootfs-*.img rootfs-*.zst

