#' @export
enron_process_data = function(file) {
  location_names <- get_location_names(path = file, range = "C4:C16")

  receipts_data <- get_data(
    path = file,
    location_names = location_names,
    type = "receipts",
    ranges = list(
      range1 = list(date_row = "F168:AI168", data_range = "F170:AI182"),
      range2 = list(date_row = "F135:AJ135", data_range = "F137:AJ149"),
      range3 = list(date_row = "F103:AI103", data_range = "F105:AI117"),
      range4 = list(date_row = "F70:AJ70", data_range = "F72:AJ84"),
      range5 = list(date_row = "F36:AJ36", data_range = "F38:AJ50"),
      range6 = list(date_row = "P2:T2", data_range = "P4:T16")
  ))

  deliveries_data <- get_data(
    path = file,
    type = "deliveries",
    location_names = location_names,
    ranges = list(
      range1 = list(date_row = "F168:AI168", data_range = "F184:AI196"),
      range2 = list(date_row = "F135:AJ135", data_range = "F151:AJ163"),
      range3 = list(date_row = "F103:AI103", data_range = "F119:AI131"),
      range4 = list(date_row = "F70:AJ70", data_range = "F86:AJ98"),
      range5 = list(date_row = "F36:AJ36", data_range = "F52:AJ64"),
      range6 = list(date_row = "P2:T2", data_range = "P18:T30")
    ))

  deliveries_data |>
    dplyr::left_join(receipts_data, by = c("location", "date")) |>
    dplyr::arrange(location, date) |>
    dplyr::mutate(date = as.Date(date))
}

get_location_names <- function(path, range) {
  readxl::read_xls(path = path, range = range, col_names = "location")
}

get_data <- function(path, type = c("receipts", "deliveries"), location_names, ranges) {
  purrr::map_df(
    .x = ranges,
    .f = function(range) {
      dates <- suppressMessages(
        readxl::read_xls(
          path = path,
          range = range$date_row,
          col_types = "text",
          col_names = FALSE
        )
      ) |>
        as.numeric() |>
        as.Date(origin = "1899-12-30") |>
        as.character()

      data <- readxl::read_xls(path = path,
                               range = range$data_range,
                               col_names = dates) |>
        dplyr::bind_cols(location_names) |>
        tidyr::pivot_longer(
          cols = -location,
          names_to = "date",
          values_to = type
        )
    }
  )
}
