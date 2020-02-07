#!/bin/bash
#
# Do any preproject setup needed before starting s-Server
# Assume we are running in the project directory

echo ... set up hadoop configuration
# copied to /home/sqlstream because longer paths seem to cause a problem

su sqlstream -m -c "cp -v hadoop/core-site.xml hadoop/hdfs-site.xml hadoop/svc*.keytab .."

echo ... add definitions to hosts file
cat hadoop/testhosts >> /etc/hosts

if [ -e hadoop/krb5.conf ]
then
    echo ... installing krb5.conf
    cp hadoop/krb5.conf /etc
fi
# 

