############################
# Load R packages
############################
library(bigrquery)
library(zipcode)
library(tidyverse)
library(ggplot2)
library(ggrepel)
library(rgdal)
library(rgeos)
library(maptools)
library(viridis)
library(lubridate)
library(RColorBrewer)
library(reshape2)
library(tidycensus)
library(sp)
library(sf)
library(tigris)
library(httr)

############################
# Set the Google Cloud Project to query M-Lab data 
############################
project <- "measurement-lab"

############################
# "Pull NDT" Functions
#
# pull_ndt_by_region -  Search for data by connection_spec.client_region & date range.
#                       client_region is an annotated field in the M-Lab NDT data, 
#                       containing the ISO 3166-2 region code, set via IP geolocation.
#
#                       - Note that as of 2018-09-26, due to a processing issue in our
#                       ETL pipeline, this field contains both the code and the name of the
#                       region for data after 2017-05-17. 
#                       - For data prior to 2017-05-17, this field contains the FIPS 10-4
#                       region code.
#                       - The M-Lab team has an open issue to reprocess the historical data
#                       archive to standardize the contents of this field to ISO 3166-2
#
############################
pull_ndt_by_region <- function(start_date, end_date, query, region, region.code){
  D.return<-data.frame()
  day.starts<-seq(ymd(start_date), ymd(end_date), by="day")
  region.loc<-str_locate(query, "REGION")
  region.fir<-str_sub(query, 1,state.loc[1]-1)
  region.last<-str_sub(query, state.loc[2]+1, nchar(query))
  query<-str_c(state.fir, state, state.last)
  
  region.code.loc<-str_locate(query, "REGIONCODE")
  region.code.fir<-str_sub(query, 1,region.code.loc[1]-1)
  region.code.last<-str_sub(query, region.code.loc[2]+1, nchar(query))
  region.code.q<-str_c("'",region.code,"'")
  query<-str_c(region.abv.fir, region.code.q, region.code.last)
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

# pull_ndt_by_country - Search for NDT data by connection_spec.client_geolocation.country_name 
#                       & date range.

pull_ndt_by_country<-function(start_date, end_date, query, country){
  D.return<-data.frame()
  day.starts<-seq(ymd(start_date), ymd(end_date), by="day")
  country.loc<-str_locate(query, "COUNTRY")
  country.fir<-str_sub(query, 1,country.loc[1]-1)
  country.last<-str_sub(query, country.loc[2]+1, nchar(query))
  query<-str_c(country.fir, country, country.last)
  
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

# pull_ndt_by_country - Search for NDT data by specifying two latitude/longitude pairs which 
#                       form the south west and north east corners of a geographic bounding box,
#                       and like other functions, limit by date range.

pull_ndt_by_boundingbox <- function(start_date, end_date, query, bblat1, bblon1, bblat2, bblon2){
  D.return<-data.frame()
  day.starts<-seq(ymd(start_date), ymd(end_date), by="day")
  
  bblat1.loc<-str_locate(query, "BBLAT1")
  bblat1.fir<-str_sub(query, 1, bblat1.loc[1]-1)
  bblat1.last<-str_sub(query, bblat1.loc[2]+1, nchar(query))
  query<-str_c(bblat1.fir, bblat1, bblat1.last)

  bblon1.loc<-str_locate(query, "BBLON1")
  bblon1.fir<-str_sub(query, 1, bblon1.loc[1]-1)
  bblon1.last<-str_sub(query, bblon1.loc[2]+1, nchar(query))
  query<-str_c(bblon1.fir, bblon1, bblon1.last)
  
  bblat2.loc<-str_locate(query, "BBLAT2")
  bblat2.fir<-str_sub(query, 1, bblat2.loc[1]-1)
  bblat2.last<-str_sub(query, bblat2.loc[2]+1, nchar(query))
  query<-str_c(bblat2.fir, bblat2, bblat2.last)
  
  bblon2.loc<-str_locate(query, "BBLON2")
  bblon2.fir<-str_sub(query, 1, bblon2.loc[1]-1)
  bblon2.last<-str_sub(query, bblon2.loc[2]+1, nchar(query))
  query<-str_c(bblon2.fir, bblon2, bblon2.last)

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
