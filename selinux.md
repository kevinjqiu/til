```
$ ssh-copy-id -i ~/.ssh/id_rsa_new.pub m2.vm.points.com
/usr/bin/ssh-copy-id: INFO: attempting to log in with the new key(s), to filter out any that are already installed
/usr/bin/ssh-copy-id: INFO: 1 key(s) remain to be installed -- if you are prompted now it is to install the new keys
kevin.qiu@m2.vm.points.com's password: 

Number of key(s) added: 1

Now try logging into the machine, with:   "ssh 'm2.vm.points.com'"
and check to make sure that only the key(s) you wanted were added.
```

```
ssh -v -i ~/.ssh/id_rsa_new m2.vm.points.com
OpenSSH_7.1p1 (CentrifyDC build 5.3.0-208) , OpenSSL 0.9.8zg 11 Jun 2015
debug1: Reading configuration data /home/kevin.qiu/.ssh/config
debug1: Reading configuration data /etc/centrifydc/ssh/ssh_config
debug1: /etc/centrifydc/ssh/ssh_config line 53: Applying options for *
debug1: Connecting to m2.vm.points.com [10.70.30.131] port 22.
debug1: Connection established.
debug1: identity file /home/kevin.qiu/.ssh/id_rsa_new type 1
debug1: key_load_public: No such file or directory
debug1: identity file /home/kevin.qiu/.ssh/id_rsa_new-cert type -1
debug1: Enabling compatibility mode for protocol 2.0
debug1: Local version string SSH-2.0-OpenSSH_7.1
debug1: Remote protocol version 2.0, remote software version OpenSSH_7.4
debug1: match: OpenSSH_7.4 pat OpenSSH* compat 0x04000000
debug1: Authenticating to m2.vm.points.com:22 as 'kevin.qiu'
debug1: Miscellaneous failure
Matching credential not found

debug1: Miscellaneous failure
Matching credential not found

debug1: SSH2_MSG_KEXINIT sent
debug1: SSH2_MSG_KEXINIT received
debug1: kex: server->client aes128-ctr umac-64-etm@openssh.com none
debug1: kex: client->server aes128-ctr umac-64-etm@openssh.com none
debug1: expecting SSH2_MSG_KEX_ECDH_REPLY
debug1: Server host key: ecdsa-sha2-nistp256 SHA256:9ouLnBXY7yxumYqU36VToOUIcFaNwlwJhE1a9RwdziA
debug1: Host 'm2.vm.points.com' is known and matches the ECDSA host key.
debug1: Found key in /home/kevin.qiu/.ssh/known_hosts:371
debug1: SSH2_MSG_NEWKEYS sent
debug1: expecting SSH2_MSG_NEWKEYS
debug1: SSH2_MSG_NEWKEYS received
debug1: Roaming not allowed by server
debug1: SSH2_MSG_SERVICE_REQUEST sent
debug1: SSH2_MSG_SERVICE_ACCEPT received
debug1: pubkey_prepare: ssh_get_authentication_socket: No such file or directory
debug1: Authentications that can continue: publickey,gssapi-keyex,gssapi-with-mic,password
debug1: Next authentication method: gssapi-keyex
debug1: No valid Key exchange context
debug1: Next authentication method: gssapi-with-mic
debug1: Miscellaneous failure
Matching credential not found

debug1: Miscellaneous failure
Matching credential not found

debug1: Next authentication method: publickey
debug1: Offering RSA public key: /home/kevin.qiu/.ssh/id_rsa_new
debug1: Authentications that can continue: publickey,gssapi-keyex,gssapi-with-mic,password
debug1: Next authentication method: password
kevin.qiu@m2.vm.points.com's password: 
```

Double checked that:
- the permission for `$HOME/.ssh` folder is `0700`
- `$HOME/.ssh/authorized_keys` is `0600`
- `$HOME/.ssh` is owned by my account

Asked a co-worker to generate a new keypair, make sure he can login with that keypair and send me the public key.
- I can login as him using his public key
- He cannot login as me using this public key after putting the private key in my `$HOME/.ssh/authorized_keys` on the server

Turn on sshd debug logging. Tried pubkey authentication again. This immediately caught my eyes in the logs:

