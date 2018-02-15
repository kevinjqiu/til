---
title: openssl
category: Linux
layout: 2017/sheet
tags: [Featured]
updated: 2018-02-15
weight: -10
intro: |
  various openssl commands and recipes
---

openssl
-------
{: .-two-column}

### Show certificate info from a remote host (with SNI)

    openssl s_client -showcerts -servername www.example.com -connect www.example.com:443 </dev/null

`</dev/null` part is to suppress pager

### Show certificate info from a remote host (without SNI)

    openssl s_client -showcerts -connect www.example.com:443 </dev/null

### View the full details of a site's cert

    echo | openssl s_client -servername ... -connect ...:443 2>/dev/null | openssl x509 -text

### Check a certificate (e.g., ca.crt)

    openssl x509 -in ca.crt -text -noout

### Check a private key

    openssl rsa -in privateKey.key -check
