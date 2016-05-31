Docker
======


Delete all stopped containers
-----------------------------

```bash
docker rm $(docker ps -aq)
```

Delete all untagged images
--------------------------

```
docker rmi $(docker images | grep "^<none>" | awk '{print $3}')
```  

Remove dangling images
----------------------

```
docker rmi -f $(docker images -q -a -f dangling=true)
```

Docker development notes
------------------------

To run the dev container:

    docker run --privileged --rm -ti -v `pwd`:/go/src/github.com/docker/docker dry-run-test /bin/bash

To run a named test:

    TESTFLAGS='-test.run ^TestValidateIPAddress$' make test-unit

if running inside the container, replace `make` with `hack/make.sh`

Use `exec` in wrapper scripts
-----------------------------

Many images use wrapper scripts to do some setup before starting a process for the software being run. It is important that if your image uses such a script, that script should use exec so that the script’s process is replaced by your software. If you do not use exec, then signals sent by docker will go to your wrapper script instead of your software’s process. This is not what you want - as illustrated by the following example:

Say that you have a wrapper script that starts a process for a server of some kind. You start your container (using docker run -i), which runs the wrapper script, which in turn starts your process. Now say that you want to kill your container with CTRL+C. If your wrapper script used exec to start the server process, docker will send SIGINT to the server process, and everything will work as you expect. If you didn’t use exec in your wrapper script, docker will send SIGINT to the process for the wrapper script - and your process will keep running like nothing happened.


From http://www.projectatomic.io/docs/docker-image-author-guidance/
