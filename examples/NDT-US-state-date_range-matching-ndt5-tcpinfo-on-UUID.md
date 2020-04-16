# NDT Upload and Download Tests from a US State within a Defined Date Range, with Fields from ndt5 and tcpinfo tables, matching on test UUID

Tags:
- unified views
- geography
- UUID matching
- ndt5
- tcpinfo

The queries below return upload and download test results from a specified US State, within a defined date range. They use the NDT "Helpful Views", _measurement-lab.ndt.unified_uploads_ and _measurement-lab.ndt.unified_downloads_, and also bring in specific fields from the `ndt5` and `tcpinfo` tables by matching on each test's Universally Unique Identifier, or UUID.

## Upload Query
```~sql
#standardSQL
SELECT 
  tcpinfo.ParseInfo.TaskFileName AS test_id,  
  a.TestTime AS UTC_date_time,
  ndt.client.IP AS client_ip,
  ndt.Client.Geo.latitude AS client_latitude,
  ndt.Client.Geo.longitude AS client_longitude,
  ndt.Client.Geo.country_code AS country_code,
  ndt.Client.Geo.region AS region,
  ndt.Client.Geo.city AS city,
  ndt.Client.Geo.postal_code AS postal_code,
  a.MeanThroughputMbps AS uploadThroughput,
  NULL AS downloadThroughput,
  TIMESTAMP_DIFF(ndt5.result.S2C.EndTime, ndt5.result.S2C.StartTime, MICROSECOND) AS duration,
  FinalSnapshot.TCPInfo.BytesReceived AS HCThruOctetsRecv
FROM `measurement-lab.ndt.unified_uploads` ndt,
     `measurement-lab.ndt.ndt5` ndt5,
     `measurement-lab.ndt.tcpinfo` tcpinfo
WHERE
  a.UUID = tcpinfo.UUID
  AND a.UUID = ndt5.result.S2C.UUID
  AND test_date BETWEEN '2020-01-01' AND '2020-03-31'
  AND ndt.Client.Geo.country_code = 'US'
  AND ndt.Client.Geo.region = 'MD'
ORDER BY UTC_date_time ASC
```

## Download Query
```~sql
#standardSQL
SELECT 
  tcpinfo.ParseInfo.TaskFileName AS test_id,  
  a.TestTime AS UTC_date_time,
  ndt.client.IP AS client_ip,
  ndt.Client.Geo.latitude AS client_latitude,
  ndt.Client.Geo.longitude AS client_longitude,
  ndt.Client.Geo.country_code AS country_code,
  ndt.Client.Geo.region AS region,
  ndt.Client.Geo.city AS city,
  ndt.Client.Geo.postal_code AS postal_code,
  a.MeanThroughputMbps AS downloadThroughput,
  NULL AS uploadThroughput,
  TIMESTAMP_DIFF(ndt5.result.S2C.EndTime, ndt5.result.S2C.StartTime, MICROSECOND) AS duration,
  FinalSnapshot.TCPInfo.BytesReceived AS HCThruOctetsRecv
FROM `measurement-lab.ndt.unified_downloads` ndt,
     `measurement-lab.ndt.ndt5` ndt5,
     `measurement-lab.ndt.tcpinfo` tcpinfo
WHERE
  a.UUID = tcpinfo.UUID
  AND a.UUID = ndt5.result.S2C.UUID
  AND test_date BETWEEN '2020-01-01' AND '2020-03-31'
  AND ndt.Client.Geo.country_code = 'US'
  AND ndt.Client.Geo.region = 'MD'
ORDER BY UTC_date_time ASC
```
