REM ROB BASSETT
REM PRG28

CLS

FOR X = 1 TO 10
   INPUT "ENTER A NUBER"; N(X)
   DO
     F = 0
     COLOR (7)
     FOR Y = 1 TO X - 1
        IF N(X) = N(Y) THEN
        F = 1
        COLOR (9)
        INPUT "SORRY NO DOUBLES"; N(X)
        END IF
     NEXT Y
     IF F = 0 THEN EXIT DO
   LOOP
NEXT X
COLOR (2)
FOR X = 1 TO 10
   PRINT N(X);
NEXT X

