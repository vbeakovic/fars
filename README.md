[![Travis build status](https://travis-ci.org/vbeakovic/fars.svg?branch=master)](https://travis-ci.org/vbeakovic/fars)


# R Package for exploring NHTSA's FARS data

NHTSA - US National Highway Traffic Safety Administration
FARS - Fatality Analysis Reporting System

The package cointains data and functions to explore data about fatal injuries suffered in motor veichle trafic crashes.
It was developed as an assignment to complete the "Building R Packages" course that is part of the Mastering Software Development in R (a JHU specialization on Coursera).

## Usage

The package comes with raw data that is in the inst/extdata folder. At the moment is spans from 2013 to 2015. Two functions are available to analyse the injuries data:

```
fars_summarize_years(year)
```
To check at monthly summaries per year(s)


```
fars_map_state(state.num, year)
```
To see the locations of the accidents per state

For more details check the package vignette.


## How to install it

To install the stable CRAN version:

    install.packages("shinyjs")

To install the latest development version from GitHub:

    install.packages("devtools")
    devtools::install_github("vbeakovic/fars")
    
    



