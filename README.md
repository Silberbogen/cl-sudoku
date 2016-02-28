cl-sudoku
=========

Das Paket CL-SUDOKU enthält außer der Möglichkeit, Sudoku in Common
Lisp zu Spielen, auch einen Generator für Rätsel, der stets lösbare
Sudokus verschiedener Spielstärken generiert (Voreinstellung: Nur EINE
richtige Lösung).

Ebenso beinhaltet das Paket einen Sudoku-Löser.

Zum Spielen sollte man per _git clone_ das Repository im Verzeichnis
~/quicklisp/local-projects/ anlegen.

Zum Spielen unter Slime empfehlen sich folgende Kommandos:
- (ql:quickload :cl-sudoku)
- (in-package :cl-sudoku)
- (spiele-sudoku)

Zur Erstellung einer ausführbaren Datei in SBCL:

$ *sbcl*

* *(ql:quickload :cl-hilfsroutinen)*
* *(ql:quickload :cl-sudoku)*
* *(sb-ext:save-lisp-and-die #p"sudoku" :toplevel #'cl-sudoku:spiele-sudoku :executable t)*


*Funktionen*
------------
* **erzeuge-sudoku**
* **erzeuge-rätsel**
* **löse-sudoku**
* **pprint-sudoku**
* **spiele-sudoku**


*Prädikate*
-----------
* **gültige-lösung-p**

Bildschirmfoto
--------------
![Bildschirmfoto](/bildschirmfoto.png)

