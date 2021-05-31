################################################################################
# Put everything together
################################################################################

#' All-in-one Shapefile Function
#'
#' Downloads block geography and merges with the cleaned PL 94-171 file.
#'
#' @param abbr The state to make the shapefile for
#' @param path The path to the PL files, as in [pl_read()]
#' @param year The year to download the block geography for. Should match the
#'   year of the PL files.
#' @param ... passed on to [dplyr::filter()]; use to subset to a certain county,
#'   for example.
#'
#' @return an `sf` object with demographic and shapefile information for the
#'   state.
#'
#' @examples
#' \donttest{
#' pl_ex_path <- system.file('extdata/ri2018_2020Style.pl', package = 'PL94171')
#' pl_tidy_shp("RI", pl_ex_path)
#' }
#'
#' @export
pl_tidy_shp = function(abbr, path, year=2020, ...) {
    blocks = tigris::blocks(abbr, year=year) %>%
        select(GEOID=starts_with("GEOID"),
               state_code=.data$STATEFP,
               county_code=.data$COUNTYFP,
               area_land=starts_with("ALAND"),
               area_water=starts_with("AWATER"),
               .data$geometry) %>%
       left_join(tigris::fips_codes, by=c("state_code", "county_code")) %>%
       select(.data$GEOID, .data$state, .data$county,
              .data$area_land, .data$area_water, .data$geometry)
    pl = read_pl(path) %>%
        pl_widen() %>%
        pl_subset("750") %>%
        pl_select_standard(clean_names=TRUE) %>%
        filter(...) %>%
        select(-.data$row_id, -.data$summary_level, -.data$county)
    left_join(pl, blocks, by=c("GEOID", "state")) %>%
        relocate(.data$county, .after=.data$state) %>%
        sf::st_as_sf()
}
