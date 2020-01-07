# sqlstream-orctest

# Introduction

This repo contains a StreamLab project that can be used to test ORC egress (to local files, HDFS and Hive)

The StreamLab export files (`xxx.slab`) each contain StreamLab project details for reuse and development. Each StreamLab project contains a single pipeline. There is one ingest pipeline:

| StreamLab project | Description | Reads from 
| --- | --- | ---
| CSVingest | ingests data from the source CSV files | host server volume at `$HOME/vzw/iot/rhy`

And the following write / egress projects which can be executed in parallel or separately:

| StreamLab project | Description | Writes to | Status 2020/01/06
| --- | --- | --- | ---
| WriteORCtoHDFS | write to ORC files | `$HOME/orctest-output` on the host server | Not yet writing to HDFS
| WriteCSVlocal | a bare-bones CSV egress just to verify pipeline functionality | `/home/sqlstream/output` on the container | Good
| WriteCSVtoHDFS | write to HDFS with no authentication | TBA | NOT FULLY WORKING
| WriteORChive  | write to ORC files in a Hive table | TBA | NOT YET IMPLEMENTED

See __Running tests__ below and particularly the sections on **source data** and **target data** to learn how to relocate the source and target locations on the host server.

## About the test image `streamlab-git` 

This test harness relies on two Docker images:

| Image Name | Purpose | Derived from 
| --- | --- | ---
| `sqlstream/streamlab-git-dev` | Includes StreamLab, used for project development | `sqlstream/development:release`
| `sqlstream/streamlab-git` | Only includes s-Server, used as a run time environment | `sqlstream/minimal:release`

You can read more about the base images here: https://docs.sqlstream.com/installing-sqlstream/docker 

For testing purposes only the second image `sqlstream/streamlab-git` is needed.

The test image is prepared as shown below - but note that this will usually be performed by the SQLstream team who can also push the build to the DockerIO repository.

```
 cd
 git clone https://github.com/NigelThomas/streamlab-git.git
 cd streamlab-git/production-image

 ./dockerbuild.sh
```
This makes an image called `sqlstream/streamlab-git` in your local Docker repository and pushes it to Docker. This image is based on the 'release' (6.0.1) branch docker image `sqlstream/minimal:release`. 

When a container is started from this image it:

* pulls support code from the `sqlstream-docker-utils` github repository
* pulls the `sqlstream-orctest` code from this github repository
* extracts SQL from the project exports (slab files)
* Sets up the SQLstream schemas required to run the test
* Starts reading the input and delivering data to the outputs


Note that __the image does not include the `sqlstream-orctest` project definitions__ - as described these get added whenever a container is created from the image. So you **don't need to rebuild this image** to pick up changes to `sqlstream-orctest` as long as those changes have been pushed to the original master repo on github.

Tests are executed without requiring StreamLab. At runtime, the SQL will be extracted from the project and installed. 

