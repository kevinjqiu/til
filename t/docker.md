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
