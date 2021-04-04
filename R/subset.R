

#' Subset ot a Summary Level
#'
#' This subsets a pl table to a desired summary level. Typical choices include:
#' * '750': block
#' * '740': block group
#' * '630': voting district
#' * '050': county
#'
#' All summary levels are listed in [pl_geog_levels].
#'
#' @param pl A list of PL tables, as read in by [read_pl()]
#' @param sumlev the summary level to filter to. A 3 character SUMLEV code. Default is '750' for blocks.
#'
#' @return tibble
#' @export
#'
#' @importFrom dplyr filter
#' @export
subset_pl <- function(pl, sumlev = "750"){
    if (!inherits(pl, "data.frame")) {
        pl <- widen_pl(pl)
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
