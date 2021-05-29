#' Select the Standard Redistricting Columns
#'
#' Selects the standard set of basic population groups and vap groups. Optionally
#' renames them from the PXXXYYYY naming convention (where XXX is the table and
#' YYYY is the variable) to more human readable names. pop_* is the total population,
#' from tables 1 and 2, while vap_* is the 18+ population (voting age population).
#'
#' If clean names, then the variables extracted are as follows:
#'
#' * `\*_hisp`: Hispanic or Latino (of any race)
#' * `\*_white`: White alone, not Hispanic or Latino
#' * `\*_black`: Black or African American alone, not Hispanic or Latino
#' * `\*_aian`: American Indian and Alaska Native alone, not Hispanic or Latino
#' * `\*_asian`: Asian alone, not Hispanic or Latino
#' * `\*_nhpi`: Native Hawaiian and Other Pacific Islander alone, not Hispanic or Latino
#' * `\*_other`: Some Other Race alone, not Hispanic or Latino
#' * `\*_two`: Population of two or more races, not Hispanic or Latino
#'
#' where \* is `pop` or `vap`.
#'
#' @param pl A list of PL tables, as read in by [read_pl()]
#' @param clean_names whether to clean names
#'
#' @return tibble
#' @export
#'
#' @importFrom dplyr rename select .data as_tibble %>%
#' @examples 
#' pl <- read_pl(system.file('extdata/ri2018_2020Style.pl', package = 'PL94171'))
#' pl <- select_standard_pl(pl)
select_standard_pl <- function(pl, clean_names = TRUE){
  if (!inherits(pl, 'data.frame')) {
    pl <- widen_pl(pl)
  }
  #pl <- dtplyr::lazy_dt(pl)

  pl <- pl %>% select(.data$GEOID,
                      .data$STUSAB,
                      .data$COUNTY,
                      .data$LOGRECNO,
                      .data$SUMLEV,
                      .data$VTD,
                      .data$P0010001, # total pop
                      .data$P0020002, # total hisp
                      .data$P0020005, # total white & not hisp
                      .data$P0020006, # total black & not hisp
                      .data$P0020007, # total aian & not hisp
                      .data$P0020008, # total asian & not hisp
                      .data$P0020009, # total nhpi & not hisp
                      .data$P0020010, # total other & not hisp
                      .data$P0020011, # total two plus & not hisp
                      .data$P0030001, # vap
                      .data$P0040002, # vap hisp
                      .data$P0040005, # vap white & not hisp
                      .data$P0040006, # vap black & not hisp
                      .data$P0040007, # vap aian & not hisp
                      .data$P0040008, # vap asian & not hisp
                      .data$P0040009, # vap nhpi & not hisp
                      .data$P0040010, # vap other & not hisp
                      .data$P0040011 # vap two plus & not hisp
  )

  if (clean_names) {
    pl <- pl %>% rename(
      state = .data$STUSAB,
      county = .data$COUNTY,
      vtd = .data$VTD,
      row_id = .data$LOGRECNO,
      summary_level = .data$SUMLEV,
      pop       = .data$P0010001,
      pop_hisp  = .data$P0020002,
      pop_white = .data$P0020005,
      pop_black = .data$P0020006,
      pop_aian  = .data$P0020007,
      pop_asian = .data$P0020008,
      pop_nhpi  = .data$P0020009,
      pop_other = .data$P0020010,
      pop_two   = .data$P0020011,
      vap       = .data$P0030001,
      vap_hisp  = .data$P0040002,
      vap_white = .data$P0040005,
      vap_black = .data$P0040006,
      vap_aian  = .data$P0040007,
      vap_asian = .data$P0040008,
      vap_nhpi  = .data$P0040009,
      vap_other = .data$P0040010,
      vap_two   = .data$P0040011
    )
  }

  return(pl)

}



#' Turn list into a tibble
#'
#' @param pl input from \code{read_pl}
#'
#' @return tibble
#'
#' @importFrom purrr reduce
#' @importFrom dplyr left_join
#' @noRd
widen_pl <- function(pl) {
    reduce(.x = pl, .f = left_join, by = c('FILEID', 'STUSAB', 'CHARITER', 'LOGRECNO'))
}
