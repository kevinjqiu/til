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
