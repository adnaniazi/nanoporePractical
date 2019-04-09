#' Title
#'
#' @param quality_score_string
#'
#' @return
#' @export
#'
#' @examples
decode_quality_scores <- function(quality_score_string) {
  quality_map<- list('!'= '0 ',
                     '"'= '1 ',
                     #2–9 6
                     '#'= '2 ',
                     '$'= '3 ',
                     '%'= '4 ',
                     '&'= '5 ',
                     "'"= '6 ',
                     '\\'= 'x ',
                     '('= '7 ',
                     ')'= '8 ',
                     '*'= '9 ',
                     #10–19 15
                     '+'= '10' ,
                     ','= '11' ,
                     '-'= '12' ,
                     '.'= '13' ,
                     '/'= '14' ,
                     '0'= '15' ,
                     '1'= '16' ,
                     '2'= '17' ,
                     '3'= '18' ,
                     '4'= '19' ,
                     #20–24 22
                     '5'= '20',
                     '6'= '21',
                     '7'= '22',
                     '8'= '23',
                     '9'= '24',
                     #25–29 27
                     ':'= '25',
                     ';'= '26',
                     '<'= '27',
                     '='= '28',
                     '>'= '29',
                     #30–34 33
                     '?'= '30',
                     '@'= '31',
                     'A'= '32',
                     'B'= '33',
                     'C'= '34',
                     #35–39 37
                     'D'= '35',
                     'E'= '36',
                     'F'= '37',
                     'G'= '38',
                     'H'= '39',
                     #≥ 40 40
                     'I'= '40',
                     'J'= '41')

  decoded_string = ''
  for (i in seq(nchar(quality_score_string))) {
    decoded_string <- paste0(decoded_string, quality_map[substr(quality_score_string, i, i)], ' ')
  }

  decoded_string <- substr(decoded_string, 1, nchar(decoded_string)-1)
  return(decoded_string)
}
