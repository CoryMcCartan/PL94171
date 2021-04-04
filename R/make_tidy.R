################################################################################
# Put everything together
################################################################################

#' All-in-one Shapefile Function
#'
#' @param abbr The state to make the shapefile for
#' @param path The path to the PL files, as in [read_pl()]
#' @param ... passed on to [dplyr::filter()]; use to subset to a certain county,
#'   for example.
#'
#' @return an `sf` object with demographic and shapefile information for the
#'   state.
#'
#' @export
make_tidy_shp = function(abbr, path, ...) {
    blocks = get_blocks(abbr)
    pl = read_pl(path) %>%
        widen_pl() %>%
        subset_pl("750") %>%
        select_standard_pl(clean_names=TRUE) %>%
        filter(...) %>%
        select(-.data$row_id, -.data$summary_level, -.data$county)
    full_join(pl, blocks, by=c("GEOID", "state")) %>%
        relocate(.data$county, .after=.data$state) %>%
        sf::st_as_sf()
}
