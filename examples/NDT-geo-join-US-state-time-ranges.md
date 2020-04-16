# NDT Upload and Download Tests from Specific Client ASNs over Multiple, Non-Contiguous Date Ranges, with Geographic Fields from Public Data Sources

Tags:
- unified views
- geography
- asn
- UUID matching
- ndt5
- tcpinfo
- conditional logic
- CASE WHEN
- WITH
- UNION
- combined results

The query below returns upload and download tests in a single table of results, limiting to tests conducted to M-Lab servers from a specific US state, from clients within a specific set of ASNs, and over two non-contiguous date ranges. The query uses the NDT "Helpful Views", _measurement-lab.ndt.unified_uploads_ and _measurement-lab.ndt.unified_downloads_, and retrieves geographic field identifiers for _county_ and _congressional district_ using BigQuery's Geographic Information Systems (GIS) functions. Geography tables are provided by Google Public Datasets.


```~sql
WITH
dl AS (
  SELECT
    test_date AS test_date,
    a.TestTime AS test_time,
    client.Geo.region AS state,
    client.Geo.city AS city,
    client.Geo.postal_code AS zip_code,
    client.Geo.latitude AS client_latitude,
    client.Geo.longitude AS client_longitude,
    client.Network.ASNumber AS ASNumber,
    CASE WHEN client.Network.ASNumber IN ('209', '3549', '3356', '2379', '5778', '622') THEN 'CenturyLink'
         WHEN client.Network.ASNumber IN ('5650', '7011', '30064', '3593', '32587', '26127') THEN 'Frontier'
      ELSE NULL END AS ISP,
    counties.geo_id AS county_geoid,
    congress.geo_id AS congressional_district_geoid,
    a.MeanThroughputMbps AS mbps,
    'download' AS test_type,
    a.MinRTT AS MinRTT,
    a.LossRate AS LossRate,
    NET.SAFE_IP_FROM_STRING(Client.IP) AS client_ip
  FROM `measurement-lab.ndt.unified_downloads`,
        `bigquery-public-data.geo_us_boundaries.counties` counties,
        `bigquery-public-data.geo_us_boundaries.congress_district_116` congress
  WHERE client.Geo.country_name = 'United States'
    AND client.Network.ASNumber IN ('209', '3549', '3356', '2379', '5778', '622', '5650', '7011', '30064', '3593', '32587', '26127')
    AND ST_WITHIN(ST_GeogPoint(client.Geo.longitude, client.Geo.latitude), counties.county_geom)
    AND ST_WITHIN(ST_GeogPoint(client.Geo.longitude, client.Geo.latitude), congress.district_geom)
    AND client.Geo.region IS NOT NULL
    AND client.Geo.region != ""
),
ul AS (
  SELECT
    test_date AS test_date,
    a.TestTime AS test_time,
    client.Geo.region AS state,
    client.Geo.city AS city,
    client.Geo.postal_code AS zip_code,
    client.Geo.latitude AS client_latitude,
    client.Geo.longitude AS client_longitude,
    client.Network.ASNumber AS ASNumber,
    CASE WHEN client.Network.ASNumber IN ('209', '3549', '3356', '2379', '5778', '622') THEN 'CenturyLink'
         WHEN client.Network.ASNumber IN ('5650', '7011', '30064', '3593', '32587', '26127') THEN 'Frontier'
      ELSE NULL END AS ISP,
    counties.geo_id AS county_geoid,
    congress.geo_id AS congressional_district_geoid,
    a.MeanThroughputMbps AS mbps,
    'upload' AS test_type,
    a.MinRTT AS MinRTT,
    a.LossRate AS LossRate,
    NET.SAFE_IP_FROM_STRING(Client.IP) AS client_ip
  FROM `measurement-lab.ndt.unified_uploads`,
        `bigquery-public-data.geo_us_boundaries.counties` counties,
        `bigquery-public-data.geo_us_boundaries.congress_district_116` congress
  WHERE client.Geo.country_name = 'United States'
    AND client.Network.ASNumber IN ('209', '3549', '3356', '2379', '5778', '622', '5650', '7011', '30064', '3593', '32587', '26127')
    AND ST_WITHIN(ST_GeogPoint(client.Geo.longitude, client.Geo.latitude), counties.county_geom)
    AND ST_WITHIN(ST_GeogPoint(client.Geo.longitude, client.Geo.latitude), congress.district_geom)
    AND client.Geo.region IS NOT NULL
    AND client.Geo.region != ""
)
SELECT * FROM dl
WHERE
  ( dl.test_date BETWEEN '2020-02-01' AND '2020-02-21'
    OR dl.test_date BETWEEN '2020-03-16' AND '2020-04-07' )
UNION ALL (SELECT * FROM ul)
```
