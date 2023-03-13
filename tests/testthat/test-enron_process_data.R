test_that("enron data matches reference", {
  processed_df <- enron_process_data(enron_download_file())
  reference_df <- read.csv("https://raw.github.com/StreamlineDataScience/enron-example/main/long_enron_data.csv")

  expect_true(identical(reference_df, processed_df))
})
