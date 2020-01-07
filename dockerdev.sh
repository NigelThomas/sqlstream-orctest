#!/bin/bash
#
# start a development container, load all slab files from the current project

HERE=$(cd `dirname $0`; pwd)
BASE_IMAGE=streamlab-git-dev
CONTAINER_NAME=orcdev

. $HERE/dockercommon.sh

