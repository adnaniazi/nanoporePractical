#' bs
#' bs
#'
#' @param fastq_data data
#' @param display_sequence seq
#' @param display_emoji emoji
#' @param display_encoded_quality qu
#' @param display_decoded_quality dq
#'
#' @return ds
#' @export
#'
#' @examples
create_formatted_string <- function(fastq_data,
                                    display_sequence_id=TRUE,
                                    display_sequence=TRUE,
                                    display_emoji=TRUE,
                                    display_encoded_quality=FALSE,
                                    display_decoded_quality=FALSE) {

  fastq_data$emoji <- lapply(fastq_data[, c('quality_score')],  function(x) map_binned(x))

  formatted_string <- ''
  for (i in seq(nrow(fastq_data))){
    if (display_sequence_id) formatted_string <- paste0(formatted_string, fastq_data$id[i], '\n')
    if (display_sequence) {
      sequence <- insert_space(fastq_data$sequence[i], num_spaces = 2)
      formatted_string <- paste0(formatted_string, sequence, '\n')
    }

    if (display_encoded_quality) {
      quality_score <- insert_space(fastq_data$quality_score[i], num_spaces = 2)
      formatted_string <- paste0(formatted_string, quality_score, '\n')
    }

    if (display_decoded_quality) {
      decode_quality_scores <- decode_quality_scores(fastq_data$quality_score[i])
      formatted_string <- paste0(formatted_string, decode_quality_scores, '\n')
    }
    if (display_emoji) formatted_string <- paste0(formatted_string, fastq_data$emoji[i], '\n')

    formatted_string <- paste0(formatted_string, '\n')

  }

  return(formatted_string)
}

# fastq_data <- read_fastq('~/Downloads/SP1.fq')
# fs <- create_formatted_string(fastq_data)
