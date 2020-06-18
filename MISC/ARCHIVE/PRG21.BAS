REM ROB BASSETT
REM PRG21

CLS

RANDOMIZE TIMER
FOR X = 1 TO 6
   INPUT "ENTER NUMBERS BETWEEN 1 AND 49"; N(X)
NEXT X
DO
C = 0
FOR X = 1 TO 6
   DO
     R(X) = INT(49 * RND + 1)
     F = 0
     FOR Y = 1 TO X - 1
       IF R(X) = R(Y) THEN F = 1
     NEXT Y
     IF F = 0 THEN EXIT DO
    LOOP
NEXT X
FOR X = 1 TO 6
   PRINT R(X), N(X)
NEXT X
FOR X = 1 TO 6
   FOR Y = 1 TO 6
     IF R(X) = N(Y) THEN C = C + 1
   NEXT Y
NEXT X
PRINT
PRINT "YOU HAVE "; C; " CORECT"
PRINT
INPUT "PLAY AGAIN ?"; A$
IF A$ <> "Y" THEN EXIT DO
LOOP
END

