
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

This is a basic example which shows you how to solve a common problem:

``` r
library(str.rdev)
## basic example code
```

##  Possible issues with generalizability of the code

`enron_process_data()` function expects  `.xls` data to be in specific cells. If the location of data changes, the output will not be as expected (and it can even produce errors). Also, it assumes that the location names are ordered for both receipts and deliveries. The code expects a date format for date values as well.

That being said, a function was developed to allow the user to easily change different data ranges. The processing is somewhat "modularized": the goal is to identify "rectangles of data" for each type of value (receipt or delivery). To simplify the function call, ranges are defined inside the function.
