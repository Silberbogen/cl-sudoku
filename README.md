cl-sudoku
=========

Das Paket CL-SUDOKU enthält außer der Möglichkeit, Sudoku in Common
Lisp zu Spielen, auch einen Generator für Rätsel, der stets lösbare
Sudokus verschiedener Spielstärken generiert (Voreinstellung: Nur EINE
richtige Lösung).

Ebenso beinhaltet das Paket einen Sudoku-Löser.

Zum Spielen sollte man per _git clone_ das Repository im Verzeichnis
~/quicklisp/local-projects/ anlegen.

Zum spielen unter Slime empfehlen sich folgende Kommandos:
- (ql:quickload :cl-sudoku)
- (in-package :cl-sudoku)
- (spiele-sudoku)


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

