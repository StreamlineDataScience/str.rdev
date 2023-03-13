test_that("can download xls data", {
  # check that the file can be downloaded
  path <- enron_download_file()
  expect_true(file.exists(path))

  dl_file <- readxl::read_xls(path)

  # check that the xls file can be read and returns the expected data.frame
  expect_s3_class(dl_file, "data.frame")
  expect_equal(dim(dl_file), c(196, 37))
})
