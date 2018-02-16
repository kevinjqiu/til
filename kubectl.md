---
title: kubectl
category: Kubernetes
layout: 2017/sheet
tags: []
updated: 2018-02-16
weight: -10
intro: |
  kubectl tips and tricks
---

kubectl
-------
{: .-two-column}

### kubectl verbosity

Use -v=N to increase verbosity

* level 6 prints out the urls the kubectl command calls
* level 7 adds the request/response headers
* level 8 adds the raw response body (truncated)
* level 9 response body untruncated

    kubectl get pods -v=6
