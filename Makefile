all:
	pdflatex --shell-escape project.tex

full:
	pdflatex --shell-escape project.tex
	pdflatex --shell-escape project.tex
	pdflatex --shell-escape project.tex

script:
	echo 'SELECT "Creazione database e impostazione variabili."' > sql/unipi_project_print.sql
	echo '    AS "************** START - FASE 1 **************";' >> sql/unipi_project_print.sql
	echo "" >> sql/unipi_project_print.sql
	cat sql/head.sql >> sql/unipi_project_print.sql
	echo "" >> sql/unipi_project_print.sql
	echo "" >> sql/unipi_project_print.sql
	echo "-- TABLES" >> sql/unipi_project_print.sql
	echo 'SELECT "Creazione tabelle." AS "***** FASE 2 *****";' >> sql/unipi_project_print.sql
	echo "" >> sql/unipi_project_print.sql
	cat sql/tables.sql >> sql/unipi_project_print.sql
	echo "" >> sql/unipi_project_print.sql
	echo "" >> sql/unipi_project_print.sql
	echo "-- LOG TABLES" >> sql/unipi_project_print.sql
	echo 'SELECT "Creazione tabelle di log." AS "******** FASE 3 *********";' >> sql/unipi_project_print.sql
	echo "" >> sql/unipi_project_print.sql
	cat sql/log-tables.sql >> sql/unipi_project_print.sql
	echo "" >> sql/unipi_project_print.sql
	echo "" >> sql/unipi_project_print.sql
	echo "-- MATERIALIZED VIEWS" >> sql/unipi_project_print.sql
	echo 'SELECT "Creazione materialized views." AS "********** FASE 4 ***********";' >> sql/unipi_project_print.sql
	echo "" >> sql/unipi_project_print.sql
	cat sql/materialized-views.sql >> sql/unipi_project_print.sql
	echo "" >> sql/unipi_project_print.sql
	echo "" >> sql/unipi_project_print.sql
	echo "-- VIEWS" >> sql/unipi_project_print.sql
	echo 'SELECT "Creazione views." AS "**** FASE 5 ****";' >> sql/unipi_project_print.sql
	echo "" >> sql/unipi_project_print.sql
	cat sql/views.sql >> sql/unipi_project_print.sql
	echo "" >> sql/unipi_project_print.sql
	echo "" >> sql/unipi_project_print.sql
	echo 'DELIMITER $$$$' >> sql/unipi_project_print.sql
	echo "" >> sql/unipi_project_print.sql
	echo "" >> sql/unipi_project_print.sql
	echo "-- STORED ROUTINES" >> sql/unipi_project_print.sql
	echo 'SELECT "Creazione stored routines." AS "********* FASE 6 *********";' >> sql/unipi_project_print.sql
	echo "" >> sql/unipi_project_print.sql
	cat sql/stored-routines.sql >> sql/unipi_project_print.sql
	echo "" >> sql/unipi_project_print.sql
	echo "" >> sql/unipi_project_print.sql
	echo "-- TRIGGERS" >> sql/unipi_project_print.sql
	echo 'SELECT "Creazione triggers." AS "***** FASE 7 ******";' >> sql/unipi_project_print.sql
	echo "" >> sql/unipi_project_print.sql
	cat sql/triggers.sql >> sql/unipi_project_print.sql
	echo "" >> sql/unipi_project_print.sql
	echo "" >> sql/unipi_project_print.sql
	echo "-- EVENTS" >> sql/unipi_project_print.sql
	echo 'SELECT "Creazione events." AS "**** FASE 8 *****";' >> sql/unipi_project_print.sql
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
	echo 'SELECT "Riempimento tabelle." AS "****** FASE 9 ******";' >> sql/unipi_project.sql
	echo "" >> sql/unipi_project.sql
	cat sql/inserts.sql >> sql/unipi_project.sql
# end of script:
	echo "" >> sql/unipi_project_print.sql
	echo "" >> sql/unipi_project_print.sql
	echo "-- INSERTS NON RIPORTATI NEL DOCUMENTO" >> sql/unipi_project_print.sql
	echo "" >> sql/unipi_project_print.sql
	echo 'SELECT "Esecuzione script terminata. Bye bye ;)"' >> sql/unipi_project_print.sql
	echo '    AS "************ END OF SCRIPT ************";' >> sql/unipi_project_print.sql
	echo "" >> sql/unipi_project.sql
	echo "" >> sql/unipi_project.sql
	echo 'SELECT "Esecuzione script terminata. Bye bye ;)" AS "************ END OF SCRIPT ************";' >> sql/unipi_project.sql

clean:
	rm project.pdf
	rm *.log
	rm *.aux
	rm *.toc
	rm tex/*.aux
	rm sql/unipi_project_print.sql
	rm sql/unipi_project.sql
	rm -r _minted-project

mintedclean:
	rm -r _minted-project
