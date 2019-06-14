HOST=rigel.cc.gatech.edu
DIR=/net/www/classes/AY2007/cs7001_fall/
#DIR=/net/www/classes/AY2006/cs7260_spring/

LDIR=$(DIR)/lectures/

SRCS = $(wildcard *.*)
LECTURES = lectures/*.pdf

all: web

web: local
	scp -C $(SRCS) Makefile $(HOST):$(DIR)
	rsync -avz -e ssh -r $(LECTURES) $(HOST):$(LDIR)/

local: $(SRCS)
	./datereplace.rb index.html
	./mklectures.rb > syllabus.html
