OUT = list
CC = mosmlc

.PHONY: all
all:
	${CC} *.sml -o ${OUT}

.PHONY: clean
clean:
	rm ${OUT} *.ui *.uo

.PHONY: install
install: all
	install ${OUT} /usr/local/bin/

