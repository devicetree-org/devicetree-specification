STYLESHEETS_DIR = /usr/share/xml/docbook/stylesheet/nwalsh
DOC=epapr-1.1
ASCIIDOCTOR=asciidoctor -r asciidoctor-diagram

all: $(DOC).html $(DOC).xml $(DOC).pdf

%.fo: %.xml
	xsltproc -o $@ $(STYLESHEETS_DIR)/fo/docbook.xsl $<

%.pdf: %.fo
	fop -pdf $@ -fo $<

%.xml: %.adoc
	$(ASCIIDOCTOR) $< -b docbook5

%.html: %.adoc
	$(ASCIIDOCTOR) $<

clean:
	rm -f $(DOC).html $(DOC).xml $(DOC).pdf
