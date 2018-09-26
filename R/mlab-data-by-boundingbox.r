### mlab-data-by-boundingbox.r
#
# This example uses the functioon, pull_ndt_by_boundingbox, to obtain NDT data from within a geographic area
# defined by a bounding box - two pairs of latitude/longitude coordinates defining the south west and north east
# corners of a geographic area. The function requires the following values: 
#     start_date, end_date, query, bblat1, bblon1, bblat2, bblon2
# 
# start_date and end_date should be in the format "YYYY-MM-DD"
# query is specified in a variable read from an external file in the folder "queries"
# bblat1 and bblon1 should be the south west bounding box coordinates
# bblat2 and bblon2 should be the north east bounding box coordinates
#
###

###
# Set the working directory for R
# - change this to the folder location where you have cloned/saved this code repository
setwd("~/Desktop/mlab10year/data-support/R")

###
# Required R packcages and M-Lab defined functions are loaded into the R project
source("functions_setup/mlab-setup.r")

###
# Load queries from external files
ndt_download <- read_file("queries/ndt_download_by_boundingbox.sql")
ndt_upload <- read_file("queries/ndt_upload_by_boundingbox.sql")

###
# Run the queries, saving results to a dataframe
with_config(config(http_version = 2), { 
  ndt_DL_2018_eastern_WA <- pull_ndt_by_boundingbox("2018-01-01", "2018-07-31", ndt_download, 
                                                    "-121.1514167031", "45.9738255702", "-116.5261725625", "49.0016222587") })
with_config(config(http_version = 2), { 
  ndt_UL_2018_eastern_WA <- pull_ndt_by_boundingbox("2018-01-01", "2018-07-31", ndt_upload, 
                                                    "-121.1514167031", "45.9738255702", "-116.5261725625", "49.0016222587") })
