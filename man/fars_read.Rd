% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/fars_functions.R
\name{fars_read}
\alias{fars_read}
\title{Read in FARS data}
\usage{
fars_read(filename)
}
\arguments{
\item{filename}{A character string giving the name of the file from
to import the data from}
}
\value{
This function returns a data frame containing the fars data for a
   given year.
}
\description{
A helper (not exported) function used by \code{fars_read_years} and \code{fars_map_state}
functions. It takes a file name and reads in the data storing it in a data frame.
If the file does not exist the function throws an error.
}
\examples{
\dontrun{
fars_read("accident_2014.csv.bz2")
}

}
