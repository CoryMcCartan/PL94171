pl_crosswalk = function(abbr, from_year=2010L) {
    fips = tigris::fips_codes$state_code[match(abbr, tigris::fips_codes$state)]
    yr_from = as.character(as.integer(from_year))
    yr_to = as.character(as.integer(from_year) + 10L)
    if (yr_from == "2000") {
        url = str_glue("https://www2.census.gov/geo/docs/maps-data/data/rel/",
                       "t{str_sub(yr_from, 3, 4)}t{str_sub(yr_to, 3, 4)}/",
                       "TAB{yr_from}_TAB{yr_to}_ST_{fips}_v2.zip")
    } else if (yr_from == "2010") {
        url = str_glue("https://www2.census.gov/geo/docs/maps-data/data/rel2020/",
                       "t{str_sub(yr_from, 3, 4)}t{str_sub(yr_to, 3, 4)}/",
                       "TAB{yr_from}_TAB{yr_to}_ST{fips}.zip")
    }
    as.character(url)
}

