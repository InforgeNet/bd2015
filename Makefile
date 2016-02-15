all:
	pdflatex --shell-escape project.tex

full:
	pdflatex --shell-escape project.tex
	pdflatex --shell-escape project.tex
	pdflatex --shell-escape project.tex

script:
	cat sql/head.sql > sql/unipi_project_print.sql
	echo "" >> sql/unipi_project_print.sql
	echo "" >> sql/unipi_project_print.sql
	echo "-- TABLES" >> sql/unipi_project_print.sql
	echo "" >> sql/unipi_project_print.sql
	cat sql/tables.sql >> sql/unipi_project_print.sql
	echo "" >> sql/unipi_project_print.sql
	echo "" >> sql/unipi_project_print.sql
	echo "-- VIEWS" >> sql/unipi_project_print.sql
	echo "" >> sql/unipi_project_print.sql
	cat sql/views.sql >> sql/unipi_project_print.sql
	echo "" >> sql/unipi_project_print.sql
	echo "" >> sql/unipi_project_print.sql
	echo "-- MATERIALIZED VIEWS" >> sql/unipi_project_print.sql
	echo "" >> sql/unipi_project_print.sql
	cat sql/materialized-views.sql >> sql/unipi_project_print.sql
	echo "" >> sql/unipi_project_print.sql
	echo "" >> sql/unipi_project_print.sql
	echo "-- LOG TABLES" >> sql/unipi_project_print.sql
	echo "" >> sql/unipi_project_print.sql
	cat sql/log-tables.sql >> sql/unipi_project_print.sql
	echo "" >> sql/unipi_project_print.sql
	echo "" >> sql/unipi_project_print.sql
	echo 'DELIMITER $$$$' >> sql/unipi_project_print.sql
	echo "" >> sql/unipi_project_print.sql
	echo "" >> sql/unipi_project_print.sql
	echo "-- STORED ROUTINES" >> sql/unipi_project_print.sql
	echo "" >> sql/unipi_project_print.sql
	cat sql/stored-routines.sql >> sql/unipi_project_print.sql
	echo "" >> sql/unipi_project_print.sql
	echo "" >> sql/unipi_project_print.sql
	echo "-- TRIGGERS" >> sql/unipi_project_print.sql
	echo "" >> sql/unipi_project_print.sql
	cat sql/triggers.sql >> sql/unipi_project_print.sql
	echo "" >> sql/unipi_project_print.sql
	echo "" >> sql/unipi_project_print.sql
	echo "-- EVENTS" >> sql/unipi_project_print.sql
	echo "" >> sql/unipi_project_print.sql
	cat sql/events.sql >> sql/unipi_project_print.sql
	echo "" >> sql/unipi_project_print.sql
	echo "" >> sql/unipi_project_print.sql
	echo 'DELIMITER ;' >> sql/unipi_project_print.sql
# full script:
	cat sql/unipi_project_print.sql > sql/unipi_project.sql
	echo "" >> sql/unipi_project.sql
	echo "" >> sql/unipi_project.sql
	echo "-- INSERTS" >> sql/unipi_project.sql
	echo "" >> sql/unipi_project.sql
	cat sql/inserts.sql >> sql/unipi_project.sql

clean:
	rm project.pdf
	rm *.log
	rm *.aux
	rm *.toc
	rm tex/*.aux
	rm sql/unipi_project_print.sql
	rm -r _minted-project

mintedclean:
	rm -r _minted-project
