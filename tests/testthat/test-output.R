
testthat::test_that("errors", {
  expect_equal(data <- enron_process_data("file"),
               data2 <- readr::read_csv(url("https://raw.githubusercontent.com/StreamlineDataScience/enron-example/main/long_enron_data.csv")))
})

