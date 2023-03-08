
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

## Shiny app insights

Regarding app contents:

- I would include raw data in a table with option to download. We could use [`reactable`](https://glin.github.io/reactable/) or [`DT`](https://rstudio.github.io/DT/) packages.
- I would add boxes with information that could be interesting. We could use [`bslib::card()`](https://rstudio.github.io/bslib/articles/cards.html) function to create them.
- We could add a table sorting the locations by receipts.
- We could add another page and explore the analysis of deliveries. We could use Shiny modules to reuse the code we used for receipts.
- I would make small improvements to the chart. The tooltip shows date in a format that is not ideal.

Regarding app development:

- You might notice that some workarounds were introduced (for example, using `R/app_imports.R` to avoid warnings in CRAN check). I think that this workarounds wouldn't be needed if we used [`golem`](https://github.com/ThinkR-open/golem) or [`rhino`](https://github.com/Appsilon/rhino) to develop the application.
- I know that the goal was to create a simple app. In a production app I would use [Shiny modules](https://shiny.rstudio.com/articles/modules.html).
- The **About** page was developed using Shiny HTML tags. I would include the `.md` in a separate file and call `shiny::includeMarkdown()`.
