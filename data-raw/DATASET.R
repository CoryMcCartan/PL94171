library(dplyr)
library(readr)

# FIPS codes ------
if (FALSE) {
fips = select(tigris::fips_codes, abbr=state, fips=state_code, state=state_name) %>%
    distinct()
abbr_to_fips = fips$fips
state_to_fips = fips$fips
names(abbr_to_fips) = fips$abbr
names(state_to_fips) = fips$state
fips_to_state = fips$state
names(fips_to_state) = fips$fips

usethis::use_data(abbr_to_fips, state_to_fips, fips_to_state,
                  internal=TRUE, overwrite=TRUE, version=3)
}


# Example data -----
devtools::load_all(".")
path = "data-raw/ri2018_2020Style.pl/"
tracts = c("0070001", "0070002", "0070003", "0070004", "0070005", "0070006")
idxs = c(1, 2, which(stringr::str_sub(out$geo$GEOID, 12, 18) %in% tracts))
out = lapply(pl_read(path), function(x) x[idxs, ])
write_delim(out$`00001`, "inst/extdata/ri2018_2020Style.pl/ri000012018_2020Style.pl",
            delim="|", col_names=FALSE, na="")
write_delim(out$`00002`, "inst/extdata/ri2018_2020Style.pl/ri000022018_2020Style.pl",
            delim="|", col_names=FALSE, na="")
write_delim(out$`00003`, "inst/extdata/ri2018_2020Style.pl/ri000032018_2020Style.pl",
            delim="|", col_names=FALSE, na="")
write_delim(out$geo, "inst/extdata/ri2018_2020Style.pl/rigeo2018_2020Style.pl",
            delim="|", col_names=FALSE, na="")

# Legacy PL formats
url_sas_2000 = "https://www2.census.gov/census_2000/datasets/redistricting_file--pl_94-171/0File_Structure/SAS/pl_geohd.sas"
url_sas_2010 = "https://www2.census.gov/census_2010/01-Redistricting_File--PL_94-171/pl_geohd_2010.sas"

proc_spec = function(x) {
    spec = stringr::str_match(x, "\\@(\\d+) ([A-Z0-9]+) \\$(\\d+)\\.")[, -1] %>%
        as.data.frame() %>%
        `names<-`(c("begin", "col_names", "size")) %>%
        as_tibble() %>%
        filter(!is.na(begin)) %>%
        mutate(begin = as.integer(begin) - 1L,
               size = as.integer(size),
               end = begin + size) %>%
        select(begin, end, col_names)
    spec$end[nrow(spec)] = NA
    spec
}

sas_2000 = read_lines(url_sas_2000)
sas_2010 = read_lines(url_sas_2010)

fwf_2000 = proc_spec(sas_2000)
fwf_2010 = proc_spec(sas_2010)

usethis::use_data(fwf_2000, fwf_2010, internal=TRUE, overwrite=TRUE, version=3)
