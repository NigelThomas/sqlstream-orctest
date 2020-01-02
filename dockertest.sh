#!/bin/bash

# Start the test environment (based on streamlab-git image)

BASE_IMAGE=streamlab-git
GIT_ACCOUNT=https://github.com/NigelThomas
GIT_PROJECT_NAME=sqlstream-orctest
CONTAINER_NAME=orctest

docker kill $CONTAINER_NAME
docker rm $CONTAINER_NAME

HOST_DATA_ROOT=/Users/nigel/NOBACKUP/vzw/iot
CONTAINER_DATA_ROOT=/home/sqlstream/iot

docker run -v $HOST_DATA_ROOT:$CONTAINER_DATA_ROOT -p 80:80 -p 5560:5560 -p 5580:5580 -p 5595:5595 -e GIT_ACCOUNT=$GIT_ACCOUNT -e GIT_PROJECT_NAME=$GIT_PROJECT_NAME -d --name $CONTAINER_NAME -it $BASE_IMAGE
docker logs -f $CONTAINER_NAME
