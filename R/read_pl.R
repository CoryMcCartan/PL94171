################################################################################
# PL Files
################################################################################


#' Read a set of PL Files
#'
#' `r lifecycle::badge("experimental")`
#' PL files come in one of four types and are pipe-delimited with no header row.
#' This function speedily reads in the files and assigns the appropriate column
#' names and types.
#'
#' @param path a path to a folder containing PL files. Can also be path or a URL
#'   for a ZIP file, which will be downloaded and unzipped.
#' @param ... passed on to [vroom::vroom()]
#'
#' @return A list of [dtplyr::lazy_dt] tables containing the four PL files.
#'
#' @export
read_pl = function(path, ...) {
    if (stringr::str_detect(path, "^(http://|https://|ftp://|ftps://)")) {
        zip_path = withr::local_tempfile(file="pl", fileext=".zip")
        utils::download.file(path, zip_path)
        zip_dir = file.path(dirname(zip_path), "PL-unzip")
        utils::unzip(path, exdir=zip_dir)
        path = zip_dir
    } else if (!dir.exists(path)) { # compressed file
        zip_dir = withr::local_tempdir()
        utils::unzip(path, exdir=zip_dir)
        path = zip_dir
    }

    files = list.files(path, pattern="\\.pl$", ignore.case=TRUE)
    out = list()
    for (fname in files) {
        file = file.path(path, fname)
        row1 = suppressMessages(vroom(file, delim="|", col_names=F, n_max=1))
        file_type = names(which(ncol(row1) == nchar(pl_spec)))

        out[[file_type]] = vroom(file, delim="|", col_names=pl_headers[[file_type]],
                                 col_types=pl_spec[[file_type]], ...) %>%
            lazy_dt(key_by=LOGRECNO)
    }

    out
}
