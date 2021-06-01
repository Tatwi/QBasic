DECLARE SUB Ascend (X%)
DECLARE SUB Boom1 (X%)
DECLARE SUB Boom2 (X%)
DECLARE SUB Boom3 (X%)
DECLARE SUB Boom4 (X%)
DECLARE SUB Boom5 (X%)
DECLARE SUB Light (X%)
DEFINT A-Z

' Fireworks, Attempt 3!
' R. Bassett Jr.
' 2021.06.01 (y.m.d)
' What I achieved here was what I had in mind when I thought about doing this
' program the other day. FWRKS1.BAS was a test, where as FWRKS2.BAS was
' the result of me thinking about solving the problem of updating multiple
' objects in a less sensible way.
'
' This program gives each firework its own timer value, which can easily be
' updated and checked against. Using a custom object TYPE in this program
' made it A LOT easier to keep track of data and program flow!
SCREEN 0
WIDTH 80, 50
CLS
TIMER ON
RANDOMIZE TIMER

DIM frameDelay AS SINGLE
frameDelay = .24
DIM deltaT AS SINGLE
DIM showSize AS INTEGER
showSize = 12  ' Higher is more fireworks
DIM fireRate AS SINGLE
fireRate = .016 ' Higher is more fireworks

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

TYPE Firework
  apogee AS INTEGER ' Character row
  ust AS SINGLE ' Start time for last update
  posY AS INTEGER ' Character row
  posX AS INTEGER ' Character coloumn
  stage AS INTEGER ' Ascending(0), Boom(1/2/3/4/5), Reset(6)
  shade AS INTEGER
END TYPE

DIM SHARED Show(1 TO showSize) AS Firework

' Reset the show
FOR X = 1 TO showSize
  Show(X).stage = 6
NEXT X

' Draw the ground
COLOR 2: LOCATE 50, 1: PRINT STRING$(80, CHR$(219))

' Main loop
i$ = ""
DO WHILE i$ <> CHR$(27)
  i$ = INKEY$

  ' Update loop
  FOR X = 1 TO showSize
    deltaT = TIMER - Show(X).ust

    IF deltaT > frameDelay THEN
      SELECT CASE Show(X).stage
        CASE 0
          Ascend X
        CASE 1
          Boom1 X
        CASE 2
          Boom2 X
        CASE 3
          Boom3 X
        CASE 4
          Boom4 X
        CASE 5
          Boom5 X
        CASE 6
          IF RND < fireRate THEN Light X
      END SELECT
    END IF
  NEXT X
LOOP

TIMER OFF
CLS : COLOR 7
END

SUB Ascend (X)
COLOR 15
IF Show(X).posY = Show(X).apogee THEN
  ' End the ascent
  LOCATE Show(X).posY, Show(X).posX: PRINT "x";
  Show(X).stage = 1
ELSE
  ' Erase
  IF SCREEN(Show(X).posY, Show(X).posX) = 249 THEN
    LOCATE Show(X).posY, Show(X).posX: PRINT " ";
  END IF

  ' Keep ascending
  Show(X).posY = Show(X).posY - 1
 
  IF SCREEN(Show(X).posY, Show(X).posX) = 32 THEN
    LOCATE Show(X).posY, Show(X).posX: PRINT CHR$(249);
  END IF
END IF
END SUB

SUB Boom1 (X)
COLOR Show(X).shade
' Erase
LOCATE Show(X).posY, Show(X).posX: PRINT CHR$(249);

'   %
'  % %
'   %

'Draw clockwise
LOCATE Show(X).posY - 1, Show(X).posX: PRINT "%";
LOCATE Show(X).posY, Show(X).posX + 1: PRINT "%";
LOCATE Show(X).posY + 1, Show(X).posX: PRINT "%";
LOCATE Show(X).posY, Show(X).posX - 1: PRINT "%";

Show(X).stage = 2
Show(X).ust = TIMER
END SUB

SUB Boom2 (X)
COLOR Show(X).shade
' Erase
LOCATE Show(X).posY - 1, Show(X).posX: PRINT " ";
LOCATE Show(X).posY, Show(X).posX + 1: PRINT " ";
LOCATE Show(X).posY + 1, Show(X).posX: PRINT " ";
LOCATE Show(X).posY, Show(X).posX - 1: PRINT " ";

'     +++
'    +   +
'    +   +
'    +   +
'     +++
'

' Draw clockwise
LOCATE Show(X).posY - 2, Show(X).posX - 1: PRINT "+++";
LOCATE Show(X).posY - 1, Show(X).posX + 2: PRINT "+";
LOCATE Show(X).posY, Show(X).posX + 2: PRINT "+";
LOCATE Show(X).posY + 1, Show(X).posX + 2: PRINT "+";
LOCATE Show(X).posY + 2, Show(X).posX - 1: PRINT "+++";
LOCATE Show(X).posY, Show(X).posX: PRINT CHR$(249);
LOCATE Show(X).posY - 1, Show(X).posX - 2: PRINT "+";
LOCATE Show(X).posY, Show(X).posX - 2: PRINT "+";
LOCATE Show(X).posY + 1, Show(X).posX - 2: PRINT "+";

