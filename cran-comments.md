## Test environments
* local R installation, R 4.1.0
* macOS-latest (on gh-actions), R 4.1.0
* windows-latest (on gh-actions), R 4.1.0
* ubuntu 20.04 (on gh-actions), R 4.1.0
* ubuntu 20.04 (on gh-actions) (devel)
* win-builder (devel)

## R CMD check results

0 errors | 0 warnings | 1 note

* This is a new release.
* Examples are \dontrun in `pl_get_prototype()` and `pl_tidy_shp()` because they
require moderately large files to be downloaded from the Internet, unzipped in a
temp directory, and parsed. These functions are tested in a local test instead.
