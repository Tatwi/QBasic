SCREEN 13 ' 300x200 40x25
CLS
pX% = 1: pY% = 1: nX% = 1: nY% = 1: i$ = ""
DIM map(25, 40) AS STRING

'Make map
FOR R = 1 TO 25
 FOR C = 1 TO 40
  RANDOMIZE TIMER
  rn% = INT(RND * 100) + 1
  IF rn% > 90 THEN
   map(R, C) = "x"
   LOCATE R, C
   PRINT map(R, C)
  END IF
 NEXT C
NEXT R

'Game loop
DO
  CLS
 
  'Draw map
  FOR R = 1 TO 25
   FOR C = 1 TO 40
    LOCATE R, C
    PRINT map(R, C)
   NEXT C
  NEXT R

  'Get input
  i$ = INKEY$
  IF i$ = "w" THEN nY% = pY% - 1
  IF i$ = "a" THEN nX% = pX% - 1
  IF i$ = "s" THEN nY% = pY% + 1
  IF i$ = "d" THEN nX% = pX% + 1

  'Wrap
  IF nY% < 1 THEN nY% = 25
  IF nY% > 25 THEN nY% = 1
  IF nX% < 1 THEN nX% = 40
  IF nX% > 40 THEN nX% = 1

  'Collision
  IF map(nY%, nX%) <> "x" THEN
   pY% = nY%: pX% = nX%
  END IF
 
  'Draw player
  LOCATE pY%, pX%
  PRINT "0"

  SLEEP 10
LOOP WHILE i$ <> "q"


