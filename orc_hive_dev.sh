#!/bin/bash
#
# start a development container, load all slab files from the current project

HERE=$(cd `dirname $0`; pwd)
BASE_IMAGE=sqlstream/streamlab-git-dev
CONTAINER_NAME=orc_hive_dev

: ${LOAD_SLAB_FILES:=CSVingest.slab WriteORCtoHive.slab}


. $HERE/dockercommon.sh

