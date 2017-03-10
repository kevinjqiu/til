Pacman
======

Pacman fails signature verification
-----------------------------------

If encounter this while `makepkg`:

    ==> Verifying source file signatures with gpg...
    linux-4.6.tar ... FAILED (unknown public key 79BE3E4300411886)
    patch-4.6.3 ... FAILED (unknown public key 38DBBDC86092693E)

Because `makepkg` uses gpg and is unaware of the pacman's keyring. Do this:

    # run as root
    gpg --list-keys

Receive the keys using `pacman-key -r KEY_ID` first, and then, add `keyring /etc/pacman.d/gnupg/pubring.gpg` to the end of `~/.gnupg/gpg.conf`.

EFI
===

In case Window upgrade breaks EFI and you get this message:

    EFI stub: ERROR: failed to read file.
    Trying to load files to higher address.
    EFI stub: ERROR: failed to read file.

In this case, systemd-boot needs to be reinstalled.

1. Boot arch install ISO
2. Mount the partitions:

    mount /dev/sda9 /mnt
    mount /dev/sda1 /mnt/boot  # the EFI partition

3. chroot:

    arch-chroot /mnt

4. Generate initcpio

    mkinitcpio -p linux

5. Install EFI boot files

    bootctl --path=/boot install

6. Exit and cleanup

    exit  # exit the chroot environment
    umount -R /mnt
    reboot

Install ArchLinux on Lenovo Yoga 700
====================================

Download archlinux iso
----------------------

Write bootable disk
-------------------

Notice /dev/sdb, not /dev/sdb1

    sudo dd bs=4M if=archlinux-2016.03.01-dual.iso of=/dev/sdb status=progress && sync

Change BIOS to UEFI priority
----------------------------

Install according to the arch install guide
-------------------------------------------

* [The guide](https://wiki.archlinux.org/index.php/installation_guide)
* Mount `/mnt/boot` using the EFI System Partition (esp)

Install boot loader (systemd-boot)
----------------------------------

[Guide](https://wiki.archlinux.org/index.php/Systemd-boot)

* Copy kernel and initramfs onto ESP (`/boot`)
* `bootctl --path=/boot install`
* [Configuration](https://wiki.archlinux.org/index.php/Systemd-boot#Configuration)
* Add the archlinux entries
* Setup [efistub](https://wiki.archlinux.org/index.php/EFISTUB#Using_systemd)

Dhcp service not started
------------------------

    systemctl start dpchcd.service

and subsequently

    systemctl enable dhcpcd.service

Install graphics drivers
------------------------

Install bumblebee, mesa, nvidia, xf86-video-intel


