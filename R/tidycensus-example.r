library(tidycensus)

#code to install api key fortidycensus
census_api_key("f348a48cd500e6582321612511c326d0b07f2d2a", install=TRUE)

#code to get all of the geom files for a country (or large region defined by totalpop_sf) in one sf object
us <- unique(fips_codes$state)[1:51]

totalpop_sf <- reduce(
  map(us, function(x) {
    get_acs(geography = "tract", variables = "B01003_001", 
            state = x, geometry = TRUE)
  }), 
  rbind
)