# Minimal makefile for Sphinx documentation
#

# You can set these variables from the command line.
SPHINXOPTS    =
SPHINXBUILD   = sphinx-build
SOURCEDIR     = source
BUILDDIR      = build
LATEXDIFF     = latexdiff

# Put it first so that "make" without argument is like "make help".
help:
	@$(SPHINXBUILD) -M help "$(SOURCEDIR)" "$(BUILDDIR)" $(SPHINXOPTS) $(O)
	@echo "  latexdiff   to make LaTeX files including changebars against previous release"

.PHONY: help latexdiff Makefile

latexdiff: latex
	@echo "Generating LaTeX changebars..."
	$(LATEXDIFF) --type=UNDERLINE --config VERBATIMENV=sphinxVerbatim $(BUILDDIR)/latex-previous/devicetree-specification.tex $(BUILDDIR)/latex/devicetree-specification.tex > $(BUILDDIR)/latex/devicetree-specification-changebars.tex
	@echo "Running LaTeX files through pdflatex..."
	$(MAKE) -C $(BUILDDIR)/latex all-pdf
	@echo
	@echo "latexdiff finished; the PDF files are in $(BUILDDIR)/latex."

# Catch-all target: route all unknown targets to Sphinx using the new
# "make mode" option.  $(O) is meant as a shortcut for $(SPHINXOPTS).
%: Makefile
	@$(SPHINXBUILD) -M $@ "$(SOURCEDIR)" "$(BUILDDIR)" $(SPHINXOPTS) $(O)
