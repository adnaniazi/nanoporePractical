#' bs
#' 
#' bs2
#'
#' @param read_data rd
#' @param width w
#' @param height h
#' @param z_normalize zn
#' @param truncate_spikes ts
#'
#' @return
#' @export
#'
#' @examples
make_plot <- function(read_data,
                      width,
                      height,
                      z_normalize=FALSE,
                      truncate_spikes=FALSE,
                      highlight = FALSE,
                      highlight_region = NULL) {

  raw_data <- read_data$raw_data

  if (z_normalize & truncate_spikes) {
    raw_data <- z_normalize(raw_data)
    raw_data <- truncate_data_spikes(raw_data, data_mean=0, data_sd=1, threshold=3)
  } else if (z_normalize) {
    raw_data <- z_normalize(raw_data)
  } else if (truncate_spikes) {
    data_mean <- mean(raw_data, na.rm = TRUE)
    data_sd <- sd(raw_data, na.rm = TRUE)
    raw_data <- truncate_data_spikes(raw_data, data_mean=data_mean, data_sd=data_sd, threshold=3)
  }

  df <-  data.frame(x = c(0:(length(raw_data)-1)),
                    raw_data = raw_data
                    )

  event_data <- read_data$event_data
  plot_title <- paste('Read ID: ', read_data$read_id, '  |  ',
                      'Samples per nt: ', round(read_data$samples_per_nt, 2),
                      sep='')
  p1 <- rbokeh::figure(data=df,
                       legend_location="top_left",
                       padding_factor = 0)
  p3 <- rbokeh::figure(data=data.frame(x=event_data$start,
                                       y=event_data$move/2),
                       legend_location="top_left", ygrid = FALSE,
                       padding_factor = 0)

  # poly(A)/(T) plot
  p1 <- p1 %>%
    rbokeh::ly_lines(x=x, y=raw_data, width=1.5, color='#b2b2b2', legend = "Raw data") %>%
    rbokeh::y_axis(label='pA', num_minor_ticks=2) %>%
    rbokeh::x_axis(label='Sample index') %>%
    rbokeh::tool_pan(dimensions = "width") %>%
    rbokeh::tool_wheel_zoom(dimensions = "width")

  if (highlight) {
    start <- highlight_region[1]
    end <- highlight_region[2]
    highlighted_data <- c(rep(NA, times = start),
                          raw_data[(start+1):end],
                          rep(NA, times = (length(raw_data) - end)))
    p1 <- p1 %>% rbokeh::ly_lines(x=x, y=highlighted_data, width=1.5, color='#e6297d', legend = "Highlighted region")
  }

  # plot containing the moves
  p3 <- p3 %>% rbokeh::ly_crect(x=x,
                                y=y,
                                width=rep(0.01, nrow(event_data)),
                                height=event_data$move,
                                color='#529c82') %>%
    rbokeh::y_axis(label='', num_minor_ticks=0, desired_num_ticks = 3) %>%
    rbokeh::x_axis(label='Sample index') %>%
    rbokeh::tool_pan(dimensions = "width") %>%
    rbokeh::tool_wheel_zoom(dimensions = "width")

  lst <- list(p1, p3)
  names(lst) <- c(plot_title, 'Moves')
  nrow <- 2
  p <- rbokeh::grid_plot(lst,
                         nrow = nrow,
                         #link_data = TRUE,
                         same_axes = c(TRUE, FALSE),
                         width = width,
                         height = height)
  return(p)
}
