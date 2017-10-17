#!/usr/bin/env Rscript

# Build each individual chapter's Markdown file, and put it the chapters_md/
# directory.
# Usage:
#   tools/build_chapters.R ch01.Rmd ch02.Rmd


files <- commandArgs(trailingOnly = TRUE)

if (!dir.exists("chapters_md"))
  dir.create("chapters_md")

orig_dir <- getwd()

lapply(files, function(file) {
  filename_no_ext <- sub("\\.Rmd$", "", file)
  outfile_md <- paste0(filename_no_ext, ".md")
  rel_file <- file.path("..", "..", file)

  # Create dir if necessary
  dest_dir <- file.path("chapters_md", filename_no_ext)
  if (!dir.exists(dest_dir))
    dir.create(dest_dir, recursive = TRUE)

  on.exit(setwd(orig_dir))
  setwd(dest_dir)

  knitr::knit(rel_file, output = outfile_md)

  # Strip out YAML header, if present.
  content <- readLines(outfile_md)
  if (content[1] == "---") {
    # Read up to 50 lines
    i <- 2
    header_found <- FALSE
    while(i <= 50 && i <= length(content)) {
      if (content[i] == "---") {
        header_found <- TRUE
        break;
      }
      i <- i + 1
    }

    # Remove header, if found
    if (header_found) {
      content <- content[-(seq_len(i))]
      writeLines(content, outfile_md)
    }
  }
})
