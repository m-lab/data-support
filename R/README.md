# R Examples - Working with M-Lab data

This folder contains examples of how to get M-Lab data using the statistics and data analysis program R. All examples assume you have: 

* read the [M-Lab BigQuery Quickstart](https://www.measurementlab.net/data/docs/bq/quickstart/) and subscribed a Gmail account to the [M-Lab Discuss group](https://groups.google.com/a/measurementlab.net/forum/#%21forum/discuss) to be whitelisted
* installed and initialized the [Google Cloud SDK](https://cloud.google.com/sdk/) on your machine

We provide comments describing the operations and functions used, and samples of their use. Depending on the particulars of your operating system and installation of R, you may need to install R packages. The primary R package needed to query M-Lab data is the [bigrquery package](https://cran.r-project.org/web/packages/bigrquery/index.html)

## Organization of code and supporting files

* _acs/_ - data files downloaded from the US Census/ACS API
* _functions_setup/_ - contains R files imported by example code, sets up 
* _geofiles/_ - geographic data in shapefile or other formats used in some examples
* _queries/_ - sql queries used in our examples, for querying M-Lab data in BigQuery
* _tutorials/_ - contains tutorials for R contributed by M-Lab users and developers
* _wip/_ - works in progress

## Current Examples

* _mlab-data-by-region.r_
* _mlab-data-by-country.r_
* _mlab-data-by-boundingbox.r_

Each example file contains code comments describing the functions used and how to use them, followed by a working code example. Each beings by setting the working directory for R, with the command `setwd("...")`. **Relace this path with the system path where you have cloned this repository before running**. The next command loads common functions and installs required packages needed by these examples using the command: `source("functions_setup/mlab-setup.r")`. 

