# orc-test

# Introduction

This repo contains a StreamLab project that can be used to test ORC egress (to local files, HDFS and Hive)

The project export files (.slab) contain the project details for reuse and development. 

At runtime, the SQL will be extracted from the projects and installed. Any one of the projects may be started.

The project runtime is executed using the streamlab-git runtime (see https://github.com/NigelThomas/streamlab-git.git). 

# Source Data

The data consists of EDRs - CSV files - these are currently stored in compressed form in a file `vzw.iot.tgz`.
The data is too large to save in github (even compressed it is 160Mb), so it is stored in OneDrive - ask nigel.thomas@guavus.com for access. Inflate the tarball - the top level directory is `iot`.


When starting the container, use Docker's -v switch to mount the file on the container as a volume. This is shown in `dockerdev.sh`

```
docker run ... -v /path/on/host/iot://home/sqlstream/iot ...
```

The root path for source data on the container is expected to be `/home/sqlstream/iot/`.

If using Kubernetes, follow the same approach, creating a read-only volume for this source data so that the test containers running in a pod can mount the volume.

# Credentials

These should not be stored in this open repository. Instead they will be shipped as a tarball that can be mounted as a volume (this volume could be combined with the source data).

# Pipelines

There will eventually be multiple pipelines:

* Ingest - common to all

* ORC output
  * Output to local file
  * Output to HDFS file
  * Output to Hive table

* Possibly there will be pipelines delivering the data in formats other than ORC


# Target Data

## local file

## HDFS files

## Hive Table


