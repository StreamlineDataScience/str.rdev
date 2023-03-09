
#' Function to read and convert the raw Enron XLS file into a usable format
#'
#' @param location_names A vector of all location names that are present in the file. This will default to the original list of clients in the sample data.
#'
#' @return A processed dataframe is returned
#' @export
#'
#' @importFrom readxl read_excel
#' @importFrom tidyr fill
#' @importFrom tidyr pivot_longer
#' @importFrom tidyr pivot_wider
#' @importFrom janitor row_to_names
#' @import dplyr
#'
#' @examples
#' enron_process_data()
#' \dontrun{
#' enron_process_data()
#' }
#'
#'
enron_process_data = function(location_names = c("ACADIAN" , "BRIDGELINE" , "COLUMBIA GULF" , "DIGCO" ,
                                                 "JEFFERSON ISLAND" , "GULF SOUTH" , "MAINLINE" , "NGPL",
                                                 "SONAT" , "SEA ROBIN" , "TEXAS GAS" , "TRUNKLINE" , "TRANSCO")){

  # Hard coded keywords to look for when processing

  dow_names <- c("Mon","Tue","Wed","Thu","Fri","Sat","Sun")
  type_names <-  c("Receipts HH","Deliveries HH")

  raw <- suppressMessages(readxl::read_excel(paste0(tempdir(),"/enron.xls"), sheet = 1, col_names = FALSE))

  # find row numbers that contain day of week headers
  row_vals <- which(apply(raw, 1, function(x) any(x %in% dow_names)))

  loop_list <- list()

  # column bind 30 row chunks beginning at dow header
  for(i in seq_along(row_vals)){

    #Create row bounds based on presence of DOW
    to <- row_vals[i]
    from <- row_vals[i] + length(location_names) * 2 + 4 # This assumes the client list will always have 2 instances of each client, 2 total rows, and a space in the header

    #Subset into individual chunks of equal row length
    chunk <- raw[to:from,]

    #Save chunks in a list
    loop_list[[i]] <- chunk


  }

  #Column bind list into single df
  df <- suppressMessages(loop_list %>%
    bind_cols())

  # Remove columns that are all NA
  df <- Filter(function(x)!all(is.na(x)), df)

  #Select columns with only the information we want
  df <- Filter(function(x) any(x %in% c(location_names, dow_names, type_names)), df)

  # Add names to location and type columns based on contents
  names(df)[as.numeric(which(apply(df, 2, function(x) any(x %in% location_names))))]  <- "location"
  names(df)[as.numeric(which(apply(df, 2, function(x) any(x %in% type_names))))]  <- "type"

  # Fill down the type column
  df <- tidyr::fill(df,.data$type)

  # Fill NA values in location and type with generic value
  df["location"][is.na(df["location"])] <- "location"
  df["type"][is.na(df["type"])] <- "type"

  # Final wrangling and re-factoring of data
  df <- df %>%
    janitor::row_to_names(row_number = 2) %>%
    filter(!.data$location %in% c("location","Total")) %>%
    mutate(type = ifelse(.data$type == "Receipts HH", "receipts", .data$type),
           type = ifelse(.data$type == "Deliveries HH", "deliveries", .data$type)) %>%
    tidyr::pivot_longer(cols = -c(.data$type,.data$location), names_to = "date") %>%
    arrange(.data$type) %>%
    tidyr::pivot_wider(names_from = .data$type, values_from = .data$value) %>%
    mutate(date = as.Date(as.numeric(.data$date), origin = "1899-12-30")) %>%
    arrange(.data$location, .data$date) %>%
    mutate(deliveries = as.numeric(.data$deliveries),
           receipts = as.numeric(.data$receipts))

  return(df)
}
