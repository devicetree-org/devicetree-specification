STYLESHEETS_DIR = /usr/share/xml/docbook/stylesheet/nwalsh

all: epapr-1.1.html epapr-1.1.xml epapr-1.1.pdf

%.fo: %.xml
	xsltproc -o $@ $(STYLESHEETS_DIR)/fo/docbook.xsl $<

%.pdf: %.fo
	fop -pdf $@ -fo $<

%.xml: %.adoc
	asciidoctor $< -b docbook5

%.html: %.adoc
	asciidoctor $<

#%.html: %.xml
#	xsltproc -o $@ $(STYLESHEETS_DIR)/xhtml/docbook.xsl $<
