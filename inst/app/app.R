# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(tidyverse)
library(ggplot2)
library(dplyr)
library(plotly)
library(shinyBS)
library(scales)

data <- enron_process_data("Enron_data.csv")
locs <- unique(data$location)

ui <- fluidPage(
  titlePanel("Enron email receipts over time by location."),

  selectInput("Location",
                label = "Choose location",
                choices = locs, selected=locs[1]),
    bsTooltip("Location", "Choose the location where the receipts belong to", placement = "top", trigger = "hover",
              options = NULL),
  plotlyOutput("line")
)

server <- function(input, output) {

    output$line <- renderPlotly({

      pdata <- data %>% filter(location==input$Location)

      p <- ggplot(pdata, aes(x=date, y=receipts, text=paste("Receipts: ", receipts))) +
        geom_point(color="grey") +
        geom_line(aes(group=1)) +
        scale_x_date(breaks=date_breaks("1 months"),
                     labels=date_format("%b %y")) +
        theme_minimal()+
        expand_limits(y=0)+
        labs(x = "Date (month/year)", y = "Receipts")
      ggplotly(p, tooltip = "text")
    })
}

# Run the application
shinyApp(ui = ui, server = server)
