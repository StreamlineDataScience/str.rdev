#' Process Enron data from XLS file
#'
#' @param file The file to process
#'
#' @return A tidy data frame
#' @export
#'
#' @examples
#' \dontrun{
#' enron_process_data("~/Desktop/andrea_ring_000_1_1.pst.0.xls")
#' }
enron_process_data <- function(file) {

  tables_needed <- tibble::tibble(
    date_cells = c("P2:T2", "F36:AJ36", "F70:AJ70", "F103:AI103",
                   "F135:AJ135", "F168:AI168"),
    deliveries_cells = c("P18:T30", "F52:AJ64", "F86:AJ98", "F119:AI131",
                       "F151:AJ163", "F184:AI196"),
    receipts_cells = c("P4:T16", "F38:AJ50", "F72:AJ84", "F105:AI117",
                       "F137:AJ149", "F170:AI182")
  )

  df <- purrr::pmap_dfr(tables_needed, ~process_month(file, ..1, ..2, ..3))

  df[order(df$location, df$date), ]
}

# Location names from top of spreadsheet
get_location_names <- function(file) {
  readxl::read_excel(file, col_names = "location", range = "C4:C16")
}

# Date row for each month block
get_date_row <- function(file, date_cells) {
  readxl::read_excel(file, col_names = FALSE, range = date_cells) %>%
    dplyr::mutate_all(as.character)
}

# Process either the deliveries or receipts for the month block
process_to_column <- function(file, loc_names, date_row, data_type, range) {

  # read in deliveries or receipts
  raw_table <- readxl::read_excel(file, col_names = FALSE, range = range) %>%
    dplyr::mutate_all(as.character)

  # combine with location & dates, process
  dplyr::bind_rows(date_row, raw_table) %>%
    janitor::row_to_names(row_number = 1) %>%
    dplyr::bind_cols(loc_names) %>%
    tidyr::pivot_longer(
      cols = 1:ncol(raw_table),
      names_to = "date",
      values_to = data_type
    ) %>%
    dplyr::mutate(date = as.Date(date))
}

# Combine and process data from one month of data
process_month <- function(file, date_cells, deliveries_cells, receipts_cells) {

  loc_names <- get_location_names(file)

  date_row <- get_date_row(file, date_cells)

  deliveries <- process_to_column(
    file,
    loc_names,
    date_row,
    "deliveries",
    deliveries_cells
  ) %>% dplyr::mutate(deliveries = as.numeric(deliveries))

  receipts <- process_to_column(
    file,
    loc_names,
    date_row,
    "receipts",
    receipts_cells
  ) %>% dplyr::mutate(receipts = as.numeric(receipts))

  dplyr::full_join(deliveries, receipts, by = c("location", "date"))
}

