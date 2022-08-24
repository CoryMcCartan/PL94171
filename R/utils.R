download_census <- function(url, path) {
    tryCatch({
        res = httr::GET(url = url, httr::write_disk(path))
        res$status_code == 200L
    }, error = function(e) {
        cat("Error:", e$message, "\n")
        FALSE
    })
}

st <- data.frame(
    stringsAsFactors = FALSE,
    fips = c("01", "02", "04", "05", "06", "08", "09", "10", "11", "12",
             "13", "15", "16", "17", "18", "19", "20", "21", "22",
             "23", "24", "25", "26", "27", "28", "29", "30", "31",
             "32", "33", "34", "35", "36", "37", "38", "39", "40",
             "41", "42", "44", "45", "46", "47", "48", "49", "50",
             "51", "53", "54", "55", "56", "60", "66", "69", "72",
             "74", "78"),
    abb = c("AL", "AK", "AZ", "AR", "CA", "CO",
            "CT", "DE", "DC", "FL", "GA", "HI", "ID", "IL", "IN",
            "IA", "KS", "KY", "LA", "ME", "MD", "MA", "MI", "MN",
            "MS", "MO", "MT", "NE", "NV", "NH", "NJ", "NM", "NY",
            "NC", "ND", "OH", "OK", "OR", "PA", "RI", "SC", "SD",
            "TN", "TX", "UT", "VT", "VA", "WA", "WV", "WI", "WY",
            "AS", "GU", "MP", "PR", "UM", "VI"),
    name = c("Alabama", "Alaska", "Arizona", "Arkansas", "California", "Colorado",
             "Connecticut", "Delaware", "District of Columbia", "Florida",
             "Georgia", "Hawaii", "Idaho", "Illinois", "Indiana",
             "Iowa", "Kansas", "Kentucky", "Louisiana", "Maine", "Maryland",
             "Massachusetts", "Michigan", "Minnesota", "Mississippi",
             "Missouri", "Montana", "Nebraska", "Nevada", "New Hampshire",
             "New Jersey", "New Mexico", "New York", "North Carolina",
             "North Dakota", "Ohio", "Oklahoma", "Oregon", "Pennsylvania",
             "Rhode Island", "South Carolina", "South Dakota", "Tennessee",
             "Texas", "Utah", "Vermont", "Virginia", "Washington",
             "West Virginia", "Wisconsin", "Wyoming", "American Samoa",
             "Guam", "Northern Mariana Islands", "Puerto Rico", "U.S. Minor Outlying Islands",
             "U.S. Virgin Islands")
)


match_fips <- function(state) {
    pos <- tolower(c(st$fips, st$abb, st$name, st$ansi))
    state <- tolower(state)
    state <- vapply(state, function(x) {
        if (nchar(x) == 1) {
            x <- paste0("0", x)
        }
        x
    }, character(1))
    matched <- match(state, pos)
    if (length(matched) != length(state) || any(is.na(matched))) {
        cli::cli_abort("{.arg state} could not be matched to a state for every entry.",
                       "Please supply a correct postal abbreaviation.")
    }
    matched <- 1 + (matched - 1) %% nrow(st)
    st$fips[matched]
}


match_name <- function(state) {
    pos <- tolower(c(st$fips, st$abb, st$name, st$ansi))
    state <- tolower(state)
    state <- vapply(state, function(x) {
        if (nchar(x) == 1) {
            x <- paste0("0", x)
        }
        x
    }, character(1))
    matched <- match(state, pos)
    if (length(matched) != length(state) || any(is.na(matched))) {
        cli::cli_abort("{.arg state} could not be matched to a state for every entry.",
                       "Please supply a correct postal abbreaviation.")
    }
    matched <- 1 + (matched - 1) %% nrow(st)
    st$name[matched]
}

