# options(warn = -1)

knitr::opts_chunk$set(collapse = TRUE, comment = "#>", cache = TRUE, fig.show = "hold")
library(ggplot2)

knit_print.data.frame <- function(x, ..., maxrows = 8) {
  output <- capture.output(
    base::print.data.frame(head(x, maxrows), ...)
  )

  if (nrow(x) > maxrows) {
    output <- c(
      output,
      paste(
        "# ... with",
        format(nrow(x) - maxrows, big.mark = ","),
        "more rows"
      )
    )
  }

  cat(output, sep = "\n")
}



knit_print.character <- function(x, ..., maxrows = 8) {
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
        "# ... with",
        format(length(x) - n_per_row * maxrows, big.mark = ","),
        "more items"
      )
    )
  }

  cat(output, sep = "\n")
}


knit_print.sf <- function(x, ...) {
    sf:::print.sf(x, ..., n = 6)
}
