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

get_default_link <- function(source) {
  switch(source,
         github = DEFAULT_GITHUB_LINK,
         google_sheets = DEFAULT_GOOGLE_SHEETS_LINK)
}

download_github <- function(link, destfile) {
  raw_link <- glue::glue("{link}?raw=true")
  req <- httr::GET(raw_link, httr::write_disk(path = destfile, overwrite = TRUE))

  if (req$status_code != 200)
    stop("Error: Github download failed")
}

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