' Do explosion sound, because light travels faster than sound!
SOUND 82, .2
SOUND 44, .6

Show(X).stage = 3
Show(X).ust = TIMER
END SUB

SUB Boom3 (X)
COLOR Show(X).shade
'     ***
'    *   *
'    *   *
'    *   *
'     ***
'

' Draw clockwise
LOCATE Show(X).posY - 2, Show(X).posX - 1: PRINT "***";
LOCATE Show(X).posY - 1, Show(X).posX + 2: PRINT "*";
LOCATE Show(X).posY, Show(X).posX + 2: PRINT "*";
LOCATE Show(X).posY + 1, Show(X).posX + 2: PRINT "*";
LOCATE Show(X).posY + 2, Show(X).posX - 1: PRINT "***";
LOCATE Show(X).posY, Show(X).posX: PRINT " ";
LOCATE Show(X).posY - 1, Show(X).posX - 2: PRINT "*";
LOCATE Show(X).posY, Show(X).posX - 2: PRINT "*";
LOCATE Show(X).posY + 1, Show(X).posX - 2: PRINT "*";

Show(X).stage = 4
END SUB

SUB Boom4 (X)
COLOR Show(X).shade
' Deminish inner
LOCATE Show(X).posY - 2, Show(X).posX - 1: PRINT STRING$(3, CHR$(249));
LOCATE Show(X).posY - 1, Show(X).posX + 2: PRINT CHR$(249);
LOCATE Show(X).posY, Show(X).posX + 2: PRINT CHR$(249);
LOCATE Show(X).posY + 1, Show(X).posX + 2: PRINT CHR$(249);
LOCATE Show(X).posY + 2, Show(X).posX - 1: PRINT STRING$(3, CHR$(249));
LOCATE Show(X).posY - 1, Show(X).posX - 2: PRINT CHR$(249);
LOCATE Show(X).posY, Show(X).posX - 2: PRINT CHR$(249);
LOCATE Show(X).posY + 1, Show(X).posX - 2: PRINT CHR$(249);

'      ***
'     *+++*
'    *+   +*
'    *+   +*
'    *+   +*
'     *+++*
'      ***

' Draw outer clockwise
LOCATE Show(X).posY - 3, Show(X).posX - 1: PRINT "***";
LOCATE Show(X).posY - 2, Show(X).posX + 2: PRINT "*";
LOCATE Show(X).posY - 1, Show(X).posX + 3: PRINT "*";
LOCATE Show(X).posY, Show(X).posX + 3: PRINT "*";
LOCATE Show(X).posY + 1, Show(X).posX + 3: PRINT "*";
LOCATE Show(X).posY + 2, Show(X).posX + 2: PRINT "*";
LOCATE Show(X).posY + 3, Show(X).posX - 1: PRINT "***";
LOCATE Show(X).posY + 2, Show(X).posX - 2: PRINT "*";
LOCATE Show(X).posY + 1, Show(X).posX - 3: PRINT "*";
LOCATE Show(X).posY, Show(X).posX - 3: PRINT "*";
LOCATE Show(X).posY - 1, Show(X).posX - 3: PRINT "*";
LOCATE Show(X).posY - 2, Show(X).posX - 2: PRINT "*";

Show(X).stage = 5
Show(X).ust = TIMER
END SUB

SUB Boom5 (X)
COLOR 15
' Erase this clockwise
'      ***
'     *+++*
'    *+   +*
'    *+   +*
'    *+   +*
'     *+++*
'      ***
LOCATE Show(X).posY - 3, Show(X).posX - 1: PRINT "   ";
LOCATE Show(X).posY - 2, Show(X).posX - 2: PRINT "     ";
LOCATE Show(X).posY - 1, Show(X).posX + 2: PRINT "  ";
LOCATE Show(X).posY, Show(X).posX + 2: PRINT "  ";
LOCATE Show(X).posY + 1, Show(X).posX + 2: PRINT "  ";
LOCATE Show(X).posY + 2, Show(X).posX - 2: PRINT "     ";
LOCATE Show(X).posY + 3, Show(X).posX - 1: PRINT "   ";

LOCATE Show(X).posY - 1, Show(X).posX - 3: PRINT "  ";
LOCATE Show(X).posY, Show(X).posX - 3: PRINT "  ";
LOCATE Show(X).posY + 1, Show(X).posX - 3: PRINT "  ";



' Reset
Show(X).stage = 6
Show(X).ust = TIMER
END SUB

SUB Light (X)
' Update the stage
Show(X).stage = 0

' Set values for this firework
' Always 4 characters from the edge to account for explosion diameter
Show(X).apogee = INT(RND * 30) + 5
Show(X).posY = 50
Show(X).posX = INT(RND * 72) + 4
Show(X).shade = fwrksClrs(INT(RND * 10) + 1)

' Set update timer start
Show(X).ust = TIMER
END SUB

