#/bin/bash
# This shell is to swap from web1 to web2	

# time1=$(docker inspect ecs189_web2_1)
# echo $time1 > sample.json
if ! [ "$(docker ps | grep ecs189_web2_1)" ]; then
	echo "docker image ecs189_web2 does not exist"
	exit
fi

docker kill ecs189_web2_1
sleep 5

docker rm $(docker ps -qa --no-trunc --filter "status=exited")
sleep 5
docker network rm $(docker network ls | grep "bridge" | awk '/ / { print $1 }')
sleep 5

docker run --network ecs189_default -d --name ecs189_web1_1 --link ecs189_proxy_1 -p 8080 activity
sleep 5

docker exec ecs189_proxy_1 /bin/bash /bin/swap1.sh
sleep 10

echo "done"




# cd /etc/nginx
# sed -e s?web2:8080/activity/?web1:8080/activity/? <nginx.conf > /tmp/xxx
# cp /tmp/xxx nginx.conf
# service nginx reload 
