#' Processes Enron dataset to long format.
#'
#' @param file The file path of the \code{.xls} file for processing.
#'
#' @return Returns a \code{data.frame}.
#' @export
#'
#' @examples
#' enron_process_data(enron_download_file())
enron_process_data <- function(file) {
  names_df <-
    readxl::read_xls(file, range = "B3:C31") |>
    dplyr::rename(type = 1, location = 2) |>
    tidyr::fill(type)


  full_df <- readxl::read_xls(file, col_names = FALSE, skip = 0)

  binary_df <- !is.na(full_df)

  left_most_col_num <- 6
  right_most_col_num <- ncol(full_df)

  vec <-
    binary_df |>
    as.data.frame.matrix() |>
    dplyr::mutate(dplyr::across(dplyr::everything(), as.numeric)) |>
    dplyr::pull(left_most_col_num) # first column of the grids of values starting from row 35


  sequence <- c(0, 1, 1, 0)

  vec_match <-
    zoo::rollapply(
      vec,
      FUN = function(vector, sequence) {
        all(vector == sequence)
      },
      sequence = sequence,
      width = length(sequence)
    )

  # add 2 because the sequence includes the empty preceding line and unnecessary day of week line
  top_left_idxs <- which(vec_match) + 2

  get_clean_ranges <- function(top_left_idx) {
    range_str <- get_excel_range_string(
      left_most_col = left_most_col_num,
      top_left_row = top_left_idx,
      right_most_col = right_most_col_num,
      n_rows = nrow(names_df)
    )

    df_grid <- readxl::read_xls(file, col_names = TRUE, skip = 0, range = range_str) # first read of data

    # find the number of empty columns to the right of the table
    cols_remove <-
      df_grid |>
      dplyr::select(dplyr::where(function(x) all(is.na(x)))) |>
      ncol() + 1 # add 1 to also remove the prior Mo Avg column

    # get updated range string and re-read data
    get_excel_range_string(
      left_most_col_num,
      top_left_idx,
      right_most_col_num - cols_remove,
      n_rows = nrow(names_df)
    )
  }

  process_table <- function(range) {
    df_grid <- readxl::read_xls(file, col_names = TRUE, skip = 0, range = range)[-1, ] # remove empty row below header

    df_grid |>
      rename_date_cols() |>
      cbind(names_df) |>
      tidyr::pivot_longer(!c(type, location), names_to = "date") |>
      dplyr::mutate(type = stringr::str_remove(tolower(type), " hh")) |>
      tidyr::pivot_wider(names_from = type, values_from = value)
  }


  xls_ranges <-
    purrr::map(top_left_idxs, get_clean_ranges) |>
    unlist() |>
    # add in the current months data manually
    # I would make this cleaner with a bit more time (and knowledge of how the sheet is updated throughout the month)
    append("P2:T31")

  dfs <- purrr::map(xls_ranges, process_table)

  do.call("rbind", dfs) |>
    dplyr::arrange(location, date) |>
    dplyr::select(location, date, deliveries, receipts) |>
    dplyr::filter(location != "Total") |>
    as.data.frame() |>
    dplyr::mutate(dplyr::across(c(deliveries, receipts), as.integer))
}

rename_date_cols <- function(data) {
  names(data) <- num_to_date(as.numeric(names(data)))
  data
}

num_to_excel_col <- function(num) {
  paste0(LETTERS[floor(num / 26)], LETTERS[num %% 26])
}

get_excel_range_string <- function(left_most_col, top_left_row, right_most_col, n_rows) {
  paste0(
    num_to_excel_col(left_most_col), top_left_row,
    ":",
    num_to_excel_col(right_most_col),
    (top_left_row + n_rows + 1) # add extra row to account for empty row under header
  )
}

num_to_date <- function(num) {
  as.character(as.Date.numeric(num, origin = "1899-12-30"))
}
