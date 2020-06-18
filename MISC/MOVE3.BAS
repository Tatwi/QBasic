SCREEN 1
CLS
pX% = 1: pY% = 1: i$ = ""

'Create map
DIM map(24, 39) AS STRING
FOR R = 1 TO 24
 FOR C = 1 TO 39
  RANDOMIZE TIMER
  i% = (RND * 100) + 1
  IF i% > 85 THEN
   map(R, C) = "X"
  ELSEIF i% < 8 THEN
   map(R, C) = "."
  ELSE
   map(R, C) = ""
  END IF
 NEXT C
NEXT R
map(1, 1) = ""

GOSUB DrawMap

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
  IF pY% < 1 THEN pY% = 24
  IF pY% > 24 THEN pY% = 1
  IF pX% < 1 THEN pX% = 40
  IF pX% > 40 THEN pX% = 1
 
  'Draw
  LOCATE pY%, pX%
  PRINT "0"
RETURN

DrawMap:
FOR R = 1 TO 24
 FOR C = 1 TO 40
  LOCATE R, C
  PRINT map(R, C)
 NEXT C
NEXT R

RETURN

