# PL94171 0.3.0
* Adds a `type` option to `pl_tidy_shp()`, allowing for tidy block or VTD shapefiles.
* Adds a `pl_get_vtd()` function to download 2020 VTD boundaries from the Census.
* Fixes an issue where `pl_crosswalk` dropped leading 0s in `GEOID_to`.
* Cleans up partial match warnings.

# PL94171 0.2.0

* Initial CRAN release.
* Avoid new libcurl and SSL errors on Windows.

# PL94171 0.1.0

* Initial release.
* Functionality to download, read, subset, and tidy P.L. 94-171 files.
* Ability to read files from 2000 and 2010, and retally according to updated
  Census geographies.
