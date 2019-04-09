ui <- shiny::shinyUI(shinydashboard::dashboardPage(skin = "red",
  shinydashboard::dashboardHeader(title = "FASTQ Quality Viewer"),
  #####################
  ###### SIDE BAR #####
  #####################
  shinydashboard::dashboardSidebar(
    shinyjs::useShinyjs(),
    shiny::checkboxInput(inputId = 'checkbox_show_sequence_id',
                         label = 'Show sequence ID',
                         value = TRUE),
    shiny::checkboxInput(inputId = 'checkbox_show_sequence',
                         label = 'Show sequence',
                         value = TRUE),
    shiny::checkboxInput(inputId = 'checkbox_show_encoded_quality',
                         label = 'Show encoded quality score',
                         value = TRUE),
    shiny::checkboxInput(inputId = 'checkbox_show_decoded_quality',
                         label = 'Show decoded quality score',
                         value = FALSE),
    shiny::checkboxInput(inputId = 'checkbox_show_emoji',
                         label = 'Show quality score as emojis',
                         value = FALSE),
    # Adjust spacing between the check boxes
    shiny::tags$head(shiny::tags$style(shiny::HTML(
      'section.sidebar .shiny-input-container, .quality_emoji_info{
       padding: 0px 0px 0px 15px;
      }'
    ))),

    shinyjs::hidden(shiny::tags$div(id='emoji_info', class='quality_emoji_info',
      shiny::tags$br(),
      shiny::tags$h5(id='sdsd', 'Quality Score to Emoji Mapping'),
      shiny::tags$h5(id='sdsd', '00 \U2014 01 \U1F92E \U2192 Worst quality'),
      shiny::tags$h5(id='sdsd', '02 \U2014 09 \U1F922 '),
      shiny::tags$h5(id='sdsd', '10 \U2014 19 \U1F915 '),
      shiny::tags$h5(id='sdsd', '20 \U2014 24 \U1F642 '),
      shiny::tags$h5(id='sdsd', '25 \U2014 29 \U1F601 '),
      shiny::tags$h5(id='sdsd', '30 \U2014 34 \U1F618 '),
      shiny::tags$h5(id='sdsd', '35 \U2014 39 \U1F60D '),
      shiny::tags$h5(id='sdsd', '40 \U2014 41 \U1F929 \U2192 Best quality'))),

    shiny::tags$head(shiny::tags$style(shiny::HTML(
      '.quality_emoji_info{
        color: #d4d4d4;
      }'
    )))



  ),
  # End of dashboard sidebard

  #####################
  ##### MAIN BODY #####
  #####################
  shinydashboard::dashboardBody(
    shiny::fluidRow(
      shiny::column(width = 6,
        # Left box
        shinydashboard::box(width = NULL, solidHeader = FALSE,
                            shinyFiles::shinyFilesButton(id = "button_file_left",
                                                         multiple = FALSE,
                                                         label = "Load FASTQ file",
                                                         title = 'Please pick a FASTQ file'),
                            shiny::textOutput(outputId = 'filepath_left'),
                            shiny::verbatimTextOutput(outputId = 'output_left'))),
      shiny::column(width = 6,
        # Right box
        shinydashboard::box(width = NULL, solidHeader = FALSE,
                            shinyFiles::shinyFilesButton(id = "button_file_right",
                                                         multiple = FALSE,
                                                         label = "Load FASTQ file",
                                                         title = 'Please pick a FASTQ file'),
                            shiny::textOutput(outputId = 'filepath_right'),
                            shiny::verbatimTextOutput(outputId = 'output_right')))
    )
  )
))
# End of shinyUI
