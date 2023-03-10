#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(data.table)
library(plotly)

green = "#4DB848"
  red = "#D50032"

# Define UI for application that draws a histogram
ui <- fluidPage(

  titlePanel("Enron: Trend in Spending"),

  sidebarLayout(
    sidebarPanel(
      shinyWidgets::pickerInput(
        "location",
        "Location",
        choices = sort(unique(enron$location)),
        selected = "ACADIAN",
        multiple = FALSE,
        options = shinyWidgets::pickerOptions(
          actionsBox = TRUE,
          noneSelectedText = "Location",
          size = 12,
          showContent = FALSE
        )),
    ),

    mainPanel(
      plotlyOutput("daily_trend_linechart")
    )
  )
)

server <- function(input, output) {

  # enron = read.csv(here::here("data", "enron.csv"))
  setDT(enron)

  enron_input = reactive({enron[location == input$location]})

  output$daily_trend_linechart <- renderPlotly({

    df = enron_input()
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
          dtick = 30 # every 60 days
        ),
        yaxis = list(
          title = ""
          # zeroline = F,
          # showline = F,
          # showgrid = F
        ))
  })
}

shinyApp(ui = ui, server = server)
