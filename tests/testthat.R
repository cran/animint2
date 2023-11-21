library(testthat)
data.table::setDTthreads(1)
test_check("animint2", filter="compiler")
