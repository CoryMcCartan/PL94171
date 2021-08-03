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
#' pl_ex_path <- system.file("extdata/ri2018_2020Style.pl", package = "PL94171")
#' pl_tidy_shp("RI", pl_ex_path)
#' }
#'
#' @concept basic
#' @export
pl_tidy_shp = function(abbr, path, year=2020, type=c("blocks", "vtds"), ...) {
    type = match.arg(type)
    if (type == "blocks") {
        units = tigris::blocks(abbr, year=year, progress_bar=interactive())
    } else if (type == "vtds") {
        if (year == 2020) {
            units = pl_get_vtd(abbr)
        } else if (year == 2010L) {
            units = tigris::voting_districts(abbr, progress_bar=interactive())
        } else {
            stop("VTDs not supported for years prior to 2010")
        }
    }

    sumlev = if (type == "blocks") "750" else if (type == "vtds") "700"

    units = units %>%
        select(GEOID=starts_with("GEOID")[1],
               state_code=starts_with("STATEFP")[1],
               county_code=starts_with("COUNTYFP")[1],
               area_land=starts_with("ALAND"),
               area_water=starts_with("AWATER"),
               .data$geometry) %>%
       left_join(tigris::fips_codes, by=c("state_code", "county_code")) %>%
       select(.data$GEOID, .data$state, .data$county,
              .data$area_land, .data$area_water, .data$geometry)
    print(head(units, 2))
    pl = read_pl(path) %>%
        pl_widen() %>%
        pl_subset(sumlev) %>%
        pl_select_standard(clean_names=TRUE) %>%
        filter(...) %>%
        select(-.data$row_id, -.data$summary_level, -.data$county)
    left_join(pl, units, by=c("GEOID", "state")) %>%
        relocate(.data$county, .after=.data$state) %>%
        sf::st_as_sf()
}
