wd = here::here()
date_origin = as.Date("1899-12-30") # Date Excel starts to count days
weekdays = weekdays(Sys.Date()+0:6, abbreviate = T)

exon = readxl::read_xls(paste0("data-raw/andrea_ring_000_1_1.pst.0.xls"), col_names = FALSE, col_types = "text")
read.csv("data-raw/andrea_ring_000_1_1.pst.0.xls")

which(grepl("Mon", exon), arr.ind = T)
which(exon == "Mon", arr.ind = T)[,1]

# Find unique rows where a weekday exists
unique_rows = lapply(weekdays, function(x) which(exon == x, arr.ind = T)[,1]) |> unlist() |> unique() |> sort()


lapply(unique_rows, )
which(exon == "Month-[0-9] Avg", arr.ind = T)
which(grepl("Month-[0-9] Avg", exon), arr.ind = T)
# stringr::str_locate_all(exon, "Month")
# split(exon, 2)

# split by 8 rows
# https://stackoverflow.com/questions/63587058/split-a-large-dataframe-into-multiple-dataframes-by-row-in-r
library(dplyr)

# Remove emply rows
remove_blank_rows = rownames(exon)[rowSums(is.na(exon)) == ncol(exon)] |> as.integer()
exon = exon[-remove_blank_rows, ]


exon = exon |> dplyr::mutate(group = rep(seq_len(nrow(exon)/30), each=30))
dfList <- split(exon, exon$group)
df_wide=do.call(cbind, dfList) |> data.table::as.data.table()

# Remove cols: where are NA, remove group, remove 'Avg'
remove_cols = colnames(df_wide)[colSums(is.na(df_wide)) == nrow(df_wide) | grepl("group$", names(df_wide)) | grepl("Avg$", df_wide[1,])]
df_wide = df_wide[ , !..remove_cols]


