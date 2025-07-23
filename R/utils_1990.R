census_disk <- function(st) {
    if (length(st) != 1) {
        cli::cli_abort('{.arg st} must be a single state abbreviation.')
    }
    if (st == 'AL') {
        st <- 'Al'
    }

    links <- c(
        'CD1 - NJ VT VA',
        'CD2 - AR IN LA MS SD WY',
        'CD3 - HI MO MT NV TX',
        'CD4 - Al DE IL NE OK OR',
        'CD5 - CT DC MD NC OH RI',
        'CD6 - IA KS MN PA',
        'CD7 - CA NY',
        'CD8 - AZ GA MI NH ND WI',
        'CD9 - FL KY MA NM TN UT',
        'CD10 - AK CO ID ME SC WA WV'
    )

    out <- links[grepl(st, links)]

    if (length(out) != 1) {
        cli::cli_abort('{.arg st} abbreviation not matched.')
    }

    out <- out |>
        stringr::str_replace_all(' ', '%20')

    out
}
