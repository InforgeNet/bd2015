# UNIPI - Progetto Basi di Dati 2014/2015  
*Copyright © 2014-2016 - Gabriele Marraccini, Lorenzo Tonelli, Niccolò Scatena - Alcuni diritti sono riservati.*  
*Università degli Studi di Pisa*  

Questo repository è reso pubblico per finalità didattiche: può essere utilizzato come esempio di progetto `MySQL` e/o `LaTeX`.  
Eventuali *pull-request* e *issue* saranno **ignorate**. *Non* saranno rilasciati aggiornamenti per questo progetto.  

## Organizzazione del codice  
Nella *root* del progetto c'è:  
* [README.md](README.md) - questo file;  
* [specifiche.pdf](specifiche.pdf) - contiene le specifiche di progetto;  
* [project.pdf](project.pdf) - contiene il progetto finale;  
* [project-twoside.pdf](project-twoside.pdf) - contiene il progetto finale per la stampa fronte-retro;  
* [project.tex](project.tex) - il documento principale che viene compilato, contiene la struttura di base del documento e la lista di pacchetti;  
* [project-twoside.tex](project-twoside.tex) - l'equivalente di `project.tex` ma con il flag `twoside` attivo (per la stampa fronte-retro);  
* [Makefile](Makefile) - utilizzato in Linux per compilare con `make`;  
* [images/](images) - cartella contenente tutte le immagini che vengono incluse nel documento;  
* [sql/](sql) - tutti i codici SQL che vengono inclusi nel documento;  
* [tex/](tex) - contiene i vari capitoli del documento; 
* [workbench/](workbench) - contiene il progetto workbench con il diagramma. **OUT-DATED**  

## Note  
* Per la compilazione, serve avere il pacchetto `minted` correttamente installato nel sistema;  
* Alcune parti del codice MySQL del progetto **non** sono testate - potrebbero non funzionare correttamente;  
* Sono presenti nel codice alcuni comandi obsoleti (ad es. `\it`, `\bf`, `$ ... $`, ecc.);  
* I codici MySQL usano 4 spazi per la tabulazione;  
* Nel [tex/ch08/access-tables.tex](Capitolo 8.2 - "Tavole degli accessi") sono presenti alcuni errori di valutazione degli accessi effettuati dalle operazioni;  
* La funzione `IngredientiDisponibili` non fa ciò che dovrebbe: non tiene conto che più di una ricetta può usare gli stessi ingredienti;  
* Gli `INSERT INTO` non sono completi;  
* Voto Finale: **29.5** *(sic!)* - Consegnato il *23 Febbraio 2016*.  

## Licenza  
**Creative Commons - Attribution, ShareAlike 4.0** *(CC BY-SA 4.0)*  

Informazioni: https://creativecommons.org/licenses/by-sa/4.0/deed.it  

Testo completo della licenza: https://creativecommons.org/licenses/by-sa/4.0/legalcode  
