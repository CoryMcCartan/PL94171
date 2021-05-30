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
#' @export
#'
#' @examples
#' pl <- pl_read(system.file('extdata/ri2018_2020Style.pl', package = 'PL94171'))
pl_read = function(path, ...) {
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
        row1 = suppressMessages(readr::read_delim(file, delim="|", col_names=F, n_max=1))
        file_type = names(which(ncol(row1) == nchar(pl_spec)))

        out[[file_type]] = readr::read_delim(file, delim="|", col_names=pl_headers[[file_type]],
                                             col_types=pl_spec[[file_type]], ...)
    }

    out
}


#' @rdname pl_read
#' @export
read_pl = pl_read
