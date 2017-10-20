# All .Rmd files except those that start with "_"
RMD_FILES=$(filter-out $(wildcard _*.Rmd),$(wildcard *.Rmd))
# Drop index.Rmd from RMD_FILES
CHAPTER_RMD_FILES=$(filter-out index.Rmd,$(RMD_FILES))

.PHONY: html pdf clean chapters_md

html:
	Rscript -e 'bookdown::render_book("index.Rmd", output_format = "bookdown::gitbook"); warnings()'

pdf:
	Rscript -e 'bookdown::render_book("index.Rmd", output_format = "bookdown::pdf_book"); warnings()'

# Knit individual chapters and put resulting .md files in chapters_md/
chapters_md: $(CHAPTER_RMD_FILES)
	tools/build_chapters.R $(CHAPTER_RMD_FILES)

clean:
	rm -f "R-Graphics-Cookbook-2e.Rmd"
	Rscript -e "bookdown::clean_book(TRUE)"
	rm -rf chapters_md/ _book/

cleaner: clean
	rm -rf _bookdown_files/
