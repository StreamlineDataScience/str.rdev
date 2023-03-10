#' Download Enron spreadsheet data
#'
#' Download the Henry Hub tracking sheet, an extremely untidy spreadsheet that
#' was extracted from the [Enron Emails
#' Corpus](https://en.wikipedia.org/wiki/Enron_Corpus). More information on this
#' data is available from [Felienne
#' Hermans](https://www.felienne.com/archives/3634).
#'
#' @param path Where to download the spreadsheet. Defaults to a file named
#'   "enron.xls" in the working directory.
#' @param verbose If `TRUE`, messages will be relayed from [download.file()].
#'
#' @return The path, invisibly, for use in pipelines.
#' @export
#'
#' @examplesIf interactive()
#' path <- tempfile(fileext = ".xls")
#' enron_download_data(path)
#' unlink(path)
enron_download_data <- function(path = "./enron.xls", verbose = FALSE) {
  # Validate arguments to fail fast.
  path <- vctrs::vec_cast(path, character())
  verbose <- vctrs::vec_cast(verbose, logical())

  # url is split up purely for easier code readability.
  url <- paste0(
    "https://github.com/StreamlineDataScience/",
    "enron-example/",
    "raw/main/",
    "andrea_ring_000_1_1.pst.0.xls"
  )
  utils::download.file(url, path, mode = "wb", quiet = !verbose)
  return(invisible(path))
}
