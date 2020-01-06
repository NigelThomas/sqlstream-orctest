# sqlstream-orctest

# Introduction

This repo contains a StreamLab project that can be used to test ORC egress (to local files, HDFS and Hive)

The project export files (.slab) contain the project details for reuse and development. 


# Test Project `sqlstream-orctest`

The test project is "sqlstream-orctest" and its StreamLab projects (each represented by a project export 'slab' file) are:

* CSVingest - ingest data from the source CSV files

And the following write / egress projects which can be executed in parallel or separately:

* WriteCSVlocal - a bare-bones CSV egress just to verify pipeline functionality
* WriteCSVtoHDFS - write to HDFS with no authentication

These projects are in development:

* WriteORClocal - write to local ORC files
* WriteORChdfs  - write to ORC files and copy them to HDFS
* WriteORChive  - write to ORC files and organize them as a Hive table

## Preparing test image `streamlab-git` 

This test harness relies on two Docker images:

| Image Name | Purpose 
| --- | ---
| `streamlab-git-dev` | Includes StreamLab, used for project development
| `streamlab-git` | Only includes s-Server, used as a run time environment

For testing purposes only the second, `streamlab-git` image is needed. It is also assumed you have Docker already installed.

To prepare the test image

```
 cd
 git clone https://github.com/NigelThomas/streamlab-git.git
 cd streamlab-git/production-image

 ./dockerbuild.sh
```

This makes a local image called `streamlab-git` in your local Docker repository. This image is based on the 'release' (6.0.1) branch docker image `sqlstream/minimal:release`. You should rerun `./dockerbuild.sh` whenever you want to pull the latest version of `sqlstream/minimal`. When a container is started from this image it:

* pulls support code from the `sqlstream-docker-utils` github repository
* pulls the `sqlstream-orctest` code from this github repository
* extracts SQL from the project exports (slab files)
* Sets up the SQLstream schemas required to run the test
* Starts reading the input and delivering data to the outputs


Note that __the image does not include the `sqlstream-orctest` project definitions__ - as described these get added whenever a container is created from the image. So you don't need to rebuild this image to pick up changes to `sqlstream-orctest` as long as those changes have been pushed to the original master repo on github.

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
You need to make sure you have the Verizon IOT data tarball (from  https://guavusnetwork-my.sharepoint.com/:u:/g/personal/nigel_thomas_guavus_com/EbxQZ01mkMBBtaxtrt7Wx4oBGq_LKZ5yrx2MnDjguLFR-g?e=KXf7qo). Unpack that into a directory on your server (to `$HOME/vzw/iot`):
```
 cd
 mkdir vzw
 cd vzw
 tar zxvf vzw.iot.tgz
```

Next, start the test runtime:
```
 cd sqlstream-orctest
 LOAD_SLAB_FILES="IngestCSV.slab WriteCSVtoHDFS.slab" ./dockertest.sh
```

The container will be named `orcdev`. The script automatically kills and removes any existing `orcdev` container, so be careful not to accidentally rerun the `dockertest.sh` script while a test is underway unless you want to abort the first test.

Setting the `LOAD_SLAB_FILES` environment variable instructs the container to load only the listed StreamLab project files. Generally it will be more convenient to combine the ingest project with just one write (sink, egress) project at a time.

If you need to place the data somewhere different on the host server you will also need to set the environment variable HOST_DATA_ROOT accordingly, either:

```
 HOST_DATA_ROOT=path/to/my/tarball/ LOAD_SLAB_FILES="CSVingest.slab WriteCSVtoHDFS.slab" ./dockertest.sh
```

or export these environment variables first: 

```
 export HOST_DATA_ROOT=path/to/my/tarball/
 export LOAD_SLAB_FILES="IngestCSV.slab WriteCSVtoHDFS.slab" 
 ./dockertest.sh
```

The `dockertest.sh` script ends by tailing the docker log file (`docker logs -f orctest`) so once that has shown the container  being started and s-Server trace log messages in the log eyou can Ctrl-C out, or you can leave the log tail running and work in another terminal.

* **TODO** - the default for LOAD_SLAB_FILES will be defined to test ORC output to HDFS using authentication
* **TODO** - the other important testing combination will be CSVingest to Hive with authentication

# Developing and extending the tests

## Preparing the development image `streamlab-git-dev`

If you are planning to change the tests, you need to use the `streamlab-git-dev` image which is based on the public `sqlstream/development:release` image.

To build that
```
 cd
 cd streamlab-git/develop-image
 ./dockerbuild.sh
```

This makes a local image called `streamlab-git-dev` in your local Docker repository. This image is based on the 'release' (6.0.1) branch docker image `sqlstream/minimal:release`. You should rerun `./dockerbuild.sh` whenever you want to pull the latest version of `sqlstream/minimal`.

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

The path for source data on the host is expected to be $HOME/vzw/iot - this can be overridden by setting the HOST_DATA_ROOT environment
variable. 

The root path for source data on the container is expected to be `/home/sqlstream/iot/`; we get EDR data from ../iot/rhy in which we see files like:
```
RFDR46EUTX_flow_REPORTOCS_20191004112349_test_000000000_708
RFDR46EUTX_flow_REPORTOCS_20191004112449_test_000000000_709
RFDR46EUTX_flow_REPORTOCS_20191004112549_test_000000000_710
```

If using Kubernetes, follow the same approach, creating a read-only volume for this source data so that the test containers running in a pod can mount the volume.



# Target Data

**TODO** complete this section or combine into the summary with StreamLab project names


## local file


## HDFS files

## Hive Table

## Credentials

These should not be stored in this open repository. Instead they will be shipped as a tarball that can be mounted as a volume (this volume could be combined with the source data).

**TODO** complete this section.

