## Resubmission
This is a resubmission. In this version we have:

* Replaced `download.file()` with calls to `httr::GET()` to avoid new
  libcurl and SSL errors on Windows.

## Test environments
* local R installation, R 4.1.0
* macOS-latest (on gh-actions), R 4.1.0
* windows-latest (on gh-actions), R 4.1.0
* ubuntu 20.04 (on gh-actions), R 4.1.0
* ubuntu 20.04 (on gh-actions) (devel)
* win-builder, R 4.1.0
* Windows server (on rhub), R 4.1.0

## R CMD check results

0 errors | 0 warnings | 1 note

* This is a new release.
* Examples are \donttest in `pl_get_prototype()`, `pl_tidy_shp()`, and
`pl_retally()` because they require moderately large files to be downloaded from
the Internet, taking more than 5-10 seconds on average. These functions are
tested in a local test and/or in vignettes instead.
