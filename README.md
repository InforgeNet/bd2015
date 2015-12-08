# UNIPI - Progetto Basi di Dati 2014/2015  
*Copyright © 2014-2015 - Gabriele Marraccini, Lorenzo Tonelli, Niccolò Scatena - Tutti i diritti sono riservati.*  

## Uso di git  
`git` è il software di *version control* più utilizzato al mondo. **GitHub** utilizza `git`.  
Ad esempio anche il *kernel Linux* viene sviluppato con `git`: [torvalds/linux](https://github.com/torvalds/linux)  
Tra l'altro `git` è proprio un progetto dello stesso *Linus Torvalds*.  

Altri esempi di software di version control sono:  
* `svn` (subversion) - un tempo era molto utilizzato ma oggi è stato interamente rimpiazzato da `git`;  
* `mercurial` - utilizzato ad esempio da *Mozilla* per *FireFox*.  

**AVVERTENZA:** è consigliato prima leggere questo capitolo e la documentazione associata **interamente** e *solo dopo* configurare ed utilizzare `git`.  

### Installazione  
Per installare `git` seguire le istruzioni del capitolo [Installing Git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git) della *documentazione ufficiale*.  

### Configurazione  
Per configurare `git` seguire le istruzioni del capitolo [First-Time Git Setup](https://git-scm.com/book/en/v2/Getting-Started-First-Time-Git-Setup) della *documentazione ufficiale*.  

Per essere correttamente riconosciuti, l'identità inserita in `git` **deve** avere:  
* come `user.name` il *nome e cognome* che avete inserito in GitHub. **NON** l'username, ma il **nome completo** che avete messo su GitHub.  
* come `user.email` lo stesso *indirizzo e-mail* del vostro account GitHub.  

Maggiori informazioni: [Set Up Git](https://help.github.com/articles/set-up-git/)  

### Clonare questo repository  
Prima di tutto è necessario *clonare* questo *repository* localmente utilizzando il comando `git clone`.  
Il link del repository da utilizzare è: https://github.com/InforgeNet/bd2015.git  

La spiegazione su come utilizzare il comando `git clone` è disponibile al capitolo [Getting a Git Repository](https://git-scm.com/book/en/v2/Git-Basics-Getting-a-Git-Repository) della *documentazione ufficiale*.  
(**non** deve essere utilizzato `git init` ma solo `git clone`)  

Quando date il comando verranno richieste le vostre credenziali (username e password) di accesso a GitHub (la password non è visibile durante la digitazione).  
Per evitare che `git` vi chieda sempre le credenziali ad ogni comando, attivate la [cache delle credenziali](https://help.github.com/articles/caching-your-github-password-in-git/)  
Il *timeout* potete impostarlo in base alle vostre preferenze (io ho messo *100 ore = 360000 secondi*).

### Lavorare con git  
Per utilizzare `git` con questo repository, è necessario anche aver letto e compreso i capitoli [Recording Changes to the Repository](https://git-scm.com/book/en/v2/Git-Basics-Recording-Changes-to-the-Repository) e [Working with Remotes](https://git-scm.com/book/en/v2/Git-Basics-Working-with-Remotes) della *documentazione ufficiale*.  
In particolare servono:
* `git add <nomefile>` ogni volta che si aggiunge un file. Usare `.` (punto) al posto di `<nomefile>` per aggiungere tutti i nuovi file inseriti;  
* `git rm <nomefile>` ogni volta che si rimuove un file;  
* `git pull` per scaricare le modifiche fatte da altri;  
* `git commit -a -m '<messaggio>'` e `git push` per caricare le modifiche sul repository.  

Il resto della documentazione ovviamente può essere sempre utile.  

**N.B.:** Qualsiasi file o cartella inizi con un punto (`.`) deve essere lasciato intoccato (es: `.gitignore`, `.git`, ecc.) - sono i file di configurazione di `git`.  

## Sistemazione dell'ambiente  
Prima di poter iniziare a lavorare con il progetto bisogna sistemare un po' l'ambiente (o si incappa in errori e casini).  

### Ritorni a capo nell'editor (solo Windows)  
Se si usa Windows ci possono essere problemi con i ritorni a capo nei file: Windows utilizza la sequenza `\r\n` (DOS File) per rappresentare il ritorno a capo; Linux invece usa solo `\n` (Unix File).  

Perciò, dato che i file di questo repository sono stati fatti tutti con Linux, per lavorarci con Windows è necessario impostare l'editor in modo da fargli riconoscere il solo `\n` come ritorno a capo.  
Con `notepad.exe` non è possibile. Ma se si fa uso di editor più avanzati (come `notepad++`) allora esiste sicuramente una configurazione dei caratteri di ritorno a capo.  
Nel caso specifico di `notepad++` la sequenza corretta di ritorni a capo dovrebbe venir *riconosciuta automaticamente* e quindi non è necessaria alcuna configurazione.  

### Tabulazioni  
Per quanto le tabulazioni non diano problemi, possibilmente è meglio adattare (dalle impostazioni) il proprio editor di testo in modo che alla pressione del tasto `TAB` invece di inserire il carattere `\t` (tabulazione) inserisca **4 (quattro) spazi**.  
Tutti i file del respository sono stati scritti utilizzando **4 spazi** al posto delle tabulazioni - quindi è consigliato mantenersi a questa regola.  

### Minted  
Il progetto `LaTeX` fa uso di un pacchetto speciale: `minted` per il *syntax highlight* dei codici SQL.  
Questo pacchetto necessita di **Python** e di **Pygments**: per la guida all'installazione seguire il *capitolo 2.1 "Prerequisites"* della [documentazione ufficiale](http://ctan.mirrorcatalogs.com/macros/latex/contrib/minted/minted.pdf).  
Il pacchetto `minted` dovrebbe essere già installato. Se così non fosse il *capitolo 2.3* spiega l'installazione manuale.  

In caso di problemi (durante la compilazione con `pdflatex` - spiegata nel prossimo capitolo), per risolverli, potrebbe essere necessario anche seguire il procedimento descritto nella risposta (quella di *Joseph Wright*) di [questo topic](https://tex.stackexchange.com/questions/23458/how-to-install-syntax-highlight-package-minted-on-windows-7) (notare che è `easy_install Pygmentize` che è diverso da Pygments - è probabile servano entrambi).  
(quella è comunque una domanda vecchia, quindi probabile non sia più necessario seguire quei passi: però io, su Linux, ho dovuto mettere anche `pygmentize` oltre a `pygments` - fatelo però solo se la compilazione (prossimo capitolo) non funziona correttamente)  

A volte anche eliminare la cartella `_minted-project` che compare dopo la prima esecuzione di `pdflatex` può risolvere alcuni problemi con `minted` dati in fase di compilazione.  

## Compilazione  
Con il *prompt dei comandi/terminale*, dirigersi nella cartella locale del progetto e dare:  
`pdflatex --shell-escape project.tex`  
(`--shell-escape` è necessario per `minted`).  

Oppure più semplicemente:  
* **Windows:** eseguire il file `make.bat`. *non testato*  
* **Linux:** dare il comando `make`.  

Talvolta può essere necessario eseguire la compilazione anche 2 o 3 volte: questo permette a `LaTeX` di impostare adeguatamente l'indice e i riferimenti del testo. Quando è necessario, compare vicino alla fine dell'output di `pdflatex`:  
`LaTeX Warning: Label(s) may have changed. Rerun to get cross-references right.`  
Per farlo:  
* **Qualsiasi:** eseguire più volte `pdflatex --shell-escape project.tex`.  
* **Windows:** eseguire più volte il file `make.bat` oppure eseguire una volta il file `make-full.bat`. *non testato*  
* **Linux:** dare più volte il comando `make` oppure dare una volta il comando `make full`.  

Se si desidera ripulire tutta la sporcizia lasciata nella cartella dalla compilazione (file `.log`, `.aux`, `.toc`):  
* **Windows:** eseguire il file `make-clean.bat`. *non testato*  
* **Linux:** dare il comando `make clean`.  

L'output viene generato in `project.pdf` visibile con un qualsiasi visualizzatore PDF.  
Qualsiasi *warning* in fase di compilazione che parla di `underfull /hbox` o `overfull /hbox` **deve**, per ora, essere ignorato (cosa significano è spiegato sotto nel capitolo sul `LaTeX`).  

## Organizzazione del File System  
Nella *root* del progetto c'è:  
* `README.md` - questo file.  
* `TODO.md` - contiene una lista delle cose ancora da fare.  
* `project.tex` - il documento principale che viene compilato, contiene la struttura di base del documento e la lista di pacchetti.  
* `Makefile` - utilizzato in Linux per compilare rapidamente con `make`.  
* `make-*.bat` - usati in Windows per compilare rapidamente.  
* `images/` - cartella contenente tutte le immagini che vengono incluse nel documento.  
* `sql/` - tutti i codici SQL che vengono inclusi nel documento.  
* `tex/` - tutti i file `.tex` che vengono inclusi da `project.tex`. Questi file contengono il *vero contenuto* del documento.  
* `workbench/` - contiene il progetto workbench con il diagramma. **NON AGGIORNATO**  

Dentro alla cartella `tex/` la struttura è un po' complessa:  
- Per ogni capitolo del progetto c'è un file `chXY.tex` che contiene il capitolo `XY` del progetto.  
- Per ogni capitolo esiste anche una cartella `chXY/` che contiene le sezioni e le sottosezioni di quel capitolo (che vengono incluse in `chXY.tex`) - *alcuni capitoli non hanno per ora la cartella in quanto non sono ancora stati scritti*.  
- Dentro alle cartelle dei capitoli (`chXY/`) ci sono i file `.tex` che contengono le varie sezioni. Per alcune sezioni ci può essere anche una cartella con lo stesso nome del file che contiene le eventuali sottosezioni.  

Con una struttura del genere diventa semplice rimuovere o riordinare capitoli/sezioni/sottosezioni.  
* Per rimuovere un capitolo/sezione/sottosezione basta commentare (con il carattere `%`) il comando `\input` o `\include` che include il file contenente il capitolo/sezione/sottosezione - **senza** cancellare alcun file.  
* Per riordinare dei capitoli/sezioni/sottosezioni basta riordinare i vari comandi `\input` o `\include`.  

**NOTA:** Il comando `\include` è da usare solo per i **CAPITOLI** nel file `project.tex`. In tutti gli altri casi deve essere utilizzato `\input`.  

Dentro alla cartella `\tex` ci sono anche i seguenti file *speciali*:  
* `title.tex` - titolo (prima pagina) del documento.  
* `style.tex` - definisce lo stile del documento.  
* `def.tex` - contiene le definizioni dei comandi *user-defined*.  
* `hyphen.tex` - specifica le regole di sillabazione delle parole non presenti nel dizionario di `LaTeX`. 
* `lang-style.tex` - definisce le regole di presentazione del codice SQL con il pacchetto `listings`. **NON UTILIZZATO** in quanto ho sostituito il pacchetto `listings` con `minted`.  

## LaTeX  
`LaTeX` è semplice: testo misto a comandi. I comandi iniziano sempre con `\` e possono contenere argomenti in parentesi graffe `{}` o argomenti opzionali in parentesi quadre `[]`  

Il 99% dei comandi si spiegano da soli: basta vederli.  
`LaTeX` si impara di fatto con la pratica e vedendo cosa fa ogni comando. I manuali `LaTeX` non sono necessari.

I *paragrafi di testo* sono separati da righe vuote (tornare semplicemente a capo una volta non basta - almeno 2 volte).  
Per tornare a capo senza cambiare paragrafo bisogna inserire `\\`.  
Gli spazi *non* vengono considerati: inserire 1 spazio o 1000 spazi tra 2 parole non cambia niente (viene considerato sempre come 1 spazio).  
Le tabelle in `LaTeX` sono invece un po' complicate (se vi serve, vi lascio a Google).

I comandi dentro il file `project.tex` sono già tutti commentati con descrizione affianco.  

### Underfull e Overfull  
`underfull /hbox` e `overfull /hbox` sono *warning* comuni in fase di compilazione (sopratutto se si lavora con tabelle).  
Stanno semplicemente ad indicare che il compilatore `LaTeX` non è stato in grado di inserire il testo in modo adeguato nel suo spazio predisposto.  

Ad esempio se volete inserire del testo in una tabella con diverse colonne, lo spazio disponibile al testo in ogni colonna è poco, e quindi `LaTeX` è costretto a tornare a capo frequentemente.  
Per far questo spesso deve spezzare le parole in base alla loro sillabazione. Non sempre però riesce a trovare un adeguato punto dove spezzare la parola - in questi casi, avvisa di `overfull /hbox`, ossia che ha dovuto *sforare* fuori dalla tabella, o di `underfull /hbox`, ossia che ha dovuto inserire spazi *più lunghi* nella riga soprastante per poter andare a capo senza perdere la giustificazione del testo.  
Gli *underfull* e *overfull* possono verificarsi ovunque (non soltanto con le tabelle). Ad ogni modo, per il momento, sono da ignorare: penseremo a sistemarli una volta finito il progetto.  
Nel caso sia attiva l'opzione `draft` nel file `project.tex`, nel PDF che viene prodotto dalla compilazione, tutti gli *underfull* e *overfull* vengono *markati* con dei quadratini neri: questi quadratini **non** compariranno, ovviamente, nella versione finale del documento.

  
Comunque l'importante è stendere il contenuto - non perdete troppo tempo dietro ai comandi `LaTeX`.  

## Markdown di GitHub  
Per scrivere testi *fighi* come questo, formattati per GitHub:  
* [Markdown Basics](https://help.github.com/articles/markdown-basics/)  
* [GitHub Flavored Markdown](https://help.github.com/articles/github-flavored-markdown/)  
* [Writing on GitHub](https://help.github.com/articles/writing-on-github/)  
* [Mastering Markdown](https://guides.github.com/features/mastering-markdown/)  

Possibilmente, alla fine di ogni riga nei file `.md`, lasciate sempre **due spazi**. Altrimenti il semplice ritorno a capo potrebbe non funzionare.  

Se volete un esempio di *documento markdown*... bhé c'è questo stesso file ;)

## Per problemi o domande  
Whatsapp ;) (o Google)  
