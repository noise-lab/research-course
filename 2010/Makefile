HOST=kendall-square.cc.gt.atl.ga.us
DIR=/usr/local/www/apache22/data/classes/cs7001/fall_2010

LDIR=$(DIR)/lectures/
PDIR=$(DIR)/psets/

SRCS = $(wildcard *.*)
LECTURES = lectures/*.ppt lectures/*.pdf
PSETS_TEX = psets/pdf/*.tex 
PSETS_PDF = psets/pdf/*.pdf

all: web

web: local
	scp -C $(SRCS) Makefile $(HOST):$(DIR)
	rsync -avz -e ssh -r $(LECTURES) $(HOST):$(LDIR)/
	rsync -avz -e ssh -r $(PSETS_TEX) $(PSETS_PDF) $(HOST):$(PDIR)/

local: $(SRCS)
	./datereplace.rb index.html
	./mklectures.rb > syllabus.html
