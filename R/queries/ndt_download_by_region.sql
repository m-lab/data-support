#standardSQL
SELECT
ndt.log_time AS log_time,
ndt.connection_spec.client_ip AS client_ip,
ndt.connection_spec.client_geolocation.latitude AS client_lat,
ndt.connection_spec.client_geolocation.longitude AS client_lon,
8 * (web100_log_entry.snap.HCThruOctetsReceived /
         web100_log_entry.snap.Duration) AS upload_speed_Mbps,
ndt.web100_log_entry.snap.MinRTT AS minRTT,
ndt.connection_spec.server_geolocation.city AS city,
ndt.connection_spec.client_geolocation.continent_code AS continent,
ndt.connection_spec.client_geolocation.country_code AS country_code,
ndt.connection_spec.client_geolocation.country_name AS country_name,
ndt.connection_spec.client_geolocation.region AS client_region,
ndt.connection_spec.server_hostname AS server_hostname,
ndt.connection_spec.server_ip AS server_ip
FROM
`measurement-lab.release.ndt_downloads` AS ndt,
WHERE
ndt.partition_date BETWEEN DATE1 AND DATE2
AND
(
  ndt.connection_spec.client_geolocation.region = STATE
  OR ndt.connection_spec.client_geolocation.region = STATEABV
);