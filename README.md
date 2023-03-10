
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

## Potential Issues

- Assumes headers will not (i.e. Maximum, Avg) change as grepl() is used
  to remove them. A different header will potentially break the code
- Both functions assume the file read/saved with be an .xls, different
  file types could be a parameter
- enron_download_data() downloads data from the exact same link
- 

## Shiny app improvements

- Use golem package as it creates a Shiny app into an R package
  architecture
- Put plotly chart inside a module with parameters on which to plot
- separate app.R into ui and server
- Add total deliveriers and receipts, and the difference and put all in
  value boxes
