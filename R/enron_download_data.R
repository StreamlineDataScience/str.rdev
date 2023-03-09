#' Download Enron dataset
#'
#' Import enron dataset from github and saves it in /data-raw
#' @param github_link link to github .xls file, username/repo/file
#' @param filename filename that is saved
#' @return xls saved in /data-raw
#' @export
enron_download_file = function(github_link = "StreamlineDataScience/enron-example/blob/main/andrea_ring_000_1_1.pst.0.xls",
                               filename = "enron") {
  link = paste0("https://github.com/", github_link, "?raw=true")
  # link = "https://github.com/StreamlineDataScience/enron-example/blob/main/andrea_ring_000_1_1.pst.0.xls?raw=true"
  tmp = paste0(here::here(), "/data-raw/", filename, '.xls')
  # tmp = paste0("data-raw/", filename, ".xls")
  download.file(url = link,
                destfile = tmp,
                mode = "wb")
}
