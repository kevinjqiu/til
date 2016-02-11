Linguistic relativity (Sapir-Whorf hypothesis)
==============================================

The principle of ... holds that the structure of a language affects the way in which its respective speakers conceptualize their world. See [here](http://en.wikipedia.org/wiki/Linguistic_relativity)

+linguistics


Dunning-Kruger effect
=====================

The Dunning-Kruger effect is a cognitive bias wherein unskilled individuals suffer from illusory superiority, mistakenly assessing their ability to be much higher than is accurate. See [here](http://en.wikipedia.org/wiki/Dunning%E2%80%93Kruger_effect)

+psychology

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

Ad Hominem
==========
An ad hominem (Latin for "to the man" or "to the person"), short for argumentum ad hominem, means responding to arguments by attacking a person's character, rather than addressing the content of their arguments.

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
