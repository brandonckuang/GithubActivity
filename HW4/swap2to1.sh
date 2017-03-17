#/bin/bash
# This shell is to swap from web1 to web2	

# time1=$(docker inspect ecs189_web2_1)
# echo $time1 > sample.json

function killitif {
    docker ps -a  > /tmp/yy_xx$$
    if grep --quiet $1 /tmp/yy_xx$$
     then
     echo "killing older version of $1"
     docker rm -f `docker ps -a | grep $1  | sed -e 's: .*$::'`
   fi
}

if ! [ "$(docker ps | grep ecs189_web2_1)" ]; then
	echo "docker image ecs189_web2 does not exist/not running"
	exit
fi

docker run --network ecs189_default -d --name ecs189_web1_1 activity
sleep 5

docker exec ecs189_proxy_1 /bin/bash /bin/swap1.sh
sleep 10

killitif web2
sleep 5

# docker rm $(docker ps -qa --no-trunc --filter "status=exited")
# sleep 5
# docker network rm $(docker network ls | grep "bridge" | awk '/ / { print $1 }')
# sleep 5

echo "done"




# cd /etc/nginx
# sed -e s?web2:8080/activity/?web1:8080/activity/? <nginx.conf > /tmp/xxx
# cp /tmp/xxx nginx.conf
# service nginx reload 
