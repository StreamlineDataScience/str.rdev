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
            title = "Analyze Selected Locations",
            echarts4r::echarts4rOutput(outputId = "chart"),
            width = 12
          ),


        ),
        bs4Dash::tabItem(
          tabName = "about_page",
          "Placeholder"
        )
      )
    )
  )
)

server <- function(input, output, session) {
  r_chart_data <- reactive({
    enron_data |>
      dplyr::filter(location %in% input$location_name)
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
      echarts4r::e_y_axis(formatter = htmlwidgets::JS(js_format_amount)) |>
      echarts4r::e_tooltip(trigger = "axis")

  })
}

shiny::shinyApp(ui, server)
