
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

- Assumes headers will not change (i.e. Maximum, Avg) as grepl() is used
  to find and remove those columns. A different header will potentially
  break the code.
- Both functions assume the file downloads/saved with be an .xls;
  allowing for different file types could be a parameter
- enron_download_data() downloads data from the exact same link. Assumes
  data is on the first sheet.
- Assumes the date field will be an integer and exported using Excel’s
  base date of Dec 30, 1899.

## Shiny app improvements

- Use golem package as it creates a Shiny app inside an R package
  architecture
- use shinydashboard + shinydashboardthemes + CSS to make app look less
  “out of the box”
- add company logo and use company colors
- Put plotly chart inside a module with parameters on which variables to
  plot
- separate app.R into ui and server
- Add total deliveries and receipts, and the difference and put all in
  value boxes
