all:
	pdflatex --shell-escape project.tex

full:
	pdflatex --shell-escape project.tex
	pdflatex --shell-escape project.tex
	pdflatex --shell-escape project.tex

script:
	cat sql/tables.sql > sql/unipi_project.sql
	echo "" >> sql/unipi_project.sql
	echo "" >> sql/unipi_project.sql
	echo "-- TRIGGERS" >> sql/unipi_project.sql
	echo "" >> sql/unipi_project.sql
	cat sql/triggers.sql >> sql/unipi_project.sql

clean:
	rm project.pdf
	rm *.log
	rm *.aux
	rm *.toc
	rm tex/*.aux
	rm sql/unipi_project.sql
	rm -r _minted-project

mintedclean:
	rm -r _minted-project
