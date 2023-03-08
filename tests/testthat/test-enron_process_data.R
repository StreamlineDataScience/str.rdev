library(testthat)

test_that("processed data is identical to benchmark csv", {
  benchmark_data <- system.file("extdata", "long_enron_data.csv", package = "str.rdev") |>
    readr::read_csv(show_col_types = FALSE)

  processed_data <- system.file("extdata", "enron_raw_data.xls", package = "str.rdev") |>
    enron_process_data()

  expect_identical(processed_data, benchmark_data)
})
