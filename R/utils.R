download_census <- function(url, path) {
    tryCatch({
        res = httr::GET(url = url, httr::write_disk(path))
        res$status_code == 200L
    }, error = function(e) {
        cat("Error:", e$message, "\n")
        FALSE
    })
}
