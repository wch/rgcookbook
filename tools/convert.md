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

mreplace -e " \{.r\}" "{r}" *.Rmd
```