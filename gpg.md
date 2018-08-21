---
title: gpg
category: Linux
tags: []
updated: 2018-08-21
weight: -10
intro: |
  pgp/gpg
---

### List keys

    gpg --list-keys

e.g.,

    $ gpg --list-keys
    /home/kevin.qiu/.gnupg/pubring.gpg
    ----------------------------------
    pub   4096R/D39DC0E3 2014-10-28
    uid                  Michal Papis (RVM signing) <mpapis@gmail.com>

    pub   2048R/26DF03A6 2018-01-10
    uid                  Kevin Qiu <kevin.qiu@points.com>
    sub   2048R/E82277EE 2018-01-10

    pub   4096R/A0FFD6F6 2015-04-11 [expires: 2025-04-08]
    uid                  keybase.io/rajitha <rajitha@keybase.io>
    sub   4096R/99E563E3 2015-04-11 [expires: 2025-04-08]


### Export to a file

    gpg --armor --export <keyid> > <email>.gpg.asc


### Import from a file

    cat <email>.gpg.asc | gpg --import
