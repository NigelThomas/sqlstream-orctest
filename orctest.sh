#!/bin/bash
# Start the test environment (based on a minimal image

HERE=$(cd `dirname $0`; pwd)
BASE_IMAGE=sqlstream/minimal:release
CONTAINER_NAME=orctest


GIT_ACCOUNT=https://github.com/NigelThomas
GIT_PROJECT_NAME=sqlstream-orctest


echo ... Kill and remove pre-existing $CONTAINER_NAME
docker kill $CONTAINER_NAME
docker rm $CONTAINER_NAME

CONTAINER_DATA_SOURCE=/home/sqlstream/iot
CONTAINER_DATA_TARGET=/home/sqlstream/output
: ${LOAD_SLAB_FILES:="CSVingest.slab WriteORCtoHDFS.slab"}

# Unless disabled, link the targer volume

if [ "$HOST_DATA_TARGET" = "none" ]
then
    HOST_TGT_MOUNT=
else
    HOST_TGT_MOUNT="-v ${HOST_DATA_TARGET:=$HOME/orctest-output}:$CONTAINER_DATA_TARGET"
fi

           #-p 80:80 -p 5560:5560 -p 5580:5580 -p 5585:5585 -p 5590:5590 \
           #-e GIT_ACCOUNT=$GIT_ACCOUNT -e GIT_PROJECT_NAME=$GIT_PROJECT_NAME \
           #-e LOAD_SLAB_FILES="${LOAD_SLAB_FILES:=CSVingest.slab WriteORCtoHDFS.slab}" \
           #-e SQLSTREAM_HEAP_MEMORY=${SQLSTREAM_HEAP_MEMORY:=4096m} \

docker run -v ${HOST_DATA_SOURCE:=$HOME/vzw/iot}:$CONTAINER_DATA_SOURCE $HOST_TGT_MOUNT \
           -d --name $CONTAINER_NAME -it $BASE_IMAGE


docker exec -it $CONTAINER_NAME bash -c\
   ". /etc/sqlstream/environment &&\
    apt-get update &&\
    apt-get install -y nano jq git &&\
    rm -rf /var/lib/apt/lists/*
     chown -R sqlstream:sqlstream /home/sqlstream &&\
     cd /home/sqlstream &&\
     export PATH=/home/sqlstream/${GIT_PROJECT_NAME}:/home/sqlstream/sqlstream-docker-utils:$PATH:$SQLSTREAM_HOME/bin &&\
     git clone https://github.com/NigelThomas/sqlstream-docker-utils.git &&\ 
     GIT_PROJECT_NAME=${GIT_PROJECT_NAME} GIT_ACCOUNT=${GIT_ACCOUNT} LOAD_SLAB_FILES=\"${LOAD_SLAB_FILES}\" SQLSTREAM_HEAP_MEMORY=\"${SQLSTREAM_HEAP_MEMORY}\" SQLSTREAM_SLEEP_SECS=${SQLSTREAM_SLEEP_SECS} fetch_and_start_project.sh"

