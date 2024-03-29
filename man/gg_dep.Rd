% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/utilities.r
\name{gg_dep}
\alias{gg_dep}
\title{Give a deprecation error, warning, or message, depending on version number.}
\usage{
gg_dep(version, msg)
}
\arguments{
\item{version}{The last version of ggplot2 where this function was good
(in other words, the last version where it was not deprecated).}

\item{msg}{The message to print.}
}
\description{
Version numbers have the format <major>.<minor>.<subminor>, like 0.9.2.
This function compares the current version number of ggplot2 against the
specified \code{version}, which is the most recent version before the
function (or other object) was deprecated.
}
\details{
\code{gg_dep} will give an error, warning, or message, depending on the
difference between the current ggplot2 version and the specified
\code{version}.

If the current major number is greater than \code{version}'s major number,
or if the current minor number is more than 1 greater than \code{version}'s
minor number, give an error.

If the current minor number differs from \code{version}'s minor number by
one, give a warning.

If the current subminor number differs from \code{version}'s subminor
number, print a message.
}
\keyword{internal}
