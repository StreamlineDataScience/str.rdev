test_that("benchmark file exists", {
  expect_true(
    file.exists(
      file.path(system.file("extdata", package="str.rdev"),
                "long_enron_data.csv")
      ))
})

test_that("xls file exists", {
  expect_true(
    file.exists(
      file.path(system.file("extdata", package="str.rdev"),
                "andrea_ring_000_1_1.pst.0.xls")
    ))
})


test_that("data is identical", {

  csv_data <- readr::read_csv(
    fs::path_package("extdata", "long_enron_data.csv",
                     package = "str.rdev")
    )
  xls_data <- enron_process_data(
    fs::path_package("extdata", "andrea_ring_000_1_1.pst.0.xls",
                     package = "str.rdev")
    )

  expect_equal(csv_data$location, xls_data$location)
  expect_equal(csv_data$date, xls_data$date)
  expect_equal(csv_data$deliveries, xls_data$deliveries)
  expect_equal(csv_data$receipts, xls_data$receipts)
})
