#' Downloads the Enron dataset from the 'StreamlineDataScience/enron-example'
#' GitHub repository.
#'
#' @param path The destination file path for the downloaded data. If missing, a temporary location is used.
#'
#' @return Returns the file path to the downloaded dataset (invisibly).
#' @export
#'
#' @examples
#' enron_download_file()
enron_download_file <- function(path) {
  if (missing(path)) {
    path <- tempfile(fileext = ".xls")
  }
  utils::download.file(
    "https://raw.githubusercontent.com/StreamlineDataScience/enron-example/main/andrea_ring_000_1_1.pst.0.xls",
    destfile = path,
    method = "curl"
  )
  invisible(path)
}
