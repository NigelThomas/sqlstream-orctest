#!/bin/bash
# Start the test environment (based on streamlab-git image)

HERE=$(cd `dirname $0`; pwd)
BASE_IMAGE=sqlstream/streamlab-git
CONTAINER_NAME=orc_hive_test

: ${LOAD_SLAB_FILES:=CSVingest.slab WriteORCtoHive.slab}


. $HERE/dockercommon.sh
