all:
	pdflatex --shell-escape project.tex
	
full:
	pdflatex --shell-escape project.tex
	pdflatex --shell-escape project.tex
	pdflatex --shell-escape project.tex

clean:
	rm project.pdf
	rm *.log
	rm *.aux
	rm *.toc
	rm tex/*.aux

mintedclean:
	rm -r _minted-project