
<!-- README.md is generated from README.Rmd. Please edit that file -->

# str.rdev

<!-- badges: start -->

[![R-CMD-check](https://github.com/StreamlineDataScience/str.rdev/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/StreamlineDataScience/str.rdev/actions/workflows/R-CMD-check.yaml)
<!-- badges: end -->

The goal of `str.rdev` is to download and process the Enron data set.

## Installation

You can install the development version of `str.rdev` from
[GitHub](https://github.com/) with:

``` r
# install.packages("remotes")
remotes::install_github("StreamlineDataScience/str.rdev")
```

## Limitations

This package is designed for downloading, processing, and displaying visualizations based on the processed results from the Enron excel data available on GitHub. 

The enron_download_data() function, which enron_process_data() and the shiny app depend on, assumes that the information from the first table will stay from column 1 to 11. Specifically, "type" and "location" should stay in column 2 and 3. It also assumes that the day of week will be a separate row above date for labeling. Otherwise, this function should be functional as long as the link to the dataset does not change, all tables stay on one excel sheet with no blank observations, and the tables are separated by at least one blank row. The enron_process_data() function assumes that there are 14 "locations" for each "type". 

The R shiny app displays receipts over time for the user-selected location. Plotting the trend of daily receipts seems too noisy for some locations, such as BRIDGELINE. It may be clearer and more aesthetically pleasing to plot weekly or monthly averages of receipts over time for the user-selected location. In addition, since there exists a large difference between deliveries and receipts for most locations, it may be interesting to add deliveries to the plots along with receipts for the selected location so that any differences will be visualized.

