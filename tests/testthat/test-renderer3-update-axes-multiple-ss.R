acontext("update_axes - multiple single selectors")

## Test for appropriate warnings
set.seed(123)

# Empty domains in axis updates -> generate warning
data_f1 <- data.frame(a=runif(30, 1, 30), b=sample(1:30))
data_f1$ss1 <- as.factor(1:3)
data_f1$ss2 <- as.factor(c("alpha", "beta"))
data_f1$ss3 <- as.factor(c("A", "A", "B"))
# factors "1" & "2" are never paired with factor "B"
# factor "3" is never paired with factor "A"
plot1 <- ggplot() + geom_point(aes(a,b),
                               showSelected=c("ss1","ss2","ss3"),
                               data = data_f1) +
  theme_animint(update_axes=c("x"))
viz <- list(p=plot1)

viz$selector.types <- list(ss1="single", ss2="single", ss3="single")
expect_warning(animint2HTML(viz),
               "some data subsets have no data to plot")

# Only a single unique value in domains for axis updates -> generate warning
data_f2 <- data.frame(a=runif(6, 1, 6), b=sample(1:6))
data_f2$ss1 <- as.factor(1:3)
data_f2$ss2 <- as.factor(c("alpha", "beta"))
# Each factor interaction only possesses a single value
plot2 <- ggplot() + geom_point(aes(a,b),
                               showSelected=c("ss1", "ss2"),
                               data = data_f2) +
  theme_animint(update_axes=c("x"))
viz <- list(p=plot2)

viz$selector.types <- list(ss1="single", ss2="single")
expect_warning(animint2HTML(viz),
               "some data subsets have only a single data value to plot")

# Axes updates for more than one single selectors -> no warnings
data_f3 <- data.frame(a=runif(60, 1, 60), b=sample(1:60))
data_f3$ss1 <- as.factor(1:3)
data_f3$ss2 <- as.factor(c("alpha", "beta"))
plot3 <- ggplot() + geom_point(aes(a,b, colour=ss1),
                               showSelected="ss2",
                               data = data_f3)
  
viz <- list(p=plot3 + theme_animint(update_axes=c("x")))

viz$selector.types <- list(ss1="single", ss2="single")
expect_no_warning(animint2HTML(viz))

## --------------------------------------------------------------------- ##
## Tests for axis updates for more than one showSelected vars

# Plots with axis updates
no_updates <- plot3

update_x <- no_updates+
  theme_animint(update_axes=c("x"))
update_y <- no_updates+
  theme_animint(update_axes=c("y"))
update_xy <- no_updates+
  theme_animint(update_axes=c("x","y"))

viz <- (list(neither=no_updates, 
             x=update_x, 
             y=update_y, 
             both=update_xy))

viz$selector.types <- list(ss1="single", ss2="single")
viz$time = list(variable="ss2", ms=5000)

info <- animint2HTML(viz)

# Update selection and get HTML
clickID(c("plot_neither_ss1_variable_3"))
Sys.sleep(1)
info$html_updated1 <- getHTML()

# Let the gear variable change and get HTML
# Also checks for automatic axis updates with animation
Sys.sleep(6)
info$html_updated2 <- getHTML()

## --------------------------------------------------------------------- ##
## Test for tick updates

rect_path <- "//svg[@id='plot_%s']//g[contains(@class, '%saxis')]"
all_rect_paths <- lapply(names(viz), sprintf, fmt=rect_path,
                         c("x","y"))[1:4]

# Take tick diffs for all 4 plots
rect_nodes1 <- sapply(all_rect_paths, getNodeSet, doc=info$html)
original_tick_diff_x <- sapply(rect_nodes1[1, ], getTickDiff, axis="x")
original_tick_diff_y <- sapply(rect_nodes1[2, ], getTickDiff, axis="y")

