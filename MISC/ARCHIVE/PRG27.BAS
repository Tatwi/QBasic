REM ROB BASSETT
REM PRG27
 
CLS

FOR X = 1 TO 5
   INPUT "ENTER A NUMBER"; N(X)
NEXT X

CLS

FOR X = 1 TO 5
   PRINT N(X);
NEXT X
PRINT
T = N(1)
N(1) = N(5)
N(5) = T
COLOR (3)
T = N(2)
N(2) = N(4)
N(4) = T
PRINT
FOR X = 1 TO 5
   PRINT N(X);
NEXT X

