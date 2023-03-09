enron = read.csv(here::here("data", "enron.csv"))
library(data.table)
library(plotly)
setDT(enron)

green = "#4DB848"
red = "#D50032"
df = enron[location == "TRUNKLINE"]
loc = df[1, location]
    plotly::plot_ly(
      data = df,
      x = ~ date
    ) |>
      plotly::add_lines(
        data = df,  # ET Line
        type = 'scatter',
        mode = 'lines',
        line = list(color = green),
        y = ~ deliveries,
        hovertemplate = '$%{y: .1f}',
        showlegend = FALSE,
        name = "deliveries"
      ) |>
      plotly::add_lines(
        data = df,
        type = 'scatter',
        mode = 'lines',
        line = list(color = red),
        y = ~ receipts,
        hovertemplate = '$%{y: .1f}',
        showlegend = FALSE,
        name = "receipts"
      ) |> plotly::layout(
        title = paste0(
          "<span style='color:",
          red,
          ";'><b>Receipts</b></span> and <span style='color:",
          green,
          ";'><b>deliveries</b></span> for ",
          loc
        ),
        xaxis = list(
          title = "",
          zeroline = F,
          showline = F,
          showgrid = F,
          tick0 = 0,
          ticks = "inside",
          tickcolor = "rgb(245,245,245)",
          dtick = 60 # every 60 days
        ),
        yaxis = list(
          title = "",
          zeroline = F,
          showline = F,
          showgrid = F
        ))
