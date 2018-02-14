---
title: tc
category: Linux
layout: 2017/sheet
tags: []
updated: 2018-02-14
weight: -10
intro: |
  Docker stuff
---

Traffic Control (tc)
--------------------
{: .-three-column}

### Inject latency

    tc qdisc add dev eth0 root netem delay 97ms

### Remove the rule

    tc qdisc del dev eth0 root netem

### List the rules

    tc -s qdisc
