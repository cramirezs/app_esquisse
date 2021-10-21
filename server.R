#!/usr/bin/R

# Author: Ciro Ramírez-Suástegui
# Date: 2021-10-21

install_pckgs <- c("esquisse", "shiny")
suppressPackageStartupMessages({
   tmp <- lapply(install_pckgs, library, character.only = TRUE)
})
options(shiny.reactlog = TRUE)

server <- function(input, output, session) {
  data_r <- reactiveValues(data = iris, name = "iris")
  react_event <- reactive({
    list(input$data, input$data_file)
  })
  observeEvent(react_event(), {
    if (input$data == "upload") {
      # validate data
      if(is.null(input$data_file$datapath)){
        showModal(modalDialog(
          p("You need to upload the data first."),
          p("You can click on database (esquisse bar) for more options."),
          icon('database'),
          title = "File missing",
          footer = tagList(
            modalButton("Dismiss"),
            actionButton("returnToInput", "Return to data viz.")
          )
        ))
      }else{
        data_r$data <- readRDS(input$data_file$datapath)
        data_r$name <- paste0(dirname(input$data_file$name), basename(input$data_file$name))
      }
    } else {
      data_r$data <- eval(parse(text = input$data))
      data_r$name <- input$data
    }
  })

  observeEvent(input$returnToInput, {
    updateTabsetPanel(session, inputId = "main")
    removeModal(session)
  })

  result <- callModule(
    module = esquisserServer,
    id = "esquisse",
    data = data_r
  )

  output$module_out <- renderPrint({
      str(reactiveValuesToList(result))
  })
}
