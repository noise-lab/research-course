HOST=kendall-square.cc.gt.atl.ga.us
DIR=/usr/local/www/apache22/data/classes/cs7001/fall_2008
#DIR=/net/ac190/www-db1/fac/feamster/classes/CS7001-FA07

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
