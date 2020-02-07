#!/bin/bash
#
# Do any preproject setup needed before loading the StreamLab projects
#
# Assume we are running in the project directory

echo ... Creating the clean_edrs interface stream

sqllineClient --run=$(which clean_edrs.sql)

echo ... done



