#' @export
run_file_picker <- function() {
  appDir <- system.file("shiny-examples", "file_picker", package = "squiggleBrowseR")
  if (appDir == "") {
    stop("Could not find example directory. Try re-installing `squiggleBrowseR`.", call. = FALSE)
  }

  shiny::runApp(appDir, display.mode = "normal")
}
