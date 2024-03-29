% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/geom-violin.r, R/stat-ydensity.r
\name{geom_violin}
\alias{geom_violin}
\alias{stat_ydensity}
\title{Violin plot.}
\usage{
geom_violin(
  mapping = NULL,
  data = NULL,
  stat = "ydensity",
  position = "dodge",
  ...,
  draw_quantiles = NULL,
  trim = TRUE,
  scale = "area",
  na.rm = FALSE,
  show.legend = NA,
  inherit.aes = TRUE
)

stat_ydensity(
  mapping = NULL,
  data = NULL,
  geom = "violin",
  position = "dodge",
  ...,
  bw = "nrd0",
  adjust = 1,
  kernel = "gaussian",
  trim = TRUE,
  scale = "area",
  na.rm = FALSE,
  show.legend = NA,
  inherit.aes = TRUE
)
}
\arguments{
\item{mapping}{Set of aesthetic mappings created by \code{\link{aes}} or
\code{\link{aes_}}. If specified and \code{inherit.aes = TRUE} (the
default), it is combined with the default mapping at the top level of the
plot. You must supply \code{mapping} if there is no plot mapping.}

\item{data}{The data to be displayed in this layer. There are three
   options:

   If \code{NULL}, the default, the data is inherited from the plot
   data as specified in the call to \code{\link{ggplot}}.

   A \code{data.frame}, or other object, will override the plot
   data. All objects will be fortified to produce a data frame. See
   \code{\link{fortify}} for which variables will be created.

   A \code{function} will be called with a single argument,
   the plot data. The return value must be a \code{data.frame.}, and
   will be used as the layer data.}

\item{position}{Position adjustment, either as a string, or the result of
a call to a position adjustment function.}

\item{...}{other arguments passed on to \code{\link{layer}}. These are
often aesthetics, used to set an aesthetic to a fixed value, like
\code{color = "red"} or \code{size = 3}. They may also be parameters
to the paired geom/stat.}

\item{draw_quantiles}{If \code{not(NULL)} (default), draw horizontal lines
at the given quantiles of the density estimate.}

\item{trim}{If \code{TRUE} (default), trim the tails of the violins
to the range of the data. If \code{FALSE}, don't trim the tails.}

\item{scale}{if "area" (default), all violins have the same area (before trimming
the tails). If "count", areas are scaled proportionally to the number of
observations. If "width", all violins have the same maximum width.}

\item{na.rm}{If \code{FALSE} (the default), removes missing values with
a warning.  If \code{TRUE} silently removes missing values.}

\item{show.legend}{logical. Should this layer be included in the legends?
\code{NA}, the default, includes if any aesthetics are mapped.
\code{FALSE} never includes, and \code{TRUE} always includes.}

\item{inherit.aes}{If \code{FALSE}, overrides the default aesthetics,
rather than combining with them. This is most useful for helper functions
that define both data and aesthetics and shouldn't inherit behaviour from
the default plot specification, e.g. \code{\link{borders}}.}

\item{geom, stat}{Use to override the default connection between
\code{geom_violin} and \code{stat_ydensity}.}

\item{bw}{the smoothing bandwidth to be used, see
\code{\link{density}} for details}

\item{adjust}{adjustment of the bandwidth, see
\code{\link{density}} for details}

\item{kernel}{kernel used for density estimation, see
\code{\link{density}} for details}
}
\description{
Violin plot.
}
\section{Aesthetics}{

\Sexpr[results=rd,stage=build]{animint2:::rd_aesthetics("geom", "violin")}
}

\section{Computed variables}{

\describe{
  \item{density}{density estimate}
  \item{scaled}{density estimate, scaled to maximum of 1}
  \item{count}{density * number of points - probably useless for violin plots}
  \item{violinwidth}{density scaled for the violin plot, according to area, counts
                     or to a constant maximum width}
  \item{n}{number of points}
  \item{width}{width of violin bounding box}
}
}

\examples{
p <- ggplot(mtcars, aes(factor(cyl), mpg))
p + geom_violin()

\donttest{
p + geom_violin() + geom_jitter(height = 0)
p + geom_violin() + coord_flip()

# Scale maximum width proportional to sample size:
p + geom_violin(scale = "count")

# Scale maximum width to 1 for all violins:
p + geom_violin(scale = "width")

# Default is to trim violins to the range of the data. To disable:
p + geom_violin(trim = FALSE)

# Use a smaller bandwidth for closer density fit (default is 1).
p + geom_violin(adjust = .5)

# Add aesthetic mappings
# Note that violins are automatically dodged when any aesthetic is
# a factor
p + geom_violin(aes(fill = cyl))
p + geom_violin(aes(fill = factor(cyl)))
p + geom_violin(aes(fill = factor(vs)))
p + geom_violin(aes(fill = factor(am)))

# Set aesthetics to fixed value
p + geom_violin(fill = "grey80", colour = "#3366FF")

# Show quartiles
p + geom_violin(draw_quantiles = c(0.25, 0.5, 0.75))

# Scales vs. coordinate transforms -------
if (require("ggplot2movies")) {
# Scale transformations occur before the density statistics are computed.
# Coordinate transformations occur afterwards.  Observe the effect on the
# number of outliers.
m <- ggplot(movies, aes(y = votes, x = rating, group = cut_width(rating, 0.5)))
m + geom_violin()
m + geom_violin() + scale_y_log10()
m + geom_violin() + coord_trans(y = "log10")
m + geom_violin() + scale_y_log10() + coord_trans(y = "log10")

# Violin plots with continuous x:
# Use the group aesthetic to group observations in violins
ggplot(movies, aes(year, budget)) + geom_violin()
ggplot(movies, aes(year, budget)) +
  geom_violin(aes(group = cut_width(year, 10)), scale = "width")
}
}
}
\references{
Hintze, J. L., Nelson, R. D. (1998) Violin Plots: A Box
Plot-Density Trace Synergism. The American Statistician 52, 181-184.
}
\seealso{
\code{\link{geom_violin}} for examples, and \code{\link{stat_density}}
  for examples with data along the x axis.
}
