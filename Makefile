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
		-accel "$(ACCEL)" \
		-machine type=q35,smm=on,usb=on \
		-global driver=cfi.pflash01,property=secure,value=on \
		-drive if=pflash,format=raw,readonly,file=arch/x86_64/OVMF_CODE_4M.secboot.fd \
		-drive if=pflash,format=raw,file=arch/x86_64/OVMF_VARS_4M.ms.fd \
		-serial mon:stdio \
		-no-reboot \
		-boot order=c,strict=on,menu=on \
		-nographic

.PHONY: clean
clean:
	\rm -vf tateru-pba-*.img tateru-pba-*.fs rootfs-*.img rootfs-*.zst

