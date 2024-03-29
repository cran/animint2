acontext("geom_point(aes(fill=numeric))")

viz <-
  list(fill=ggplot()+
       geom_point(aes(Sepal.Width, Petal.Width,
                      fill=Petal.Length),
                  data=iris, color="black", size=5, pch=21),
       size=ggplot()+
       geom_point(aes(Sepal.Width, Petal.Width,
                      size=Sepal.Length),
                  data=iris, color="black", fill="red", pch=21),
       color=ggplot()+
       geom_point(aes(Sepal.Width, Petal.Width,
                      color=Petal.Length),
                  data=iris, size=5)+
       scale_color_continuous("petal length"))

test_that("legends are produced", {
  info <- animint2dir(viz, open.browser=FALSE)
  expect_identical(names(info$plots$fill$legend), "Petal.Length")
  expect_identical(names(info$plots$size$legend), "Sepal.Length")
  expect_identical(names(info$plots$color$legend), "petal length")
})
