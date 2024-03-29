acontext('facet_grid(space="free")')

no.panels <- ggplot(mtcars, aes(mpg, wt)) + 
  geom_point(colour='grey50', size = 4) + 
  geom_point(aes(colour = cyl)) 
viz <- animint(
  freeBoth = no.panels +
    ggtitle("space=free, scales=free")+
    facet_grid(.~am, space = "free", scales = "free", labeller=label_both),
  freeScale = no.panels +
    ggtitle("space=fixed, scales=free")+
    facet_grid(.~am, scales="free", labeller=label_both),
  fixed = no.panels +
    ggtitle("space=fixed, scales=fixed")+
    facet_grid(.~am, labeller=label_both))
info <- animint2HTML(viz)

## For some reason the "space between panels" tests only work on
## travis/wercker if the rect class is "background_rect". Not
## "border_rect"! Even though they both should appear, only
## background_rect appears on travis/wercker... is this because we
## don't wait long enough before calling getHTML()?
panel.rect.xpath.tmp <- '//svg[@id="plot_%s"]//rect[@class="background_rect"]'

test_that("some horizontal space between panels", {
  for(plot.name in names(viz)){
    xpath <- sprintf(panel.rect.xpath.tmp, plot.name)
    rect.list <- getNodeSet(info$html, xpath)
    expect_equal(length(rect.list), 2)
    first <- xmlAttrs(rect.list[[1]])
    first.left <- as.numeric(first[["x"]])
    first.right <- first.left+as.numeric(first[["width"]])
    second <- xmlAttrs(rect.list[[2]])
    second.left <- as.numeric(second[["x"]])
    second.right <- second.left+as.numeric(second[["width"]])
    expect_lt(first.right, second.left)
    ## Also make sure the xtitle is placed in the middle of the
    ## plotting region.
    xpath <- sprintf('//svg[@id="plot_%s"]//text[@class="xtitle"]', plot.name)
    text.list <- getNodeSet(info$html, xpath)
    expect_equal(length(text.list), 1)
    transform.str <- xmlAttrs(text.list[[1]])[["transform"]]
    transform.mat <- str_match_perl(transform.str, translatePattern)
    xtitle.x.computed <- as.numeric(transform.mat[, "x"])
    xtitle.x.expected <- (first.left + second.right)/2
    expect_equal(xtitle.x.computed, xtitle.x.expected)
  }
})

test_that("each plot has two x axes and 1 y axis", {
  for(plot.name in names(viz)){
    svg.xpath <- sprintf("//svg[@id='plot_%s']", plot.name)
    x.xpath <- paste0(svg.xpath, "//g[contains(@class, 'xaxis')]")
    x.axes <- getNodeSet(info$html, x.xpath)
    y.xpath <- paste0(svg.xpath, "//g[contains(@class, 'yaxis')]")
    y.axes <- getNodeSet(info$html, y.xpath)
    expect_equal(length(y.axes), 1)
  }
})

test_that("top strips present in each plot", {
  for(plot.name in names(viz)){ 
    xpath <- sprintf(
      "//svg[@id='plot_%s']//g[@class='topStrip']//text", plot.name)
    strip.text <- getNodeSet(info$html, xpath)
    expect_equal(length(strip.text), 2)
    text.values <- sapply(strip.text, xmlValue)
    expect_identical(text.values, c("am: 0", "am: 1"))
  }
})

test_that("pixels between 15 and 20 is constant or variable", {
  ## scale="fixed" means the distance between ticks 15 and 20 should
  ## be the same across the 2 panels.
  x.axes <- getNodeSet(
    info$html, "//svg[@id='plot_fixed']//g[contains(@class, 'xaxis')]")
  expect_equal(length(x.axes), 2)
  xdiff <- lapply(x.axes, getTickDiff)
  expect_true(both.equal(xdiff))
  ## scale="free" means the distance between ticks 15 and 20 should
  ## be different across the 2 panels.
  x.axes <- getNodeSet(
    info$html, "//svg[@id='plot_freeScale']//g[contains(@class, 'xaxis')]")
  expect_equal(length(x.axes), 2)
  xdiff <- lapply(x.axes, getTickDiff)
  expect_true(!both.equal(xdiff))
  ## scale="free" and space="free" means the distance between ticks 15
  ## and 20 should be the same across the 2 panels.
  x.axes <- getNodeSet(
    info$html, "//svg[@id='plot_freeBoth']//g[contains(@class, 'xaxis')]")
  expect_equal(length(x.axes), 2)
  xdiff <- lapply(x.axes, getTickDiff)
  expect_true(both.equal(xdiff))
})

test_that("width_proportion is constant or variable", {
  expect_true(both.equal(info$plots$fixed$layout$width_proportion))
  expect_true(both.equal(info$plots$freeScale$layout$width_proportion))
  expect_true(!both.equal(info$plots$freeBoth$layout$width_proportion))
})

