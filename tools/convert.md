Notes for converting from AsciiDoc to Rmd
=========================================

The original format of the documents from the O'Reilly repository is AsciiDoc. It needs to be converted to Rmd to be used with bookdown.



Convert from asciidoc to docbook:

```sh
docker run --rm -it -v $(pwd):/documents/ asciidoctor/docker-asciidoctor

# Convert asciidoc files to docbook
ls *.asciidoc | xargs -L 1 asciidoctor -b docbook5
```


Convert docbook to md:

```sh
# Command line is like:
#   pandoc --from docbook --to markdown-header_attributes --wrap=preserve ch01.xml -o ch01.md
for old in *.xml; do pandoc --from docbook --to markdown-header_attributes --wrap=preserve $old -o `basename $old .xml`.md; done

rm *.xml
mv *.md ../rgcookbook2e
```


Convert md to Rmd, then fix up code blocks:

```sh
cd ../rgcookbook2e
mmv -e \\.md .Rmd

# Fix code blocks
mreplace -e " \{.r\}" "{r}" *.Rmd

# Fix smart quote markers
mreplace -e "RSQUO" "'" *.Rmd
mreplace -e "RDQUO" '"' *.Rmd
mreplace -e "LDQUO" '"' *.Rmd

# Rename FIG_X_Y to FIG-X-Y. knitr doesn't like underscores for numbered figure
# refs. Run this repeatedly until no more are found.
mreplace -e "FIG([^ \n]*?)_" "FIG\\1-" *.Rmd

# Change figure references to knitr format
mreplace -e "\\[figure\\\\_title\\]\\(#" "Figure \\@ref(fig:" *.Rmd


# Rename RECIPE_X_Y to RECIPE-X-Y.
# Run this repeatedly until no more are found.
mreplace -e "RECIPE([^ \n]*?)_" "RECIPE\\1-" *.Rmd

# Change recipe references to knitr format
mreplace -e "\\[.*?]\\(#RECIPE" "Recipe \\@ref(RECIPE" *.Rmd


# Rename CHAPTER_X_Y to CHAPTER-X-Y.
# Run this repeatedly until no more are found.
mreplace -e "CHAPTER([^ \n]*?)_" "CHAPTER\\1-" *.Rmd

# Change chapter references to knitr format
mreplace -e "\\[.*?]\\(#CHAPTER" "Chapter \\@ref(CHAPTER" *.Rmd


# Remove Problem/Solution/See Also/Discussion labels
mreplace " +{#_(problem|solution|see_also|discussion)_\\d+}" "" *.Rmd

# Replace "\$\$\_\$\$" with "_"
mreplace "(\w+)\\\\\\$\\\\\\$\\\_\\\\\\$\\\\\\\$(\w+)" "\1_\2" *.Rmd
```
