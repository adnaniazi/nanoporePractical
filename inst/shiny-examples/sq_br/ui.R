
ui <- shinydashboard::dashboardPage(
  shinydashboard::dashboardHeader(title="Squiggle Browser"),
  shinydashboard::dashboardSidebar(
  shinyjs::useShinyjs(),
    # folder selection
    shiny::tags$br(),
    shinyFiles::shinyDirButton(id = "button_dir",
                               label = "Choose reads directory", "Upload"),

    # currently-selected folder path to display
    shiny::h5(class = "path_text", shiny::textOutput(outputId = 'text_dir')),
    shiny::hr(),
    
    # Adjust left spacing for path text
    shiny::tags$head(shiny::tags$style(shiny::HTML(
      '.path_text {
      word-wrap: break-all;
      overflow-wrap: break-word;
      padding-left: 15px !important;
      padding-right: 15px;

      }'
    ))),

    # Default basecall group
    shiny::textInput(inputId = 'basecall_group', label = 'Basecall Group',
                     value = 'Basecall_1D_000'),
  
    # basic preprocessing options
    shiny::checkboxGroupInput(inputId='checkboxes_preprocess',
                              label='Basic preprocessing options',
                              choices=list("Z-normalize" = 'z_normalize',
                                           "Truncate spikes" = 'truncate_spikes'),
                              inline=FALSE),
    shiny::checkboxInput(inputId = 'checkbox_highlight',
                         label = 'Highlight a region in the data',
                         value = FALSE)
  ),
  # END OF SIDEBAR
  shinydashboard::dashboardBody(id='main', shiny::column(width=12,
        shiny::fluidRow(id='row1', shiny::selectInput(inputId = 'selectInput_currentread',
                                           label = 'Current read',
                                           choices = '',
                                           width = '100%')),
        shiny::fluidRow(id='row2', shiny::column(width=4, offset=4,
          shiny::actionButton(inputId='button_previous',
                                            label='Previous read'),
          shiny::actionButton(inputId='button_next',
                                            label='Next read'))),
        shiny::fluidRow(id='row3', rbokeh::rbokehOutput("rbokeh",  width = "100%", height = "100%")),
        shinyjs::hidden(shiny::fluidRow(id='row4', shiny::sliderInput(inputId = 'highlight_slider',
                                                      width='100%',
                                                      min = 0, max=1,
                                                      value = c(0, 1),
                                                      step = 1,
                                                      label = "Highlight region"))),

        shiny::tags$head(shiny::tags$script('
                                            var dimension = [0, 0, 0];
                                            var box = document.querySelector("main");
                                            $(document).on("shiny:connected", function(e) {
                                              dimension[0] = document.getElementsByClassName("content")[0].clientWidth - 30;
                                              var height_bs1 = document.getElementById("row1").clientHeight;
                                              var height_bs2 = document.getElementById("row2").clientHeight;
                                              var height_win = window.innerHeight;
                                              dimension[1] = height_win - height_bs1 - height_bs2 - 80;
                                              dimension[2] = height_bs1 + height_bs1/3;
                                              Shiny.onInputChange("dimension", dimension);
                                            });
                                            $(window).resize(function(e) {
                                              dimension[0] = document.getElementsByClassName("content")[0].clientWidth - 30;
                                              var height_bs1 = document.getElementById("row1").clientHeight;
                                              var height_bs2 = document.getElementById("row2").clientHeight;
                                              var height_win = window.innerHeight;
                                              dimension[1] = height_win - height_bs1 - height_bs2 - 80;
                                              dimension[2] = height_bs1 + height_bs1/3;

                                              Shiny.onInputChange("dimension", dimension);
                                            });
                                            ')
                         ))
  )
  # END OF BODY
)
