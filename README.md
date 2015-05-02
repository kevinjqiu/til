TIL
===

til is a command-line utility that helps you manage your TIL (Today-I-Learned) entries.


Installation
============

TBD

Usages
======

Show help message
-----------------

    til help

Initialize your TIL repo
------------------------

    til init

Make a new TIL entry
--------------------

    til new

This will bring up your `$EDITOR` and create a new TIL entry after you save and quit your editor.


You can also write a TIL entry directly from standard input:

    til new -

Type your note and hit `Ctrl+D` when you're done.  The note should be in [markdown](http://en.wikipedia.org/wiki/Markdown) format.


You can also add tags to your entry:

    docker can use libvirt, libcontainer or lxc to access virtualization features of the kernel. #docker #linux

Show your TIL entries
---------------------

    til show

You can also show a filtered list of your TIL entries:

    til show --tags=linux,docker

`show` command can also take an option `--export` to export the (filtered) list to HTML

    til show --export
    til show --tags=linux --export
