.PHONY: all cn en clean

all: cn en

cn:
	latexmk -xelatex -cd -outdir=build resume-cn.tex

en:
	latexmk -xelatex -cd -outdir=build resume-en.tex

clean:
	latexmk -C -cd -outdir=build resume-cn.tex
	latexmk -C -cd -outdir=build resume-en.tex
