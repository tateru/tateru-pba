# Tateru PBA
Pre-boot authentication image for TCG SSC OPAL 2.0 with TPM 2.0 and EFI support

Used to unlock OPAL/SED boot disks.

Planned features:

 * Static key based on platform VPD or EFI variables
 * TPM 2.0 unmeasured and measured unlock

## Building

```
$ sudo apt install \
    gnupg2 gpgv2 flex bison build-essential libelf-dev \
    curl libssl-dev bc zstd dosfstools gdisk mtools
$ gpg2 --locate-keys torvalds@kernel.org gregkh@kernel.org autosigner@kernel.org
# Make sure sgdisk is in the PATH
$ PATH=$PATH:/sbin make
```

## Testing

```
$ OPAL_KEY=debug
$ sudo sedutil-cli --loadpbaimage "${OPAL_KEY}" tateru-pba-x86_64.img /dev/sdb
```
