' Quick and dirty fireworks for something to do!
' R. Bassett Jr.
' 2021.05.26

DEFINT A-Z
SCREEN 0
WIDTH 80, 50

COLOR 2
FOR X = 1 TO 8
  LOCATE 42 + X, 1: PRINT STRING$(80, CHR$(219));
NEXT X
COLOR 0, 2
LOCATE 50, 65: PRINT "Press q to exit";
COLOR 0, 0

Start:
P = 40
L = INT(RND * 50) + 15
H = INT(RND * 10) + 20
FOR X = 1 TO H
  ' Erase
  LOCATE P + 1, L: PRINT " "
 
  ' Draw
  COLOR INT(RND * 14) + 1
  LOCATE P, L: PRINT ".";
  
  P = P - 1

  FOR Y = 1 TO 900
  NEXT Y
NEXT X

COLOR 14
LOCATE P + 1, L: PRINT "*";
FOR Y = 1 TO 7000
NEXT Y
LOCATE P + 1, L: PRINT " ";


COLOR 15
LOCATE P, L: PRINT "*";
LOCATE P + 2, L: PRINT "*";
LOCATE P + 1, L + 1: PRINT "*";
LOCATE P + 1, L - 1: PRINT "*";
FOR Y = 1 TO 8000
NEXT Y
LOCATE P, L: PRINT " ";
LOCATE P + 2, L: PRINT " ";
LOCATE P + 1, L + 1: PRINT " ";
LOCATE P + 1, L - 1: PRINT " ";

COLOR INT(RND * 14) + 1
LOCATE P - 1, L - 1: PRINT "***";
LOCATE P, L + 2: PRINT "*";
LOCATE P + 1, L + 2: PRINT "*";
LOCATE P + 2, L + 2: PRINT "*";
LOCATE P + 3, L - 1: PRINT "***";
LOCATE P, L - 2: PRINT "*";
LOCATE P + 1, L - 2: PRINT "*";
LOCATE P + 2, L - 2: PRINT "*";
FOR Y = 1 TO 12000
NEXT Y
COLOR 0
FOR X = 1 TO 6
  LOCATE P - 3 + X
  PRINT STRING$(80, " ")
NEXT X

IF INKEY$ = "q" GOTO Quit
GOTO Start

Quit:
COLOR 7
END

