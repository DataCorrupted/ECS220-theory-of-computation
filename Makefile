ifeq ($(OS),Windows_NT)
	PDFVIEWER=chrome
else
	PDFVIEWER=xdg-open
endif

.PHONY : clean all open

all : clean $(patsubst %,%.pdf,$(TARGET)) open

clean-pdf :
	rm -f *.pdf

clean : clean-pdf
	for i in aux log bbl blg bcf out run.xml fdb_latexmk fls; do \
		rm -f $(patsubst %,%.$$i,$(TARGET)); \
	done
	-rm -f *~

# You may append other dependencies
%.pdf : %.tex
	$(eval basename = $(patsubst %.tex,%,$<))
	xelatex $(basename)
	xelatex $(basename)

open : $(TARGET).pdf
	$(PDFVIEWER) $(shell pwd)/$(TARGET).pdf &