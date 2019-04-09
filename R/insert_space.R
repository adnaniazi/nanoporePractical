#' bs
#' bs2
#'
#' @param character_string cs
#' @param num_spaces ns
#'
#' @return a val
#' @export
insert_space <- function(character_string, num_spaces) {
  #character_string <- tolower(character_string)
  character_string <- strsplit(character_string, split='')[[1]]
  if (num_spaces == 0){
    character_string <- paste(unlist(character_string), collapse = '')
  }

  if (num_spaces == 1){
    character_string <- paste(unlist(character_string), collapse = ' ')
  }

  if (num_spaces == 2){
    character_string <- paste(unlist(character_string), collapse = '  ')
  }

  if (num_spaces == 3){
    character_string <- paste(unlist(character_string), collapse = '   ')
  }

  return(character_string)
}
