test_that("enron cleaned dataset", {
  # enron_download_file()
  # enron_process_data("enron")

  # setDT(enron)
  enron_dt = data.table(enron)

  expect_equal(dim(enron), c(2054, 4))
  expect_identical(length(enron[is.na(enron)]) , 0L) # No NA at all
  expect_identical(max(enron$date) , "2002-02-05") # Dates are within range
  expect_identical(min(enron$date) , "2001-09-01")
  expect_identical(nrow(enron_dt[, .N, by = location]), 13L) # We have 13 locations
  expect_identical(sum(enron_dt[ , .N, by = location][,N] == nrow(enron)/13L), 13L) # Each location has the same number of rows/dates
  expect_identical(sum(enron$deliveries <= 0), nrow(enron)) # all are negative
  expect_identical(sum(enron$receipts >= 0), nrow(enron)) # all are positive
})
