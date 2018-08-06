source("functions_setup/mlab-setup.r")

ndt_download <- read_file("queries/ndt_download_by_region.sql")
ndt_upload <- read_file("queries/ndt_upload_by_region.sql")

ndt_DL_2017_Illinois <- with_config(config(http_version = 2), { 
	pull_mm_ndt("2017-01-01", "2017-12-31", ndt_download, "'Illinois'","IL") }
ndt_UL_2017_Illinois <- with_config(config(http_version = 2), { 
	pull_mm_ndt("2017-01-01", "2017-12-31", ndt_upload, "'Illinois'","IL") }
