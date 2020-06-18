REM ROB BASSETT
REM PRG31

CLS
RANDOMIZE TIMER
DIM N$(50)


FOR Z = 1 TO 3
   GOSUB INNAMES
   GOSUB PRINTNAMES
   S = INT(14 * RND + 1)
   COLOR (S)
   GOSUB SORT
   GOSUB PRINTNAMES
NEXT Z
END

INNAMES:
   DO
     C = C + 1
     INPUT "ENTER A NAME"; N$(C)
     IF N$(C) = "XXX" THEN EXIT DO
   LOOP
   C = C - 1
RETURN

PRINTNAMES:
   FOR X = 1 TO C
      PRINT N$(X),
   NEXT X
   PRINT
RETURN

SORT:
   FOR Y = 1 TO C - 1
      F = 0
      FOR X = 1 TO C - Y
         IF N$(X) > N$(X + 1) THEN
          T$ = N$(X): N$(X) = N$(X + 1): N$(X + 1) = T$
         END IF
         F = 1
      NEXT X
      IF F = 0 THEN EXIT FOR
   NEXT Y
RETURN

