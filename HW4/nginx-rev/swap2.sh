#/bin/bash
# This shell is to swap from web1 to web2	

# time1=$(docker inspect ecs189_web2_1)
# echo $time1 > sample.json

# docker kill ecs189_web1_1
# sleep 10

# docker rm $(docker ps -qa --no-trunc --filter "status=exited")
# sleep 10
# docker network rm $(docker network ls | grep "bridge" | awk '/ / { print $1 }')
# sleep 10

# docker run --network ecs189_default -d --name ecs189_web2_1 --link ecs189_proxy_1 -p 32832:8080 brandon
# sleep 10

# docker exec ecs189_proxy_1 /bin/bash /bin/swap2.sh
# sleep 20

cd /etc/nginx
sed -e s?ecs189_web1_1:8080/activity/?ecs189_web2_1:8080/activity/? <nginx.conf > /tmp/xxx
cp /tmp/xxx nginx.conf
service nginx reload 
