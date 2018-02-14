---
title: systemd
category: Linux
layout: 2017/sheet
tags: []
updated: 2018-02-14
weight: -10
intro: |
  tmux
---

tmux
----

### scroll size

Set scroll size:

    set-option -g history-limit 3000

### set history limit

For a new panel:

    tmux set-option history-limit 5000 \; new-window

For a new session:

    tmux set-option -g history-limit 5000 \; new-session

### redraw

Redraw tmux window when switching smaller monitor to a bigger one

    tmux attach -d

From tmux man page:
```
If -d is specified, any other clients attached to the session are detached.
```

