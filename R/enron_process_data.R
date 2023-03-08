#' Process the Enron dataset.
#'
#' @details This function further processes the downloaded Enron dataset so that it is ready for R shiny visualization.
#'
#' @param file character, the data file that contains the downloaded and pre-cleaned Enron dataset for further processing.
#'
#' @return A processed Enron dataset for R shiny visualization.
#'
#' @import tidyverse
#' @import dplyr
#' @import tidyr
#' @importFrom utils read.csv tail write.csv
#'
#' @export
#'
#' @examples
#' \dontrun{enron_process_data("enron_data.csv")}
#'

enron_process_data = function(file) {
  if (file.exists(file)) {data<-read.csv(file, check.names=FALSE)} else {data<-enron_download_file()}

  # some data manipulation
  data <- as.data.frame(data)
  data[1:14,1] <- "receipts"
  data[15:nrow(data),1] <- "deliveries"
  data <- data[-grep("Total", as.vector(data[,"location"])),]

  # convert from wide to long
  type <- NULL
  longdata <- data %>% group_by(type) %>%
    gather(key="date", value="amount", 3:ncol(data)) %>%
    spread(key="type", value="amount")

  # change date into a date object
  longdata$date <- as.numeric(longdata$date)
  longdata$date <- as.Date(longdata$date, origin = "1899-12-30")
  longdata$receipts <- as.numeric(longdata$receipts)
  longdata$deliveries <- as.numeric(longdata$deliveries)
  write.csv(longdata, paste(here(), "shiny_data.csv", sep="/"), row.names=FALSE)
  return(longdata)
}
