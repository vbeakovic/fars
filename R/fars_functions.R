#' Read in FARS data
#'
#' A helper (not exported) function used by \code{fars_read_years} and \code{fars_map_state}
#' functions. It takes a file name and reads in the data storing it in a data frame.
#' If the file does not exist the function throws an error.
#'
#' @param filename A character string giving the name of the file from
#'    to import the data from
#'
#' @return This function returns a data frame containing the fars data for a
#'    given year.
#'
#' @importFrom readr read_csv
#' @importFrom dplyr tbl_df
#'
#' @examples
#' \dontrun{
#' fars_read("accident_2014.csv.bz2")
#' }
#'
fars_read <- function(filename) {
        if (!file.exists(filename))
                stop("file '", filename, "' does not exist")
        data <- suppressMessages({
                readr::read_csv(filename, progress = FALSE)
        })
        dplyr::tbl_df(data)
}

#' Create complete file name for a given year
#'
#' A helper (not exported) function used by \code{fars_read_years} and \code{fars_map_state}
#' functions. It takes a year as argument and returns the complete file name
#' containing data for the given year.
#'
#' @param year A character string or numeric specifing the year.
#'
#' @return This function returns a character string containing the complete
#'    filename for the given year
#'
#' @examples
#' \dontrun{
#' make_filename(2013)
#' make_filename("2013")
#' }
#'
make_filename <- function(year) {
        year <- as.integer(year)
        sprintf("accident_%d.csv.bz2", year)
}

#' Read FARS data for multiple years
#'
#' A helper (not exported) function used by \code{fars_summarize_years} Function.
#' It reads in data for all the given years. The function selects the year and month
#' from every observation in the dataset.
#' If an invalid year is given the function generates a warning.
#'
#' @param years A numeric or character vector contining the year(s) for which
#' the data should be read in.
#'
#' @return This function returns a list of length that equals the length(number of years)
#'    of the input vector. Each element of the list contains a data frame with data
#'    of the corresponding year.
#'
#' @importFrom dplyr mutate select
#' @importFrom rlang .data
#' @importFrom magrittr %>%
#'
#' @examples
#' \dontrun{
#' fars_read_years(2013)
#' fars_read_years("2013")
#' fars_read_years(c(2013, 2014))
#' fars_read_years(c("2013", "2014"))
#' }
#'
fars_read_years <- function(years) {
        lapply(years, function(year) {
                file <- make_filename(year)
                tryCatch({
                        dat <- fars_read(file)
                        dplyr::mutate(dat, year = year) %>%
                                dplyr::select(.data$MONTH, .data$year)
                }, error = function(e) {
                        warning("invalid year: ", year)
                        return(NULL)
                })
        })
}

#' Number of acccidents per year and per month
#'
#' This is a function that summarises the number of accidents per year and  month.
#'
#' @param years A numeric or character vector contining the year(s) for which
#' the data should be summarized.
#'
#' @return This function returns a data frame with number of accidents
#'    summarized per year and month.
#'
#' @importFrom dplyr bind_rows group_by summarize
#' @importFrom tidyr spread
#' @importFrom rlang .data
#' @importFrom magrittr %>%
#'
#' @examples
#' \dontrun{
#' fars_summarize_years(2013)
#' fars_summarize_years("2013")
#' fars_summarize_years(c(2013, 2014))
#' fars_summarize_years(c("2013", "2014"))
#' }
#'
#' @export
fars_summarize_years <- function(years) {
        dat_list <- fars_read_years(years)
        dplyr::bind_rows(dat_list) %>%
                dplyr::group_by(.data$year, .data$MONTH) %>%
                dplyr::summarize(n = dplyr::n()) %>%
                tidyr::spread(.data$year, .data$n)
}

#' Visualize accident data on a map
#'
#' This is a function that vizualizes accident data on a map of the selected state.
#'
#' @param state.num A character or numeric specifing the state code.
#' @param year A character or numeric specifing the year.
#'
#' @return This function returns a map of the selected state with a point drawn
#'    on the map for each accident observation
#'
#' @importFrom dplyr filter
#' @importFrom maps map
#' @importFrom graphics points
#' @importFrom rlang .data
#'
#' @examples
#' \dontrun{
#' fars_map_state(1, 2014)
#' fars_map_state("28", "2015")
#' }
#'
#' @export
fars_map_state <- function(state.num, year) {
        filename <- make_filename(year)
        data <- fars_read(filename)
        state.num <- as.integer(state.num)

        if (!(state.num %in% unique(data$STATE)))
                stop("invalid STATE number: ", state.num)
        data.sub <- dplyr::filter(data, .data$STATE == state.num)
        if (nrow(data.sub) == 0L) {
                message("no accidents to plot")
                return(invisible(NULL))
        }
        is.na(data.sub$LONGITUD) <- data.sub$LONGITUD > 900
        is.na(data.sub$LATITUDE) <- data.sub$LATITUDE > 90
        with(data.sub, {
                maps::map("state", ylim = range(LATITUDE, na.rm = TRUE),
                          xlim = range(LONGITUD, na.rm = TRUE))
                graphics::points(LONGITUD, LATITUDE, pch = 46)
        })
}
