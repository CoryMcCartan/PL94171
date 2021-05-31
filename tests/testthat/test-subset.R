test_that("subsetting  works", {
  sub <- pl_subset(pl_ex)
  
  expect_true(nrow(sub) == 569)
  expect_true(ncol(sub) == 397)
  expect_s3_class(sub, 'data.frame')
})
