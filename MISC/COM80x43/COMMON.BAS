DEFINT A-Z
DECLARE SUB LoadSprite (sprite(), file$, H, W)
DECLARE SUB AddSprite (sprite(), H, W, RS, CS)
DECLARE SUB AddText (txt$, colour, RS, CS)
DECLARE SUB PrintScreen ()
WIDTH 80, 43
' R. Bassett Jr.
' 2020.10.01
' The full screen in this mode is displayed as
' Top Half: Page 0, first 2048 characters
' Bottom Half: Page 1, last 1392 characters
' And there is a back buffer for each on Pages 2 and 3.
' I'm using an array as canvas that represents the whole screen
' and a text printing routine so that I can easily modify the whole
' screen without worrying about which "page" the content is on.
' Text printing is limited at this time.

' Define the arrays used to track what is printed on the screen
DIM SHARED canvas(x) AS INTEGER
DIM SHARED colours(x) AS INTEGER
REDIM canvas(3440) AS INTEGER, colours(3440) AS INTEGER

' Fill both arrays with some test junk
PRINT "Generating screen data..."
character = 1
FOR x = 1 TO 3440
  IF x > 2050 THEN
    character = 2
  ELSEIF x = 2048 THEN
    character = 219
  ELSEIF x = 2049 THEN
    character = 4
  ELSE
    character = 1
  END IF

  canvas(x) = character
  colours(x) = INT(RND * 15) + 1
NEXT x

PRINT "Loading Sprite..."
DIM sp1(8, 8)
LoadSprite sp1(), "SP1.CSV", 8, 8

PRINT "Adding sprites to canvas..."
AddSprite sp1(), 8, 8, 20, 20
AddSprite sp1(), 8, 8, 5, 60
AddSprite sp1(), 8, 8, 35, 40
AddSprite sp1(), 8, 8, 1, 10

PrintScreen

i$ = ""
DO WHILE i$ <> CHR$(27)
  i$ = INKEY$
 
  IF i$ = CHR$(32) THEN
    'REDIM canvas(3440), colours(3440)
    AddSprite sp1(), 8, 8, INT(RND * 35), INT(RND * 72)
    PrintScreen
  END IF
LOOP

' Clear the screen
REDIM canvas(3440) AS INTEGER, colours(3440) AS INTEGER
PrintScreen

' Print something on the screen
AddText "Pretty cool, eh?", 26, 1, 1
AddText "It sure is!!", 5, 22, 34
AddText "Testing line 27...", 1, 27, 1
AddText "X...", 1, 27, 80
COLOR 15

SUB AddSprite (sprite(), H, W, RS, CS)
' Adds an image to the canvas using 1 character squares as pixels
RS = RS * 80: P = 1

FOR R = 1 TO H
  FOR C = 1 TO W
    P = RS + CS + C
    colours(P) = sprite(R, C)
    canvas(P) = 219
  NEXT C
  RS = RS + 80
NEXT R

END SUB

SUB AddText (txt$, colour, RS, CS)
' Adds text to the screen after the canvas has been drawn

' Bottom or top of the screen
IF RS < 27 THEN
 SCREEN 0, , 0, 0
ELSE
 SCREEN 0, , 1, 0
 RS = RS - 26

 IF CS < 33 THEN CS = CS + 32

 IF CS > 64 THEN
   CS = CS - 48
   RS = RS + 1
   IF RS > 43 THEN RS = 43
 END IF
END IF

COLOR colour: LOCATE RS, CS: PRINT txt$
END SUB

SUB LoadSprite (sprite(), file$, H, W)

OPEN file$ FOR INPUT AS #1
FOR x = 1 TO H
  FOR Y = 1 TO W
    INPUT #1, i
    sprite(Y, x) = i
  NEXT Y
NEXT x
CLOSE #1

END SUB

SUB PrintScreen

'Top of screen
SCREEN 0, , 2, 0
LOCATE 1, 1
FOR x = 1 TO 2048
  COLOR colours(x): PRINT CHR$(canvas(x));
NEXT x

'Bottom of screen
SCREEN 0, , 3, 0
LOCATE 1, 1
FOR x = 1 TO 1392
  COLOR colours(x + 2048): PRINT CHR$(canvas(x + 2048));
NEXT x

'Display screen to user
PCOPY 2, 0
PCOPY 3, 1
END SUB

