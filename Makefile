OUT = list

.PHONY: all
all:
	mosmlc -standalone *.sml -o ${OUT}

.PHONY: clean
clean:
	rm ${OUT} *.ui *.uo

.PHONY: install
install: all
	install ${OUT} /usr/local/bin/

