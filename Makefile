# All .Rmd files except those that start with "_"
RMD_FILES=$(filter-out $(wildcard _*.Rmd),$(wildcard *.Rmd))
# Drop index.Rmd from RMD_FILES
CHAPTER_RMD_FILES=$(filter-out index.Rmd,$(RMD_FILES))

.PHONY: html pdf chapters_md semiclean clean cleaner

html:
	Rscript --no-init-file -e 'bookdown::render_book("index.Rmd", output_format = "bookdown::gitbook"); warnings()'

pdf:
	Rscript --no-init-file -e 'bookdown::render_book("index.Rmd", output_format = "bookdown::pdf_book"); warnings()'

html_artifacts:
	Rscript --no-init-file -e 'bookdown::render_book("index.Rmd", output_format = "bookdown::gitbook", clean = FALSE); warnings()'

pdf_artifacts:
	Rscript --no-init-file -e 'bookdown::render_book("index.Rmd", output_format = "bookdown::pdf_book", clean = FALSE); warnings()'

# Knit individual chapters and put resulting .md files in chapters_md/
chapters_md: $(CHAPTER_RMD_FILES)
	tools/build_chapters.R $(CHAPTER_RMD_FILES)

semiclean:
	rm -f "R-Graphics-Cookbook-2e.Rmd"

clean:
	rm -f "R-Graphics-Cookbook-2e.Rmd"
	Rscript -e "bookdown::clean_book(TRUE)"
	rm -rf chapters_md/ _book/

cleaner: clean
	rm -rf _bookdown_files/
