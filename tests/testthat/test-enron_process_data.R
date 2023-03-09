context("Testing that our data processing function")

testthat::test_that("Whether enron_process_data produces the same results as an example dataset", {

  enron_download_file()
  res <- enron_process_data()

  testthat::expect_equal(res, dput(enron_sample))

})

