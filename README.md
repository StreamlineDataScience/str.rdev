
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

path <- enron_download_file()
enron_data <- enron_process_data(path)

head(enron_data)
#>   location       date deliveries receipts
#> 1  ACADIAN 2001-09-01     -45374        0
#> 2  ACADIAN 2001-09-02     -45374        0
#> 3  ACADIAN 2001-09-03     -45374        0
#> 4  ACADIAN 2001-09-04          0        0
#> 5  ACADIAN 2001-09-05     -30264        0
#> 6  ACADIAN 2001-09-06     -41047        0
```

## Possible limitations

Some of the code that processes the xls data into the long format has
expectations to the format and location of the content in the downloaded
file. If the tables are arrange differently or moved elsewhere within
the spreadsheet, this may cause the processing code to fail and not
rearrange the data appropriately. The processing code is able to detect
all tables below the first automatically and include them in the
processed data but includes expectations about their arrangement
including that there are two empty lines between sequential tables and
that the tables begin in the 6th column of the sheet. If this were to
change, then it may fail to detect the entire content of the tables
appropriately.

## shiny app

The shiny app offers a basic visualisation of the number of receipts and
deliveries over time for each location. Possible improvements to the app
could be more filters that the user could apply or the ability to filter
the data by date to zoom-in on a particular period. Alternatively, the
plots could be made a bit more interactive and include an ability to
hover over a line and display the actual value in a text box.
