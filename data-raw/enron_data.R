## code to prepare `enron_data` dataset goes here
enron_data <- system.file("extdata", "enron_raw_data.xls", package = "str.rdev") |>
  enron_process_data()

usethis::use_data(enron_data, overwrite = TRUE)
