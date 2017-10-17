#!/usr/bin/env Rscript

# Build each individual chapter's Markdown file, and put it the chapters_md/
# directory.
# Usage:
#   tools/build_chapters.R ch01.Rmd ch02.Rmd


files <- commandArgs(trailingOnly = TRUE)

if (!dir.exists("chapters_md"))
  dir.create("chapters_md")

for (file in files) {
  file_no_ext <- sub("\\.Rmd$", "", file)
  file_md <- paste0(file_no_ext, ".md")

  dest_dir <- file.path("chapters_md", file_no_ext)
  if (!dir.exists(dest_dir))
    dir.create(dest_dir, recursive = TRUE)

  withr::with_dir(dest_dir, {
    knitr::knit(
      file.path("..", "..", file),
      output = file_md
    )
  })
}
