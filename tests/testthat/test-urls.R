skip_on_cran()

test_that("PL URLs are generated correctly", {
    wa10_url = "https://www2.census.gov/census_2010/01-Redistricting_File--PL_94-171/Washington/wa2010.pl.zip"
    expect_equal(pl_url("WA", 2010), wa10_url)
    expect_true(httr::HEAD(pl_url("WA", 2000)[3])$all_headers[[1]]$status == 200)
    expect_true(httr::HEAD(pl_url("DC", 2010))$all_headers[[1]]$status == 200)
})
