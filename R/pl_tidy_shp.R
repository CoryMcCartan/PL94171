################################################################################
# Put everything together
################################################################################

#' All-in-one Shapefile Function
#'
#' @param abbr The state to make the shapefile for
#' @param path The path to the PL files, as in [pl_read()]
#' @param ... passed on to [dplyr::filter()]; use to subset to a certain county,
#'   for example.
#'
#' @return an `sf` object with demographic and shapefile information for the
#'   state.
#'
#' @export
pl_tidy_shp = function(abbr, path, ...) {
    blocks = tigris::blocks(abbr)
    pl = read_pl(path) %>%
        pl_widen()# %>%
        #pl_subset("750") %>%
        #pl_select_standard(clean_names=TRUE) %>%
        #filter(...) %>%
        #select(-.data$row_id, -.data$summary_level, -.data$county)
    print(names(pl))
    print(pl)
    #full_join(pl, blocks, by=c("GEOID", "state")) %>%
    #    relocate(.data$county, .after=.data$state) %>%
    #    sf::st_as_sf()
}
