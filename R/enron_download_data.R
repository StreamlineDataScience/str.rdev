#' Download Enron dataset
#'
#' Downloads enron dataset from a from github (username/repo/file.xls) and saves it in /data-raw
#' @importFrom utils download.file
#' @param github_link link to github .xls file, username/repo/file
#' @param filename filename that is saved
#' @return xls saved in /data-raw
#' @export
enron_download_file = function(github_link = "StreamlineDataScience/enron-example/blob/main/andrea_ring_000_1_1.pst.0.xls",
                               filename = "enron") {

  link = paste0("https://github.com/", github_link, "?raw=true")

  tmp = here::here("data-raw", paste0(filename, ".xls"))
  download.file(url = link,
                destfile = tmp,
                mode = "wb")
}