viz <- animint(
  freeBothFlip = ggplot(mtcars, aes(wt, mpg)) + 
    ggtitle("space=free, scales=free") +
    scale_x_continuous(breaks=seq(1, 9)) +
    geom_point(colour='grey50', size = 4) + 
    geom_point(aes(colour = cyl)) +
    facet_grid(am ~ vs, space = "free", scales = "free", labeller=label_both))
info <- animint2HTML(viz)
test_that("same spacing for vertical and horizontal ticks", {
  ## scale="free" and space="free" means the distance between ticks
  ## should be the same across the horizontal and vertical panels.
  x.axes <- getNodeSet(
    info$html, "//svg[@id='plot_freeBothFlip']//g[contains(@class, 'xaxis')]")
  expect_equal(length(x.axes), 2)
  xdiff <- lapply(x.axes, getTickDiff, axis="x")
  expect_true(both.equal(xdiff))
  y.axes <- getNodeSet(
    info$html, "//svg[@id='plot_freeBothFlip']//g[contains(@class, 'yaxis')]")
  expect_equal(length(y.axes), 2)
  ydiff <- lapply(y.axes, getTickDiff, axis="y")
  expect_true(both.equal(ydiff))
})

no.panels <- ggplot(mtcars, aes(wt, mpg)) + 
  geom_point(colour='grey50', size = 4) + 
  geom_point(aes(colour = cyl)) 

viz <-
  list(freeBoth = no.panels +
         facet_grid(am ~ ., space = "free", scales = "free",
                    labeller=label_both),
       freeScale = no.panels +
         facet_grid(am ~ ., scales="free", labeller=label_both),
       fixed = no.panels +
         facet_grid(am ~ ., labeller=label_both))

info <- animint2HTML(viz)

test_that("some vertical space between panels", {
  for(plot.name in names(viz)){
    xpath <- sprintf(panel.rect.xpath.tmp, plot.name)
    rect.list <- getNodeSet(info$html, xpath)
    expect_equal(length(rect.list), 2)
    first <- xmlAttrs(rect.list[[1]])
    first.top <- as.numeric(first[["y"]])
    first.bottom <- first.top+as.numeric(first[["height"]])
    second <- xmlAttrs(rect.list[[2]])
    second.top <- as.numeric(second[["y"]])
    second.bottom <- second.top+as.numeric(second[["height"]])
    expect_lt(first.bottom, second.top)
    ## Also check that ytitle is placed in the middle of the plotting
    ## region.
    xpath <- sprintf('//svg[@id="plot_%s"]//text[@class="ytitle"]', plot.name)
    text.list <- getNodeSet(info$html, xpath)
    expect_equal(length(text.list), 1)
    transform.str <- xmlAttrs(text.list[[1]])[["transform"]]
    transform.mat <- str_match_perl(transform.str, translatePattern)
    ytitle.y.computed <- as.numeric(transform.mat[, "y"])
    ytitle.y.expected <- (first.top + second.bottom)/2
    expect_equal(ytitle.y.computed, ytitle.y.expected)
  }
})

test_that("right strips present in each plot", {
  for(plot.name in names(viz)){ 
    xpath <- sprintf(
      "//svg[@id='plot_%s']//g[@class='rightStrip']//text", plot.name)
    strip.text <- getNodeSet(info$html, xpath)
    expect_equal(length(strip.text), 2)
    text.values <- sapply(strip.text, xmlValue)
    expect_identical(text.values, c("am: 0", "am: 1"))
  }
})

test_that("y pixels between 15 and 20 is constant or variable", {
  ## scale="fixed" means the distance between ticks 15 and 20 should
  ## be the same across the 2 panels.
  y.axes <- getNodeSet(
    info$html, "//svg[@id='plot_fixed']//g[contains(@class, 'yaxis')]")
  expect_equal(length(y.axes), 2)
  ydiff <- lapply(y.axes, getTickDiff, axis="y")
  expect_true(both.equal(ydiff))
  ## scale="free" means the distance between ticks 15 and 20 should
  ## be different across the 2 panels.
  y.axes <- getNodeSet(
    info$html, "//svg[@id='plot_freeScale']//g[contains(@class, 'yaxis')]")
  expect_equal(length(y.axes), 2)
  ydiff <- lapply(y.axes, getTickDiff, axis="y")
  expect_true(!both.equal(ydiff))
  ## scale="free" and space="free" means the distance between ticks 15
  ## and 20 should be the same across the 2 panels.
  y.axes <- getNodeSet(
    info$html, "//svg[@id='plot_freeBoth']//g[contains(@class, 'yaxis')]")
  expect_equal(length(y.axes), 2)
  ydiff <- lapply(y.axes, getTickDiff, axis="y")
  expect_true(both.equal(ydiff))
})

test_that("height_proportion is constant or variable", {
  expect_true(both.equal(info$plots$fixed$layout$height_proportion))
  expect_true(both.equal(info$plots$freeScale$layout$height_proportion))
  expect_true(!both.equal(info$plots$freeBoth$layout$height_proportion))
})
