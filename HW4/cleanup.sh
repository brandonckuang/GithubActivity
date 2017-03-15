docker rm $(docker ps -qa --no-trunc --filter "status=exited")
docker network rm $(docker network ls | grep "bridge" | awk '/ / { print $1 }')
docker rmi $(docker images | grep "^<none>" | awk "{print $3}")

