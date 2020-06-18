REM  ROB BASSETT
REM PRG23 / COMPAIRISON

CLS
RANDOMIZE TIMER

FOR X = 1 TO 10
   READ C$(X)
NEXT X

REM CHECK PREVIOS

FOR X = 1 TO 10
   DO
      R(X) = INT(10 * RND + 1)
      F = 0
      FOR Y = 1 TO X - 1
         IF R(X) = R(Y) THEN F = 1
      NEXT Y
      IF F = 0 THEN EXIT DO
   LOOP
T = T + 1
PRINT C$(X);
NEXT X
PRINT T
PRINT

RESTORE
FOR X = 1 TO 10
   READ C$(X)
NEXT X

REM SHUFFLE UP

C = 10
FOR X = 1 TO 10
   R = INT(C * RND + 1)
   PRINT C$(R);
   FOR Y = R TO C - 1
      C$(Y) = C$(Y + 1)
   NEXT Y
   C = C - 1
   T = T + 1
NEXT X
PRINT T
PRINT

RESTORE
FOR X = 1 TO 10
   READ C$(X)
NEXT X

REM DELETE METHODE

DO
   R = INT(10 * RND + 1)
   IF C$(R) <> "*" THEN
      PRINT C$(R);
      C$(R) = "*"
      C = C + 1
   END IF
   IF C = 10 THEN EXIT DO
   T = T + 1
LOOP
PRINT T

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

