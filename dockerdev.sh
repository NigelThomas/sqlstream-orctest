#!/bin/bash
#
# start a development container, load all slab files from the current project

BASE_IMAGE=streamlab-git-dev

GIT_ACCOUNT=https://github.com/NigelThomas
GIT_PROJECT_NAME=sqlstream-orctest

CONTAINER_NAME=orcdev

docker kill $CONTAINER_NAME
docker rm $CONTAINER_NAME

CONTAINER_DATA_ROOT=/home/sqlstream/iot

docker run -v ${HOST_DATA_ROOT:=$HOME/vzw/iot}:$CONTAINER_DATA_ROOT \
           -p 80:80 -p 5560:5560 -p 5580:5580 -p 5585:5585 -p 5590:5590 \
           -e GIT_ACCOUNT=$GIT_ACCOUNT -e GIT_PROJECT_NAME=$GIT_PROJECT_NAME -e LOAD_SLAB_FILES="${LOAD_SLAB_FILES}" \
           -d --name $CONTAINER_NAME -it $BASE_IMAGE

docker logs -f $CONTAINER_NAME
