;;;; -*- mode: lisp -*-
;;;; -*- coding: utf-8 -*-
;;;; Dateiname: cl-sudoku.lisp
;;;; Beschreibung: Lösungen diverser Aufgaben von Projekt Euler
;;;; ------------------------------------------------------------------------
;;;; Author: Sascha K. Biermanns, <skkd PUNKT h4k1n9 AT yahoo PUNKT de>
;;;; Lizenz: GPL v3
;;;; Copyright (C) 2011-2015 Sascha K. Biermanns
;;;; This program is free software; you can redistribute it and/or modify it
;;;; under the terms of the GNU General Public License as published by the
;;;; Free Software Foundation; either version 3 of the License, or (at your
;;;; option) any later version.
;;;;
;;;; This program is distributed in the hope that it will be useful, but
;;;; WITHOUT ANY WARRANTY; without even the implied warranty of
;;;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General
;;;; Public License for more details.
;;;;
;;;; You should have received a copy of the GNU General Public License along
;;;; with this program; if not, see <http://www.gnu.org/licenses/>. 
;;;; ------------------------------------------------------------------------


(in-package #:cl-sudoku)



(defun erstelle-kopie (orig)
  "ERSTELLE-KOPIE erzeugt eine tiefe Kopie des übergebenen Sudoku-Arrays."
  (let ((kopie (make-array '(9 9))))
	(dotimes (i 9 kopie)
	  (dotimes (j 9)
		(setf (aref kopie i j) (aref orig i j))))))


(defun möglichkeiten (zeile spalte tab)
  "MÖGLICHKEITEN errechnet, welche Zahlen tatsächlich an einer Position möglich ist und übergibt eine Liste mit allen Möglichkeiten zurück."
  (flet ((zeile-nachbarn (zeile spalte &aux (nachbarn '()))
		   (dotimes (i 9 nachbarn)
			 (let ((x (aref tab zeile i)))
			   (unless (or (eq '_ x) (= i spalte))
				 (push x nachbarn)))))
		 (spalte-nachbarn (zeile spalte &aux (nachbarn '()))
		   (dotimes (i 9 nachbarn)
			 (let ((x (aref tab i spalte)))
			   (unless (or (eq x '_) (= i zeile))
				 (push x nachbarn)))))
		 (box-nachbarn (zeile spalte &aux (nachbarn '()))
		   (let* ((zeile-min (* 3 (floor zeile 3)))    (zeile-max (+ zeile-min 3))
				  (spalte-min (* 3 (floor spalte 3))) (spalte-max (+ spalte-min 3)))
			 (do ((r zeile-min (1+ r))) ((= r zeile-max) nachbarn)
			   (do ((c spalte-min (1+ c))) ((= c spalte-max))
				 (let ((x (aref tab r c)))
				   (unless (or (eq x '_) (= r zeile) (= c spalte))
					 (push x nachbarn))))))))
	(nset-difference
	 (list 1 2 3 4 5 6 7 8 9)
	 (nconc (zeile-nachbarn zeile spalte)
			(spalte-nachbarn zeile spalte)
			(box-nachbarn zeile spalte)))))


(defun erzeuge-sudoku (&aux (max 9))
  "ERZEUGE-SUDOKU erzeugt ein neues, gültiges, vollständig ausgefülltest Sudoku.
Beispiel: (erzeuge-sudoku)
#2A((7 9 4 6 2 8 1 5 3)
    (3 5 1 7 4 9 6 2 8)
    (2 8 6 5 1 3 7 9 4)
    (1 2 8 3 9 6 5 4 7)
    (5 6 3 4 7 1 2 8 9)
    (4 7 9 8 5 2 3 1 6)
    (9 3 7 2 8 5 4 6 1)
    (8 4 5 1 6 7 9 3 2)
    (6 1 2 9 3 4 8 7 5))"
  (flet ((suche-sudoku ()
		   (let ((tab (make-array '(9 9) :initial-element '_)))
			 (flet ((setze-feld (i j)
					  (let ((lst (möglichkeiten i j tab)))
						(when (null lst)
						  (return-from suche-sudoku 'nil))
						(setf (aref tab i j) (elt lst (random (length lst)))))))
			   (dotimes (i max tab)
				 (do ((j i (1+ j)))
					 ((= j max))
				   (setze-feld i j)
				   (when (eql '_ (aref tab j i))
					 (setze-feld j i))))))))
	(let ((tab (suche-sudoku)))
	  (when tab
		(return-from erzeuge-sudoku tab))
	  (erzeuge-sudoku))))


(defun erzeuge-rätsel (&optional (tab '()) (anz 25) (versuch '()) (runde 81))
  "ERZEUGE-RÄTSEL erstellt aus einem gültigen SUDOKU ein einmaliges Rätsel. Je niedriger die Anzahl ANZ an vorgegebenen ausgefüllten Feldern ist, umso schwerer wird das Sudoku. Zurückgeliefert wird das unausgefüllte Sudoku, sowie das ausgefüllte Sudoku.
Beispiel: (erzeuge-rätsel #2A((7 9 4 6 2 8 1 5 3)
    (3 5 1 7 4 9 6 2 8)
    (2 8 6 5 1 3 7 9 4)
    (1 2 8 3 9 6 5 4 7)
    (5 6 3 4 7 1 2 8 9)
    (4 7 9 8 5 2 3 1 6)
    (9 3 7 2 8 5 4 6 1)
    (8 4 5 1 6 7 9 3 2)
    (6 1 2 9 3 4 8 7 5)))
#2A((7 9 _ _ _ _ 1 _ _)
    (_ _ _ _ _ _ _ _ _)
    (_ _ 6 _ _ _ 7 9 4)
    (_ _ 8 _ _ _ _ _ 7)
    (_ 6 _ _ 7 _ 2 _ 9)
    (_ 7 _ 8 5 _ 3 1 _)
    (_ _ 7 _ _ 5 _ _ _)
    (_ _ 5 _ _ _ _ _ _)
    (6 _ 2 9 _ 4 _ _ _))
#2A((7 9 4 6 2 8 1 5 3)
    (3 5 1 7 4 9 6 2 8)
    (2 8 6 5 1 3 7 9 4)
    (1 2 8 3 9 6 5 4 7)
    (5 6 3 4 7 1 2 8 9)
    (4 7 9 8 5 2 3 1 6)
    (9 3 7 2 8 5 4 6 1)
    (8 4 5 1 6 7 9 3 2)
    (6 1 2 9 3 4 8 7 5))"
  (labels ((entferne-zahl (orig)
			 (let ((i (random 9))
				   (j (random 9)))
			   (if (not (eq '_ (aref orig i j)))
				   (let ((kopie (erstelle-kopie orig)))
					 (setf (aref kopie i j) '_)
					 (return-from entferne-zahl kopie))
				   (entferne-zahl orig)))))
	(cond ((null tab)
		   (erzeuge-rätsel (erzeuge-sudoku) anz versuch runde))
		  ((null versuch)
		   (let ((versuch (erstelle-kopie tab)))
			 (erzeuge-rätsel tab anz versuch runde)))
		  ((= runde anz)
		   (if (equalp (löse-sudoku (erstelle-kopie versuch)) tab)
			   (return-from erzeuge-rätsel (values versuch tab))
			   nil))
		  (t
		   (let ((temp (entferne-zahl (erstelle-kopie versuch))))
			 (if (equalp (löse-sudoku (erstelle-kopie temp)) tab)
				 (erzeuge-rätsel tab anz temp (1- runde))
				 (erzeuge-rätsel tab anz versuch runde)))))))


(defun gültige-lösung-p (tab &aux (max 9))
  "GÜLTIGE-LÖSUNG-P überprüft ob die übergebene Sudoku-Lösung gültig ist.
Beispiel: (gültige-lösung-p #2A((7 9 4 6 2 8 1 5 3)
    (3 5 1 7 4 9 6 2 8)
    (2 8 6 5 1 3 7 9 4)
    (1 2 8 3 9 6 5 4 7)
    (5 6 3 4 7 1 2 8 9)
    (4 7 9 8 5 2 3 1 6)
    (9 3 7 2 8 5 4 6 1)
    (8 4 5 1 6 7 9 3 2)
    (6 1 2 9 3 4 8 7 5)))
T"
  (labels ((gültigp (lst)
			 (unless (numberp (first lst))
			   (return-from gültige-lösung-p 'nil)))
		   (zeile (nr)
			 (let (lst)
			   (dotimes (i max lst)
				 (push (aref tab nr i) lst)
				 (gültigp lst))))
		   (spalte (nr)
			 (let (lst)
			   (dotimes (i max lst)
				 (push (aref tab i nr) lst)
				 (gültigp lst))))
		   (box (nr)
			 (let (lst
				   (x-kor (* 3 (rem nr 3)))
				   (y-kor (* 3 (truncate (/ nr 3)))))
			   (dotimes (i 3 lst)
				 (dotimes (j 3)
				   (push (aref tab (+ i x-kor) (+ j y-kor)) lst)
				   (gültigp lst)))))
		   (gültige-sequenz-p (seq)
			 (let* ((sortiert (sort seq #'<))
					(gültig (apply #'< sortiert))
					(länge (length sortiert)))
			   (and gültig (= max länge)))))
	(dotimes (i max t)
	  (unless (and (gültige-sequenz-p (zeile i))
				   (gültige-sequenz-p (spalte i))
				   (gültige-sequenz-p (box i)))
		(return-from gültige-lösung-p 'nil)))))


(defun löse-sudoku (tab &optional (zeile 0) (spalte 0) &aux (max 9))
  "LÖSE-SUDOKU versucht das übergebene Sudoku TAB zu lösen und gibt die LÖSUNG oder NIL zurück.
Beispiel: (löse-sudoku #2A((7 9 _ _ _ _ 1 _ _)
    (_ _ _ _ _ _ _ _ _)
    (_ _ 6 _ _ _ 7 9 4)
    (_ _ 8 _ _ _ _ _ 7)
    (_ 6 _ _ 7 _ 2 _ 9)
    (_ 7 _ 8 5 _ 3 1 _)
    (_ _ 7 _ _ 5 _ _ _)
    (_ _ 5 _ _ _ _ _ _)
    (6 _ 2 9 _ 4 _ _ _)))
#2A((7 9 4 6 2 8 1 5 3)
    (3 5 1 7 4 9 6 2 8)
    (2 8 6 5 1 3 7 9 4)
    (1 2 8 3 9 6 5 4 7)
    (5 6 3 4 7 1 2 8 9)
    (4 7 9 8 5 2 3 1 6)
    (9 3 7 2 8 5 4 6 1)
    (8 4 5 1 6 7 9 3 2)
    (6 1 2 9 3 4 8 7 5))"
  (cond ((= zeile max)
		 tab)
		((= spalte max)
		 (löse-sudoku tab (1+ zeile) 0))
		((not (eq '_ (aref tab zeile spalte)))
		 (löse-sudoku tab zeile (1+ spalte)))
		(t (dolist (auswahl (möglichkeiten zeile spalte tab) (setf (aref tab zeile spalte) '_))
			 (setf (aref tab zeile spalte) auswahl)
			 (when (eq tab (löse-sudoku tab zeile (1+ spalte)))
			   (return tab))))))


(defun pprint-sudoku (tab &optional (koordinaten 'nil))
  "PPRINT-SUDOKU gibt ein übergebenes Sudoku TAB als formatiertes Sudoku in Tabellenform aus, wahlweise mit oder ohne Koordinaten.
Beispiel: (pprint-sudoku #2A((7 9 _ _ _ _ 1 _ _)
    (_ _ _ _ _ _ _ _ _)
    (_ _ 6 _ _ _ 7 9 4)
    (_ _ 8 _ _ _ _ _ 7)
    (_ 6 _ _ 7 _ 2 _ 9)
    (_ 7 _ 8 5 _ 3 1 _)
    (_ _ 7 _ _ 5 _ _ _)
    (_ _ 5 _ _ _ _ _ _)
    (6 _ 2 9 _ 4 _ _ _)))
 7 9 4 | 6 2 8 | 1 5 3 
 3 5 1 | 7 4 9 | 6 2 8 
 2 8 6 | 5 1 3 | 7 9 4 
-------+-------+-------
 1 2 8 | 3 9 6 | 5 4 7 
 5 6 3 | 4 7 1 | 2 8 9 
 4 7 9 | 8 5 2 | 3 1 6 
-------+-------+-------
 9 3 7 | 2 8 5 | 4 6 1 
 8 4 5 | 1 6 7 | 9 3 2 
 6 1 2 | 9 3 4 | 8 7 5 
NIL"
  (flet ((2d-array->list (array)
		   (loop for i below (array-dimension array 0)
			  collect (loop for j below (array-dimension array 1)
						 collect (aref array i j)))))
	(let ((i 0))
	  (dolist (zeile (2d-array->list tab))
		(format t "~{ ~A ~A ~A | ~A ~A ~A | ~A ~A ~A ~}" zeile)
		(incf i)
		(if koordinaten
			(format t " ~A~%" i)
			(format t "~%"))
		(when (and (zerop (rem i 3)) (/= i 9))
		  (format t "-------+-------+-------~%"))
		(when (and koordinaten (= i 9))
		  (format t "~% A B C   D E F   G H I~%~%"))))))


(defun hole-eingabe ()
  "HOLE-EINGABE nimmt eine Eingabe entgegen und liefert diese qualifiziert zurück.
Beispiel: (hole-eingabe)
Deine Eingabe (? für Anleitung): a5 7

(:KOORDINATEN 4 0 7)"
  (format t "Deine Eingabe (? für Anleitung): ")
  (terpri)
  (let ((eingabe (string-upcase (string-trim " " (read-line)))))
	(if (find-if #'digit-char-p eingabe)
		(let* ((y (- (char-int (aref eingabe 0)) 65)) ; 1 mehr, da Zählung bei 0 beginnt
			   (lst (coerce (string-trim " " (subseq eingabe 1)) 'list))
			   (x (- (char-int (first lst)) 49)) ; 1 mehr, da Zählung bei 9 beginnt
			   (wert (- (char-int (first (last lst))) 48)))
		  (list :koordinaten x y wert))
		(list (intern (string-upcase eingabe) :keyword)))))


(defun spiele-sudoku ()
  "SPIELE-SUDOKU startet eine Partie Sudoku."
  (format t "Erzeuge neues Rätsel, bitte warten!~%")
  (let* ((original (erzeuge-sudoku))
         (spiel (erzeuge-rätsel (erstelle-kopie original)))
		 (unberührt 't)
		 züge)
	(flet ((zeige-anleitung ()
			 (format t "--- ANLEITUNG ---~%Durch Eingabe von ?, MENÜ, ANLEITUNG oder ANWEISUNG bekommst du diese Übersicht angezeigt.~%Die Eingabe von >, HINWEIS, TIP oder HILFE deckt genau eine weitere Zahl auf.~%Die Eingabe von !, AUFLÖSUNG, BEENDEN, ENDE, SCHLUß, QUIT oder EXIT beendet das Spiel und zeigt dir die vollständige Auflösung an.~%Die Eingabe von <, ZURÜCK, UNDO, UPS, ENTSCHULDIGUNG, DAVOR nimmt die letzte Änderung zurück.~%Um einen Wert in ein Feld einzutragen, mußt du zuerst die Koordinaten (erst Buchstabe, dann Zahl) gefolgt von der Zahl die du an dieser Stelle wünschst angeben.~%~%"))
		   (mache-zug (ergebnis)
			 (let ((i (second ergebnis))
				   (j (third ergebnis))
				   (wert (fourth ergebnis)))
			   (push (list i j (aref spiel i j)) züge)
			   (setf (aref spiel i j) wert)
			   (when (gültige-lösung-p spiel)
				 (format t "Gratuliere!~%Du hast das Sudoku gelöst!~%")
				 (unless unberührt
				   (format t "Allerdings, mit ein klein wenig Hilfe von mir, hm? ;-)~%"))
				 (return-from spiele-sudoku))))
		   (gebe-hinweis ()
			 (setf unberührt 'nil)
			 (do* ((i (random 9) (random 9))
				   (j (random 9) (random 9)))
				  ((eq (aref spiel i j) '_)
				   (push (list i j '_) züge)
				   (setf (aref spiel i j) (aref original i j))))
			 (when (gültige-lösung-p spiel)
			   (pprint-sudoku spiel t)
			   (format t "~%Schade!~%Jetzt habe ich deine Arbeit übernommen.~%")
			   (format t "Beim nächsten Mal, solltest du versuchen, es selber zu lösen!~%")
			   (return-from spiele-sudoku)))
		   (nimm-zug-zurück ()
			 (unless (null züge)
			   (let* ((zug (pop züge))
					  (i (first zug))
					  (j (second zug))
					  (wert (third zug)))
				 (setf (aref spiel i j) wert))))
		   (print-lösbarkeit ()
			 (if (equalp (löse-sudoku (erstelle-kopie spiel)) original)
				 (format t "(lösbar) ")
				 (format t "(unlösbar) "))))
	  (do ()
		  (nil)
		(pprint-sudoku spiel t)
		(print-lösbarkeit)
		(let ((ergebnis (hole-eingabe)))
		  (case (first ergebnis)
			((:? :menü :anleitung :anweisung)
			 (zeige-anleitung))
			((:koordinaten)
			 (mache-zug ergebnis))
			((:> :hinweis :tip :hilfe)
			 (gebe-hinweis))
			((:! :löse :auflösung :beenden :ende :schluß :quit :exit)
			 (return-from spiele-sudoku (pprint-sudoku original t)))
			((:< :zurück :undo :ups :entschuldigung :davor :entschuldige)
			 (nimm-zug-zurück))
			(otherwise
			 (format t "~%Gib ? oder ANLEITUNG ein, wenn du nicht weißt, wie man spielt.~%"))))))))
