download_census <- function(url, path) {
    httr::GET(url = url, httr::write_disk(path))
}
