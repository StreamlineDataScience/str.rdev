library(shiny)
library(dplyr)
library(tidyr)
library(shinyWidgets)
library(str.rdev)
library(ggplot2)
library(scales)

enron_df <- enron_process_data(enron_download_file())
enron_df$date <- as.Date.character(enron_df$date)

enron_locations <- unique(enron_df$location)

dropdownButton <- function(label = "", status = c("default", "primary", "success", "info", "warning", "danger"), ..., width = NULL) {
  # https://stackoverflow.com/questions/34530142/drop-down-checkbox-input-in-shiny
  status <- match.arg(status)
  # dropdown button content
  html_ul <- list(
    class = "dropdown-menu",
    style = if (!is.null(width)) {
      paste0("width: ", validateCssUnit(width), ";")
    },
    lapply(X = list(...), FUN = tags$li, style = "margin-left: 10px; margin-right: 10px;")
  )
  # dropdown button apparence
  html_button <- list(
    class = paste0("btn btn-", status, " dropdown-toggle"),
    type = "button",
    `data-toggle` = "dropdown"
  )
  html_button <- c(html_button, list(label))
  html_button <- c(html_button, list(tags$span(class = "caret")))
  # final result
  tags$div(
    class = "dropdown",
    do.call(tags$button, html_button),
    do.call(tags$ul, html_ul),
    tags$script(
      "$('.dropdown-menu').click(function(e) {
      e.stopPropagation();
});"
    )
  )
}


ui <- fluidPage(
  sidebarLayout(
    sidebarPanel(
      "",
      dropdownButton(
        checkboxInput("locations_all", "Select All/None", value = TRUE),
        label = "Select locations", status = "default", width = NULL,
        checkboxGroupInput(
          inputId = "enron_locations", label = "Locations:",
          choices = enron_locations,
          selected = enron_locations
        )
      )
    ),
    mainPanel(
      plotOutput("plot"),
      tags$br(),
    )
  )
)


server <- function(input, output, session) {
  observe({
    updateCheckboxGroupInput(
      inputId = "enron_locations",
      choices = enron_locations,
      selected = if (input$locations_all) enron_locations else c()
    )
  })

  df_plot <- reactive({
    filtered_df <-
      enron_df |>
      filter(location %in% input$enron_locations)

    if (nrow(filtered_df) == 0) {
      return()
    }

    filtered_df |>
      pivot_longer(c(deliveries, receipts), names_to = "type", values_to = "count")
  })

  output$plot <- renderPlot({
    if (is.null(df_plot())) {
      return()
    }

    ggplot(df_plot(), aes(x = date, y = count, col = location)) +
      geom_line() +
      facet_wrap(~type, ncol = 1, scales = "free_y") +
      theme_bw() +
      labs(
        col = "",
        x = "",
        y = "Count (n)"
      ) +
      scale_x_date(date_breaks = "1 month", date_labels = "%b %Y") +
      scale_y_continuous(labels = label_number(scale_cut = cut_short_scale()))
  })
}

shinyApp(ui = ui, server = server)
