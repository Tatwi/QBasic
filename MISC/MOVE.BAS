SCREEN 7, , 1, 0' 300x200 40x25
CLS
pX% = 1: pY% = 1: i$ = ""

LOCATE 11, 10
PRINT "Use W A S D to move."
LOCATE 14, 12
PRINT "Press Q to quit."
PCOPY 1, 0

DO WHILE i$ <> "q"
   i$ = INKEY$
   IF i$ <> "" THEN GOSUB GameUpdate
LOOP
END


GameUpdate:
  CLS

  'Move
  IF i$ = "w" THEN pY% = pY% - 1
  IF i$ = "a" THEN pX% = pX% - 1
  IF i$ = "s" THEN pY% = pY% + 1
  IF i$ = "d" THEN pX% = pX% + 1

  'Wrap
  IF pY% < 1 THEN pY% = 25
  IF pY% > 25 THEN pY% = 1
  IF pX% < 1 THEN pX% = 40
  IF pX% > 40 THEN pX% = 1
 
  'Draw
  LOCATE pY%, pX%
  PRINT CHR$(2)
  PCOPY 1, 0
RETURN


