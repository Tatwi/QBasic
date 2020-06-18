REM ROB BASSETT
REM PRG22

CLS
RANDOMIZE TIMER

FOR X = 1 TO 10
   READ C$(X)
NEXT X

FOR X = 1 TO 10
   DO
      N(X) = INT(10 * RND + 1)
      F = 0
      FOR Y = 1 TO X - 1
         IF N(X) = N(Y) THEN F = 1
      NEXT Y
      IF F = 0 THEN EXIT DO
   LOOP
NEXT X

DATA A
DATA B
DATA C
DATA D
DATA E
DATA F
DATA G   
DATA H
DATA I
DATA J
S = INT(15 * RND + 1)
COLOR (S)
FOR X = 1 TO 10
   R = INT(10 * RND + 1)
   PRINT C$(N(X))
NEXT X

