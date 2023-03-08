#' Process enron data
#'
#' @param file Character. Filepath of the `.xls` file to be processed.
#'
#' @details The structure of data stored in the `.xls` file is not ideal. Four
#' different elements were identified: locations, receipts, deliveries and dates.
#' The data processing was developed in a way that allows the user to easily
#' adapt code if the location of data changes. First, the set of different
#' location names is identified. This set of location names is later used in the
#' processing of receipts and deliveries, which is done via a helper function
#' that expects each data range with their corresponding dates. Finally,
#' all data is merged and arranged.
#'
#' @export
enron_process_data = function(file) {
  location <- NULL # Line added to pass CRAN check

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

#' Get location names
#'
#' @param path Character. Filepath of the `.xls` file to be processed.
#' @param range Character. Cells where location names can be found in the file.
#'
#' @details This helper function is used to extract the set of location names.
get_location_names <- function(path, range) {
  readxl::read_xls(path = path, range = range, col_names = "location")
}

#' Get data
#'
#' @param path Character. Filepath of the `.xls` file to be processed.
#' @param type Character. The type of data being extracted. Possible values are
#' `"receipts"` and `"deliveries"`.
#' @param location_names Tibble. A one-column tibble where each row corresponds
#' to a location name. The name of the column is `location`.
#' @param ranges List. A list of two elements: `date_row` and `data_range`. Each
#' of these elements expect the cells where the corresponding data is stored.
#'
#' @details This helper function is used to process receipts and deliveries data.
#' It expects each set of cell ranges to be expressed in its own element of a
#' list. Dates are used as column names for each set of data. These dates need to
#' be processed in order to be properly used. The location names are binded to
#' wide data, which is later pivoted to long format.
get_data <- function(path, type = c("receipts", "deliveries"), location_names, ranges) {
  location <- NULL # Line added to pass CRAN check

  type <- match.arg(type)

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
