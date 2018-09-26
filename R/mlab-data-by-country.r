### mlab-data-by-country.r
#
# This example uses the function, pull_ndt_by_country, to obtain NDT data from within a specified country.
# Search for data by connection_spec.client_country & date range.
#
###

###
# Set the working directory for R
# - change this to the folder location where you have cloned/saved this code repository
setwd("~/Desktop/mlab10year/data-support/R")

source("functions_setup/mlab-setup.r")

ndt_download <- read_file("queries/ndt_download_by_country.sql")
ndt_upload <- read_file("queries/ndt_upload_by_country.sql")

ndt_DL_2017_Germany <- with_config(config(http_version = 2), { 
	pull_mm_ndt("2017-01-01", "2017-12-31", ndt_download, "Germany") }
ndt_UL_2017_Germany <- with_config(config(http_version = 2), { 
	pull_mm_ndt("2017-01-01", "2017-12-31", ndt_upload, "Germany") }
