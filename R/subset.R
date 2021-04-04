

#' Subset ot a Summary Level
#' 
#' This subsets a pl table to a desired summary level. Typical choices include:
#' * '750': block
#' * '740': block group
#' * '630': voting district
#' * '050': county
#' 
#' All summary levels are listed in \code{\link{sumlev}}.
#'
#'
#'
#' @param pl A list of PL tables, as read in by \code{\link{read_pl}}
#' @param sumlev the summary level to filter to. A 3 character SUMLEV code. Default is '750' for blocks.
#'
#' @return tibble
#' @export
#'
#' @importFrom dplyr filter
#' @md 
subset_pl <- function(pl, sumlev = '750'){
  if(is.list(pl)){
    pl <- widen_pl(pl)
  }
  
  if('summary_level' %in% names(pl)){
    pl %>% filter(.data$summary_level == sumlev)
  } else {
    pl %>% filter(.data$SUMLEV == sumlev)
  }
  
}