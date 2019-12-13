#!/bin/bash
#
# start a development container, load all slab files from the current project

BASE_IMAGE=sqlstream/complete:release

GIT_ACCOUNT=https://github.com/NigelThomas
GIT_PROJECT_NAME=sqlstream-orctest

CONTAINER_NAME=orcdev

docker kill $CONTAINER_NAME
docker rm $CONTAINER_NAME

HOST_DATA_ROOT=/Users/nigel/NOBACKUP/vzw/iot
CONTAINER_DATA_ROOT=/home/sqlstream/iot

docker run -v $HOST_DATA_ROOT:$CONTAINER_DATA_ROOT -p 80:80 -p 5560:5560 -p 5580:5580 -p 5585:5585 -p 5590:5590 -e GIT_ACCOUNT=$GIT_ACCOUNT -e GIT_PROJECT_NAME=$GIT_PROJECT_NAME -d --name $CONTAINER_NAME -it $BASE_IMAGE

# wait for the image to be started

while [ 1 -eq 1 ]
do
    curl http://localhost:5580/status 2>/dev/null
    if [ $? -eq 0 ]
    then
        break
    fi
    echo waiting for webagent
    sleep 3
done

for f in *.slab
do
    if [ -e $f ]
    then
        Echo posting $f
        curl -d@$f http://localhost/_project_import/user
    else
        echo No such file $f
    fi
done
