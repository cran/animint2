% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/geom-ribbon.r
\name{geom_ribbon}
\alias{geom_ribbon}
\alias{geom_area}
\title{Ribbons and area plots.}
\usage{
geom_ribbon(
  mapping = NULL,
  data = NULL,
  stat = "identity",
  position = "identity",
  ...,
  na.rm = FALSE,
  show.legend = NA,
  inherit.aes = TRUE
)

geom_area(
  mapping = NULL,
  data = NULL,
  stat = "identity",
  position = "stack",
  na.rm = FALSE,
  show.legend = NA,
  inherit.aes = TRUE,
  ...
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

\item{stat}{The statistical transformation to use on the data for this
layer, as a string.}

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
}
\description{
For each continuous x value, \code{geom_interval} displays a y interval.
\code{geom_area} is a special case of \code{geom_ribbon}, where the
minimum of the range is fixed to 0.
}
\details{
An area plot is the continuous analog of a stacked bar chart (see
\code{\link{geom_bar}}), and can be used to show how composition of the
whole varies over the range of x.  Choosing the order in which different
components is stacked is very important, as it becomes increasing hard to
see the individual pattern as you move up the stack.
}
\section{Aesthetics}{

\Sexpr[results=rd,stage=build]{animint2:::rd_aesthetics("geom", "ribbon")}
}

\examples{
# Generate data
huron <- data.frame(year = 1875:1972, level = as.vector(LakeHuron))
h <- ggplot(huron, aes(year))

h + geom_ribbon(aes(ymin=0, ymax=level))
h + geom_area(aes(y = level))

# Add aesthetic mappings
h +
  geom_ribbon(aes(ymin = level - 1, ymax = level + 1), fill = "grey70") +
  geom_line(aes(y = level))
}
\seealso{
\code{\link{geom_bar}} for discrete intervals (bars),
  \code{\link{geom_linerange}} for discrete intervals (lines),
  \code{\link{geom_polygon}} for general polygons
}
