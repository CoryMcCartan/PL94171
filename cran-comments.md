## Test environments
* local R installation, R 4.1.0
* macOS-latest (on gh-actions), R 4.1.0
* windows-latest (on gh-actions), R 4.1.0
* ubuntu 20.04 (on gh-actions), R 4.1.0
* ubuntu 20.04 (on gh-actions) (devel)
* Debian Linux (on rhub) (R-patched)
* Solaris (on rhub) (R-patched)

## R CMD check results

0 errors | 0 warnings | 0 notes

* Examples are \donttest in `pl_get_prototype()`, `pl_tidy_shp()`,
`pl_get_vtd()`, and `pl_retally()` because they require
moderately large files to be downloaded from the Internet, taking more than 5-10
seconds on average. These functions are tested in a local test and/or in
vignettes instead. Examples are \dontrun in `pl_crosswalk()` because of driver
problems on some Solaris systems.
