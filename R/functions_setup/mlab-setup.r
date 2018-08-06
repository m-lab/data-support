############################
# Load R packages
############################
library(bigrquery)
library(lubridate)
library(tidyverse)
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
# Function to pull M-Lab Data by region code, by day, for a given date range
# -- note - replace with Nick's function
############################
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