-- Create schema and table for VZW_ORCTEST Hive pipeline

!set force on
CREATE SCHEMA vzw_orctest;
!set force off


USE vzw_orctest;

!set force on
DROP TABLE vzw_orctest_hive;
!set force off

CREATE TABLE vzw_orctest_hive
(   countryCode CHAR(2),
    countryName VARCHAR(34),
    city VARCHAR(32),
    region VARCHAR(2),
    latitude DOUBLE,
    longitude DOUBLE,
    rowtime_hour BIGINT,
    sn_end_time TIMESTAMP,
    sn_start_time TIMESTAMP,
    bearer_3gpp_imei VARCHAR(32),
    tac VARCHAR(32),
    bearer_3gpp_imsi BIGINT,
    bearer_3gpp_rat_type INT,
    bearer_3gpp_user_location_information VARCHAR(32),
    ip_server_ip_address VARCHAR(16),
    ip_subscriber_ip_address VARCHAR(64),
    p2p_tls_sni VARCHAR(128),
    radius_calling_station_id BIGINT,
    sn_direction VARCHAR(16),
    sn_duration INT,
    sn_flow_id VARCHAR(32),
    sn_flow_start_time TIMESTAMP,
    sn_server_port INT,
    sn_subscriber_port INT,
    sn_volume_amt_ip_bytes_downlink INT,
    sn_volume_amt_ip_bytes_uplink INT,
    sn_closure_reason INT,
    event_label VARCHAR(16),
    marketing_name VARCHAR(256),
    manufacturer VARCHAR(64),
    Bands VARCHAR(128),
    5GBands VARCHAR(16),
    LPWAN VARCHAR(16),
    radio_interface VARCHAR(4),
    brand_name VARCHAR(16),
    model_name VARCHAR(256),
    operating_system VARCHAR(16),
    NFC VARCHAR(16),
    bluetooth VARCHAR(16),
    WLAN VARCHAR(16),
    device_type VARCHAR(8),
    removable_uicc VARCHAR(16),
    removable_euicc VARCHAR(16),
    non_removable_uicc VARCHAR(16),
    non_removable_euicc VARCHAR(16),
    sim_slot VARCHAR(16),
    imei_quantity_support VARCHAR(16)
)
STORED AS ORC
LOCATION '/data/svc_sqlstream_guavus/vzw_orctest_hive'
TBLPROPERTIES 
( "orc.compress" = "SNAPPY"
);