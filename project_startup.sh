#!/bin/bash
#
# Bootstrap to load the project

HERE=$(dirname $0)
cd $HERE

. /etc/sqlstream/environment
export PATH=$PATH:$SQLSTREAM_HOME/bin:$HERE

. serviceFunctions.sh
. streamlabFunctions.sh

# wait for the image to be started

while [ 1 -eq 1 ]
do
    curl http://localhost:5580/status 2>/dev/null
    if [ $? -eq 0 ]
    then
        break
    fi
    echo waiting for s-Server
    sleep 5
done

sleep 30

# do some pre-project setup
preStartup

importSlabFiles

# do some post-project setup
postproject.sh


