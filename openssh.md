---
title: openssh
category: Linux
layout: 2017/sheet
tags: []
updated: 2018-02-16
weight: -10
intro: |
  openssh
---

openssh
-------
{: .-three-column}


### Unable to negotiate with ... port 22: no matching key exchange method found. Their offer: diffie-hellman-group1-sha1

solution: use openssh legacy key exchange:

```
ssh -oKexAlgorithms=+diffie-hellman-group1-sha1 ...
```
