#' Clean exon dataset
#'
#' Puts data in long df with four cols. Saves cleaned as an RDA for package data
#' @import data.table
#' @importFrom "utils" "write.csv"
#' @param file name of raw .xls file to clean, is located in /data-raw
#' @return clean long df with
#'
#' @export
enron_process_data = function(file = "enron") {
    openfile = here::here("data-raw", paste0(file, ".xls"))
    df = readxl::read_xls(
      # paste0("data-raw/", file, ".xls"),
      openfile,
      col_names = FALSE,
      col_types = "text"
    )
    setDT(df)

    # Remove empty rows
    remove_blank_rows = rownames(df)[rowSums(is.na(df)) == ncol(df)] |> as.integer()
    df = df[-remove_blank_rows,]

    # Assign a group ID for every xx (30) rows assuming last row is 'Total'.
    # This will be used to split the dt and then do a cbind to make a wide dt
    # Find where the max 'Total' row is, and that is the nrow() of the cleaned dt
    total_row_loc = max(which(df == "Total", arr.ind = T)[, 1])
    df[, group := rep(seq_len(nrow(df) / total_row_loc), each = total_row_loc)]
    df_list <- split(df, df[ , group])
    df_wide = do.call(cbind, df_list)

    # Remove cols: where all are NA, remove group ID, remove cols of 'Avg' or 'Maximum' of row 1
    remove_cols = colnames(df_wide)[colSums(is.na(df_wide)) == nrow(df_wide) |
                                      grepl("group$", names(df_wide)) |
                                      grepl("Avg$|Maximum$", df_wide[1, ])]
    df_wide = df_wide[, !..remove_cols]

    # Find Receipts/Deliveries col and fill it
    receipts_col = which(grepl("Receipts", df_wide))
    df_wide = tidyr::fill(df_wide, receipts_col)

    # Remove first row and 2 cols
    df_wide = df_wide[receipts_col:nrow(df_wide), ]
    remove_two_cols = which(grepl("Change|Henry", df_wide))
    df_wide = df_wide[, !..remove_two_cols]

    # TODO Assumes these will be NA and are in the right col
    df_wide[1, 1:2] = data.frame("type", "location")

    # First row to colnames
    colnames(df_wide) <- as.character(df_wide[1, ])
    df_wide = df_wide[-1, ]

    # Long format
    df_long = melt(df_wide,
                   id.vars = c("type", "location"),
                   variable.factor = FALSE)
    # df_long[, variable := as.integer(variable) + date_origin]
    df_long[, `:=` (variable = as.integer(variable) + date_origin, value = as.integer(value))]
    #
    # # Separate by type and merge the two together, we know deliveries is X and receipts is Y
    df_long_clean = merge(df_long[location != "Total" &
                                    grepl("^Deliveries", type), !"type"],
                          df_long[location != "Total" &
                                    grepl("^Receipts", type), !"type"], by = c("location", "variable"))
    #
    names(df_long_clean) = c("location", "date", "deliveries", "receipts")

    usethis::use_data(enron, overwrite = TRUE)
    # write.csv(df_long_clean, here::here("data-clean", paste0(file, ".csv")), row.names = FALSE)
}
