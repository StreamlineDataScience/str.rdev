#' Process Enron spreadsheet data
#'
#' Process the spreadsheet of Enron data. This is currently quite fragile, and
#' will not function properly if new data is added to the spreadsheet, if rows
#' are combined, etc.
#'
#' @inheritParams .read_enron_block
#'
#' @return A tibble of clean data.
#' @export
#'
#' @examples
#' enron_process_data(system.file("extdata/enron.xls", package = "str.rdev"))
enron_process_data <- function(path) {
  # Validate arguments to fail fast.
  path <- vctrs::vec_cast(path, character())

  # TODO: Read locations more automatically. This is low-priority, since
  # locations are unlikely to change in this exact format, but it would be
  # useful to look (for example) for all-caps fields in that general location.

  # While it's tempting to try to robustly parse things and figure out where the
  # real data is, instead we'll manually load in pieces and put it back
  # together.
  locations <- readxl::read_xls(
    path, range = "C4:C16", col_names = "location"
  )$location

  # TODO: Detect blocks of data by the whitespace (or lack thereof) around them.
  # There isn't a consistent number of gap rows between sections, so be careful
  # not to just assume the next block would be at the bottom. Also it looks
  # likely that they were adding data to the TOP of the spreadsheet, and then
  # pushing everything else down.

  # Make a map of the data. Long-term I'd rather make this smart, reading all
  # the way to the end of that group of rows, then getting rid of sums.
  data_map <- tibble::tribble(
    ~"start_row", ~"start_col", ~"end_col",
    2, "P", "T",
    36, "F", "AJ",
    70, "F", "AJ",
    103, "F", "AI",
    135, "F", "AJ",
    168, "F", "AI"
  )

  all_data <- purrr::pmap(
    data_map,
    .read_enron_block,
    path = path,
    locations = locations
  ) |>
    purrr::list_rbind() |>
    dplyr::arrange(.data$location, .data$date)

  return(all_data)
}

#' Read and clean a block of Enron spreadsheet data
#'
#' In a real package, I like to document even internal functions, to remind
#' future me how things work. Note the `@keywords internal` bit at the bottom. I
#' also like to prefix unexported functions with `.`, again to help future me
#' remember that it's not supposed to be exported. I'm just documenting this
#' single internal function to give the idea.
#'
#' @param start_row Integer scalar. The first row to read (the row with the
#'   date).
#' @param start_col Character scalar. The first column to read.
#' @param end_col Character scalar. The last column to read.
#' @param locations The character vector of locations.
#' @param path The path to the spreadsheet.
#'
#' @return A clean tibble.
#' @keywords internal
.read_enron_block <- function(start_row, start_col, end_col, path, locations) {
  end_row <- start_row + 28L
  range <- glue::glue(
    "{start_col}{start_row}:{end_col}{end_row}"
  )

  return(
    .clean_segment(
      readxl::read_xls(path, range = range)[-1,],
      locations
    )
  )
}

.clean_segment <- function(dat, locations) {
  receipt_rows <- seq_along(locations)
  delivery_rows <- receipt_rows + length(receipt_rows) + 1

  receipts <- dat[receipt_rows,] |>
    .pivot(locations = locations, values_to = "receipts")
  deliveries <- dat[delivery_rows,] |>
    .pivot(locations = locations, values_to = "deliveries")

  return(
    dplyr::left_join(
      deliveries,
      receipts,
      by = dplyr::join_by("location", "date")
    )
  )
}

.fix_xl_dates <- function(dates) {
  return(as.Date(as.integer(dates), origin = "1899-12-30"))
}

.pivot <- function(dat, locations, values_to) {
  dat <- dat |>
    dplyr::mutate(location = locations) |>
    tidyr::pivot_longer(
      -"location",
      names_to = "date",
      names_transform = .fix_xl_dates,
      values_to = values_to,
      values_transform = as.integer
    )
  return(dat)
}
