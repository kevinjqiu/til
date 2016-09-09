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