rect_nodes2 <- sapply(all_rect_paths, getNodeSet, doc=info$html_updated1)
updated_tick_diff_x1 <- sapply(rect_nodes2[1, ], getTickDiff, axis="x")
updated_tick_diff_y1 <- sapply(rect_nodes2[2, ], getTickDiff, axis="y")

rect_nodes3 <- sapply(all_rect_paths, getNodeSet, doc=info$html_updated2)
updated_tick_diff_x2 <- sapply(rect_nodes3[1, ], getTickDiff, axis="x")
updated_tick_diff_y2 <- sapply(rect_nodes3[2, ], getTickDiff, axis="y")

test_that("axis ticks change when plots are updated",{
  #no_updates
  expect_equal(updated_tick_diff_x1[1], original_tick_diff_x[1])
  expect_equal(updated_tick_diff_y1[1], original_tick_diff_y[1])
  expect_equal(updated_tick_diff_x2[1], original_tick_diff_x[1])
  expect_equal(updated_tick_diff_y2[1], original_tick_diff_y[1])
  #update_x
  expect_true(unequal(updated_tick_diff_x1[2], original_tick_diff_x[2],
                      tolerance=0.01))
  expect_true(unequal(updated_tick_diff_x2[2], original_tick_diff_x[2],
                      tolerance=0.01))
  expect_true(unequal(updated_tick_diff_x2[2], updated_tick_diff_x1[2],
                      tolerance=0.01))
  expect_equal(updated_tick_diff_y1[2], original_tick_diff_y[2])
  expect_equal(updated_tick_diff_y2[2], original_tick_diff_y[2])
  #update_y
  expect_equal(updated_tick_diff_x1[3], original_tick_diff_x[3])
  expect_equal(updated_tick_diff_x2[3], original_tick_diff_x[3])
  expect_true(unequal(updated_tick_diff_y1[3], original_tick_diff_y[3],
                      tolerance=0.01))
  expect_true(unequal(updated_tick_diff_y2[3], original_tick_diff_y[3],
                      tolerance=0.01))
  expect_true(unequal(updated_tick_diff_y2[3], updated_tick_diff_y1[3],
                      tolerance=0.01))
  #update_xy
  expect_true(unequal(updated_tick_diff_x1[4], original_tick_diff_x[4],
                      tolerance=0.01))
  expect_true(unequal(updated_tick_diff_x2[4], original_tick_diff_x[4],
                      tolerance=0.01))
  expect_true(unequal(updated_tick_diff_x2[4], updated_tick_diff_x1[4],
                      tolerance=0.01))
  expect_true(unequal(updated_tick_diff_y1[4], original_tick_diff_y[4],
                      tolerance=0.01))
  expect_true(unequal(updated_tick_diff_y2[4], original_tick_diff_y[4],
                      tolerance=0.01))
  expect_true(unequal(updated_tick_diff_y2[4], updated_tick_diff_y1[4],
                      tolerance=0.01))
})


## ------------------------------------------------------------------- ##
## Test for grid updates

minor_grid_attr1 <- minor_grid_attr2 <- minor_grid_attr3 <- list()
major_grid_attr1 <- major_grid_attr2 <- major_grid_attr3 <- list()

p_names <- names(viz)[1:4]
for(p.name in p_names){
  major_grid_attr1[[p.name]] <- get_grid_lines(info$html, p.name, "major")
  major_grid_attr2[[p.name]] <- get_grid_lines(info$html_updated1,
                                               p.name, "major")
  major_grid_attr3[[p.name]] <- get_grid_lines(info$html_updated2,
                                               p.name, "major")
  
  minor_grid_attr1[[p.name]] <- get_grid_lines(info$html, p.name, "minor")
  minor_grid_attr2[[p.name]] <- get_grid_lines(info$html_updated1,
                                               p.name, "minor")
  minor_grid_attr3[[p.name]] <- get_grid_lines(info$html_updated2,
                                               p.name, "minor")
}

