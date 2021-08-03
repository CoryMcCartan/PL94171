

#' Subset to a Summary Level
#'
#' This subsets a pl table to a desired summary level. Typical choices include:
#' * '750': block
#' * '150': block group
#' * '630': voting district
#' * '050': county
#'
#' All summary levels are listed in [pl_geog_levels].
#'
#' @param pl A list of PL tables, as read in by [pl_read()]
#' @param sumlev the summary level to filter to. A 3 character SUMLEV code. Default is '750' for blocks.
#'
#' @return tibble
#'
#' @concept basic
#' @export
#'
#' @importFrom dplyr filter
#' @examples
#' pl_ex_path <- system.file('extdata/ri2018_2020Style.pl', package = 'PL94171')
#' pl <- pl_read(pl_ex_path)
#' pl <- pl_subset(pl)
pl_subset <- function(pl, sumlev = "750"){
    if (!inherits(pl, "data.frame")) {
        pl <- pl_widen(pl)
    }

    sumlev = match.arg(sumlev, pl_geog_levels$SUMLEV, several.ok=F)

    if ('summary_level' %in% names(pl)) {
        pl %>%
            filter(.data$summary_level == sumlev) %>%
            mutate(GEOID = stringr::str_sub(.data$GEOID, 10))
    } else {
        pl %>%
            filter(.data$SUMLEV == sumlev) %>%
            mutate(GEOID = stringr::str_sub(.data$GEOID, 10))
    }
}
