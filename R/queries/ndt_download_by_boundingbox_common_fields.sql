#standardSQL
SELECT
ndt.log_time AS log_time,
8 * (ndt.web100_log_entry.snap.HCThruOctetsAcked /
(ndt.web100_log_entry.snap.SndLimTimeRwin +
ndt.web100_log_entry.snap.SndLimTimeCwnd +
ndt.web100_log_entry.snap.SndLimTimeSnd)) AS download_speed_Mbps,
ndt.web100_log_entry.snap.MinRTT AS minRTT,
ndt.web100_log_entry.snap.MaxRTT AS maxRTT,
mm.asn_number AS asn_number,
mm.asn_name AS asn_name,
ndt.connection_spec.client_ip AS client_ip,
ndt.connection_spec.client_geolocation.latitude AS client_lat,
ndt.connection_spec.client_geolocation.longitude AS client_lon,
ndt.connection_spec.client_geolocation.area_code AS client_area_code,
ndt.connection_spec.client_geolocation.city AS client_city,
ndt.connection_spec.client_geolocation.postal_code AS client_postal_code,
ndt.connection_spec.client_geolocation.region AS client_region,
ndt.test_id AS test_id,
ndt.partition_date AS partition_date,
ndt.connection_spec.client_application AS client_application,
ndt.connection_spec.client_browser AS client_browser,
ndt.connection_spec.client_hostname AS client_hostname,
ndt.connection_spec.client_os AS client_os,
ndt.connection_spec.client_kernel_version AS client_kernel_version,
ndt.connection_spec.client_version AS client_version
FROM
`measurement-lab.release.ndt_downloads` AS ndt,
`measurement-lab.maxmind_historical.DATEMM` AS mm
WHERE
ndt.partition_date BETWEEN DATE1 AND DATE2
AND ndt.connection_spec.client_geolocation.latitude > BBLAT1
AND ndt.connection_spec.client_geolocation.longitude > BBLON1
AND ndt.connection_spec.client_geolocation.latitude < BBLAT2
AND ndt.connection_spec.client_geolocation.longitude < BBLON2
AND 
TO_BASE64(NET.IP_FROM_STRING(ndt.connection_spec.client_ip)) 
BETWEEN 
TO_BASE64(NET.IP_FROM_STRING(mm.min_ip)) AND
TO_BASE64(NET.IP_FROM_STRING(mm.max_ip));