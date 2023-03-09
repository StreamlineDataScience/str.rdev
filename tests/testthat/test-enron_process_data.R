test_that("enron dataset", {
  # enron_download_file()
  enron <- enron_process_data("enron")
  expect_s3_class(enron, "data.table")
  expect_equal(dim(enron), c(2054,4))
  expect_identical(max(enron$date) , as.Date("2002-02-05"))
  expect_identical(min(enron$date) , as.Date("2001-09-01"))

})
