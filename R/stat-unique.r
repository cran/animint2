#' Remove duplicates.
#'
#' @export
#' @inheritParams layer
#' @inheritParams geom_point
#' @examples
#' ggplot(mtcars, aes(vs, am)) + geom_point(alpha = 0.1)
#' ggplot(mtcars, aes(vs, am)) + geom_point(alpha = 0.1, stat="unique")
stat_unique <- function(mapping = NULL, data = NULL,
                        geom = "point", position = "identity",
                        ...,
                        na.rm = FALSE,
                        show.legend = NA,
                        inherit.aes = TRUE) {
  layer(
    data = data,
    mapping = mapping,
    stat = StatUnique,
    geom = geom,
    position = position,
    show.legend = show.legend,
    inherit.aes = inherit.aes,
    params = list(
      na.rm = na.rm,
      ...
    )
  )
}

#' @rdname animint2-gganimintproto
#' @format NULL
#' @usage NULL
#' @export
StatUnique <- gganimintproto("StatUnique", Stat,
  compute_panel = function(data, scales) unique(data)
)
