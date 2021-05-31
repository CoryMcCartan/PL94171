test_that("select standard works", {
  sub <- pl_select_standard(pl_ex)
  
  expect_true(ncol(sub) == 24)
  expect_true(nrow(sub) == 606)
  expect_true(sum(sub$pop) == 1315781)
  expect_true(length(unique(sub$vtd)) == 18)
  expect_equal(names(sub), c("GEOID", "state", "county", "row_id", "summary_level", "vtd", 
                             "pop", "pop_hisp", "pop_white", "pop_black", "pop_aian", "pop_asian", 
                             "pop_nhpi", "pop_other", "pop_two", "vap", "vap_hisp", "vap_white", 
                             "vap_black", "vap_aian", "vap_asian", "vap_nhpi", "vap_other", 
                             "vap_two"))

})


test_that("select standard works with clean names false", {
  sub <- pl_select_standard(pl_ex, clean_names = FALSE)
  
  expect_true(ncol(sub) == 24)
  expect_true(nrow(sub) == 606)
  expect_true(sum(sub$P0010001) == 1315781)
  expect_true(length(unique(sub$VTD)) == 18)
  expect_equal(names(sub), c("GEOID", "STUSAB", "COUNTY", "LOGRECNO", "SUMLEV", "VTD", "P0010001", 
                             "P0020002", "P0020005", "P0020006", "P0020007", "P0020008", "P0020009", 
                             "P0020010", "P0020011", "P0030001", "P0040002", "P0040005", "P0040006", 
                             "P0040007", "P0040008", "P0040009", "P0040010", "P0040011"))
  
})