library(shiny)
library(str.rdev)

# In this case, there's no need to process this repeatedly, so we'll load it
# once globally.
path <- tempfile(fileext = ".xls")
dat <- path |>
    enron_download_data() |>
    enron_process_data()

unlink(path)

ui <- fluidPage(
    titlePanel("Enron Receipts"),
    plotOutput("receipts")
)

server <- function(input, output, session) {
    output$receipts <- renderPlot({
        ggplot2::ggplot(
            dat,
            ggplot2::aes(x = date, y = receipts, color = location)
        ) +
            ggplot2::geom_line() +
            ggplot2::scale_x_date(
                date_labels = "%Y-%m-%d",
                date_breaks = "2 weeks"
            ) +
            ggplot2::scale_y_continuous(labels = scales::dollar_format()) +
            ggplot2::facet_wrap(ggplot2::vars(location)) +
            ggplot2::theme(
                axis.text.x = ggplot2::element_text(
                    angle = 90, vjust = 0.5, hjust = 1
                ),
                legend.position = "none"
            )
    })
}

# Run the application
shinyApp(ui = ui, server = server)
