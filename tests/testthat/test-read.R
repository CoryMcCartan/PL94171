test_that("pl_read works", {
  
  actual <- pl_read(system.file('extdata/ri2018_2020Style.pl', package = 'PL94171'))
  
  expect_equal(pl_ex, actual)
})
