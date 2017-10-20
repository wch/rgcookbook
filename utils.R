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

