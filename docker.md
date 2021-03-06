---
title: docker
category: Docker
layout: 2017/sheet
tags: [Featured]
updated: 2018-02-14
weight: -10
intro: |
  Docker stuff
---

Docker
------

### Debugging scratch containers

Containers made from `scratch` images have no `/bin/sh` or anything except for the binary for the container to run.

To debug it, spin up a separate container using, say, `alpine` image and have it spawn in the same namespace as the container you're trying to debug:

	$ docker run -it --rm --pid=container:60c1c49379cf --net=container:60c1c49379cf alpine sh
	Unable to find image 'alpine:latest' locally
	latest: Pulling from library/alpine
	2aecc7e1714b: Pull complete 
	Digest: sha256:0b94d1d1b5eb130dd0253374552445b39470653fb1a1ec2d81490948876e462c
	Status: Downloaded newer image for alpine:latest
	/ # ps
	PID   USER     TIME   COMMAND
		1 root       0:04 /traefik --configfile=/config/traefik.toml
	   10 root       0:00 sh
	   14 root       0:00 ps
	/ # 

To have the same root file system, add `--volumes-from 60c1c49379cf`.


[Here](https://medium.com/@rothgar/how-to-debug-a-running-docker-container-from-a-separate-container-983f11740dc6) for more details

### Monitor unix domain socket

    sudo mv /path/to/sock /path/to/sock.original
    sudo socat -t100 -x -v UNIX-LISTEN:/path/to/sock,mode=777,reuseaddr,fork UNIX-CONNECT:/path/to/sock.original

### Delete all stopped containers

```bash
docker rm $(docker ps -aq)
```

### Delete all untagged images

```
docker rmi $(docker images | grep "^<none>" | awk '{print $3}')
```  

### Remove dangling images

```
docker rmi -f $(docker images -q -a -f dangling=true)
```

### Remove dangling volumes

```
docker volume ls -qf dangling=true | xargs -r docker volume rm
```

### Docker development notes

To run the dev container:

    docker run --privileged --rm -ti -v `pwd`:/go/src/github.com/docker/docker dry-run-test /bin/bash

To run a named test:

    TESTFLAGS='-test.run ^TestValidateIPAddress$' make test-unit

if running inside the container, replace `make` with `hack/make.sh`

Other
-----
{: .-one-column}

### Use `exec` in wrapper scripts

Many images use wrapper scripts to do some setup before starting a process for the software being run. It is important that if your image uses such a script, that script should use exec so that the script’s process is replaced by your software. If you do not use exec, then signals sent by docker will go to your wrapper script instead of your software’s process. This is not what you want - as illustrated by the following example:

Say that you have a wrapper script that starts a process for a server of some kind. You start your container (using docker run -i), which runs the wrapper script, which in turn starts your process. Now say that you want to kill your container with CTRL+C. If your wrapper script used exec to start the server process, docker will send SIGINT to the server process, and everything will work as you expect. If you didn’t use exec in your wrapper script, docker will send SIGINT to the process for the wrapper script - and your process will keep running like nothing happened.


From http://www.projectatomic.io/docs/docker-image-author-guidance/

### Running out of space

This seems to happen more often on Docker 0.12 using overlay storage engine.

The operating system reports that there's no space left on the device, even though `df` shows that there are plenty of space left.

It turns out that `No space left on device` may also be caused by [not having enough metadata blocks](https://wiki.gentoo.org/wiki/Knowledge_Base:No_space_left_on_device_while_there_is_plenty_of_space_available). Use `df -i` to check the available inodes:

```
root@ip-172-31-51-118:~# df -i
Filesystem     Inodes  IUsed  IFree IUse% Mounted on
udev           124890    393 124497    1% /dev
tmpfs          126805    523 126282    1% /run
/dev/xvda1     524288 524288      0  100% /
tmpfs          126805      1 126804    1% /dev/shm
tmpfs          126805      3 126802    1% /run/lock
tmpfs          126805     16 126789    1% /sys/fs/cgroup
overlay        524288 524288      0  100% /var/lib/docker/overlay/acb2b31fc0e2944750c16050e035a9ecf31f824d8239cca227c99f256ce93d56/merged
shm            126811      1 126810    1% /var/lib/docker/containers/6b0603f536e33866ba51fb49fd2efc684e9f4c2297e6496bc25c4f243222e335/shm
tmpfs          126811      4 126807    1% /run/user/1000
```

Docker used up all inodes!

Delete the exited containers with their volumes:

    docker rm -v <container_id>

And that freed up a bunch of inodes.

```
root@ip-172-31-51-118:~# df -i
Filesystem     Inodes  IUsed  IFree IUse% Mounted on
udev           124890    393 124497    1% /dev
tmpfs          126805    523 126282    1% /run
/dev/xvda1     524288 524288      0  100% /
tmpfs          126805      1 126804    1% /dev/shm
tmpfs          126805      3 126802    1% /run/lock
tmpfs          126805     16 126789    1% /sys/fs/cgroup
overlay        524288 524288      0  100% /var/lib/docker/overlay/acb2b31fc0e2944750c16050e035a9ecf31f824d8239cca227c99f256ce93d56/merged
shm            126811      1 126810    1% /var/lib/docker/containers/6b0603f536e33866ba51fb49fd2efc684e9f4c2297e6496bc25c4f243222e335/shm
tmpfs          126811      4 126807    1% /run/user/1000
```
