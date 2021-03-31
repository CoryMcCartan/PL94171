# FIPS codes ------
fips = dplyr::select(tigris::fips_codes, abbr=state, fips=state_code, state=state_name) %>%
    dplyr::distinct()
abbr_to_fips = fips$fips
state_to_fips = fips$fips
names(abbr_to_fips) = fips$abbr
names(state_to_fips) = fips$state
fips_to_state = fips$state
names(fips_to_state) = fips$fips

usethis::use_data(abbr_to_fips, state_to_fips, fips_to_state,
                  internal=TRUE, overwrite=TRUE, version=3)
