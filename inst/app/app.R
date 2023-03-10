
library(shiny)
library(str.rdev)
library(scales)
library(tidyverse)

data("enron_tidy_data")

locations <- unique(enron_tidy_data$location)

ui <- fluidPage(
  theme = bslib::bs_theme(bootswatch = "cerulean"),
  titlePanel(
    "Enron E-mail Dataset: Receipts from Various Locations"
  ),
  sidebarLayout(
    sidebarPanel(
      selectInput("location", "Select Location", locations)
    ),
    mainPanel(
      plotOutput("plot")
    )
  )
)

server <- function(input, output, session) {
  filtered_data <- reactive({
    enron_tidy_data %>%
      filter(location == input$location)
  })

  output$plot <- renderPlot({
    ggplot(filtered_data(), aes(x = date, y = receipts)) +
      geom_line() +
      scale_y_continuous(
        labels = label_comma(),
        limits = c(0, 400000)
        ) +
      scale_x_date(date_breaks = "14 days", labels = label_date_short()) +
      theme_minimal() +
      labs(
        x = "Date",
        y = "Receipts",
        title = paste0("Receipts from ", str_to_title(input$location))
        )

  })
}

shinyApp(ui, server)
