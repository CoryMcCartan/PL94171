
<!-- README.md is generated from README.Rmd. Please edit that file -->

# **PL94171**: Tabulate P.L. 94-171 Redistricting Data Summary Files

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
[![R-CMD-check](https://github.com/CoryMcCartan/PL94171/workflows/R-CMD-check/badge.svg)](https://github.com/CoryMcCartan/PL94171/actions)

[![CRAN
status](https://www.r-pkg.org/badges/version/PL94171)](https://CRAN.R-project.org/package=PL94171)
<!-- badges: end -->

<img align="right" height="240" src="man/figures/logo.png" />

The **PL94171** package contains tools to process legacy format summary
redistricting data files produced by the United States Census Bureau
pursuant to P.L. 94-171. These files are generally available earlier but
are difficult to work with as-is.

## Installation

Install the latest version from CRAN with:

``` r
install.packages("PL94171")
```

You can also install the development version from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("CoryMcCartan/PL94171")
```

## Basic Usage

Just need block- or precicnt-level data for total and voting-age
population by race? Then `pl_tidy_shp()` is all you need.

``` r
library(PL94171)
# put the path to the PL 94-171 files here, or use `pl_url()` to download them
pl_path = system.file("extdata/ri2018_2020Style.pl", package="PL94171")
pl_tidy_shp("RI", pl_path)
#> Simple feature collection with 2 features and 5 fields
#> Geometry type: MULTIPOLYGON
#> Dimension:     XY
#> Bounding box:  xmin: -71.71127 ymin: 41.33654 xmax: -71.4672 ymax: 41.39571
#> Geodetic CRS:  NAD83
#>             GEOID state            county area_land area_water
#> 1 440090515033040    RI Washington County     38410          0
#> 2 440090511013077    RI Washington County     19661          0
#>                         geometry
#> 1 MULTIPOLYGON (((-71.47043 4...
#> 2 MULTIPOLYGON (((-71.71127 4...
#> Simple feature collection with 569 features and 24 fields (with 86 geometries empty)
#> Geometry type: MULTIPOLYGON
#> Dimension:     XY
#> Bounding box:  xmin: -71.42641 ymin: 41.77238 xmax: -71.36969 ymax: 41.82
#> Geodetic CRS:  NAD83
#> # A tibble: 569 x 25
#>    GEOID      state county     vtd     pop pop_hisp pop_white pop_black pop_aian
#>    <chr>      <chr> <chr>      <chr> <int>    <int>     <int>     <int>    <int>
#>  1 440070001… RI    Providenc… 4428…     0        0         0         0        0
#>  2 440070001… RI    Providenc… 4428…     0        0         0         0        0
#>  3 440070001… RI    Providenc… 4428…     0        0         0         0        0
#>  4 440070001… RI    Providenc… 4428…    50        0        50         0        0
#>  5 440070001… RI    Providenc… 4428…     0        0         0         0        0
#>  6 440070001… RI    Providenc… 4428…     0        0         0         0        0
#>  7 440070001… RI    Providenc… 4428…    18       18         0         0        0
#>  8 440070001… RI    Providenc… 4428…     0        0         0         0        0
#>  9 440070001… RI    Providenc… 4428…    86       86         0         0        0
#> 10 440070001… RI    Providenc… 4428…    19        0         0        19        0
#> # … with 559 more rows, and 16 more variables: pop_asian <int>, pop_nhpi <int>,
#> #   pop_other <int>, pop_two <int>, vap <int>, vap_hisp <int>, vap_white <int>,
#> #   vap_black <int>, vap_aian <int>, vap_asian <int>, vap_nhpi <int>,
#> #   vap_other <int>, vap_two <int>, area_land <dbl>, area_water <dbl>,
#> #   geometry <MULTIPOLYGON [°]>
```

To tabulate at different geographies, or to extract other variables,
check out the [Getting Started
page](https://corymccartan.github.io/PL94171/articles/PL94171.html).
