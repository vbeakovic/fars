context("Testing summary function")
test_that("Accidents data installed with package", {
  testthat::expect_equal(list.files(system.file("extdata", package = "fars")),
                         c("accident_2013.csv.bz2",
                           "accident_2014.csv.bz2",
                           "accident_2015.csv.bz2"))
})

test_that("Omitting the year argument produces and error", {
  testthat::expect_error(fars_summarize_years())
})

test_that("Summary for year 2013 is correct", {
  expect_output_file(print(fars_summarize_years(2013)), "year2013.txt", update = FALSE)
})

test_that("Summary for year 2014 is correct", {
  expect_output_file(print(fars_summarize_years(2014)), "year2014.txt", update = FALSE)
})

test_that("Summary for year 2015 is correct", {
  expect_output_file(print(fars_summarize_years(2015)), "year2015.txt", update = FALSE)
})
