skip_on_cran()

test_that("PL URLs are generated correctly", {
    wa10_url = "https://www2.census.gov/census_2010/01-Redistricting_File--PL_94-171/Washington/wa2010.pl.zip"
    expect_equal(pl_url("WA", 2010), wa10_url)
    expect_true(attr(curlGetHeaders(url = pl_url("WA", 2000)[3]), 'status') == 200)
    expect_true(attr(curlGetHeaders(url = pl_url("DC", 2000)[3]), 'status') == 200)
    expect_true(attr(curlGetHeaders(url = pl_url("IA", 2000)[3]), 'status') == 200)
})
