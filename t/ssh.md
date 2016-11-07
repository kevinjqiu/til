SSH
===

Use OpenSSH with legacy SSH implementation
------------------------------------------

if:
```
Unable to negotiate with 127.0.0.1: no matching key exchange method found.
Their offer: diffie-hellman-group1-sha1
```

Do:

```
ssh -oKexAlgorithms=+diffie-hellman-group1-sha1 user@127.0.0.1
```

or:

add this to `~/.ssh/config`:

```
Host somehost.example.org
	KexAlgorithms +diffie-hellman-group1-sha1
```

See also: [this article](http://www.openssh.com/legacy.html)

SSH Tunneling
--------------

    ssh -L <remote_port>:localhost:<local_port> user@host

e.g.,

    ssh -L 5984:localhost:5984 -i /path/to/key ubuntu@ip
