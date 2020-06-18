REM ROB BASSETT
REM PRG29

CLS
RANDOMIZE TIMER

FOR X = 1 TO 10
   DO
     N(X) = INT(50 * RND + 1)
     F = 0
     FOR Y = 1 TO X - 1
        IF N(X) = N(Y) THEN
         F = 1
        END IF
     NEXT Y
     IF F = 0 THEN EXIT DO
   LOOP
NEXT X

FOR X = 1 TO 10
  PRINT N(X);
NEXT X
PRINT
PRINT : COLOR (14)
FOR Y = 1 TO 9
   F = 0
   FOR X = 1 TO 9
      IF N(X) > N(X + 1) THEN
       T = N(X): N(X) = N(X + 1): N(X + 1) = T
      END IF
      F = 1
   NEXT X
   IF F = 0 THEN EXIT FOR
NEXT Y

FOR X = 1 TO 10
   PRINT N(X);
NEXT X
     

