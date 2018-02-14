---
title: netstat
category: Linux
layout: 2017/sheet
tags: []
updated: 2018-02-14
weight: -10
intro: |
  netstat
---

netstat
-------
{: .-three-column}

### List all listening connections
{: .-prime}

    netstat -l

### List all listening connections with numeric port numbers

    netstat -l -n

### List all connections

    netstat -a

### List used ports

    netstat -tupln