```
Jan 11 09:16:19 m2.vm.points.com sshd[58280]: debug1: PAM: setting PAM_TTY to "ssh"
Jan 11 09:16:19 m2.vm.points.com sshd[58280]: debug1: userauth-request for user kevin.qiu service ssh-connection method publickey [preauth]
Jan 11 09:16:19 m2.vm.points.com sshd[58280]: debug1: attempt 1 failures 0 [preauth]
Jan 11 09:16:19 m2.vm.points.com sshd[58280]: debug1: userauth_pubkey: test whether pkalg/pkblob are acceptable for RSA SHA256:vaGsCNnIp8yO8gbF49sZ3wDISGt0vy0W7jbK5tCu/YU [preauth]
Jan 11 09:16:19 m2.vm.points.com sshd[58280]: debug1: temporarily_use_uid: 65488/10005 (e=0/0)
Jan 11 09:16:19 m2.vm.points.com sshd[58280]: debug1: trying public key file /home/kevin.qiu/.ssh/authorized_keys
Jan 11 09:16:19 m2.vm.points.com sshd[58280]: debug1: Could not open authorized keys '/home/kevin.qiu/.ssh/authorized_keys': Permission denied
Jan 11 09:16:19 m2.vm.points.com sshd[58280]: debug1: restore_uid: 0/0
Jan 11 09:16:19 m2.vm.points.com sshd[58280]: debug1: temporarily_use_uid: 65488/10005 (e=0/0)
Jan 11 09:16:19 m2.vm.points.com sshd[58280]: debug1: trying public key file /home/kevin.qiu/.ssh/authorized_keys2
Jan 11 09:16:19 m2.vm.points.com sshd[58280]: debug1: Could not open authorized keys '/home/kevin.qiu/.ssh/authorized_keys2': No such file or directory
Jan 11 09:16:19 m2.vm.points.com sshd[58280]: debug1: restore_uid: 0/0
Jan 11 09:16:19 m2.vm.points.com sshd[58280]: Failed publickey for kevin.qiu from 10.203.0.48 port 50936 ssh2: RSA SHA256:vaGsCNnIp8yO8gbF49sZ3wDISGt0vy0W7jbK5tCu/YU
Jan 11 09:18:30 m2.vm.points.com sshd[58238]: debug1: Received SIGCHLD.
```

In particular:

```
Jan 11 09:16:19 m2.vm.points.com sshd[58280]: debug1: Could not open authorized keys '/home/kevin.qiu/.ssh/authorized_keys': Permission denied
```

sshd should have access to everyone's `.ssh` folder. Why it can't with mine?

```
# stat /home/kevin.qiu/.ssh
  File: ‘/home/kevin.qiu/.ssh’
  Size: 61              Blocks: 0          IO Block: 4096   directory
Device: fd00h/64768d    Inode: 67160978    Links: 2
Access: (0700/drwx------)  Uid: (65488/kevin.qiu)   Gid: (10005/     dev)
Context: unconfined_u:object_r:default_t:s0
Access: 2018-01-10 17:13:01.734947076 -0500
Modify: 2018-01-10 17:11:50.539706126 -0500
Change: 2018-01-10 17:11:50.539706126 -0500
 Birth: -
```

The permission bits seemed alright but there's this extra `Context` key. It's a SELinux thing. Could it be the problem?

Did `stat` on my coworker's `.ssh` folder:

```
# stat /home/raj.perera/.ssh
...
Context: unconfined_u:object_r:ssh_home_t:s0
...
```

Ahhh the security context is different!

Googled around, [this](https://stackoverflow.com/questions/20688844/sshd-gives-error-could-not-open-authorized-keys-although-permissions-seem-corre#comment48811328_20818775) came up.

```
# chcon -Rv -t ssh_home_t .ssh
changing security context of ‘.ssh/id_rsa’
changing security context of ‘.ssh/id_rsa.pub’
changing security context of ‘.ssh/authorized_keys’
changing security context of ‘.ssh’
```

and voila!

```
ssh -i id_rsa_new m2.vm.points.com                                                                                                                     
Last login: Thu Jan 11 09:35:36 2018 from pts-kqui2.toronto.exclamation.com
-sh-4.2$ 
```

