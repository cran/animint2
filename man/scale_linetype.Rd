% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/scale-linetype.r
\name{scale_linetype}
\alias{scale_linetype}
\alias{scale_linetype_continuous}
\alias{scale_linetype_discrete}
\title{Scale for line patterns.}
\usage{
scale_linetype(..., na.value = "blank")

scale_linetype_continuous(...)

scale_linetype_discrete(..., na.value = "blank")
}
\arguments{
\item{...}{common discrete scale parameters: \code{name}, \code{breaks},
\code{labels}, \code{na.value}, \code{limits} and \code{guide}.  See
\code{\link{discrete_scale}} for more details}

\item{na.value}{The linetype to use for \code{NA} values.}
}
\description{
Default line types based on a set supplied by Richard Pearson,
University of Manchester.  Line types can not be mapped to continuous
values.
}
\examples{
base <- ggplot(economics_long, aes(date, value01))
base + geom_line(aes(group = variable))
base + geom_line(aes(linetype = variable))

# See scale_manual for more flexibility
}
