% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/geom-freqpoly.r, R/geom-histogram.r,
%   R/stat-bin.r
\name{geom_freqpoly}
\alias{geom_freqpoly}
\alias{geom_histogram}
\alias{stat_bin}
\title{Histograms and frequency polygons.}
\usage{
geom_freqpoly(
  mapping = NULL,
  data = NULL,
  stat = "bin",
  position = "identity",
  ...,
  na.rm = FALSE,
  show.legend = NA,
  inherit.aes = TRUE
)

geom_histogram(
  mapping = NULL,
  data = NULL,
  stat = "bin",
  position = "stack",
  ...,
  binwidth = NULL,
  bins = NULL,
  na.rm = FALSE,
  show.legend = NA,
  inherit.aes = TRUE
)

stat_bin(
  mapping = NULL,
  data = NULL,
  geom = "bar",
  position = "stack",
  ...,
  binwidth = NULL,
  bins = NULL,
  center = NULL,
  boundary = NULL,
  closed = c("right", "left"),
  pad = FALSE,
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

\item{na.rm}{If \code{FALSE} (the default), removes missing values with
a warning.  If \code{TRUE} silently removes missing values.}

\item{show.legend}{logical. Should this layer be included in the legends?
\code{NA}, the default, includes if any aesthetics are mapped.
\code{FALSE} never includes, and \code{TRUE} always includes.}

\item{inherit.aes}{If \code{FALSE}, overrides the default aesthetics,
rather than combining with them. This is most useful for helper functions
that define both data and aesthetics and shouldn't inherit behaviour from
the default plot specification, e.g. \code{\link{borders}}.}

\item{binwidth}{The width of the bins. The default is to use \code{bins}
  bins that cover the range of the data. You should always override
  this value, exploring multiple widths to find the best to illustrate the
  stories in your data.

  The bin width of a date variable is the number of days in each time; the
  bin width of a time variable is the number of seconds.}

\item{bins}{Number of bins. Overridden by \code{binwidth}. Defaults to 30}

\item{geom, stat}{Use to override the default connection between
\code{geom_histogram}/\code{geom_freqpoly} and \code{stat_bin}.}

\item{center}{The center of one of the bins.  Note that if center is above or
below the range of the data, things will be shifted by an appropriate
number of \code{width}s. To center on integers, for example, use
\code{width=1} and \code{center=0}, even if \code{0} is outside the range
of the data.  At most one of \code{center} and \code{boundary} may be
specified.}

\item{boundary}{A boundary between two bins. As with \code{center}, things
are shifted when \code{boundary} is outside the range of the data. For
example, to center on integers, use \code{width = 1} and \code{boundary =
0.5}, even if \code{1} is outside the range of the data.  At most one of
\code{center} and \code{boundary} may be specified.}

\item{closed}{One of \code{"right"} or \code{"left"} indicating whether right
or left edges of bins are included in the bin.}

\item{pad}{If \code{TRUE}, adds empty bins at either end of x. This ensures
frequency polygons touch 0. Defaults to \code{FALSE}.}
}
\description{
Display a 1d distribution by dividing into bins and counting the number
of observations in each bin. Histograms use bars; frequency polygons use
lines.
}
\details{
By default, \code{stat_bin} uses 30 bins - this is not a good default,
but the idea is to get you experimenting with different binwidths. You
may need to look at a few to uncover the full story behind your data.
}
\section{Aesthetics}{

\code{geom_histogram} uses the same aesthetics as \code{geom_bar};
\code{geom_freqpoly} uses the same aesthetics as \code{geom_line}.
}

\section{Computed variables}{

\describe{
  \item{count}{number of points in bin}
  \item{density}{density of points in bin, scaled to integrate to 1}
  \item{ncount}{count, scaled to maximum of 1}
  \item{ndensity}{density, scaled to maximum of 1}
}
}

\examples{
ggplot(diamonds, aes(carat)) +
  geom_histogram()
ggplot(diamonds, aes(carat)) +
  geom_histogram(binwidth = 0.01)
ggplot(diamonds, aes(carat)) +
  geom_histogram(bins = 200)

# Rather than stacking histograms, it's easier to compare frequency
# polygons
ggplot(diamonds, aes(price, fill = cut)) +
  geom_histogram(binwidth = 500)
ggplot(diamonds, aes(price, colour = cut)) +
  geom_freqpoly(binwidth = 500)

# To make it easier to compare distributions with very different counts,
# put density on the y axis instead of the default count
ggplot(diamonds, aes(price, ..density.., colour = cut)) +
  geom_freqpoly(binwidth = 500)

if (require("ggplot2movies")) {
# Often we don't want the height of the bar to represent the
# count of observations, but the sum of some other variable.
# For example, the following plot shows the number of movies
# in each rating.
m <- ggplot(movies, aes(rating))
m + geom_histogram(binwidth = 0.1)

# If, however, we want to see the number of votes cast in each
# category, we need to weight by the votes variable
m + geom_histogram(aes(weight = votes), binwidth = 0.1) + ylab("votes")

# For transformed scales, binwidth applies to the transformed data.
# The bins have constant width on the transformed scale.
m + geom_histogram() + scale_x_log10()
m + geom_histogram(binwidth = 0.05) + scale_x_log10()

# For transformed coordinate systems, the binwidth applies to the
# raw data. The bins have constant width on the original scale.

# Using log scales does not work here, because the first
# bar is anchored at zero, and so when transformed becomes negative
# infinity. This is not a problem when transforming the scales, because
# no observations have 0 ratings.
m + geom_histogram(origin = 0) + coord_trans(x = "log10")
# Use origin = 0, to make sure we don't take sqrt of negative values
m + geom_histogram(origin = 0) + coord_trans(x = "sqrt")

}
rm(movies)
}
\seealso{
\code{\link{stat_count}}, which counts the number of cases at each x
  posotion, without binning. It is suitable for both discrete and continuous
  x data, whereas \link{stat_bin} is suitable only for continuous x data.
}
