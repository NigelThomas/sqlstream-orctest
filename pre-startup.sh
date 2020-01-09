#!/bin/bash
#
# Do any preproject setup needed before loading the StreamLab projects
#
# Assume we are running in the project directory


su sqlstream -m -c "cp -v hadoop/core-site.xml hadoop/hdfs-site.xml hadoop/svc*.keytab .."

ls -l

echo ... add definitions to hosts file

#cat hadoop/testhosts >> /etc/hosts

echo ... Creating the clean_edrs interface stream

sqllineClient --run=$(which clean_edrs.sql)

echo ... done



