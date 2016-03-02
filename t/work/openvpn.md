openvpn
=======

## Automatically set the DNS to the default gateway after connect

- Download [this script](https://github.com/masterkorp/openvpn-update-resolv-conf/blob/master/update-resolv-conf.sh) and place it somewhere accessible (e.g., `/etc/update-resolv-conf.sh`)

- Make it executable
```
chmod +x /etc/update-resolv-conf.sh
```

- Install `resolvconf` (You may already have it installed)
```
apt-get install resolfconf
```
- Find out where the binary is:
```
which resolvconf
```
- Edit `update-resolv-conf.sh` script and update the following line:

```
## You might need to set the path manually here, i.e.
RESOLVCONF=/usr/bin/resolvconf
```

to the location on your machine.  On Ubuntu, it's `/sbin/resolvconf`

- Add the following lines to your openvpn file (.ovpn):

```
script-security 3 system
up /etc/update-resolv-conf
down /etc/update-resolv-conf
```
- Connect!

    sudo openvpn /path/to/ovpn/file
