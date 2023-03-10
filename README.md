
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

## Example

To download the data file:

``` r
library(str.rdev)

enron_download_data("path/ernron_raw_data.xls")
```

To process the XLS data:

``` r

enron_process_data("path/ernron_raw_data.xls")
```

## Notes on implementation

The data processing function, `enron_process_data()` relies on known
cells in the XLS spreadsheet. For example, the receipts data for the
month of December is stored in cells F72 to AJ84. If this were to
change, the data processing would no longer work. Additionally, there is
no way to know if the rows/locations in each table (i.e. for each month)
correspond to the rows/locations listed in cells C4 to C16. The code
assumes the order is the same for each month. If the collaborator sent a
spreadsheet with data stored in different cells, the data processing
function would need to be updated.

The Shiny app takes input from the user, the facility/location of
interest, and then creates a line plot of receipts over the time range.
One basic improvement to the app is to add more reactivity to the plot,
so that the user can user their mouse to hover on the plot, and see the
exact value (receipt amount and date) for that observation. Another
improvement is to add a plot for deliveries, either in a separate tab or
below the receipts plot.
