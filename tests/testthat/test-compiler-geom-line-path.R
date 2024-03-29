library(testthat)
acontext("geom line")

data(intreg, package = "animint2")
min.logratio <- min(intreg$signals$logratio)-0.2
max.logratio <- max(intreg$signals$logratio)
intreg$breaks$min.logratio <- min.logratio
intreg$breaks$max.logratio <- max.logratio
signal.colors <- c(estimate="#0adb0a", latent="#0098ef")
breakpoint.colors <- c("1breakpoint"="#ff7d7d", "0breakpoints"='#f6f4bf')
models.by.signal <- with(intreg, split(segments, segments$signal))
signals.by.signal <- with(intreg, split(signals, signals$signal))
model.selection.list <- list()
sig.labels.list <- list()
sig.seg.names.list <- list()
sig.names.list <- list()
for(signal.name in names(models.by.signal)){
  signal <- signals.by.signal[[signal.name]]
  signal.models <- models.by.signal[[signal.name]]
  models.by.segments <- split(signal.models, signal.models$segments)
  sig.seg.by.segments <- list()
  for(segments.str in names(models.by.segments)){
    segments <- as.numeric(segments.str)
    model <- models.by.segments[[segments.str]]
    model$rss <- NA
    model$data <- NA
    for(segment.i in 1:nrow(model)){
      one.segment <- model[segment.i, ]
      seg.data <-
        subset(signal,
               one.segment$first.base < base &
                 base < one.segment$last.base)
      model$data[segment.i] <- nrow(seg.data)
      residual.vec <- seg.data$logratio - one.segment$mean
      model$rss[segment.i] <- sum(residual.vec * residual.vec)
    }
    stopifnot(sum(model$data) == nrow(signal))
    model.stats <-
      data.frame(signal=signal.name,
                 segments,
                 error=sum(model$rss),
                 data=sum(model$data))
    model.selection.list[[paste(signal.name, segments.str)]] <- model.stats
    if(segments.str == "1"){
      sig.labels.list[[signal.name]] <- model.stats
    }
    sig.seg.by.segments[[segments.str]] <-
      data.frame(signal=signal.name,
                 segments, min.logratio, max.logratio,
                 base=(min(signal$base)+max(signal$base))/2)
  }
  sig.seg.tall <- do.call(rbind, sig.seg.by.segments)
  sig.seg.names.list[[signal.name]] <- sig.seg.tall
  sig.names.list[[signal.name]] <- sig.seg.tall[1,]
}
model.selection.sorted <- do.call(rbind, model.selection.list)
set.seed(1)
model.selection <-
  model.selection.sorted[sample(1:nrow(model.selection.sorted)),]
sig.seg.names <- do.call(rbind, sig.seg.names.list)
sig.names <- do.call(rbind, sig.names.list)
sig.labels <- do.call(rbind, sig.labels.list)

## Plot segments rather than penalty.
mmir.selection <-
  list(error=ggplot()+
       ggtitle("Select profile and number of segments")+
       make_tallrect(model.selection, "segments",
                     colour=signal.colors[["estimate"]])+
       theme_bw()+
       theme_animint(width=600)+
       theme(panel.margin=grid::unit(0, "lines"))+
       facet_grid(. ~ geom)+
       geom_text(aes(0, error, label=signal),
                 clickSelects="signal",
                 data=sig.labels, hjust=1)+
       scale_x_continuous("segments", breaks=c(1, 5, 10, 20),
                          limits=c(-2, 20))+
       xlab("squared error")+
       geom_line(aes(segments, error,
                     group=signal),
                 data=data.frame(model.selection, geom="line"),
                 clickSelects="signal",
                 alpha=0.6, size=8)+
       geom_path(aes(segments, error,
                     group=signal),
                 data=data.frame(model.selection, geom="path"),
                     clickSelects="signal",
                 alpha=0.6, size=8),

       signal=ggplot()+
         theme_bw()+
       theme_animint(width=800)+
       scale_x_continuous("position on chromosome (mega base pairs)",
                          breaks=c(100,200))+
       scale_fill_manual(values=breakpoint.colors,guide="none")+
       geom_blank(aes(first.base/1e6, logratio+2/8), data=intreg$ann)+
       ggtitle("Copy number profile and maximum likelihood segmentation")+
       ylab("logratio")+
       geom_point(aes(base/1e6, logratio),
                  data=intreg$sig,
                      showSelected="signal")+
       geom_segment(aes(first.base/1e6, mean, xend=last.base/1e6, yend=mean),
                    data=intreg$seg, colour=signal.colors[["estimate"]],
                        showSelected=c("signal", "segments"))+
       geom_segment(aes(base/1e6, min.logratio,
                        xend=base/1e6, yend=max.logratio),
                  colour=signal.colors[["estimate"]],
                    showSelected=c("signal", "segments"),
                  linetype="dashed",
                  data=intreg$breaks)+
       geom_text(aes(base/1e6, max.logratio, label=paste("signal", signal)),
                 data=sig.names,
                 showSelected="signal")+
       geom_text(aes(base/1e6, min.logratio,
                     label=sprintf("%d segment%s", segments,
                       ifelse(segments==1, "", "s"))),
                 data=sig.seg.names,
                 showSelected=c("signal", "segments"),
                 color=signal.colors[["estimate"]]),

       first=list(signal="4.2", segments=4))

tdir <- tempfile()
animint2dir(mmir.selection, tdir, open.browser=FALSE)

all.increasing <- function(num.vec){
  stopifnot(is.numeric(num.vec))
  all(0 < diff(num.vec))
}
expected.list <-
  list(geom3_line_error=TRUE,
       geom4_path_error=FALSE)
result.list <- list()
for(g.class in names(expected.list)){
  expected <- expected.list[[g.class]]
  tsv.path <- Sys.glob(file.path(tdir, paste0(g.class, "*")))
  g.data <- read.table(tsv.path, header=TRUE, comment.char = "")
  tsv.by.signal <- split(g.data, g.data$clickSelects)
  for(signal.name in names(tsv.by.signal)){
    one.signal <- tsv.by.signal[[signal.name]]
    computed <- all.increasing(one.signal$x)
    result.list[[paste(g.class, signal.name)]] <-
      data.frame(g.class, signal.name, computed, expected)
  }
}
result <- do.call(rbind, result.list)

test_that("line sorts tsv data by x value, path does not", {
  with(result, {
    expect_identical(computed, expected)
  })
})
