test_that("enron_process_data cleans data as expected", {
  target_result <- tibble::as_tibble(read.csv(test_path("long_enron_data.csv")))
  path <- system.file("extdata/enron.xls", package = "str.rdev")

  target_result$date <- as.Date(target_result$date)
  expect_identical(
    enron_process_data(path),
    target_result
  )
})
