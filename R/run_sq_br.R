#' @export
run_squiggle_browser <- function() {
  appDir <- system.file("shiny-examples", "sq_br", package = "nanoporePractical")
  if (appDir == "") {
    stop("Could not find example directory. Try re-installing `nanoporePractical`.", call. = FALSE)
  }

  shiny::runApp(appDir, display.mode = "normal")
}
