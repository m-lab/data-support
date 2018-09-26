### mlab-data-by-region.r
#
# This example uses the function, pull_ndt_by_region, to obtain NDT data from within a specified region.
# Search for data by connection_spec.client_region & date range.
#
# client_region is an annotated field in the M-Lab NDT data, 
# containing the ISO 3166-2 region code, set via IP geolocation.
#
# - Note that as of 2018-09-26, due to a processing issue in our
# ETL pipeline, this field contains both the code and the name of the
# region for data after 2017-05-17. 
# - For data prior to 2017-05-17, this field contains the FIPS 10-4 region code.
# - The M-Lab team has an open issue to reprocess the historical data
# archive to standardize the contents of this field to ISO 3166-2
#
###

###
# Set the working directory for R
# - change this to the folder location where you have cloned/saved this code repository
setwd("~/data-support/R")

source("functions_setup/mlab-setup.r")

ndt_download <- read_file("queries/ndt_download_by_region.sql")
ndt_upload <- read_file("queries/ndt_upload_by_region.sql")

ndt_DL_2017_Illinois <- with_config(config(http_version = 2), { 
	pull_mm_ndt("2017-01-01", "2017-12-31", ndt_download, "'Illinois'","IL") }
ndt_UL_2017_Illinois <- with_config(config(http_version = 2), { 
	pull_mm_ndt("2017-01-01", "2017-12-31", ndt_upload, "'Illinois'","IL") }
