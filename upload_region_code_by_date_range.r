library(bigrquery)
library(lubridate)
library(tidyverse)
project <- "mlab-sandbox"
sql_fir <- "#standardSQL
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
mm.asn_number AS asn_number,
mm.asn_name AS asn_name,
ndt.connection_spec.server_hostname AS server_hostname,
ndt.connection_spec.server_ip AS server_ip
FROM
`measurement-lab.release.ndt_downloads` AS ndt,
`mlab-sandbox.maxmind_historical.DATEMM` AS mm
WHERE
ndt.partition_date BETWEEN DATE1 AND DATE2
AND
(
  ndt.connection_spec.client_geolocation.region = STATE
  OR ndt.connection_spec.client_geolocation.region = STATEABV
)
AND 
TO_BASE64(NET.IP_FROM_STRING(ndt.connection_spec.client_ip)) 
BETWEEN 
TO_BASE64(NET.IP_FROM_STRING(mm.min_ip)) AND
TO_BASE64(NET.IP_FROM_STRING(mm.max_ip));"


pull_mm_ndt<-function(start_date, end_date, query, state, state.abv){
  D.return<-data.frame()
  day.starts<-seq(ymd(start_date), ymd(end_date), by="day")
  state.loc<-str_locate(query, "STATE")
  state.fir<-str_sub(query, 1,state.loc[1]-1)
  state.last<-str_sub(query, state.loc[2]+1, nchar(query))
  query<-str_c(state.fir, state, state.last)
  
  state.abv.loc<-str_locate(query, "STATEABV")
  state.abv.fir<-str_sub(query, 1,state.abv.loc[1]-1)
  state.abv.last<-str_sub(query, state.abv.loc[2]+1, nchar(query))
  state.abv.q<-str_c("'",state.abv,"'")
  query<-str_c(state.abv.fir, state.abv.q, state.abv.last)
  start.query<-query
  
  for(i in 1:length(day.starts)){
    date_1<-day.starts[i]
    date_mm<-format(as.Date(day.starts), "%Y_%m")
    date_2<-date_1+1
    date_1b<-str_c("'",date_1,"'")
    date_2<-str_c("'",date_2,"'")
    
    date.loc<-str_locate(query, "DATE1")
    date.fir<-str_sub(query, 1,date.loc[1]-1)
    date.last<-str_sub(query, date.loc[2]+1, nchar(query))
    query<-str_c(date.fir, date_1b, date.last)
    
    date.loc<-str_locate(query, "DATE2")
    date.fir<-str_sub(query, 1,date.loc[1]-1)
    date.last<-str_sub(query, date.loc[2]+1, nchar(query))
    query<-str_c(date.fir, date_2, date.last)
    
    date.mm.loc<-str_locate(query, "DATEMM")
    date.mm.fir<-str_sub(query, 1,date.mm.loc[1]-1)
    date.mm.last<-str_sub(query, date.mm.loc[2]+1, nchar(query))
    query<-str_c(date.mm.fir, date_mm[i], date.mm.last)

    todo_copies <- query_exec(query, project = project, use_legacy_sql=FALSE, max_pages = Inf)
    D.curr<-data.frame(todo_copies,"date"=rep(date_1, nrow(todo_copies)))
    D.return<-bind_rows(D.return,D.curr)
    
    query<-start.query
  }
  
  return(D.return)
  
}

D<-pull_mm_ndt("2015-12-01", "2015-12-31", sql_fir, "'Pennsylvania'","PA")