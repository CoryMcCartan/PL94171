test_that("full pl_tidy_shp workflow runs", {
    skip_on_cran()
    pl_ex_path <- system.file('extdata/ri2018_2020Style.pl', package = 'PL94171')
    res = pl_tidy_shp("RI", pl_ex_path)
    expect_equal(nrow(res), 569L)
    expect_equal(sum(is.na(res$pop)), 0L)
})

test_that("prototype shapefiles download", {
    skip_on_cran()
    res = pl_get_prototype("tract", 2020)
    expect_equal(nrow(res), 141L)
    expect_equal(sum(is.na(res$ALAND20)), 0L)
})
