REPORT=paper
CAMERA=fp125-feamster
LATEX=latex
BIBTEX=bibtex
REF1=ref
REF2=rfc

TEX = $(wildcard *.tex)
SRCS = $(TEX)
REFS=$(REF1).bib $(REF2).bib

all: $(REPORT).dvi $(REPORT).ps 

camera: $(REPORT).dvi
	rm -f $(CAMERA).*
	dvips -t letter -Pcmz $(REPORT).dvi -o $(CAMERA).ps
	ps2pdf14 -dPDFSETTINGS=/prepress -dSubsetFonts=true -dEmbedAllFonts=true $(CAMERA).ps $(CAMERA).pdf
	cat *tex *.bbl > $(CAMERA).tex
	perl -pi -e 's/^%.*\n//' $(CAMERA).tex
	tar cvf - $(CAMERA).* | gzip -c > $(CAMERA).tar.gz

$(REPORT).dvi: $(SRCS) #$(REFS)
	$(LATEX) $(REPORT)
	$(BIBTEX) $(REPORT)
	perl -pi -e "s/%\s+//" paper.bbl
	$(LATEX) $(REPORT)
	$(LATEX) $(REPORT)

$(REPORT).ps: $(REPORT).dvi figures
	dvips -t letter -G0 -Pcmz $(REPORT).dvi -o $(REPORT).ps

view: $(REPORT).dvi
	xdvi $(REPORT).dvi

print: $(REPORT).dvi
	dvips $(REPORT).dvi

pdf: $(REPORT).ps
	ps2pdf $< $(REPORT).pdf

printer: $(REPORT).ps
	lpr $(REPORT).ps

tidy:
	rm -f *.dvi *.aux *.log *.blg *.bbl

clean:
	rm -f *~ *.dvi *.aux *.log *.blg *.bbl $(REPORT).ps

