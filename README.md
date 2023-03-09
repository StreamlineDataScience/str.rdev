<!-- README.md is generated from README.Rmd. Please edit that file -->

# str.rdev

<!-- badges: start -->

[![R-CMD-check](https://github.com/StreamlineDataScience/str.rdev/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/StreamlineDataScience/str.rdev/actions/workflows/R-CMD-check.yaml)

<!-- badges: end -->

The goal of `str.rdev` is to download and process the Enron data set.

## Installation

You can install the development version of `str.rdev` from [GitHub](https://github.com/) with:

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

-   Excel table headers are the exact same (i.e. Avg, Maximum, Henry Hub) because grepl() was used to remove them. If different, then code most likely will break. This could potentially be added as a parameter.
-  Assumes the 'date' row will be imported as an integer because of Excel's wonderful conversion of Dec 30, 1899 base date
-  Add more parameters: enron_download_data() can only download from the exact same link
-  Check to see if downloaded file is up-to-date and not corrupt
- I was having issues wrapping global binding, (.data[["var"]]), so I put the variables in global.R

## Shiny App Suggestions

-   use golem package to turn Shiny app to have a package development framework
-   Put Plotly chart into a module, of course, separate UI and Server
-   use shinydashboard + dashboardthemes + CSS/HTML to make the app look nicer
-   Add company logo / use company colors to make is look less "out of the box"
