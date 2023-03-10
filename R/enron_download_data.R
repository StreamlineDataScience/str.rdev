#' Download the Enron XLS file
#'
#' @param destfile Destination for XLS file.
#'
#' @return A XLS file saved at the specified file path.
#' @export
#'
#' @examples
#' \dontrun{
#' enron_download_data("~/Desktop/enron_data.xls")
#' }
enron_download_data <- function(destfile) {
  utils::download.file(
    url = "https://github.com/StreamlineDataScience/enron-example/blob/main/andrea_ring_000_1_1.pst.0.xls?raw=true",
    destfile = destfile
  )
}
