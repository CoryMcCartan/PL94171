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
