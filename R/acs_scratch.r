library(rgdal)    # for readOGR and others
library(sp)       # for spatial objects
library(leaflet)  # for interactive maps (NOT leafletR here)
library(dplyr)    # for working with data frames
library(ggplot2)  # for plotting
library(acs)

acs_vars<-load_variables(2017,"acs5", cache=TRUE)
View(acs_vars)

cd_115<- readOGR(dsn="examples/geofiles/us_legislative_districts", "cb_2017_us_cd115_500k")
cd_115@data$GEOID<-as.character(cd_115@data$GEOID)

MN_03_cd115 <- select(filter(cd_115@data, STATEFP == '27'),colnames(cd_115@data))

coordinates(AR_2018_06_upload) <- c("client_lon", "client_lat")
AR_cd115 <- subset(cd_115,STATEFP='05')
proj4string(AR_2018_06_upload) <- proj4string(cd_115)
AR2018_down <- cbind(AR2018_down,over(AR2018_down,AR_cd115))

#################
cd_115<- st_read(dsn="examples/geofiles/us_legislative_districts", layer="cb_2017_us_cd115_500k", quiet=TRUE)
AR_cd115 <- subset(cd_115,STATEFP='05')
AR_cd115_sp <- as(AR_cd115,"Spatial")
> (AR_geom <- st_geometry(AR_cd115))

######## cowork with Nick
library(tidyverse)



