test_that("enron_download_data works", {
  skip_on_cran()
  path <- withr::local_tempfile(fileext = ".xls")
  expect_error(
    {test_result <- enron_download_data(path)},
    NA
  )
  expect_identical(test_result, path)

  expect_identical(
    file.size(test_result),
    file.size(system.file("extdata/enron.xls", package = "str.rdev"))
  )
})
