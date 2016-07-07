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

Add `keyring /etc/pacman.d/gnupg/pubring.gpg` to the end of `~/.gnupg/gpg.conf`.
