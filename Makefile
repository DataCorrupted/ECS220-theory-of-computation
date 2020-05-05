ifeq ($(OS),Windows_NT)
	PDFVIEWER=chrome
else
	PDFVIEWER=xdg-open
endif

.PHONY : clean all open

all : clean clean-pdf $(patsubst %,%.pdf,$(TARGET)) $(patsubst %,open_%,$(TARGET))

clean-pdf :
	rm -f *.pdf

clean : 
	for i in aux log bbl blg bcf out run.xml fdb_latexmk fls; do \
		rm -f *.$$i ;\
	done
	-rm -f *~

# You may append other dependencies
%.pdf : %.tex
	$(eval basename = $(patsubst %.tex,%,$<))
	xelatex $(basename)

open_% : %.pdf
	$(PDFVIEWER) $(shell pwd)/$< &