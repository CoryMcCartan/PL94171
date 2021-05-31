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
#' pl_ex_path <- system.file('extdata/ri2018_2020Style.pl', package = 'PL94171')
#' pl <- pl_read(pl_ex_path)
#' # or try `pl_read(pl_url("RI", 2010))`
#'
#' @export
pl_read = function(path, ...) {
    if (length(path) > 1) {
        if (all(stringr::str_detect(path, "^(http://|https://|ftp://|ftps://)"))) {
            zip_dir = withr::local_tempdir(pattern="pl")
            for (p in path) {
                zip_path = withr::local_tempfile(pattern="pl", fileext=".zip")
                utils::download.file(p, zip_path)
                utils::unzip(zip_path, exdir=zip_dir)
            }
            path = zip_dir
        } else {
            stop("Provide a single path to the directory containing the PL files.")
        }
    } else if (stringr::str_detect(path, "^(http://|https://|ftp://|ftps://)")) {
        zip_path = withr::local_tempfile(pattern="pl", fileext=".zip")
        utils::download.file(path, zip_path)
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
                                                 ...)
        } else { # Legacy geo file
            spec = readr::fwf_widths(pl_size_legacy, col_names=pl_headers_legacy$geo)
            out$geo = readr::read_fwf(file, spec, col_types=pl_spec_legacy)
        }
    }

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
        warning("2020 P.L. 94-171 files have not been released yet.\n",
             "Download Rhode Island prototype data at\n",
             "<https://www2.census.gov/programs-surveys/decennial/rdo/datasets/2018/ri2018_2020Style.pl.zip>")
        url = str_glue("https://www2.census.gov/programs-surveys/decennial/2020/data/",
                       "01-Redistricting_File--PL_94-171/{name}/{tolower(abbr)}2020.pl.zip")
    }
    as.character(url)
}
