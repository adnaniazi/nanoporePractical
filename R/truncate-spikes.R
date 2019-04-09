#' Truncate spikes
#'
#' It has been observed that the signal contains a lot of high-voltage spikes
#' distributed throughout the lenght of the read. This function truncates/clips
#' these spikes to a specified threshold value
#'
#' @param threshold
#' @param data Data that needs its spikes to be truncated
#' @param data_mean
#' @param data_sd
#'
#' @return Same data as input but with spikes clipped
#' @export
#' @examples
#'
truncate_data_spikes <- function (data, data_mean, data_sd, threshold=2){
    upper_limit <- data_mean + data_sd*threshold
    lower_limit <- data_mean - data_sd*threshold
    data[data > upper_limit] <- upper_limit
    data[data < lower_limit] <- lower_limit
    return(data)
}
