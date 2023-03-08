ui <- shiny::tagList(
  bs4Dash::dashboardPage(
    header = bs4Dash::dashboardHeader(
      title = bs4Dash::dashboardBrand(
        title = "Streamline Data Science",
        color = "secondary",
        href = "https://www.streamlinedatascience.io/"
      )
    ),
    sidebar = bs4Dash::dashboardSidebar(
      bs4Dash::sidebarMenu(
        bs4Dash::menuItem(
          text = "Analysis",
          tabName = "analysis_page"
        ),
        bs4Dash::menuItem(
          text = "About",
          tabName = "about_page"
        )
      )
    ),
    body = bs4Dash::dashboardBody(
      bs4Dash::tabItems(
        bs4Dash::tabItem(
          tabName = "analysis_page",

          shiny::fluidRow(
            bs4Dash::box(
              title = "Select Locations",
              shinyWidgets::pickerInput(
                inputId = "location_name",
                label = NULL,
                choices = unique(enron_data$location),
                selected = (enron_data$location),
                multiple = TRUE,
                options = list(`actions-box` = TRUE, `selected-text-format` = 'count > 3')
              ),
              width = 4
            ),

            bs4Dash::box(
              title = "Select Data Aggregation",
              shinyWidgets::pickerInput(
                inputId = "data_aggregation",
                label = NULL,
                choices = c("Daily", "Monthly"),
                selected = "Monthly",
                multiple = FALSE
              ),
              width = 4
            )
          ),

          bs4Dash::box(
            title = "Analyze Selected Locations",
            echarts4r::echarts4rOutput(outputId = "chart"),
            width = 12
          ),

        ),
        bs4Dash::tabItem(
          tabName = "about_page",
          shiny::h1("Data"),

          shiny::p("Data is from", shiny::a(href = "https://en.wikipedia.org/wiki/Enron", "Enron"), ", which was a gas pipeline company."),

          shiny::p("After a scandal, a number of their spreadsheets were released to the public."),

          shiny::p("The original spreadsheet can be found in", shiny::a(href = "https://github.com/StreamlineDataScience/enron-example/blob/main/andrea_ring_000_1_1.pst.0.xls", "GitHub"), "or", shiny::a(href = "https://docs.google.com/spreadsheets/d/1sx6H8HywgO8wJFLCZa2ejA97ByrPTGse/edit#gid=958365174", "Google Sheets"), "."),

          shiny::p("Data contains", shiny::strong("deliveries"), "and", shiny::strong("receipts"), "for a number of", shiny::strong("locations/facilities"), "(e.g. ACADIAN, BRIDGELINE)."),

          shiny::h1("Application"),

          shiny::p("This application, which was created using Shiny, allows the user to analyze the trend of receipts over time for each location."),

          shiny::p("The user can select any number of locations and the aggregation of data (daily or monthly).")

        )
      )
    )
  )
)

server <- function(input, output, session) {
  r_chart_data <- reactive({
    out <- enron_data |>
      dplyr::filter(location %in% input$location_name)

    if (input$data_aggregation == "Monthly") {
      out <- out |>
        dplyr::mutate(date = lubridate::ymd(date) |> lubridate::floor_date(unit = "month")) |>
        dplyr::group_by(location, date) |>
        dplyr::summarise(receipts = sum(receipts)) |>
        dplyr::ungroup()
    }

    out
  })

  js_format_amount <- "
    function(value) {
      if (value === 0) return('')
      else if (value > 1000 && value < 1000000) {
        thousands = value/1000
        comma_separated = thousands.toString().replace(/\\B(?=(\\d{3})+(?!\\d))/g, ',')
        return(comma_separated + 'K')
      } else if (value >= 1000000) {
        millions = value/1000000
        millions = millions.toFixed(1)
        comma_separated = millions.toString().replace(/\\B(?=(\\d{3})+(?!\\d))/g, ',')
        return(comma_separated + 'M')
      }
    }"

  output$chart <- echarts4r::renderEcharts4r({
    r_chart_data() |>
      dplyr::group_by(location) |>
      echarts4r::e_chart(x = date) |>
      echarts4r::e_line(serie = receipts) |>
      echarts4r::e_title(text = "Receipts over Time by Location") |>
      echarts4r::e_legend(
        left = "right",
        top = "middle",
        orient = "vertical"
      ) |>
      echarts4r::e_y_axis(formatter = htmlwidgets::JS(js_format_amount),
                          axisLabel = list(fontSize = 16)) |>
      echarts4r::e_tooltip(trigger = "axis")

  })
}

shiny::shinyApp(ui, server)