The project depends on the streamlab-git runtime (see https://github.com/NigelThomas/streamlab-git.git). 
To start the projects, use the `dockertest.sh` script. You can either allow all egress pipelines to be installed - they will run in parallel - or you can nominate just a subset to
be executed by supplying a comma-separated list of projects to be installed (note: `CSVingest` is always loaded).

## Running tests using the `sqlstream-orctest` project

Now you can use the image to run the `sqlstream-orctest` project. First, clone the project on your test host server:

```
 cd
 git clone https://github.com/NigelThomas/sqlstream-orctest.git
```

### Source Data

The data consists of EDRs - which are CSV files - these are currently stored in compressed form in a file `vzw.iot.tgz`.
The data is too large to save in github (even compressed it is 160Mb), so it is stored in OneDrive - ask nigel.thomas@guavus.com for access. Inflate the tarball - the top level directory is `iot`.

You need to make sure you have the Verizon IOT data tarball (from  https://guavusnetwork-my.sharepoint.com/:u:/g/personal/nigel_thomas_guavus_com/EbxQZ01mkMBBtaxtrt7Wx4oBGq_LKZ5yrx2MnDjguLFR-g?e=KXf7qo). Unpack that into a directory on your server (normally to `$HOME/vzw/iot`):

```
 cd
 mkdir vzw
 cd vzw
 tar zxvf vzw.iot.tgz
```
We get EDR data from `../iot/rhy` in which we see files like:
```
RFDR46EUTX_flow_REPORTOCS_20191004112349_test_000000000_708
RFDR46EUTX_flow_REPORTOCS_20191004112449_test_000000000_709
RFDR46EUTX_flow_REPORTOCS_20191004112549_test_000000000_710
```

If you need to change the location of the source CSV data, you will need to set the environment variable `HOST_DATA_SOURCE` accordingly before running the tests.

### Target Data

Make a directory $HOME/orctest-output. If you need to use a different location, you will need to set the environment variable HOST_DATA_TARGET before running the tests.

If you do not want to expose output data on the host server, just set the `HOST_DATA_TARGET` environment variable:

```
export HOST_DATA_TARGET=none
```

before running the `dockertest.sh` script as shown below.


### Starting the test container

Next, start the test runtime:
```
 cd sqlstream-orctest
 LOAD_SLAB_FILES="IngestCSV.slab WriteCSVtoHDFS.slab" ./dockertest.sh
```

The container will be named `orcdev`. The script automatically kills and removes any existing `orcdev` container, so be careful not to accidentally rerun the `dockertest.sh` script while a test is underway unless you want to abort the first test.

### Arguments for the runtime

The `dockertest.sh` script supports setting certain arguments by supplying values in some environment variables:

| Environment Variable | Default | Usage
| --- | --- | ---
| LOAD_SLAB_FILES | "IngestCSV.slab WriteCSVtoHDFS.slab" | instructs the container to load only the listed StreamLab project files. Generally it will be more convenient to combine the ingest project with just one write (sink, egress) project at a time.
| HOST_DATA_SOURCE | $HOME/vzw/iot | Location of the source data on the host server (mounted on the container as `/home/sqlstream/iot`)
| HOST_DATA_TARGET | $HOME/output | Location of local target data on the host server (mounted on the container as `/home/sqlstream/output`). **NOTE** if this is set to "none" then the output volume will not be mounted and all local target data will remain within the container
| SQLSTREAM_HEAP_MEMORY | 4096m | Java max heap memory (set using -Xmx<size> ; include k, m, g units as required. s-Server default is 2048m)

You can set any one or more of these environment variables either directly on the command line:
```
 HOST_DATA_ROOT=path/to/my/tarball/ LOAD_SLAB_FILES="CSVingest.slab WriteCSVtoHDFS.slab" ./dockertest.sh
```

or set and export these environment variables first: 

```
 export HOST_DATA_ROOT=path/to/my/tarball/
 export LOAD_SLAB_FILES="IngestCSV.slab WriteORCtoHDFS.slab" 
 ./dockertest.sh
```

The default setting for `LOAD_SLAB_FILES` checks the HDFS delivery. The other common setting will be to test Hive:

```
 export LOAD_SLAB_FILES="IngestCSV.slab WriteORCtoHive.slab"
 ./dockertest.sh
```

### Following the container log

The `dockertest.sh` script ends by tailing the docker log file (`docker logs -f orctest`) so once that has shown the container  being started and s-Server trace log messages in the log eyou can Ctrl-C out, or you can leave the log tail running and work in another terminal.


# Developing and extending the tests

## Preparing the development image `sqlstream/streamlab-git-dev`

If you are planning to change the tests, you need to use the `streamlab-git-dev` image which is based on the public `sqlstream/development:release` image.

To build that
```
 cd
 cd streamlab-git/develop-image
 ./dockerbuild.sh
```

This makes a local image called `sqlstream/streamlab-git-dev` in your local Docker repository and then pushes it to Docker. This image is based on the 'release' (6.0.1) branch docker image `sqlstream/minimal:release`. Normally this image will be rebuilt by the SQLstream engineering team re-running `./dockerbuild.sh` whenever the latest version of `sqlstream/minimal:release` is modified.

Note that __the image does not include the `sqlstream-orctest` project definitions__ - these get added whenever a container is created from the image. So you don't need to rebuild this image to pick up changes to `sqlstream-orctest` as long as those changes have been pushed to the original master repo on github.

## Running the development image

Start the development runtime using the `dockerdev.sh` script:
```
 cd
 cd sqlstream-orctest
 LOAD_SLAB_FILES="IngestCSV.slab WriteCSVtoHDFS.slab" ./dockerdev.sh
```
The container will be named `orcdev`. The script automatically kills and removes any existing `orcdev` container, so be careful not to accidentally rerun the `dockerdev.sh` script unless you are sure you want to discard the existing container.

You can use LOAD_SLAB_FILES and HOST_DATA_ROOT environment variables exactly as defined for the test image (but using the `./dockerdev,.sh script`). The same defaults will apply.

When you start the container the selected StreamLab projects will be already loaded and started. 

The `dockerdev.sh` script ends by tailing the docker log file (`docker logs -f orcdev`) so once that has shown the container  being started and s-Server trace log messages in the log eyou can Ctrl-C out, or you can leave the log tail running and work in another terminal.


# Making changes to the StreamLab rojects

You can make changes to the projects in the normal way using StreamLab.

To save changes to your project you should:

1. Save the project from StreamLab (by clicking on the project name). This saves a rose file on the container
2. Export the project from StreamLab to your local server (where you have the working copy of the `sqlstream-orctest` project) by 
  * click on the Projects menu option
  * click on the export icon (on the left, in the row of icons underneath the project name, the third icon from the left) 
  * a project .slab file will be saved normally to your Downloads directory
3. Move the .slab file(s) from Downloads into the working copy to overwrite existing .slab file(s)
4. Then `git add` all changed files, `git commit` and finally `git push origin master`

Note: the `dockerdev.sh` script gets the slab files from the git repository and NOT from your local working copy. Be sure to commit **and push** your changes before re-testing.

## Scripting project export

Rather than using the StreamLab GUI to export projects, you can script the export, using the Rose command
line API (both curl commands must be executed in this order) for each project:

```
curl http://localhost:5585/_project_export/user/CSVingest
curl -o orctest.slab http://localhost:5585/_download/user/CSVingest
```

These commands can be found in `export_project.sh`


# Source Data

The data consists of EDRs - CSV files - these are currently stored in compressed form in a file `vzw.iot.tgz`.
The data is too large to save in github (even compressed it is 160Mb), so it is stored in OneDrive - ask nigel.thomas@guavus.com for access. Inflate the tarball - the top level directory is `iot`.

When starting the container, use Docker's -v switch to mount the file on the container as a volume. This is shown in `dockerdev.sh`

```
docker run ... -v /path/on/host/iot://home/sqlstream/iot ...
```

The path for source data on the host is expected to be `$HOME/vzw/iot` - this can be overridden by setting the `HOST_DATA_SOURCE` environment
variable. The root path for source data on the container is expected to be `/home/sqlstream/iot/`; we get EDR data from `../iot/rhy` in which we see files like:
```
RFDR46EUTX_flow_REPORTOCS_20191004112349_test_000000000_708
RFDR46EUTX_flow_REPORTOCS_20191004112449_test_000000000_709
RFDR46EUTX_flow_REPORTOCS_20191004112549_test_000000000_710
```

For more about environment variables that can be used as arguments, see **Arguments for the runtime** above in the **Testing** section.

If using Kubernetes, follow the same approach, creating a read-only volume for this source data so that the test containers running in a pod can mount the volume.



## Credentials

These should not be stored in this open repository. Instead they will be shipped as a tarball that can be mounted as a volume (this volume could be combined with the source data).

**TODO** complete this section.

