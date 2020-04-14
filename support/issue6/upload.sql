WITH ndt5uploads AS (
  SELECT *
  FROM   `measurement-lab.ndt.ndt5`
  -- Limit to valid C2S results
  WHERE result.C2S IS NOT NULL
),

tcpinfo AS (
  SELECT * EXCEPT (snapshots)
  FROM `measurement-lab.ndt.tcpinfo`
),
filtervalid AS (
  SELECT
    uploads.*, tcpinfo.Client, tcpinfo.Server,
    tcpinfo.FinalSnapshot AS FinalSnapshot,
    -- Receiver side can not compute IsCongested
    -- Receiver side can not directly compute IsBloated
 FROM
    -- Use a left join to allow NDT test without matching tcpinfo rows.
    ndt5uploads AS uploads
    LEFT JOIN tcpinfo
    ON uploads.result.C2S.UUID = tcpinfo.UUID
 WHERE
    uploads.result.C2S.ClientIP NOT IN
        ("45.56.98.222", "35.192.37.249", "35.225.75.192", "23.228.128.99",
        "2600:3c03::f03c:91ff:fe33:819",  "2605:a601:f1ff:fffe::99")
      OR (NET.IP_TRUNC(NET.SAFE_IP_FROM_STRING(uploads.result.C2S.ServerIP),
                8) = NET.IP_FROM_STRING("10.0.0.0"))
      OR (NET.IP_TRUNC(NET.SAFE_IP_FROM_STRING(uploads.result.C2S.ServerIP),
                12) = NET.IP_FROM_STRING("172.16.0.0"))
      OR (NET.IP_TRUNC(NET.SAFE_IP_FROM_STRING(uploads.result.C2S.ServerIP),
                16) = NET.IP_FROM_STRING("192.168.0.0"))
)
SELECT 
  ParseInfo.TaskFileName AS test_id,
  TIMESTAMP_SECONDS(log_time) AS UTC_date_time,
  result.ClientIP AS client_ip,
  Client.Geo.latitude AS client_latitude,
  Client.Geo.longitude AS client_longitude,
  Client.Geo.country_code AS country_code,
  Client.Geo.region AS region,
  Client.Geo.city AS city,
  Client.Geo.postal_code AS postal_code,
  result.C2S.MeanThroughputMbps AS uploadThroughput,
  NULL AS downloadThroughput,
  TIMESTAMP_DIFF(result.C2S.EndTime, result.C2S.StartTime, MICROSECOND) AS duration,
  FinalSnapshot.TCPInfo.BytesReceived AS HCThruOctetsRecv
FROM filtervalid
WHERE
  partition_date BETWEEN '2020-01-01' AND '2020-03-31'
  AND Client.Geo.country_code = 'US'
  AND Client.Geo.region = 'OR'
ORDER BY partition_date ASC, log_time ASC
