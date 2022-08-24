#' Download TIGER Prototype shapefiles
#'
#' `r lifecycle::badge("experimental")`
#' These prototype shapefiles correspond to the Rhode Island end-to-end Census
#' test and the accompanying prototype P.L. 94-171 data. This function is
#' unlikely to be useful for working with any actual decennial Census data.
#' The corresponding `tinytiger` or `tigris` functions should be used instead.
#'
#' Current acceptable arguments to geog include:
#' - `block`: block
#' - `block_group`: block group
#' - `tract`: tract
#' - `county`: county
#' - `state`: state
#' - `sld_low`: state legislative district lower house
#' - `sld_up`: state legislative district upper house
#' - `congressional_district`: federal congressional district
#' - `place`: Census place
#' - `voting_district`: voting tabulation district
#'
#' @param geog Geography to download data for. See details for full list.
#' @param year year, either 2010 or 2020
#' @param full_state whether to return the full state (TRUE) or the single county subset (FALSE)
#' @param cache_to the file name, if any, to cache the results to (as an RDS).
#'   If a file exists and `refresh=FALSE`, will read from this file.
#' @param clean_names whether to clean and rename columns
#' @param refresh if `TRUE`, force a re-download of the data.
#'
#' @return An `sf` object containing the blocks.
#'
#' @examples
#' \donttest{
#' shp <- pl_get_prototype("block")
#' }
#'
#' @concept advanced
#' @export
pl_get_prototype = function(geog, year = 2020, full_state = TRUE, cache_to=NULL,
                            clean_names=TRUE, refresh=FALSE) {
    if (!is.null(cache_to) && file.exists(cache_to) && !refresh) {
        return(readRDS(cache_to))
    }

    match.arg(geog, choices = names(geog_to_folder))
    stopifnot(year %in% year_folder[[geog]] | is.null(year_folder[[geog]]))

    if(geog %in% c('congressional_district', 'sld_up', 'sld_low', 'state') & !full_state){
        full_state <- TRUE
    }

    off_geog <- geog_to_folder[geog]
    off_geog_l <- stringr::str_to_lower(off_geog)
    full_state <- ifelse(full_state, '44', '44007')
    year_stem <- year - 2000

    path_name = str_glue("{off_geog}/{year}/tl_2018_{full_state}_{off_geog_l}{year_stem}")
    base_name = str_glue('tl_2018_{full_state}_{off_geog_l}{year_stem}')

    zip_url = str_glue("https://www2.census.gov/geo/tiger/TIGER2018PLtest/{path_name}.zip")
    zip_path = withr::local_tempfile(file="baf")
    zip_dir = dirname(zip_path)
    success = download_census(zip_url, zip_path)
    if (!success) {
        message("Download did not succeed. Try again.")
        return(NULL)
    }

    files = utils::unzip(zip_path, list=TRUE)$Name
    utils::unzip(zip_path, exdir=zip_dir)

    shp = sf::read_sf(file.path(zip_dir, paste0(base_name, ".shp")))
    if (!is.null(cache_to)) {
        saveRDS(shp, file=cache_to, compress="gzip")
    }

    withr::deferred_clear()
    shp
}

# folder names
geog_to_folder <- c(block_group = 'BG',
                    congressional_district = 'CD',
                    county = 'COUNTY',
                    place = 'PLACE',
                    sld_low = 'SLDL',
                    sld_up = 'SLDU',
                    state = 'STATE',
                    block = 'TABBLOCK',
                    tract = 'TRACT',
                    voting_district = 'VTD')

year_folder <- list(block_group = c(2010, 2020),
                    congressional_district = c(2010, 2020),
                    county = c(2010, 2020),
                    place = c(2010, 2020),
                    sld_low = c(2010, 2020),
                    sld_up = c(2010, 2020),
                    state = c(2010, 2020),
                    block = c(2010, 2020),
                    tract = c(2010, 2020),
                    voting_district = c(2020))
