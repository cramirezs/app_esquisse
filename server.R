#!/usr/bin/R

# Author: Ciro Ramírez-Suástegui
# Date: 2021-10-21

install_pckgs <- c("esquisse", "shiny")
suppressPackageStartupMessages({
   tmp <- lapply(install_pckgs, library, character.only = TRUE)
})
options(shiny.reactlog = TRUE)

server <- function(input, output, session) {
  # Initialize on a pre-selected data
  data_r <- reactiveValues(data = iris, name = "iris")
  # Make it react to both inputs: button and file
  react_event <- reactive({
    list(input$data, input$data_file)
  })
  # These are the events or chunks that will be processing the data/inputs
  # Re-run every time the input changes
  observeEvent(react_event(), { # ----------------------------------------------
    if (input$data == "upload") {
      if(is.null(input$data_file$datapath)){ # validate data
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
      }else{ # at the moment it only reads one time of file from here
        data_r$data <- readRDS(input$data_file$datapath)
        data_r$name <- paste0(dirname(input$data_file$name), basename(input$data_file$name))
      }
    } else { # or use a base dataset
      data_r$data <- eval(parse(text = input$data))
      data_r$name <- input$data
    }
  })

  observeEvent(input$returnToInput, { # ----------------------------------------
    updateTabsetPanel(session, inputId = "main")
    removeModal(session)
  })

  # We pass the data to the esquisser server
  result <- callModule(
    id = "esquisse",
    module = esquisserServer,
    data = data_r
  )

  # We would like to print what's happened to the result
  output$module_out <- renderPrint({
      str(reactiveValuesToList(result))
  })
}
