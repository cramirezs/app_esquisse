#!/usr/bin/R

# Author: Ciro Ramírez-Suástegui
# Date: 2021-10-21

ui <- fluidPage(
  titlePanel("Use esquisse as a Shiny module"),
  # Now we create the sections
  sidebarLayout( # -------------------------------------------------------------
    sidebarPanel(
      radioButtons( # Options as buttons
        inputId = 'data',
        label = "Data to use:",
        selected = 'iris',
        inline = FALSE,
        choiceNames = c('Flowers example', 'Cars example', 'Upload from computer'),
        choiceValues = c('iris', 'mtcars', 'upload')
      ),
      fileInput( # If you want to upload a file
        inputId = 'data_file',
        label = '',
        accept = c(
          'text/csv', 'text/comma-separated-values',
          'text/tab-separated-values', 'text/plain',
          '.csv', '.tsv', '.rds'
        ), placeholder = "No file selected"
      )
    ),
    mainPanel( # ---------------------------------------------------------------
      tabsetPanel(
        id = "main", # and we have two tabs
        tabPanel(title = "esquisse", esquisserUI(id = "esquisse")),
        tabPanel(title = "output", verbatimTextOutput("module_out"))
      )
    )
  )
)
