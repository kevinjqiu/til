---
title: openssl self sign certs
category: Linux
tags: []
updated: 2018-02-15
weight: -10
intro: |
  Various notes regarding ArchLinux
---

Private CA and self-signed certs
---------------------------------

### Step 1: Generate a private root key

    $ openssl genrsa -out rootCA.key 2048
    Generating RSA private key, 2048 bit long modulus
    ........................................................................+++
    ............+++
    e is 65537 (0x010001)

use `-des3` for password protected key

### Step 2: Self sign the certificate

    $ openssl req -x509 -new -nodes -key rootCA.key -sha256 -days 999 -out rootCA.pem
    You are about to be asked to enter information that will be incorporated
    into your certificate request.
    What you are about to enter is what is called a Distinguished Name or a DN.
    There are quite a few fields but you can leave some blank
    For some fields there will be a default value,
    If you enter '.', the field will be left blank.
    -----
    Country Name (2 letter code) [AU]:CA
    State or Province Name (full name) [Some-State]:Ontario
    Locality Name (eg, city) []:Toronto
    Organization Name (eg, company) [Internet Widgits Pty Ltd]: Foobar
    Organizational Unit Name (eg, section) []:
    Common Name (e.g. server FQDN or YOUR name) []:
    Email Address []:

This produces rootCA.pem (certificate)

### Step 3: Create a certificate to be signed by our CA

    # Generate a private key
    $ openssl genrsa -out bob.key 2048
    Generating RSA private key, 2048 bit long modulus
    ........+++
    ......................................................+++
    e is 65537 (0x010001)

    # Generate a certificate signing request
    openssl req -new -key bob.key -out bob.csr
    ...
    Country Name (2 letter code) [AU]:CA
    State or Province Name (full name) [Some-State]:Ontario
    Locality Name (eg, city) []:Toronto
    Organization Name (eg, company) [Internet Widgits Pty Ltd]:Bob Corp
    Organizational Unit Name (eg, section) []:
    Common Name (e.g. server FQDN or YOUR name) []:
    Email Address []:

CSR can also be generated non-interactively. Pass `-subj`:

    openssl req -new -key bob.key -out bob.csr -subj "/C=CA/ST=Ontario/L=Toronto/O=Bob Corp/CN=example.com"

### Step 4: Sign the CSR using the CA cert

    openssl x509 -req -in bob.csr -CA rootCA.pem -CAkey rootCA.key -CAcreateserial -out bob.crt -days 500 -sha256
    Signature ok
    subject=C = CA, ST = Ontario, L = Toronto, O = Bob Corp
    Getting CA Private Key

Now you should have bob.crt file (the certificate).
