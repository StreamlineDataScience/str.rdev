#' Download Enron dataset
#'
#' Downloads enron dataset from the Streamline github repo and saves it locally
#' in /data-raw
#' @importFrom "utils" "download.file"
#' @param filename filename that is saved
#' @return xls saved in /data-raw
#' @export
enron_download_file = function(filename = "enron") {

  link = "https://github.com/StreamlineDataScience/enron-example/blob/main/andrea_ring_000_1_1.pst.0.xls?raw=true"

  tmp = here::here("data-raw", paste0(filename, ".xls"))
  download.file(url = link,
                destfile = tmp,
                mode = "wb")
}
