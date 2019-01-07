context("Testing maps function")
test_that("Accidents data installed with package", {
  testthat::expect_equal(list.files(system.file("extdata", package = "fars")),
                         c("accident_2013.csv.bz2",
                           "accident_2014.csv.bz2",
                           "accident_2015.csv.bz2"))
})

test_that("Omitting the arguments produces an error", {
  testthat::expect_error(fars_map_state())
})


test_that("Omitting the year arguments produces an error", {
  testthat::expect_error(fars_map_state(1))
})


test_that("Omitting the wrong arguments produce an error", {
  testthat::expect_error(fars_map_state(130, 2130))
})

