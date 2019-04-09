#' @export
run_fastq_viewer <- function() {
  appDir <- system.file("shiny-examples", "fsatqe", package = "nanoporePractical")
  if (appDir == "") {
    stop("Could not find example directory. Try re-installing `squiggleBrowseR`.", call. = FALSE)
  }

  shiny::runApp(appDir, display.mode = "showcase")
}
