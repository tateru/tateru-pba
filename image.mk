ifeq ($(ARCH),x86_64)
BOOTX := bootx64.efi
endif

tateru-pba-$(ARCH).fs: $(KERNEL_IMAGE) rootfs-$(ARCH).zst
	truncate -s 30M "$@"
	mkfs.vfat -n TATERUPBA "$@"
	mmd -oi "$@" ::EFI
	mmd -oi "$@" ::EFI/BOOT
	mcopy -oi "$@" $< ::EFI/BOOT/linux.krn
	mcopy -oi "$@" rootfs-$(ARCH).zst ::EFI/BOOT/rootfs.zst
	mcopy -oi "$@" arch/$(ARCH)/grub*.efi ::EFI/BOOT/$(BOOTX)
	mdir -/i "$@" ::

tateru-pba-$(ARCH).img: tateru-pba-$(ARCH).fs
	truncate -s 32M "$@"
	sgdisk -og "$@"
	sgdisk -n "1:2048:" -c 1:"EFI System Partition" -t 1:ef00 "$@"
	dd if="$<" of="$@" seek=2048 bs=512 conv=notrunc
	sfdisk -l "$@"
