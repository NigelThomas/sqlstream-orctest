

CREATE OR REPLACE SCHEMA "hdfs_test";
ALTER PUMP "hdfs_test".* STOP;

CREATE OR REPLACE FOREIGN DATA WRAPPER ECDAWRAPPER LIBRARY 'class com.sqlstream.aspen.namespace.common.CommonDataWrapper' LANGUAGE JAVA;
CREATE OR REPLACE SERVER "ECDAReaderServer_1"
FOREIGN DATA WRAPPER ECDAWRAPPER
OPTIONS (classname 'com.sqlstream.aspen.namespace.common.FileSetColumnSet');

CREATE OR REPLACE FOREIGN STREAM "hdfs_test"."data_1_raw"
      (
          "id" BIGINT,
          "reported_at" VARCHAR(32),
          "speed" INTEGER,
          "driver_no" BIGINT,
          "prescribed" BOOLEAN,
          "gps" VARCHAR(128),
          "highway" VARCHAR(8)
      )
      SERVER "FILE_SERVER"
      OPTIONS (
          "PARSER" 'XML',
          "CHARACTER_ENCODING" 'UTF-8',
          "PARSER_XML_ROW_TAGS" '/Table1',
          "PARSER_XML_USE_ATTRIBUTES" 'false',
          "id_XPATH" '/Table1/id',
          "reported_at_XPATH" '/Table1/reported_at',
          "speed_XPATH" '/Table1/speed',
          "driver_no_XPATH" '/Table1/driver_no',
          "prescribed_XPATH" '/Table1/prescribed',
          "gps_XPATH" '/Table1/gps',
          "highway_XPATH" '/Table1/highway',
          "DIRECTORY" '/tmp',
          "FILENAME_PATTERN" 'buses.log'
      );

CREATE or REPLACE VIEW "hdfs_test"."data_1" AS
SELECT stream *
FROM "hdfs_test"."data_1_raw";

CREATE OR REPLACE SERVER "HDFS_SERVER" TYPE 'hdfs'
FOREIGN DATA WRAPPER ECDA;

CREATE or REPLACE FOREIGN STREAM "hdfs_test"."guide_1_out_sink" (
        "id" BIGINT,
        "reported_at" VARCHAR(32),
        "speed" INTEGER,
        "driver_no" BIGINT,
        "prescribed" BOOLEAN,
        "gps" VARCHAR(128),
        "highway" VARCHAR(8)
        )
    SERVER "HDFS_SERVER"
    OPTIONS (
        "FORMATTER" 'JSON',
        "CONFIG_PATH" '/home/sqlstream/hadoop-configuration.xml',
        "DIRECTORY" '/tmp',
        "FILENAME_PREFIX" 'output-hdfs',
        "FILENAME_SUFFIX" '.log',
        "FILENAME_DATE_FORMAT" 'yyyy-MM-dd-HH-mm-ss',
        "FILE_ROTATION_SIZE" '10k',
        "FORMATTER_INCLUDE_ROWTIME" 'false'
    );

CREATE OR REPLACE PUMP "hdfs_test"."guide_1_out_sink-Pump" stopped AS
INSERT INTO "hdfs_test"."guide_1_out_sink"
    ("id", "reported_at", "speed", "driver_no", "prescribed", "gps", "highway")
SELECT STREAM *
    FROM "hdfs_test"."data_1";

alter pump "hdfs_test".* start;