test_that("major grids are updated",{
  # initial grid updates
  expect_true(unequal(major_grid_attr1$x, major_grid_attr1$neither))
  expect_true(unequal(major_grid_attr1$y, major_grid_attr1$neither))
  expect_true(unequal(major_grid_attr1$both, major_grid_attr1$neither))
  expect_true(unequal(major_grid_attr1$x, major_grid_attr1$neither))
  expect_true(unequal(major_grid_attr1$y, major_grid_attr1$neither))
  expect_true(unequal(major_grid_attr1$both, major_grid_attr1$neither))
  
  #no_updates
  expect_identical(major_grid_attr2$neither, major_grid_attr1$neither)
  expect_identical(major_grid_attr3$neither, major_grid_attr1$neither)
  
  #update_x -> only vert grids are updated
  expect_identical(major_grid_attr2$x$hor, major_grid_attr1$x$hor)
  expect_identical(major_grid_attr3$x$hor, major_grid_attr1$x$hor)
  expect_true(unequal(major_grid_attr2$x$vert,
                      major_grid_attr1$x$vert, tolerance=0.01))
  expect_true(unequal(major_grid_attr3$x$vert,
                      major_grid_attr1$x$vert, tolerance=0.01))
  expect_true(unequal(major_grid_attr3$x$vert,
                      major_grid_attr2$x$vert, tolerance=0.01))
  
  #update_y -> only hor grids are updated
  expect_true(unequal(major_grid_attr2$y$hor,
                      major_grid_attr1$y$hor, tolerance=0.01))
  expect_true(unequal(major_grid_attr3$y$hor,
                      major_grid_attr1$y$hor, tolerance=0.01))
  expect_true(unequal(major_grid_attr3$y$hor,
                      major_grid_attr2$y$hor, tolerance=0.01))
  expect_identical(major_grid_attr2$y$vert, major_grid_attr1$y$vert)
  expect_identical(major_grid_attr3$y$vert, major_grid_attr1$y$vert)
  
  #update_xy -> both vert and hor grids updated
  expect_true(unequal(major_grid_attr2$both$hor,
                      major_grid_attr1$both$hor, tolerance=0.01))
  expect_true(unequal(major_grid_attr3$both$hor,
                      major_grid_attr1$both$hor, tolerance=0.01))
  expect_true(unequal(major_grid_attr3$both$hor,
                      major_grid_attr2$both$hor, tolerance=0.01))
  expect_true(unequal(major_grid_attr2$both$vert,
                      major_grid_attr1$both$vert, tolerance=0.01))
  expect_true(unequal(major_grid_attr3$both$vert,
                      major_grid_attr1$both$vert, tolerance=0.01))
  expect_true(unequal(major_grid_attr3$both$vert,
                      major_grid_attr2$both$vert, tolerance=0.01))
})

