REM ROB BASSETT
REM PRG9

CLS

INPUT N
FOR X = 1 TO N
   FOR Y = 1 TO N - X
   PRINT " ";
   NEXT Y
   FOR Y = 1 TO X * 2 - 1
   PRINT "*";
   NEXT Y
   PRINT
NEXT X


