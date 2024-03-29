% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/labels.r
\name{update_labels}
\alias{update_labels}
\title{Update axis/legend labels}
\usage{
update_labels(p, labels)
}
\arguments{
\item{p}{plot to modify}

\item{labels}{named list of new labels}
}
\description{
Update axis/legend labels
}
\examples{
p <- ggplot(mtcars, aes(mpg, wt)) + geom_point()
update_labels(p, list(x = "New x"))
update_labels(p, list(x = expression(x / y ^ 2)))
update_labels(p, list(x = "New x", y = "New Y"))
update_labels(p, list(colour = "Fail silently"))
}
