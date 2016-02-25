journalctl
==========

`journactl -b` show logs since the last boot (current boot)

+linux

Printer doesn't print after installing scanner driver
=====================================================
Brother 7060D stuck on "Waiting for printer to become available" after installing brscan4 (the scanner driver).  Because the scanner driver adds a udev rule so that the node is owned by the `scanner` group, which is no longer accessible by `lp`.  Temporary solution is to `chown root:lp /dev/usb/002/007/`, replace `002/007` with the actual location the use node is created. (Check `lsusb`)
+printer

tmux
====

## scroll size

Set scroll size:

    set-option -g history-limit 3000

For a new panel:

    tmux set-option history-limit 5000 \; new-window

For a new session:

    tmux set-option -g history-limit 5000 \; new-session

Logins and Failed Logins
========================

Last logins:
```
last
```

Last logins for all users:

```
lastlog
```

Bad logins:

```
lastb
```
