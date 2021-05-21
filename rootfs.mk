ifeq ($(ARCH),x86_64)
GOARCH := amd64
endif

rootfs-$(ARCH).img:
	# TODO: This is only placeholder for now...
	GOARCH="$(GOARCH)" ~/go/bin/u-root -o "$(@)" core boot

rootfs-$(ARCH).zst: rootfs-$(ARCH).img
	zstd -f "$(^)" -o "$@"
