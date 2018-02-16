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

### Extract CSR from a certificate

    openssl x509 -in domain.crt -signkey domain.key -x509toreq -out domain.csr

### Verify a cert was signed by the CA

    openssl verify -verbose -CAfile ca.crt domain.crt

### Verify a private key matches CSR and cert

    openssl rsa -noout -modulus -in domain.key | openssl sha256
    openssl x509 -noout -modulus -in domain.crt | openssl sha256
    openssl req -noout -modulus -in domain.csr | openssl sha256

The three outputs should match
