#' Download 2020 Voting District Shapefiles
#'
#' `r lifecycle::badge("experimental")`
#' A (likely temporary) function to download TIGER shapefiles for 2020 voting
#' tabulation districts (VTDs).
#'
#' @param abbr Geography to download data for. See details for full list.
#' @param cache_to the file name, if any, to cache the results to (as an RDS).
#'   If a file exists and `refresh=FALSE`, will read from this file.
#' @param refresh if `TRUE`, force a re-download of the data.
#'
#' @return An `sf` object containing the VTDs.
#'
#' @examples
#' \donttest{
#' shp <- pl_get_vtd("RI")
#' }
#'
#' @concept basic
#' @export
pl_get_vtd = function(abbr, cache_to=NULL, refresh=FALSE) {
    if (!is.null(cache_to) && file.exists(cache_to) && !refresh) {
        return(readRDS(cache_to))
    }

    fips = tigris::fips_codes$state_code[match(abbr, tigris::fips_codes$state)]
    stopifnot(!is.na(fips))

    zip_url = stringr::str_glue("https://www2.census.gov/geo/tiger/TIGER2020PL/LAYER/VTD/2020/tl_2020_{fips}_vtd20.zip")
    zip_path = withr::local_tempfile(fileext = "zip")
    download_census(zip_url, zip_path)

    unz_path = file.path(dirname(zip_path), glue::glue("vtd_2020_{fips}"))

    utils::unzip(zipfile=zip_path, exdir=unz_path)

    out = sf::read_sf(file.path(unz_path, glue::glue("tl_2020_{fips}_vtd20.shp")))

    if (!is.null(cache_to)) {
        saveRDS(out, file=cache_to, compress="gzip")
    }

    withr::deferred_clear()
    out
}
