# All .Rmd files except those that start with "_"
RMD_FILES=$(filter-out $(wildcard _*.Rmd),$(wildcard *.Rmd))


.PHONY: html pdf clean

html: $(RMD_FILES)
	Rscript -e 'bookdown::render_book("index.Rmd", output_format = "bookdown::gitbook")'

pdf: $(RMD_FILES)
	Rscript -e 'bookdown::render_book("index.Rmd", output_format = "bookdown::pdf_book")'

clean:
	Rscript -e "bookdown::clean_book(TRUE)"
	rm -f "R Graphics Cookbook.Rmd"

cleaner: clean
	rm -rf _bookdown_files/
