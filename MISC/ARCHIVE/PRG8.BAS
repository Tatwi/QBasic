REM ROB BASSSETT
REM PRG8

CLS

INPUT N
FOR X = 1 TO N
   FOR Y = 1 TO N - X
      PRINT " ";
   NEXT Y
   FOR Y = 1 TO X
      PRINT "*";
   NEXT Y
PRINT
NEXT X

