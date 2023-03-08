#' Download the Enron dataset.
#'
#' @details This function downloads the Enron XLS file from github url and performs initial data cleaning.
#'
#' @return The downloaded and initially cleaned Enron dataset from internet and ready to be processed further in R by other functions.
#'
#' @import dplyr
#' @import rio
#' @import here
#' @import purrr
#' @importFrom utils read.csv tail write.csv
#'
#' @export
#'
#' @examples
#' \dontrun{enron_download_file()}
#'

enron_download_file = function() {
  link <- "https://github.com/StreamlineDataScience/enron-example/blob/main/andrea_ring_000_1_1.pst.0.xls?raw=TRUE"
  data <- import(link) # use import_list if there are multiple sheets

  pre_data <- list()
  pre_data <- group_split(data, group = cumsum(rowSums(is.na(data)) == ncol(data)), .keep = FALSE) %>%
    map_at(-1, tail, -1)
  pre_data <- pre_data[sapply(pre_data, function(x) nrow(x)!=0)]

  mid_data <- list()
  index <- c(1,3,5,7,9,11)
  for (i in seq_along(index)){
    mid_data[[i]] <- bind_rows(pre_data[[index[i]]], pre_data[[index[i]+1]])
  }

  post_data <- list()
  post_data[["location"]] <- mid_data[[1]][2:nrow(mid_data[[1]]),2:3]
  colnames(post_data[["location"]]) <- c("type", "location")

  mid_data[[1]] <- mid_data[[1]][,-(1:11)] # assuming month averages will always be in first 11 columns
  mid_data[[1]] <- mid_data[[1]][,!(colSums(is.na(mid_data[[1]])) == (nrow(mid_data[[1]])))]
  colnames(mid_data[[1]]) <- mid_data[[1]][1,]
  mid_data[[1]] <- mid_data[[1]][-1,]

  for (i in 2:length(mid_data)){
    colnames(mid_data[[i]]) <- mid_data[[i]][1,]
    mid_data[[i]] <- mid_data[[i]][,-grep("Avg", colnames(mid_data[[i]]))]
    mid_data[[i]] <- mid_data[[i]][-1,]
    colnames(mid_data[[i]]) <- mid_data[[i]][1,]
    mid_data[[i]] <- mid_data[[i]][-1,]
    ind <- colSums(is.na(mid_data[[i]])) == (nrow(mid_data[[i]]))
    mid_data[[i]] <- mid_data[[i]][,!ind]
  }

  post_data[["amount"]] <- bind_cols(mid_data,)
  enron_data <- bind_cols(post_data)
  write.csv(enron_data, paste(here(), "enron_data.csv", sep="/"), row.names=FALSE)
  return(enron_data)
}
