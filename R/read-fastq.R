#' bs
#' 
#' bs2
#'
#' @param fastq_file_path ffp
#'
#' @return
#' @export
#'
#' @examples
read_fastq <- function(fastq_file_path) {
  con <- file(fastq_file_path, open="r")
  records <- readLines(con)
  close(con)

  quality_scores <- records[seq_along(records) %% 4 == 0]
  fastq_sequences <- records[seq_along(records) %% 4 == 2]
  sequence_ids <- records[seq_along(records) %% 4 == 1]
  sequence_ids <- sapply(sequence_ids,
                         FUN = function(d){substring(d, regexpr('@',d) + 1, nchar(d))},
                         USE.NAMES=FALSE)

  fastq_data <- data.frame(id=sequence_ids,
                           sequence=fastq_sequences,
                           quality_score=quality_scores,
                           stringsAsFactors = FALSE)

  return(fastq_data)
}

#fastq_data <- read_fastq('~/Downloads/SP1.fq')



