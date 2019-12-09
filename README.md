# orc-test

# Introduction

This repo contains a StreamLab project that can be used to test ORC egress (to local files, HDFS and Hive)

The project export files (.slab) contain the project details for reuse and development. 

At runtime, the SQL will be extracted from the projects and installed. Any one of the projects may be started.

The project runtime is executed using the streamlab-git runtime (see https://github.com/NigelThomas/streamlab-git.git). 

# Source Data

The test data is kept in its own repository, in a compressed format. This can be inflated into a host directory, and then made accessible to the docker container as a volume.

# Target Data

## local file

## HDFS files

## Hive Table

# The Test Pipeline


