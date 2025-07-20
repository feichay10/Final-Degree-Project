main=memtfg

all:
	latexmk -xelatex $(main)

.PHONY: clean
clean:
	latexmk -c $(main)

.PHONY: mrproper
mrproper:
	latexmk -C $(main)

.PHONY: count
count:
	texcount -inc $(main).tex

