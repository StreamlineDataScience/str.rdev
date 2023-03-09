## code to prepare `DATASET` dataset goes here

enron_sample <- read.csv("https://raw.githubusercontent.com/StreamlineDataScience/enron-example/main/long_enron_data.csv")

enron_sample <- df2 %>%
  mutate(date =  as.Date(date),
         receipts = as.numeric(receipts),
         deliveries = as.numeric(deliveries)) %>%
  as_tibble()

usethis::use_data(enron_sample, overwrite = TRUE, compress = "xz")
