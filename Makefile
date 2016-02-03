STYLESHEETS_DIR = /usr/share/xml/docbook/stylesheet/nwalsh
DOC=epapr-1.1

all: $(DOC).html $(DOC).xml $(DOC).pdf

%.fo: %.xml
	xsltproc -o $@ $(STYLESHEETS_DIR)/fo/docbook.xsl $<

%.pdf: %.fo
	fop -pdf $@ -fo $<

%.xml: %.adoc
	asciidoctor $< -b docbook5

%.html: %.adoc
	asciidoctor $<

clean:
	rm -f $(DOC).html $(DOC).xml $(DOC).pdf
