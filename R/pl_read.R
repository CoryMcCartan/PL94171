################################################################################
# PL Files
################################################################################


#' Read a set of PL Files
#'
#' PL files come in one of four types and are pipe-delimited with no header row.
#' This function speedily reads in the files and assigns the appropriate column
#' names and types.
#'
#' @param path a path to a folder containing PL files. Can also be path or a URL
#'   for a ZIP file, which will be downloaded and unzipped.
#' @param ... passed on to [readr::read_delim()]
#'
#' @return A list of data frames containing the four PL files.
#'
#' @examples
#' \donttest{
#' pl_ex_path <- system.file('extdata/ri2018_2020Style.pl', package = 'PL94171')
#' pl <- pl_read(pl_ex_path)
#' }
#' # or try `pl_read(pl_url("RI", 2010))`
#'
#' @concept basic
#' @export
pl_read = function(path, ...) {
    if (length(path) > 1) {
        if (all(stringr::str_detect(path, "^(http://|https://|ftp://|ftps://)"))) {
            zip_dir = withr::local_tempdir(pattern="pl")
            for (p in path) {
                zip_path = withr::local_tempfile(pattern="pl", fileext=".zip")
                success = download_census(p, zip_path)
                if (!success) {
                    message("Download did not succeed. Try again.")
                    return(NULL)
                }
                utils::unzip(zip_path, exdir=zip_dir)
            }
            path = zip_dir
        } else {
            stop("Provide a single path to the directory containing the PL files.")
        }
    } else if (stringr::str_detect(path, "^(http://|https://|ftp://|ftps://)")) {
        zip_path = withr::local_tempfile(pattern="pl", fileext=".zip")
        success = download_census(path, zip_path)
        if (!success) {
            message("Download did not succeed. Try again.")
            return(NULL)
        }
        zip_dir = file.path(dirname(zip_path), "PL-unzip")
        utils::unzip(zip_path, exdir=zip_dir)
        path = zip_dir
    } else if (!dir.exists(path)) { # compressed file
        zip_dir = withr::local_tempdir()
        utils::unzip(path, exdir=zip_dir)
        path = zip_dir
    }

    files = list.files(path, pattern="\\.u?pl$", ignore.case=TRUE)
    if (length(files) == 0) stop("No P.L. 94-171 files found in the provided directory.")
    out = list()
    ftypes = c("00001", "00002", "00003", "geo")
    for (fname in files) {
        file = file.path(path, fname)
        delim = str_match(readr::read_lines(file, n_max=1), "\\W")[,1]
        if (delim != " ") {
            file_type = ftypes[stringr::str_detect(fname, ftypes)]
            row1 = suppressMessages(readr::read_delim(file, delim=delim, col_names=F, n_max=1))

            out[[file_type]] = readr::read_delim(file, delim=delim,
                                                 col_names=pl_headers[[file_type]][1:ncol(row1)],
                                                 col_types=str_sub(pl_spec[[file_type]], 1, ncol(row1)),
                                                 progress=interactive(), ...)
        } else { # Legacy geo file
            col_length = nchar(readr::read_lines(file, n_max=1))
            spec = if (col_length == 500) fwf_2010 else fwf_2000
            types = rep("c", nrow(spec))
            names(types) = spec$col_names
            types["LOGRECNO"] = "i"

            out$geo = readr::read_fwf(file, spec, col_types=types,
                                      progress=interactive())
            out$geo$GEOID = with(out$geo,
                                 case_when(!is.na(BLOCK) ~ str_c("7500000US", STATE, COUNTY, TRACT, BLOCK),
                                           !is.na(BLKGRP) ~ str_c("1500000US", STATE, COUNTY, TRACT, BLKGRP),
                                           !is.na(TRACT) ~ str_c("1400000US", STATE, COUNTY, TRACT),
                                           !is.na(COUNTY) ~ str_c("0500000US", STATE, COUNTY),
                                           TRUE ~ NA_character_))
        }
    }
    withr::deferred_clear()
    out
}


#' @rdname pl_read
#' @export
read_pl = pl_read


#' Get the URL for PL files for a particular state and year
#'
#' @param abbr The state to download the PL files for
#' @param year The year of PL file to download. Supported years: 2000, 2010,
#'   2020 (after release). 2000 files are in a different format.
#'   Earlier years available on tape or CD-ROM only.
#'
#' @return a character vector containing the URL to a ZIP containing the PL files.
#'
#' @examples
#' pl_url("RI", 2010)
#'
#' @concept basic
#' @export
pl_url = function(abbr, year=2010) {
    name = tigris::fips_codes$state_name[match(abbr, tigris::fips_codes$state)]
    name = stringr::str_replace_all(name, " ", "_")
    if (year == 2000) {
        url = str_glue("https://www2.census.gov/census_2000/datasets/redistricting_file--pl_94-171/",
                       "{name}/{tolower(abbr)}{c('00001', '00002', 'geo')}.upl.zip")
    } else if (year == 2010) {
        url = str_glue("https://www2.census.gov/census_2010/01-Redistricting_File--PL_94-171/",
                       "{name}/{tolower(abbr)}2010.pl.zip")
    } else if (year == 2020) {
        url = str_glue("https://www2.census.gov/programs-surveys/decennial/2020/data/",
                       "01-Redistricting_File--PL_94-171/{name}/{tolower(abbr)}2020.pl.zip")
    }
    as.character(url)
}
