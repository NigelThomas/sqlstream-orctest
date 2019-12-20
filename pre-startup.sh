#!/bin/bash
#
# Do any preproject setup needed before loading the StreamLab projects
#
. /etc/sqlstream/environment
export PATH=$PATH:$SQLSTREAM_HOME/bin
echo ... Creating the clean_edrs interface stream


sqllineClient --run=home/sqlstream/clean_edrs.sql

echo ... done



