DEFINT A-Z
DECLARE SUB LoadSprite (sprite(), file$, H, W)
DECLARE SUB PrintScreen ()
WIDTH 80, 43
' R. Bassett Jr.
' 2020.10.01
' The full screen in this mode is displayed as
' Top Half: Page 0
' Bottom Half: Page 1
' And there is a back buffer for each on Pages 2 and 3.

' Define the arrays used to track what is printed on the screen
DIM SHARED canvas(3440)
DIM SHARED colours(3440)

' Fill both arrays with some test junk
PRINT "Generating screen data..."
character = 1
FOR X = 1 TO 3440
  IF X > 2050 THEN
    character = 2
  ELSEIF X = 2048 THEN
    character = 219
  ELSEIF X = 2049 THEN
    character = 4
  ELSE
    character = 1
  END IF

  canvas(X) = character
  colours(X) = INT(RND * 15) + 1
NEXT X

PRINT "Loading Sprite..."
DIM sp1(8, 8)
LoadSprite sp1(), "SP1.CSV", 8, 8

PRINT "Adding sprite to the canvas..."
rowStart = 34 * 80
colStart = 60

FOR R = 1 TO 8
  FOR C = 1 TO 8
    pixel = rowStart + colStart + C
    colours(pixel) = sp1(R, C)
    canvas(pixel) = 219
  NEXT C
  rowStart = rowStart + 80
NEXT R

PrintScreen

i$ = ""
DO WHILE i$ = ""
  i$ = INKEY$
LOOP

SUB LoadSprite (sprite(), file$, H, W)

OPEN file$ FOR INPUT AS #1
FOR X = 1 TO H
  FOR Y = 1 TO W
    INPUT #1, i
    sprite(Y, X) = i
  NEXT Y
NEXT X
CLOSE #1

END SUB

SUB PrintScreen
PRINT "Drawing Screen..."

'Top of screen
SCREEN 0, , 2, 0
FOR X = 1 TO 2048
  R = INT(X / 80 + 1)
  C = X MOD 80 + 1
  LOCATE R, C
  COLOR colours(X): PRINT CHR$(canvas(X));
NEXT X

'Bottom of screen
SCREEN 0, , 3, 0
FOR X = 1 TO 1392
  R = INT(X / 80 + 1)
  C = INT(X MOD 80) + 1
  'IF C > 1 THEN C = C - 1
  LOCATE R, C
  COLOR colours(X + 2048): PRINT CHR$(canvas(X + 2048));
NEXT X

'Display screen to user
PCOPY 2, 0
PCOPY 3, 1
END SUB

