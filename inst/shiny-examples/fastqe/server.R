server <- shinyServer(function(input, output, session) {
  shinyFiles::shinyFileChoose(input, id = 'button_file_left',
                              roots = c(home = '~'),
                              filetypes = c('', 'fq', 'fastq'),
                              defaultPath = '',
                              defaultRoot = 'home')
  shinyFiles::shinyFileChoose(input, id = 'button_file_right',
                              roots = c(home = '~'),
                              filetypes = c('', 'fq', 'fastq'),
                              defaultPath = '',
                              defaultRoot = 'home')

  dir_left <- shiny::reactive(input$button_file_left)
  dir_right <- shiny::reactive(input$button_file_right)

  # make a proper directory path
  left_filepath <- shiny::reactive({
    if (is.integer(dir_left())) return(NULL)
    home <- normalizePath("~")
    result = tryCatch({
      file.path(home, paste(unlist(dir_left()[1]), collapse = .Platform$file.sep))
    }, warning = function(w) {
      'warning-handler-code'
    }, error = function(e) {
       NULL
    }, finally = {
      'cleanup-code'
    })
  })

  # make a proper directory path
  right_filepath <- shiny::reactive({
    if (is.integer(dir_right())) return(NULL)
    home <- normalizePath("~")
    result = tryCatch({
      file.path(home, paste(unlist(dir_right()[1]), collapse = .Platform$file.sep))
    }, warning = function(w) {
      'warning-handler-code'
    }, error = function(e) {
      NULL
    }, finally = {
      'cleanup-code'
    })
  })

  output$filepath_left <- shiny::renderText({
    left_filepath()
  })
  output$filepath_right <- shiny::renderText({
    right_filepath()
  })

  output$output_left <- shiny::renderText({
    if (is.integer(dir_left())) return(NULL)
    fastq_data <- read_fastq(left_filepath())
    fs <- create_formatted_string(fastq_data,
                                  display_sequence_id=input$checkbox_show_sequence_id,
                                  display_sequence=input$checkbox_show_sequence,
                                  display_emoji=input$checkbox_show_emoji,
                                  display_encoded_quality=input$checkbox_show_encoded_quality,
                                  display_decoded_quality=input$checkbox_show_decoded_quality)
  })

  output$output_right <- shiny::renderText({
    if (is.integer(dir_right())) return(NULL)
    fastq_data <- read_fastq(right_filepath())
    fs <- create_formatted_string(fastq_data,
                                  display_sequence_id=input$checkbox_show_sequence_id,
                                  display_sequence=input$checkbox_show_sequence,
                                  display_emoji=input$checkbox_show_emoji,
                                  display_encoded_quality=input$checkbox_show_encoded_quality,
                                  display_decoded_quality=input$checkbox_show_decoded_quality)
    })

  shiny::observeEvent(input$checkbox_show_emoji, {
    if (input$checkbox_show_emoji) {
      shinyjs::show("emoji_info")
    } else {
      shinyjs::hide("emoji_info")
    }
  })

})

shinyApp(ui = ui, server = server)
