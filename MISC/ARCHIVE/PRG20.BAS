REM ROB BASSETT
REM PRG20

CLS
RANDOMIZE TIMER
FOR X = 1 TO 6
   C = INT(12 * RND + 1)
   COLOR (C)
   DO
     R(X) = INT(9 * RND + 1)
     F = 0
     FOR Y = 1 TO X - 1
       IF R(X) = R(Y) THEN F = 1
     NEXT Y
     IF F = 0 THEN EXIT DO
     LOOP
     PRINT R(X);
     SLEEP 1
NEXT X
COLOR (C + 1)
PRINT
PRINT "THESE ARE YOUR LOTTO NUMBERS"

