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
      AND test_date BETWEEN '#{start_date}' AND '#{end_date}'
      AND ndt.Client.Geo.country_code = '#{country_code}'
      AND ndt.Client.Geo.region = '#{region}'
    ORDER BY UTC_date_time ASC