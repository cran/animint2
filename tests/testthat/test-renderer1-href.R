acontext("aes(href)")

color.df <- data.frame(
  x=c(1, 1, 2, 1, 2),
  university=c(
    "Stanford",
    rep("UC Berkeley", 2),
    rep("Oregon State", 2)),
  color=c("red", "blue", "gold", "orange", "black"))
university.df <- as.data.frame(table(color.df$university))
names(university.df) <- c("university", "colors")

test_that("clickSelects and href is an error", {
  viz <- list(
    colors=ggplot()+
      geom_point(aes(
        x, university, color=color, href=color),
        clickSelects="university",
        data=color.df)+
      scale_color_identity())
  expect_error({
    animint2dir(viz, open.browser=FALSE)
  }, "clickSelects can not be used with aes(href)", fixed=TRUE)
})

test_that("aes(href) becomes <a href>", {
  viz <- list(
    universities=ggplot()+
      geom_bar(aes(
        university, colors,
        id=university),
        clickSelects="university",
        data=university.df, stat="identity"),
    colors=ggplot()+
      geom_point(aes(
        x, university, color=color,
        href=paste0("http://en.wikipedia.org/wiki/", color)),
        showSelected="university",
        data=color.df, size=5)+
      scale_color_identity(),
    first=list(university="UC Berkeley"))
  info <- animint2HTML(viz)
  expected.links <- c(
    "http://en.wikipedia.org/wiki/blue",
    "http://en.wikipedia.org/wiki/gold")
  expect_links(info$html, expected.links)
})

test_that("clicking updates href", {
  stanford.html <- clickHTML("id"="Stanford")
  expect_links(stanford.html, "http://en.wikipedia.org/wiki/red")
})

test_that("clicking updates href (again)", {
  osu.html <- clickHTML("id"="Oregon State")
  expect_links(osu.html,
               c("http://en.wikipedia.org/wiki/orange",
                 "http://en.wikipedia.org/wiki/black"))
})

test_that("aes(href) works with geom_polygon", {
  USpolygons <- map_data("state")
  USpolygons$href <- paste0("https://en.wikipedia.org/wiki/", USpolygons$region)
  viz.href <- list(
    map=ggplot()+
      ggtitle("click a state to read its Wikipedia page")+
      coord_equal()+
      geom_polygon(
        aes(x=long, y=lat, group=group, href=href),
        data=USpolygons, fill="black", colour="grey")
  )
  info <- animint2HTML(viz.href)
  (expected.vec <- unique(USpolygons$href))
  expect_links(info$html, expected.vec)
})
