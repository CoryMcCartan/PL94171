## Test environments
* local R installation, MacOS, R 4.2.0
* windows-latest (on gh-actions), R 4.2.0
* ubuntu 20.04 (on gh-actions), R 4.2.0
* ubuntu 20.04 (on gh-actions) (devel)

## R CMD check results

0 errors | 0 warnings | 0 notes

* This version adds graceful error handling for internet resources, and in doing
so addresses errors in the CRAN checks.

* Examples are \donttest in manyfunctions because they require
moderately large files to be downloaded from the Internet, taking more than 5-10
seconds on average, or because CRAN Windows machines are slow to read in the
example data. All of these functions are tested in a local test and/or in
vignettes instead. Examples are \dontrun in `pl_crosswalk()` because of driver
problems on some Solaris systems.

