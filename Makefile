.PHONY: all cn en clean

all: cn en

cn:
	latexmk -xelatex -cd -outdir=../build src/resume-cn.tex

en:
	latexmk -xelatex -cd -outdir=../build src/resume-en.tex

clean:
	latexmk -C -cd -outdir=../build src/resume-cn.tex
	latexmk -C -cd -outdir=../build src/resume-en.tex
