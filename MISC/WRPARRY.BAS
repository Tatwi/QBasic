' Wrapping my brain around wrapping an array...
' R. Bassett Jr.
' 2020.11.01

DEFINT A-Z
DIM blah(1 TO 20) AS STRING
CLS

FOR X = 1 TO 20
  blah(X) = "Position" + STR$(X)
NEXT X

Go:
CLS
RANDOMIZE TIMER
S = INT(RND * 19) + 1
' S = 18

PRINT "Before Selected Number:"
Z = 5
FOR X = 1 TO 5
  TP = S - Z
  IF TP = 0 THEN TP = 20
  IF TP < 0 THEN TP = 20 - ABS(TP)
  PRINT blah(TP)
  Z = Z - 1
NEXT X

PRINT ""
PRINT "The Selected Number:"
PRINT blah(S)
PRINT ""

PRINT "After Selected Number:"
FOR X = 1 TO 5
  TP = S + X

  IF TP < 1 THEN TP = 21 - X
  IF TP > 20 THEN TP = TP - 20
 
  PRINT blah(TP)

NEXT X

PRINT ""
PRINT "Press SPACE for a new roll or ESC to exit"

I$ = ""
DO WHILE I$ <> CHR$(27)
  I$ = INKEY$
  IF I$ = " " THEN GOTO Go
  SLEEP 1
LOOP

END


