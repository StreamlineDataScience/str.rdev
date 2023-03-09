## app.R ##
library(shiny)
library(shinydashboard)
library(plotly)
library(ggplot2)
library(dplyr)
library(str.rdev)

enron_download_file()
df <- enron_process_data()


ui <- dashboardPage(

  dashboardHeader(title = "Enron Dashboard"),

  dashboardSidebar(

    selectInput("locations","Select locations", choices = unique(df$location),multiple = TRUE, selected = unique(df$location))


  ),

  dashboardBody(

    plotlyOutput("lineplot", height = "600")

  )
)

server <- function(input, output) {


  df_react <- reactive({
    df %>%
      filter(location %in% input$locations)
  })

  output$lineplot <- renderPlotly(

    ggplotly(
      df_react() %>%
        ggplot(aes(x = date, y = receipts, col = location)) +
        geom_line() +
        labs(title = "Receipts Over Time", x = NULL, y = NULL) +
        scale_y_continuous(labels = scales::dollar_format())
    )

  )


}

shinyApp(ui, server)


