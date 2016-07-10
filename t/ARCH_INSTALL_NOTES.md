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


