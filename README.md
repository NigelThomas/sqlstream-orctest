# sqlstream-orctest

# Introduction

This repo contains a StreamLab project that can be used to test ORC egress (to local files, HDFS and Hive)

The project export files (.slab) contain the project details for reuse and development. 


# Test Project Development 

The test project is "sqlstream-orctest" and its StreamLab projects (each represented by a project export 'slab' file) are:

* CSVingest - ingest data from the source CSV files

And the following write / egress projects which can be executed in parallel or separately:

* WriteCSVlocal - a bare-bones CSV egress just to verify pipeline functionality
* WriteORClocal - write to local ORC files
* WriteORChdfs  - write to ORC files and copy them to HDFS
* WriteORChive  - write to ORC files and organize them as a Hive table

(these projects are in development)

To develop and maintain the StreamLab projects, use the `dockerdev.sh` script. This launches a SQLstream docker appliance with the source test data mounted as 
`/home/sqlstream/iot' and loads the StreamLab projects into StreamLab. The docker container will have the name `orcdev`.

You can make changes to the project(s), then remember to export any changed project back to your working copy of the streamlab-orctest repository
before shutting down the docker container. You may export the project manually (using the StreamLab GUI) or you may use the command
line API (both curl commands must be executed in this order) for each project

```
curl http://localhost:5585/_project_export/user/CSVingest
curl -o orctest.slab http://localhost:5585/_download/user/CSVingest
```

These commands can be found in `export_project.sh`

Note: the `dockerdev.sh` script gets the slab files from the git repository and NOT from your local working copy. Be sure to commit and push your changes before testing.

# Test Execution

Tests are executed without requiring StreamLab. At runtime, the SQL will be extracted from the project and installed. 

The project depends on the streamlab-git runtime (see https://github.com/NigelThomas/streamlab-git.git). This:

* assembles a docker container based on the `sqlstream/minimal:release` image
* pulls the test code from this github repository
* extracts SQL from the project exports (slab files)
* Sets up the SQLstream schemas required to run the test
* Starts reading the input and delivering data to the outputs

To start the projects, use the `dockertest.sh` script. You can either allow all egress pipelines to be installed - they will run in parallel - or you can nominate just a subset to
be executed by supplying a comma-separated list of projects to be installed (note: `CSVingest` is always loaded).

# Source Data

The data consists of EDRs - CSV files - these are currently stored in compressed form in a file `vzw.iot.tgz`.
The data is too large to save in github (even compressed it is 160Mb), so it is stored in OneDrive - ask nigel.thomas@guavus.com for access. Inflate the tarball - the top level directory is `iot`.

When starting the container, use Docker's -v switch to mount the file on the container as a volume. This is shown in `dockerdev.sh`

```
docker run ... -v /path/on/host/iot://home/sqlstream/iot ...
```

The root path for source data on the container is expected to be `/home/sqlstream/iot/`; we get EDR data from ../iot/rhy in which we see files like:



If using Kubernetes, follow the same approach, creating a read-only volume for this source data so that the test containers running in a pod can mount the volume.


# Pipelines

There will eventually be multiple pipelines:

* Ingest - common to all

* ORC output
  * Output to local file
  * Output to HDFS file
  * Output to Hive table

* Possibly there will also be pipelines delivering the data in formats other than ORC


# Target Data

## Credentials

These should not be stored in this open repository. Instead they will be shipped as a tarball that can be mounted as a volume (this volume could be combined with the source data).

## local file

## HDFS files

## Hive Table


