shiny::shinyServer(function(input, output, session) {
  current_read_in_session <- 0
  fast5_files_in_session <- NULL

  # get user-specified directory
  shinyFiles::shinyDirChoose(input, 'button_dir',
                             roots = c(home = '~'),
                             filetypes = c('', '*.fast5$'))
  dir <- shiny::reactive(input$button_dir)

  # make a proper directory path
  path <- shiny::reactive({
    home <- normalizePath("~", winslash = '/')
    if (Sys.info()[['sysname']] == "Windows") {
      home <- gsub('*Documents', '', home)
    }
    result = tryCatch({
      lfp <- file.path(home, paste(unlist(dir()$path[-1]), collapse = .Platform$file.sep))
      if (Sys.info()[['sysname']] == "Windows") {
        lfp <- gsub("//", "/", lfp)
      }
      lfp
    }, warning = function(w) {
      'warning-handler-code'
    }, error = function(e) {
       NULL
    }, finally = {
      'cleanup-code'
    })
  })

  # dispay the chosen directory
  output$text_dir <- shiny::renderText(path())

  files_list <- shiny::reactive({
     result = tryCatch({
      list.files(path = path(),
                 recursive = TRUE,
                 pattern = '*.fast5$',
                 full.names = FALSE)
    }, warning = function(w) {
      'warning-handler-code'
    }, error = function(e) {
      NULL
    }, finally = {
      'cleanup-code'
    })
  })

  # populate the select input with reads
  shiny::observe({
    files <- files_list()
    fast5_files_in_session <<- files
    current_read_in_session <<- 1
    shiny::updateSelectInput(session, "selectInput_currentread",
                             choices = files)
    })

  # observe the next and previous button, and also the selectInput
  # for clicks and go forward or backwords in reads list
  shiny::observeEvent(input$button_next, {
    current_read_in_session <<- current_read_in_session + 1
    if (current_read_in_session > length(fast5_files_in_session)) {
      current_read_in_session <<- length(fast5_files_in_session)
    }
    shiny::updateSelectInput(session, "selectInput_currentread",
                             choices = fast5_files_in_session,
                             selected = fast5_files_in_session[current_read_in_session])
  })

  shiny::observeEvent(input$button_previous, {
    current_read_in_session <<- current_read_in_session - 1
    if (current_read_in_session < 1) {
      current_read_in_session <<- 1
    }
    shiny::updateSelectInput(session, "selectInput_currentread",
                             choices = fast5_files_in_session,
                             selected = fast5_files_in_session[current_read_in_session])
  })

  shiny::observeEvent(input$selectInput_currentread, {
    current_read_in_session <<- match(input$selectInput_currentread,
                                      fast5_files_in_session)
  })

  current_read <- shiny::eventReactive(input$selectInput_currentread, {
    input$selectInput_currentread
  })

  f5_data <- shiny::reactive({
    # set the highlight slider to default
    shiny::updateSliderInput(inputId = 'highlight_slider', value = c(0,1), session = session)

    fast5file_path <- file.path(path(), current_read())

    current_read_path <- current_read()
    if (length(fast5file_path) == 0 | current_read_path == '') {
      return(NULL)
    }

    basecall_group <- input$basecall_group
    print(basecall_group)
    datatype <- explore_basecaller_and_fast5type(fast5file_path=fast5file_path,
                                                 basecall_group=basecall_group)
    read_data <- extract_read_data (file_path = fast5file_path,
                                    read_id_fast5_file = NA,
                                    plot_debug = TRUE,
                                    basecalled_with = datatype$basecalled_with,
                                    basecall_group = basecall_group,
                                    multifast5 = FALSE,
                                    model = datatype$model,
                                    plotting_library = 'rbokeh')
  })


  output$rbokeh <- rbokeh::renderRbokeh({
    read_data <- f5_data()

    if (is.null(read_data)) {
      p1 <- rbokeh::figure()
      return(p1)
    }

    plot_width <- round(input$dimension[1], digits = 0)
    plot_height <- round(input$dimension[2], digits = 0)
    #plot_height <- 300
    print(input$dimension[1])
    print(input$dimension[2])

    #return(NULL)
    chkb <- input$checkboxes_preprocess
    zn <- "z_normalize"     %in% input$checkboxes_preprocess
    ts <- "truncate_spikes" %in% input$checkboxes_preprocess

    if(is.null(chkb)) {
      z_normalize <- FALSE
      truncate_spikes <- FALSE
    } else if (zn & ts) {
      z_normalize <- TRUE
      truncate_spikes <- TRUE
    } else if (ts) {
      truncate_spikes <- TRUE
      z_normalize <- FALSE
    } else if (zn) {
      z_normalize <- TRUE
      truncate_spikes <- FALSE
    }

    #default_highlight_min <- round(data_length/4, digits = 0)
    #default_highlight_max <- round(data_length/3, digits = 0)
    #highlight_region <- c(default_highlight_min, default_highlight_max)
    if (input$checkbox_highlight){
      shinyjs::show(id='row4')
      plot_height <- round(input$dimension[2] - input$dimension[3], digits = 0)

      #if first time the
      if (input$highlight_slider[1] == 0 & input$highlight_slider[2] == 1) {
        data_length <- length(read_data$raw_data)
        default_highlight_min <- round(data_length/4, digits = 0)
        default_highlight_max <- round(data_length/3, digits = 0)
        highlight_region <- c(default_highlight_min, default_highlight_max)
        shiny::updateSliderInput(session, inputId = 'highlight_slider',
                                 min = 0, max=length(read_data$raw_data),
                                 value = highlight_region)
      } else {
        highlight_region <- input$highlight_slider
      }

    } else {
      shinyjs::hide(id='row4')
      plot_height <- round(input$dimension[2], digits = 0)
    }

    #highlight_region <- input$highlight_slider
    #print(highlight_region)

    p <- make_plot(read_data = read_data,
                   width = plot_width,
                   height = plot_height,
                   z_normalize = z_normalize,
                   truncate_spikes = truncate_spikes,
                   highlight = input$checkbox_highlight,
                   highlight_region = highlight_region)
    })


  shiny::observeEvent(input$highlight_slider, {
    input$highlight_slider
  })

})
