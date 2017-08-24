# All .Rmd files except those that start with "_"
RMD_FILES=$(filter-out $(wildcard _*.Rmd),$(wildcard *.Rmd))


.PHONY: html pdf clean

html:
	Rscript -e 'bookdown::render_book("index.Rmd", output_format = "bookdown::gitbook")'

pdf:
	Rscript -e 'bookdown::render_book("index.Rmd", output_format = "bookdown::pdf_book")'

clean:
	rm -f "R-Graphics-Cookbook-2e.Rmd"
	Rscript -e "bookdown::clean_book(TRUE)"

cleaner: clean
	rm -rf _bookdown_files/
