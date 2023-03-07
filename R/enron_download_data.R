#' Download enron data
#'
#' @param source Character. Indicates where to download enron data from.
#' Possible options are `"github"` and `"google_sheets"`.
#' @param link Character. Link to the `.xls` enron file.
#' @param destfile Character. Filepath where the `.xls` file should be stored.
#'
#' @details This function is used to donwload enron `.xls` data.
#' By default, i.e. when no arguments are passed to the function, it will
#' download data from GitHub and save it in `"inst/extdata/enron_raw_data.xls"`.
#' Default `link`s for different `source`s were defined in `R/constants.R`.
#'
#' @export
enron_download_data = function(source = c("github", "google_sheets"),
                               link = NULL,
                               destfile = "inst/extdata/enron_raw_data.xls") {
  source <- match.arg(source)

  if (is.null(link)) {
    link <- get_default_link(source)
  }

  switch(source,
         github = download_github(link, destfile),
         google_sheets = download_google_sheets(link, destfile))
}

#' Get default download link
#'
#' @inheritParams enron_download_data
#'
#' @details This function is used to get download links when `link = NULL`.
#' Default `link`s for different `source`s were defined in `R/constants.R`.
get_default_link <- function(source) {
  switch(source,
         github = DEFAULT_GITHUB_LINK,
         google_sheets = DEFAULT_GOOGLE_SHEETS_LINK)
}

#' Download enron data from GitHub
#'
#' @inheritParams enron_download_data
#'
#' @details This is a helper function that gets called when`source = "github"`.
#' To download the file from GitHub, the string `?raw=true` needed to be added.
download_github <- function(link, destfile) {
  raw_link <- glue::glue("{link}?raw=true")
  req <- httr::GET(raw_link, httr::write_disk(path = destfile, overwrite = TRUE))

  if (req$status_code != 200)
    stop("Error: Github download failed")
}

#' Download enron data from Google Sheets
#'
#' @inheritParams enron_download_data
#'
#' @details This is a helper function that gets called when `source = "google_sheets"`.
download_google_sheets <- function(link, destfile) {
  tryCatch({
    suppressMessages(
      googledrive::drive_download(file = link,
                                  path = destfile,
                                  overwrite = TRUE)
    )

  },
  error = function(e) {
    stop("Error: Google Sheets download failed")
  })
}
