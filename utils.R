# options(warn = -1)

library(ggplot2)
library(dplyr)

knitr::opts_chunk$set(
    collapse = TRUE,
    comment = "#>",
    cache = TRUE,
    fig.show = "hold",
    # out.width = NULL,
    fig.align = "center",
    fig.width=5,
    fig.height=4,
    out.width=NULL
)

# Seems to be necessary for captions for multiple images in a single Figure.
if (identical(knitr:::pandoc_to(), 'latex')) {
  knitr::knit_hooks$set(plot = knitr::hook_plot_tex)
}

knitr::knit_hooks$set(small.mar = function(before, options, envir) {
    if (before) par(mar = c(4.5, 4.5, 1, .5))  # smaller margin on top and right
})


# As of R 3.5, we need to register knit_print methods using registerS3method.
# https://github.com/yihui/knitr/issues/1580
#
# This is borrowed from: https://github.com/klutometis/roxygen/issues/623
register_s3_method <- function(pkg, generic, class, fun = NULL) {
  stopifnot(is.character(pkg), length(pkg) == 1)
  envir <- asNamespace(pkg)

  stopifnot(is.character(generic), length(generic) == 1)
  stopifnot(is.character(class), length(class) == 1)
  if (is.null(fun)) {
    fun <- get(paste0(generic, ".", class), envir = parent.frame())
  }
  stopifnot(is.function(fun))


  if (pkg %in% loadedNamespaces()) {
    registerS3method(generic, class, fun, envir = envir)
  }

  # Always register hook in case package is later unloaded & reloaded
  setHook(
    packageEvent(pkg, "onLoad"),
    function(...) {
      registerS3method(generic, class, fun, envir = envir)
    }
  )
}

register_s3_method("knitr", "knit_print", "data.frame",
  function(x, ..., maxrows = getOption("knit_print_df_rows", default = 8)) {
  # browser()
    output <- capture.output(
      base::print.data.frame(head(x, maxrows), ...)
    )

    if (nrow(x) > maxrows) {
      output <- c(
        output,
        paste(
          "... with",
          format(nrow(x) - maxrows, big.mark = ","),
          "more rows"
        )
      )
    }

    cat(output, sep = "\n")
  }
)

register_s3_method("knitr", "knit_print", "character",
  function(x, ..., maxrows = 8) {
    output <- capture.output(
      base::print.default(x, ...)
    )

    if (length(output) > maxrows) {
      # Find out how many items are on each line of text.
      # Get number on second line:
      line2_n <- as.integer(sub("^\\s*\\[(\\d+)\\].*", "\\1", output[2]))
      n_per_row <- line2_n - 1
      n_printed <- n_per_row * maxrows

      output <- c(
        output[seq_len(maxrows)],
        paste(
          "... with",
          format(length(x) - n_per_row * maxrows, big.mark = ","),
          "more items"
        )
      )
    }

    cat(output, sep = "\n")
  }
)

register_s3_method("knitr", "knit_print", "ts",
  function(x, ..., maxrows = getOption("knit_print_ts_rows", default = 6)) {
    output <- capture.output(
      stats:::print.ts(x, ...)
    )

    if (length(output) > maxrows) {
      output <- c(
        output[seq_len(maxrows)],
        paste(
          "... with",
          format(length(output) - maxrows, big.mark = ","),
          "more rows"
        )
      )
    }

    cat(output, sep = "\n")
  }
)


register_s3_method("knitr", "knit_print", "matrix",
  function(x, ..., maxrows = getOption("knit_print_matrix_rows", default = 8)) {
    attrs <- attributes(x)
    attrs <- attrs[names(attrs) %in% c("dim", "dimnames")]
    attributes(x) <- attrs

    output <- capture.output(
      print.default(head(x, maxrows), ...)
    )

    if (nrow(x) > maxrows) {
      output <- c(
        output,
        paste(
          "... with",
          format(nrow(x) - maxrows, big.mark = ","),
          "more rows"
        )
      )
    }

    cat(output, sep = "\n")
  }
)


register_s3_method("knitr", "knit_print", "sf",
  function(x, ...) {
    sf:::print.sf(x, ..., n = 6)
  }
)

register_s3_method("knitr", "knit_print", "tbl_df",
  function(x, ..., maxrows = 8) {
  # browser()
    tibble:::print.tbl_df(x, ..., n = maxrows)
  }
)


register_s3_method("knitr", "knit_print", "tbl",
  function(x, ..., maxrows = 8) {
  # browser()
    tibble:::print.tbl(x, ..., n = maxrows)
  }
)
