source("functions_setup/mlab-setup.r")

# Install your US Census API key (add your key below and run once)
census_api_key("<INSERT YOUR US CENSUS API KEY HERE>", install=TRUE)

# Get all of the geom files for a country 
us <- unique(fips_codes$state)[1:51]

# Example - returns total population by census tract for US
totalpop_sf <- reduce(
  map(us, function(x) {
    get_acs(geography = "tract", variables = "B01003_001", 
            state = x, geometry = TRUE)
  }), 
  rbind
)
