#' Download Block Crosswalk Files
#'
#' Downloads crosswalks from <https://www.census.gov/geographies/reference-files/time-series/geo/relationship-files.html>.
#' Adjusts land overlap area to ensure weights sum to 1.
#'
#' @param abbr the state to download the crosswalk for.
#' @param from_year the year with the blocks that the data is currently tabulated with respect to.
#' @param to_year the year with the blocks that the data should be tabulated into.
#'
#' @return A tibble, with two sets of GEOIDs and overlap information.
#'
#' @examples
#' \dontrun{
#' # Takes a bit of time to run
#' pl_crosswalk("RI", 2010, 2020)
#' }
#'
#' @concept advanced
#' @export
pl_crosswalk = function(abbr, from_year=2010L, to_year=from_year + 10L) {
    fips = tigris::fips_codes$state_code[match(abbr, tigris::fips_codes$state)]
    if (isTRUE(all.equal(to_year, from_year)) ||
            abs(to_year - from_year) > 10+1e-6) {
        stop("`to` and `from` years must be a decade apart.")
    }

    yr_1 = as.character(min(from_year, to_year))
    yr_2 = as.character(max(from_year, to_year))
    if (yr_1 == "2000") {
        url = str_glue("https://www2.census.gov/geo/docs/maps-data/data/rel/",
                       "t{str_sub(yr_1, 3, 4)}t{str_sub(yr_2, 3, 4)}/",
                       "TAB{yr_1}_TAB{yr_2}_ST_{fips}_v2.zip")
    } else if (yr_1 == "2010") {
        url = str_glue("https://www2.census.gov/geo/docs/maps-data/data/rel2020/",
                       "t{str_sub(yr_1, 3, 4)}t{str_sub(yr_2, 3, 4)}/",
                       "TAB{yr_1}_TAB{yr_2}_ST{fips}.zip")
    }

    zip_path = withr::local_tempfile(fileext = "baf")
    download_census(url = url, path = zip_path)
    withr::deferred_clear()
    if (yr_2 == "2010") {
        cw_d = readr::read_delim(zip_path, skip = 0, delim = ",", col_types = "cccclddccccdlddcdc")
        names(cw_d)[length(cw_d)] = "AREAWATER_INT"
        cw_d$AREAWATER_INT =  as.integer(stringr::str_replace_all(cw_d$AREAWATER_INT, "[^0-9]", ""))
    } else {
        cw_d = readr::read_delim(zip_path, delim = "|", col_types = "cccclddccccdlddcdd",
                             progress = interactive())
    }
    cw_d %>%
        rename_with(~ str_c(str_sub(., 0, -5), "fr"), ends_with(as.character(from_year))) %>%
        rename_with(~ str_c(str_sub(., 0, -5), "to"), ends_with(as.character(to_year))) %>%
        transmute(GEOID = str_c(.data$STATE_fr, .data$COUNTY_fr, .data$TRACT_fr, .data$BLK_fr),
                  GEOID_to = str_c(.data$STATE_to, .data$COUNTY_to, .data$TRACT_to, .data$BLK_to),
                  area_land = .data$AREALAND_to,
                  area_water = .data$AREAWATER_to,
                  int_land = if_else(is.na(.data$BLOCK_PART_FLAG_O), 1,
                                     coalesce(.data$AREALAND_INT / .data$AREALAND_fr,
                                              .data$AREAWATER_INT / .data$AREAWATER_fr))) %>%
        group_by(.data$GEOID) %>%
        mutate(int_land = if_else(rep(sum(.data$int_land), n()) > 0.9,
                                  .data$int_land / sum(.data$int_land), .data$int_land)) %>%
        ungroup()
}


# checks if x is constant
is_const_rel = function(x) {
    !is.numeric(x) & length(unique(x))
}

#' Approximately re-tally Census data under new block boundaries
#'
#' Applies a block crosswalk to a table of block data using areal interpolation.
#' That is, the fraction of land area in the overlapping region between old and
#' new blocks is used to divide the population of the old blocks into the new.
#'
#' All numeric columns will be re-tallied. Integer columns will be re-tallied
#' with rounding. Character columns will be preserved if constant across new
#' block geometries.
#'
#' Blocks from other states will be ignored.
#'
#' @param d_from The data frame to process. All numeric columns will be re-tallied.
#'   Integer columns will be re-tallied with rounding.
#'   Character columns will be preserved if constant across new block geometries.
#' @param crosswalk The crosswalk data frame, from [pl_crosswalk()]
#'
#' @return A new data frame, like `d_from`, except with the geometry column
#'   dropped, if one exists. New geometry should be loaded, perhaps with
#'   [tigris::blocks()].
#'
#' @examples \donttest{
#' crosswalk = pl_crosswalk("RI", 2010, 2020)
#' RI_2010 = pl_tidy_shp("RI", pl_url("RI", 2010), 2010)
#' pl_retally(RI_2010, crosswalk)
#' }
#'
#' @concept advanced
#' @export
pl_retally = function(d_from, crosswalk) {
    if (inherits(d_from, "sf")) {
        d_from = sf::st_drop_geometry(d_from)
    }
    fips = str_sub(d_from$GEOID, 1, 2)[1]

    d_from %>%
        select(-dplyr::any_of(c("area_water", "area_land"))) %>%
        full_join(crosswalk, by="GEOID") %>%
        filter(str_sub(.data$GEOID_to, 1, 2) == fips) %>%
        mutate(GEOID=.data$GEOID_to) %>%
        select(-.data$GEOID_to) %>%
        group_by(.data$GEOID) %>%
        summarize(across(where(is_const_rel), ~ .[1]),
                  area_land = .data$area_land[1],
                  area_water = .data$area_water[1],
                  across(where(is.integer), ~ as.integer(round(sum(.data$int_land * .)))),
                  across(c(where(is.double), -.data$int_land,
                           -.data$area_land, -.data$area_water),
                         ~ sum(.data$int_land * .))) %>%
        ungroup()
}
