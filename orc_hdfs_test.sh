#!/bin/bash
# Start the test environment (based on streamlab-git image)

HERE=$(cd `dirname $0`; pwd)
BASE_IMAGE=sqlstream/streamlab-git
CONTAINER_NAME=orc_hdfs_test

: ${LOAD_SLAB_FILES:=CSVingest.slab WriteORCtoHDFS.slab}


. $HERE/dockercommon.sh
