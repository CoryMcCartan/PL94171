################################################################################
# Block Assignment Files
################################################################################

#' Download 2020 Block Assignment Files for a State
#'
#' `r lifecycle::badge("experimental")`
#' From the Census: "The Block Assignment Files (BAFs) are among the geographic
#' products that the Census Bureau provides to states and other data users
#' containing the small area census data necessary for legislative
#' redistricting.  The BAFs contain Census tabulation block codes and geographic
#' area codes for a specific geographic entity type."
#'
#' @param abbr the state abbreviation to get the BAF for
#' @param geographies the geographies to get. Defaults to all available.
#' @param cache_to the file name, if any, to cache the results to (as an RDS).
#'   If a file exists and `refresh=FALSE`, will read BAF from this file.
#' @param refresh if `TRUE`, force a re-download of the BAF data.
#'
#' @return A list of [tibble]s, one for each available BAF geography.
#'
#' @examples
#' pl_get_baf("RI")
#' pl_get_baf("RI", "VTD")
#'
#' @export
pl_get_baf = function(abbr, geographies=NULL, cache_to=NULL, refresh=FALSE) {
    if (!is.null(cache_to) && file.exists(cache_to) && !refresh) {
        return(readRDS(cache_to))
    }

    fips = tigris::fips_codes$state_code[match(abbr, tigris::fips_codes$state)]
    stopifnot(!is.na(fips))
    base_name = str_glue("BlockAssign_ST{fips}_{abbr}")

    zip_url = str_glue("https://www2.census.gov/geo/docs/maps-data/data/baf2020/{base_name}.zip")
    zip_path = withr::local_tempfile(file="baf")
    zip_dir = dirname(zip_path)
    utils::download.file(zip_url, zip_path)

    files = utils::unzip(zip_path, list=T)$Name
    utils::unzip(zip_path, exdir=zip_dir)
    out = list()
    for (fname in files) {
        geogr = str_match(fname, paste0(base_name, "_([A-Z_]+)\\.txt"))[,2]
        if (!is.null(geographies) && !(geogr %in% geographies)) next
        table = readr::read_delim(file.path(zip_dir, fname), delim="|",
                                  col_types=readr::cols(.default="c"))
        # check final column is not all NA
        if (!all(is.na(table[[ncol(table)]]))) {
            out[[geogr]] = table
        }
    }

    if (!is.null(cache_to)) {
        saveRDS(out, file=cache_to, compress="gzip")
    }

    out
}
