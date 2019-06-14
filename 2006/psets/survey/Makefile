DOC_TEX=survey.tex
LATEX=latex

DOC_DVI=$(subst .tex,.dvi,$(DOC_TEX))
DOC_PS=$(subst .tex,.ps,$(DOC_TEX))
DOC_PDF=$(subst .tex,.pdf,$(DOC_TEX))


all:	$(DOC_PS) $(DOC_PDF)

web:
	rsync -avz -e ssh $(DOC_PDF) feamster@rigel.cc.gatech.edu:cs7260-web/

%.pdf: %.ps
	ps2pdf14 $< $@

%.ps: %.dvi
	dvips -t letter -o $@ $<

%.dvi: %.tex
	latex $<
	latex $<
	latex $<

clean:
	rm -f *.dvi *.aux *.log *.blg *.bbl $(DOC_PS)