test_that("minor grids are updated",{
  # initial grid updates
  expect_true(unequal(minor_grid_attr1$x, minor_grid_attr1$neither))
  expect_true(unequal(minor_grid_attr1$y, minor_grid_attr1$neither))
  expect_true(unequal(minor_grid_attr1$both, minor_grid_attr1$neither))
  expect_true(unequal(minor_grid_attr1$x, minor_grid_attr1$neither))
  expect_true(unequal(minor_grid_attr1$y, minor_grid_attr1$neither))
  expect_true(unequal(minor_grid_attr1$both, minor_grid_attr1$neither))
  
  #no_updates
  expect_identical(minor_grid_attr2$neither, minor_grid_attr1$neither)
  expect_identical(minor_grid_attr3$neither, minor_grid_attr1$neither)
  
  #update_x -> only vert grids are updated
  expect_identical(minor_grid_attr2$x$hor, minor_grid_attr1$x$hor)
  expect_identical(minor_grid_attr3$x$hor, minor_grid_attr1$x$hor)
  expect_true(unequal(minor_grid_attr2$x$vert,
                      minor_grid_attr1$x$vert, tolerance=0.01))
  expect_true(unequal(minor_grid_attr3$x$vert,
                      minor_grid_attr1$x$vert, tolerance=0.01))
  expect_true(unequal(minor_grid_attr3$x$vert,
                      minor_grid_attr2$x$vert, tolerance=0.01))
  
  #update_y -> only hor grids are updated
  expect_true(unequal(minor_grid_attr2$y$hor,
                      minor_grid_attr1$y$hor, tolerance=0.01))
  expect_true(unequal(minor_grid_attr3$y$hor,
                      minor_grid_attr1$y$hor, tolerance=0.01))
  expect_true(unequal(minor_grid_attr3$y$hor,
                      minor_grid_attr2$y$hor, tolerance=0.01))
  expect_identical(minor_grid_attr2$y$vert, minor_grid_attr1$y$vert)
  expect_identical(minor_grid_attr3$y$vert, minor_grid_attr1$y$vert)
  
  #update_xy -> both vert and hor grids updated
  expect_true(unequal(minor_grid_attr2$both$hor,
                      minor_grid_attr1$both$hor, tolerance=0.01))
  expect_true(unequal(minor_grid_attr3$both$hor,
                      minor_grid_attr1$both$hor, tolerance=0.01))
  expect_true(unequal(minor_grid_attr3$both$hor,
                      minor_grid_attr2$both$hor, tolerance=0.01))
  expect_true(unequal(minor_grid_attr2$both$vert,
                      minor_grid_attr1$both$vert, tolerance=0.01))
  expect_true(unequal(minor_grid_attr3$both$vert,
                      minor_grid_attr1$both$vert, tolerance=0.01))
  expect_true(unequal(minor_grid_attr3$both$vert,
                      minor_grid_attr2$both$vert, tolerance=0.01))
})

## -------------------------------------------------------------------- ##
## Test for zooming of geoms

## Get ranges of geoms
no_updates_ranges1 <- get_pixel_ranges(info$html_updated1,
                                       "geom1_point_neither")
no_updates_ranges2 <- get_pixel_ranges(info$html_updated2,
                                       "geom1_point_neither")

x_updates_ranges1 <- get_pixel_ranges(info$html_updated1,
                                      "geom2_point_x")
x_updates_ranges2 <- get_pixel_ranges(info$html_updated2,
                                      "geom2_point_x")

y_updates_ranges1 <- get_pixel_ranges(info$html_updated1,
                                      "geom3_point_y")
y_updates_ranges2 <- get_pixel_ranges(info$html_updated2,
                                      "geom3_point_y")

xy_updates_ranges1 <- get_pixel_ranges(info$html_updated1,
                                       "geom4_point_both")
xy_updates_ranges2 <- get_pixel_ranges(info$html_updated2,
                                       "geom4_point_both")

test_that("geoms get zoomed-in upon changing selection", {
  # no_updates
  expect_true(unequal(no_updates_ranges2$x, no_updates_ranges1$x,
                      tolerance=0.01))
  expect_true(unequal(no_updates_ranges2$y, no_updates_ranges1$y,
                      tolerance=0.01))
  
  # x_updates
  expect_equal(x_updates_ranges2$x, x_updates_ranges1$x, tolerance=0.0001)
  expect_true(unequal(x_updates_ranges2$y, x_updates_ranges1$y,
                      tolerance=0.01))
  
  # y_updates
  expect_true(unequal(y_updates_ranges2$x, y_updates_ranges1$x,
                      tolerance=0.01))
  expect_equal(y_updates_ranges2$y, y_updates_ranges1$y, tolerance=0.0001)
  
  # xy_updates
  expect_equal(xy_updates_ranges2$x, xy_updates_ranges1$x, tolerance=0.0001)
  expect_equal(xy_updates_ranges2$y, xy_updates_ranges1$y, tolerance=0.0001)
})

