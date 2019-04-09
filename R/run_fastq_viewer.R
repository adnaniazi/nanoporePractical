#' @export
run_fastq_viewer <- function() {
  appDir <- system.file("shiny-examples", "fastqe", package = "nanoporePractical")
  if (appDir == "") {
    stop("Could not find example directory. Try re-installing `nanoporePractical`.", call. = FALSE)
  }

  shiny::runApp(appDir, display.mode = "normal")
}
