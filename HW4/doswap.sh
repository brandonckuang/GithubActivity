function killitif {
    docker ps -a  > /tmp/yy_xx$$
    if grep --quiet $1 /tmp/yy_xx$$
     then
     echo "killing older version of $1"
     docker rm -f `docker ps -a | grep $1  | sed -e 's: .*$::'`
   fi
}

if [[ -z $1 ]]; then
	echo "No Docker Image given in argument"
	exit
fi
if ! [ "$(docker images | grep $1)" ]; then
	echo "docker image $1 does not exist"
	exit
fi
if [ "$(docker ps | grep ecs189_web1_1)" ]; then
	echo "ecs189_web1_1 running"


	docker run --network ecs189_default -d --name ecs189_web2_1 --link ecs189_proxy_1 -p 8080 $1
	sleep 5

	docker exec ecs189_proxy_1 /bin/bash /bin/swap2.sh
	sleep 10

	killitif web1
	sleep 5

	echo "done swapping"
	exit


fi
if [ "$(docker ps | grep ecs189_web2_1)" ] ; then
	echo "ecs189_web2_1"

	docker run --network ecs189_default -d --name ecs189_web1_1 --link ecs189_proxy_1 -p 8080 $1
	sleep 5

	docker exec ecs189_proxy_1 /bin/bash /bin/swap1.sh
	sleep 10

	killitif web2

	sleep 5

	echo "done swapping"
	exit
fi