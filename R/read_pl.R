################################################################################
# PL Files
################################################################################


#' Read a PL File
#'
#' `r lifecycle::badge("experimental")`
#' PL files come in one of four types and are pipe-delimited with no header row.
#' This function speedily reads in the file and assigns the appropriate column names.
#'
#' @param file path to a local file.
#' @param file_type the PL file type. One of `c("00001", "00002", "00003", "geo")`.
#'   If not provided, will try to be determined from the file name.
#' @param ... passed on to [vroom::vroom()]
#'
#' @return a [tibble] containing the PL file data.
#'
#' @export
read_pl = function(file, file_type=NULL, ...) {
    if (is.null(file_type)) {
        file_type = str_match(basename(file), "\\w\\w(\\d\\d\\d\\d\\d|geo).+\\.pl")[, 2]
    }
    file_type = match.arg(file_type, c("00001", "00002", "00003", "geo"), several.ok=FALSE)

    vroom::vroom(file, delim="|", col_names=pl_headers[[file_type]],
                 col_types=pl_spec[[file_type]], ...)
}
