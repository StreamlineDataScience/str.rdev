test_that("data is identical", {

  csv_data <- readr::read_csv("inst/extdata/long_enron_data.csv")
  xls_data <- enron_process_data("inst/extdata/andrea_ring_000_1_1.pst.0.xls")

  expect_equal(csv_data$location, xls_data$location)
  expect_equal(csv_data$date, xls_data$date)
  expect_equal(csv_data$deliveries, xls_data$deliveries)
  expect_equal(csv_data$receipts, xls_data$receipts)
})
