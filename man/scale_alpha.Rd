% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/scale-alpha.r
\name{scale_alpha}
\alias{scale_alpha}
\alias{scale_alpha_continuous}
\alias{scale_alpha_discrete}
\title{Alpha scales.}
\usage{
scale_alpha(..., range = c(0.1, 1))

scale_alpha_continuous(..., range = c(0.1, 1))

scale_alpha_discrete(..., range = c(0.1, 1))
}
\arguments{
\item{...}{Other arguments passed on to \code{\link{continuous_scale}}
or \code{\link{discrete_scale}} as appropriate, to control name, limits,
breaks, labels and so forth.}

\item{range}{range of output alpha values.  Should lie between 0 and 1.}
}
\description{
\code{scale_alpha} is an alias for \code{scale_alpha_continuous} since
that is the most common use of alpha, and it saves a bit of typing.
}
\examples{
(p <- ggplot(mtcars, aes(mpg, cyl)) +
  geom_point(aes(alpha = cyl)))
p + scale_alpha("cylinders")
p + scale_alpha("number\nof\ncylinders")

p + scale_alpha(range = c(0.4, 0.8))

(p <- ggplot(mtcars, aes(mpg, cyl)) +
  geom_point(aes(alpha = factor(cyl))))
p + scale_alpha_discrete(range = c(0.4, 0.8))
}
