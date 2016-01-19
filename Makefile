all: epapr-1.1.html epapr-1.1.xml


%.xml: %.adoc
	asciidoctor $< -b docbook5

%.html: %.adoc
	asciidoctor $<
