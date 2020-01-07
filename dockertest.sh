#!/bin/bash
# Start the test environment (based on streamlab-git image)

HERE=$(cd `dirname $0`; pwd)
BASE_IMAGE=streamlab-git
CONTAINER_NAME=orctest

. $HERE/dockercommon.sh
