' Wrapping my brain around wrapping an array...
' R. Bassett Jr.
' 2020.11.01

CLS
DEFINT A-Z
DIM blah(1 TO 20) AS STRING

FOR X = 1 TO 20
  blah(X) = "farts" + STR$(X)
NEXT X

RANDOMIZE TIMER
' S = INT(RND * 19) + 1
S = 18

' before
Z = 5
FOR X = 1 TO 5
  TP = S - Z
  IF TP = 0 THEN TP = 20
  IF TP < 0 THEN TP = 20 - ABS(TP)
  PRINT blah(TP)
  Z = Z - 1
NEXT X

PRINT ""
PRINT blah(S)
PRINT ""

' after
FOR X = 1 TO 5
  TP = S + X

  IF TP < 1 THEN TP = 21 - X
  IF TP > 20 THEN TP = TP - 20
 
  PRINT blah(TP)

NEXT X




