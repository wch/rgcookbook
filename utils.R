# options(warn = -1)

# TODO: Add checks for code/computer output wider than 80 columns

library <- function(...) {
  suppressPackageStartupMessages(base::library(...))
}

# Need to load some packages before tidyverse because of conflicts
library(igraph)
library(MASS)
library(ggplot2)
library(dplyr)


options(width = 77)

knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  cache = TRUE,
  fig.show = "hold",
  fig.align = "center",
  fig.width = 5,
  fig.height = 4,
  out.width = NULL,
  print_df_rows = c(3, 3),
  print_df_digits = NULL,
  print_tbl_rows = 6
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

# Round numeric columns in a data frame to some number of digits after decimal.
round_df <- function(df, digits) {
  is.num <- vapply(df, is.numeric, TRUE)
  df[is.num] <- lapply(df[is.num], round, digits = digits)
  df
}


knit_print_data.frame <- function(x, ...,
  rows = knitr::opts_current$get("print_df_rows"),
  digits_ = knitr::opts_current$get("print_df_digits")
) {
  # If the data frame has up to `rows` plus two extra, just print the data
  # frame.
  if (nrow(x) <= sum(rows) + 2) {
    print(x)
    return()
  }

  # By default, print first 3 and last 3 rows.
  rownums <- c(seq(from = 1,       length.out = rows[1]),
               seq(to   = nrow(x), length.out = rows[2]))

  # If digits_ is specified, round to that number of digits. It's called
  # `digits_` so it doesn't clash with the `digits` parameter for
  # print.data.frame.
  if (!is.null(digits_)) {
    x <- round_df(x, digits = digits_)
  }

  # Need to print the head and tail of data frame in one go, so that
  # alignment is correct.
  output <- capture.output(
    print(x[rownums, , drop = FALSE], ...)
  )

  if (nrow(x) > sum(rows)) {
    output <- c(
      head(output, -rows[2]),
      paste0(
        " ...<",
        format(nrow(x) - sum(rows), big.mark = ","),
        " more rows>..."
      ),
      tail(output, rows[2])
    )
  }

  cat(output, sep = "\n")
}


# This will need tweaking to work with very long vectors which do not finish printing
knit_print_vector <- function(x, ..., rows = knitr::opts_current$get("print_df_rows")) {
  output <- capture.output(
    print(x, ...)
  )

  # If the printed output has up to `rows` plus two extra, just print it.
  if (length(output) <= sum(rows) + 2) {
    cat(output, sep = "\n")
    return()
  }

  if (length(output) > sum(rows)) {
    output <- c(
      head(output, rows[1]),
      paste0(
        " ..."
      ),
      tail(output, rows[2])
    )
  }

  cat(output, sep = "\n")
}

knit_print_ts <- function(x, ..., rows = knitr::opts_current$get("print_df_rows")) {
  # Need one extra row for header
  knit_print_vector(x, ..., rows = c(rows[1] + 1, rows[2]))
}

# Customized for Creating a Mosaic Plot recipe, with UCBAdmissions
knit_print_table <- function(x, ...) {
  txt <- capture.output(base::print.table(x, ...))
  if (length(txt) > 14) {
    cat(txt[1:14], sep = "\n")
    cat(" ... with", length(txt)-1, "more lines of text\n")
  } else{
    cat(txt, sep = "\n")
  }
  invisible()
}

knit_print_tbl <-   function(x, ..., maxrows = knitr::opts_current$get("print_tbl_rows")) {
  print(x, ..., n = maxrows)
}

# Need this explicit registration step because of some change in R 3.5
register_s3_method("knitr", "knit_print", "data.frame", knit_print_data.frame)
register_s3_method("knitr", "knit_print", "matrix",     knit_print_data.frame)

register_s3_method("knitr", "knit_print", "character",  knit_print_vector)

register_s3_method("knitr", "knit_print", "ts",         knit_print_ts)

register_s3_method("knitr", "knit_print", "table",      knit_print_table)

register_s3_method("knitr", "knit_print", "grouped_df", knit_print_tbl)
register_s3_method("knitr", "knit_print", "tbl_df",     knit_print_tbl)
register_s3_method("knitr", "knit_print", "tbl",        knit_print_tbl)


register_s3_method("knitr", "knit_print", "sf",
  function(x, ...) {
    print(x, ..., n = 6)
  }
)

