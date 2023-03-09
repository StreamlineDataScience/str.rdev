
#' Function for downloading and storing Enron data
#'
#' @param link A url to the Enron dataset to be downloaded.
#'
#' @return A raw XLS file is downloaded to the local temp file location via \code{\link{download.file}}.
#' @export
#'
#' @importFrom here here
#' @importFrom utils download.file
#'
#' @examples
#' enron_download_file()
#' \dontrun{
#' enron_download_file()
#' }
#'
#'
enron_download_file = function(link = NULL) {

  if(is.null(link)){

    link <- "https://github.com/StreamlineDataScience/enron-example/blob/main/andrea_ring_000_1_1.pst.0.xls?raw=true"
    download.file(url = link, destfile =  paste0(tempdir(),"/enron.xls"), mode="wb")

  } else {

    download.file(url = link, destfile =  paste0(tempdir(),"/enron.xls"), mode="wb")

  }


}





