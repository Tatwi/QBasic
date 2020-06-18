REM ROB BASSETT
REM PRG32

CLS

LOCATE 12, 40
PRINT "*";
DO
  B$ = INKEY$
  IF B$ <> "" THEN A$ = B$
   FOR X = 1 TO 50: NEXT X
  IF A$ = "6" THEN GOSUB RIGHT
  IF A$ = "4" THEN GOSUB LEFT
  IF A$ = "2" THEN GOSUB DOWN
  IF A$ = "8" THEN GOSUB UP
LOOP UNTIL A$ = CHR$(27)
END

LEFT:
  PRINT CHR$(29); " "; CHR$(29); CHR$(29); "*";
RETURN

DOWN:
  PRINT CHR$(29); " "; CHR$(31); CHR$(29); "*";
RETURN

UP:
  PRINT CHR$(29); " "; CHR$(30); CHR$(29); "*";
RETURN

RIGHT:
  PRINT CHR$(29); " *";
RETURN

