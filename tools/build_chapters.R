#!/usr/bin/env Rscript

# Build each individual chapter's Markdown file, and put it the chapters_md/
# directory.
# Usage:
#   tools/build_chapters.R ch01.Rmd ch02.Rmd


files <- commandArgs(trailingOnly = TRUE)

if (!dir.exists("chapters_md"))
  dir.create("chapters_md")

setwd("chapters_md")

for (file in files) {
  file_md <- sub("\\.Rmd$", ".md", file)
  knitr::knit(
    file.path("..", file),
    output = file_md
  )
}
