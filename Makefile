# Makefile for splitting A0 poster.pdf into 2 A1 horizontal pages using mutool

INPUT     = poster.pdf
OUTPUT    = posterA1.pdf
TMPDIR    = tmp_pages

.PHONY: all clean info

all: $(OUTPUT)

$(OUTPUT): $(INPUT)
	@echo "🔧 Splitting A0 → A1 x 2 (horizontal)..."
	mkdir -p $(TMPDIR)
	mutool poster -y 2 $(INPUT) $(TMPDIR)/page.pdf
	@echo "🧹 Merging 2 pages into $(OUTPUT)..."
	# If available, use pdfunite or ghostscript to merge
	if command -v pdfunite >/dev/null; then \
		pdfunite $(TMPDIR)/page-1.pdf $(TMPDIR)/page-2.pdf $@; \
	elif command -v gs >/dev/null; then \
		gs -dBATCH -dNOPAUSE -q -sDEVICE=pdfwrite -sOutputFile=$@ $(TMPDIR)/page-*.pdf; \
	else \
		echo "⚠️ Error: neither pdfunite nor ghostscript (gs) is available to merge PDFs."; \
		exit 1; \
	fi
	@echo "✅ Done: $(OUTPUT) created."

info:
	@echo "📄 Page info for $(OUTPUT):"
	pdfinfo $(OUTPUT) || echo "(install poppler to use pdfinfo)"

clean:
	rm -rf $(TMPDIR) $(OUTPUT)
	@echo "🧼 Cleaned temporary files and output."
