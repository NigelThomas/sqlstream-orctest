#!/bin/bash
#
# start a development container, load all slab files from the current project
# expects BASE_IMAGE and CONTAINER_NAME to be supplied by caller 

GIT_ACCOUNT=https://github.com/NigelThomas
GIT_PROJECT_NAME=sqlstream-orctest


docker kill $CONTAINER_NAME
docker rm $CONTAINER_NAME

CONTAINER_DATA_SOURCE=/home/sqlstream/iot
CONTAINER_DATA_TARGET=/home/sqlstream/output
CONTAINER_JNDI_DIR=/home/sqlstream/jndi

# Unless disabled, link the targer volume

if [ "$HOST_DATA_TARGET" = "none" ]
then
    HOST_TGT_MOUNT=
else
    HOST_TGT_MOUNT="-v ${HOST_DATA_TARGET:=$HOME/orctest-output}:$CONTAINER_DATA_TARGET"
fi

# mount the custom JNDI directory if needed (else we use the git repo's jndi directory
# note: you may use the project's own jndi directory in which case working copies of properties files will override committed/pushed copies

if [ -n "HOST_JNDI_DIR" ]
then
    HOST_JNDI_MOUNT="-v ${HOST_JNDI_DIR:=$HERE/jndi}:$CONTAINER_JNDI_DIR"
fi

docker run -v ${HOST_DATA_SOURCE:=$HOME/vzw/iot}:$CONTAINER_DATA_SOURCE $HOST_TGT_MOUNT $HOST_JNDI_MOUNT \
           -p 80:80 -p 5560:5560 -p 5580:5580 -p 5585:5585 -p 5590:5590 \
           -e GIT_ACCOUNT=$GIT_ACCOUNT -e GIT_PROJECT_NAME=$GIT_PROJECT_NAME \
           -e LOAD_SLAB_FILES="${LOAD_SLAB_FILES:=CSVingest.slab WriteORCtoHDFS.slab}" \
           -e SQLSTREAM_HEAP_MEMORY=${SQLSTREAM_HEAP_MEMORY:=4096m} \
           -e SQLSTREAM_SLEEP_SECS=${SQLSTREAM_SLEEP_SECS:=10} \
           -d --name $CONTAINER_NAME -it $BASE_IMAGE

docker logs -f $CONTAINER_NAME
