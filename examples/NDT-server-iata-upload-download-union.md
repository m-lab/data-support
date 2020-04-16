# NDT Upload and Download Tests to Servers in a specific Metro area identified by IATA code, over a defined time period.

Tags:
- unified views
- geography
- UUID matching
- ndt5
- tcpinfo
- WITH
- UNION
- combined results

The query below returns upload and download tests in a single table of results, limiting to tests conducted to M-Lab servers in a specific metro area. THe query uses the NDT "Helpful Views", _measurement-lab.ndt.unified_uploads_ and _measurement-lab.ndt.unified_downloads_, and matches the upload and download tests' UUIDs to limit tests to those within the metro area 'beg' using the field, `Server.IATA`, designating the airport code nearest to each M-Lab server. The query also includes some fields from the `ndt5` and `tcpinfo` tables by matching on each test's Universally Unique Identifier, or UUID.


```~sql
WITH
dl AS (
  SELECT
    ndt.test_date AS test_date,
    ndt.a.TestTime AS test_datetime,
    EXTRACT(HOUR FROM a.TestTime) AS test_hour,
    ndt.client.Geo.region AS region,
    ndt.client.Geo.city AS city,
    ndt.client.Geo.latitude AS client_latitude,
    ndt.client.Geo.longitude AS client_longitude,
    ndt.client.Network.ASNumber AS ASNumber,
    a.MeanThroughputMbps AS mbps,
    'download' AS test_type,
    a.MinRTT AS MinRTT,
    a.LossRate AS LossRate
  FROM `measurement-lab.ndt.unified_downloads` ndt, `measurement-lab.ndt.tcpinfo` tcpinfo
  WHERE 
    a.UUID = tcpinfo.UUID
    AND test_date >= '2020-01-01'
    AND tcpinfo.Server.IATA = 'beg'
),
ul AS (
  SELECT
    ndt.test_date AS test_date,
    ndt.a.TestTime AS test_datetime,
    EXTRACT(HOUR FROM a.TestTime) AS test_hour,
    ndt.client.Geo.region AS region,
    ndt.client.Geo.city AS city,
    ndt.client.Geo.latitude AS client_latitude,
    ndt.client.Geo.longitude AS client_longitude,
    ndt.client.Network.ASNumber AS ASNumber,
    a.MeanThroughputMbps AS mbps,
    'upload' AS test_type,
    a.MinRTT AS MinRTT,
    a.LossRate AS LossRate
  FROM `measurement-lab.ndt.unified_uploads` ndt, `measurement-lab.ndt.tcpinfo` tcpinfo
  WHERE 
    a.UUID = tcpinfo.UUID
    AND test_date >= '2020-01-01'
    AND tcpinfo.Server.IATA = 'beg'
)
SELECT * FROM dl
UNION ALL (SELECT * FROM ul)
```
