-- stream used to communicate between StreamLab projects
--
-- ingest should pump INTO stream
-- egress should pump OUT from stream
--
-- neither ingest nor egress project should issue any DDL against the stream in production


CREATE OR REPLACE SCHEMA "interface";


CREATE OR REPLACE STREAM "interface"."ingest_final_sink"(
    "countryCode" CHAR(2),
    "countryName" VARCHAR(34),
    "city" VARCHAR(32),
    "region" VARCHAR(2),
    "latitude" DOUBLE,
    "longitude" DOUBLE,
    "rowtime_hour" BIGINT,
    "sn-end-time" TIMESTAMP,
    "sn-start-time" TIMESTAMP,
    "bearer-3gpp imei" VARCHAR(32),
    "tac" VARCHAR(32),
    "bearer-3gpp imsi" BIGINT,
    "bearer-3gpp rat-type" INTEGER,
    "bearer-3gpp user-location-information" VARCHAR(32),
    "ip-server-ip-address" VARCHAR(16),
    "ip-subscriber-ip-address" VARCHAR(64),
    "p2p-tls-sni" VARCHAR(128),
    "radius-calling-station-id" BIGINT,
    "sn-direction" VARCHAR(16),
    "sn-duration" INTEGER,
    "sn-flow-id" VARCHAR(32),
    "sn-flow-start-time" TIMESTAMP,
    "sn-server-port" INTEGER,
    "sn-subscriber-port" INTEGER,
    "sn-volume-amt-ip-bytes-downlink" INTEGER,
    "sn-volume-amt-ip-bytes-uplink" INTEGER,
    "sn-closure-reason" INTEGER,
    "event-label" VARCHAR(16),
    "marketing_name" VARCHAR(256),
    "manufacturer" VARCHAR(64),
    "Bands" VARCHAR(128),
    "5GBands" VARCHAR(16),
    "LPWAN" VARCHAR(16),
    "radio_interface" VARCHAR(4),
    "brand_name" VARCHAR(16),
    "model_name" VARCHAR(256),
    "operating_system" VARCHAR(16),
    "NFC" VARCHAR(16),
    "bluetooth" VARCHAR(16),
    "WLAN" VARCHAR(16),
    "device_type" VARCHAR(8),
    "removable_uicc" VARCHAR(16),
    "removable_euicc" VARCHAR(16),
    "non_removable_uicc" VARCHAR(16),
    "non_removable_euicc" VARCHAR(16),
    "sim_slot" VARCHAR(16),
    "imei_quantity_support" VARCHAR(16)
);

