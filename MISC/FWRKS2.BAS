DEFINT A-Z
DECLARE SUB volley ()
DECLARE SUB ascend (X, Y)
DECLARE SUB exp1 (X, Y)
DECLARE SUB exp2 (X, Y)
DECLARE SUB exp3 (X, Y)
DECLARE SUB exp4 (X, Y)
SCREEN 0
WIDTH 80, 50
CLS
RANDOMIZE TIMER
TIMER ON
' More Advanced (and buggy...) Fireworks
' R. Bassett Jr.
' 2021.05.28
'
' Logic Flow:
' Number of explosions?
' Position of explosions?
' Loop until all explosions cleared:
'   Draw dots towards positions
'   If position reached, do explosion
'   Clear explosion
' Repeat

I$ = ""
S# = TIMER
DIM SHARED F AS INTEGER
F = 6 ' Number of fireworks
DIM SHARED D AS INTEGER
D = 0 ' Number of fwrks that have completed
DIM SHARED highest AS INTEGER
highest = 1 ' The highest firework in the volley
DIM SHARED fwrks(F) AS INTEGER ' Current Y position of fireworks
DIM SHARED xPos(F) AS INTEGER  ' X position
DIM SHARED yPos(F) AS INTEGER  ' Final Y position
DIM SHARED boom(F) AS INTEGER ' Stage of explosion
DIM SHARED done AS INTEGER
done = 0
DIM SHARED soFar AS INTEGER
soFar = 0
DIM SHARED fwrksClrs(11) AS INTEGER
fwrksClrs(1) = 1
fwrksClrs(2) = 2
fwrksClrs(3) = 3
fwrksClrs(4) = 4
fwrksClrs(5) = 5
fwrksClrs(6) = 9
fwrksClrs(7) = 10
fwrksClrs(8) = 11
fwrksClrs(9) = 12
fwrksClrs(10) = 13
fwrksClrs(11) = 14

' Configure first volley
volley

DO WHILE I$ <> CHR$(27)
  I$ = INKEY$

  ' Update fireworks
  IF TIMER - S# > .03 THEN
    FOR C = 1 TO F
      IF fwrks(C) > yPos(C) THEN
        ascend xPos(C), fwrks(C)
        fwrks(C) = fwrks(C) - 1
       
        ' Has this firework completed its accent?
        IF fwrks(C) = yPos(C) THEN
          soFar = soFar + yPos(C)
          ' Trigger explosion
          boom(C) = 1
        END IF
      END IF

      IF boom(C) > 0 THEN
        IF boom(C) < 4 THEN
          exp1 xPos(C), yPos(C)
          boom(C) = boom(C) + 1
        ELSEIF boom(C) < 8 THEN
          exp2 xPos(C), yPos(C)
          boom(C) = boom(C) + 1
        ELSEIF boom(C) < 12 THEN
          exp3 xPos(C), yPos(C)
          boom(C) = boom(C) + 1
        ELSEIF boom(C) < 18 THEN
          exp4 xPos(C), yPos(C)
          boom(C) = 255
        END IF
      END IF
    NEXT C

    S# = TIMER
 
    ' Launch a new volley
    IF boom(highest) = 255 THEN volley
  END IF
LOOP

TIMER OFF
END

SUB ascend (X, Y)
' Draw
COLOR INT(RND * 14) + 1
LOCATE Y, X: PRINT ".";
COLOR 7

' Erase
IF Y + 1 < 51 THEN
  LOCATE Y + 1, X: PRINT " ";
END IF
END SUB

SUB exp1 (X, Y)
' Erase
LOCATE Y + 1, X: PRINT " ";

' Draw
COLOR 15
LOCATE Y, X: PRINT "X"
END SUB

SUB exp2 (X, Y)
COLOR 14
LOCATE Y - 1, X: PRINT "x"
LOCATE Y, X - 1: PRINT "x  x"
LOCATE Y + 1, X: PRINT "x"
END SUB

SUB exp3 (X, Y)
COLOR fwrksClrs(INT(RND * 10) + 1)
LOCATE Y - 2, X - 3: PRINT " * * *"
LOCATE Y - 1, X - 3: PRINT "*     *"
LOCATE Y, X - 3: PRINT "*     *"
LOCATE Y + 1, X - 3: PRINT "*     *"
LOCATE Y + 2, X - 3: PRINT " * * *"
END SUB

SUB exp4 (X, Y)
COLOR 15
LOCATE Y - 2, X - 3: PRINT " + + +"
LOCATE Y - 1, X - 3: PRINT "+     +"
LOCATE Y, X - 3: PRINT "+     +"
LOCATE Y + 1, X - 3: PRINT "+     +"
LOCATE Y + 2, X - 3: PRINT " + + +"
END SUB

SUB volley
  CLS
  done = 0
  soFar = 0
  F = INT(RND * 6) + 4 ' Number of fwrks in this volley
  REDIM fwrks(F) AS INTEGER
  REDIM xPos(F) AS INTEGER
  REDIM yPos(F) AS INTEGER
  REDIM boom(F) AS INTEGER

  FOR C = 1 TO F
    fwrks(C) = 50
    boom(C) = 0
    xPos(C) = INT(RND * 60) + 10
    yPos(C) = INT(RND * 24) + 10
    done = done + yPos(C)
 
    IF yPos(C) > highest THEN highest = C
  NEXT C

END SUB

