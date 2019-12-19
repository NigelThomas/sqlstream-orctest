#!/bin/bash
#
# Do any postproject setup needed after loading the StreamLab projects
#
. /etc/sqlstream/environment
export PATH=$PATH:$SQLSTREAM_HOME/bin

echo ... starting project pumps


sqllineClient --run=home/sqlstream/startPumps.sql

echo ... done



