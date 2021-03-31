################################################################################
# Block Shapefile Data
################################################################################

#' Download TIGER shapefiles for 2020 Census Blocks
#'
#' `r lifecycle::badge("experimental")`
#' 2020 analog to [tigris::blocks()], until it is updated. Requires `sf` to be
#' installed.
#'
#' @param abbr the state abbreviation to get the BAF for
#' @param cache_to the file name, if any, to cache the results to (as an RDS).
#'   If a file exists and `refresh=FALSE`, will read BAF from this file.
#' @param refresh if `TRUE`, force a re-download of the BAF data.
#'
#' @return An `sf` [tibble] containing the blocks.
#'
#' @examples
#' \dontrun{
#' get_blocks("RI")
#' }
#'
#' @export
get_blocks = function(abbr, cache_to=NULL, refresh=FALSE) {
    if (!requireNamespace("sf", quietly=TRUE))
        stop("Must install `sf` package to use `get_blocks()`.")

    if (!is.null(cache_to) && file.exists(cache_to) && !refresh) {
        return(readRDS(cache_to))
    }

    fips = abbr_to_fips[abbr]
    stopifnot(!is.na(fips))
    base_name = str_glue("tl_2020_{fips}_tabblock20")

    zip_url = str_glue("https://www2.census.gov/geo/tiger/TIGER2020/TABBLOCK20/{base_name}.zip")
    zip_path = withr::local_tempfile(file="baf")
    zip_dir = dirname(zip_path)
    utils::download.file(zip_url, zip_path)

    files = utils::unzip(zip_path, list=T)$Name
    utils::unzip(zip_path, exdir=zip_dir)

    shp = sf::read_sf(file.path(zip_dir, paste0(base_name, ".shp")))
    if (!is.null(cache_to)) {
        saveRDS(shp, file=cache_to, compress="gzip")
    }

    shp
}
