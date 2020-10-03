DEFINT A-Z
DECLARE SUB LoadSprite (sprite(), file$, H, W)
DECLARE SUB AddSprite (sprite(), H, W, RS, CS)
DECLARE SUB AddText (txt$, colour, RS, CS)
DECLARE SUB PrintScreen ()
DECLARE SUB HappyFaces ()
DECLARE SUB EndGame ()
DECLARE SUB DoInput ()
DECLARE SUB LotsOfSprites ()
DECLARE SUB MainLoop ()

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

' Declare variables:
DIM SHARED PKEY AS STRING   ' Keyboard input, as using INKEY$ directly doesn't always register in DOSBox
DIM SHARED sp1(8, 8)
' Define the array used to track what is printed on the screen
DIM SHARED canvas(X) AS INTEGER: REDIM canvas(3440) AS INTEGER

' Prepare the initial screen content
HappyFaces
LotsOfSprites
PRINT "Printing the initial screen..."; : PrintScreen

MainLoop
EndGame

SUB AddSprite (sprite(), H, W, RS, CS)
' Adds an image to the canvas using 1 character squares as pixels
RS = RS * 80: P = 1

FOR R = 1 TO H
  FOR C = 1 TO W
    P = RS + CS + C
    canvas(P) = sprite(R, C)
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

SUB DoInput
' Handler player keyboard inputs
PKEY = INKEY$
SELECT CASE UCASE$(PKEY)
  CASE IS = CHR$(32)
    RANDOMIZE TIMER
    AddSprite sp1(), 8, 8, INT(RND * 35), INT(RND * 72)
    PrintScreen
END SELECT
END SUB

SUB EndGame
' Clear the screen
REDIM canvas(3440) AS INTEGER
PrintScreen

' Print something on the screen
AddText "Pretty cool, eh?", 26, 1, 1
AddText "It sure is!!", 5, 22, 34
AddText "Testing line 27...", 1, 27, 1
AddText "X...", 1, 27, 80
COLOR 15
END SUB

SUB HappyFaces
' Fill canvas array with test pattern
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

  canvas(X) = ((INT(RND * 15) + 1) * 1000) + character
NEXT X

END SUB

SUB LoadSprite (sprite(), file$, H, W)

OPEN file$ FOR INPUT AS #1
FOR X = 1 TO H
  FOR Y = 1 TO W
    INPUT #1, I%: sprite(X, Y) = I%
  NEXT Y
NEXT X
CLOSE #1
END SUB

SUB LotsOfSprites
PRINT "Loading a sprite from file..."
LoadSprite sp1(), "SP1.IMG", 8, 8

PRINT "Adding several sprites to the canvas..."
AddSprite sp1(), 8, 8, 20, 20
AddSprite sp1(), 8, 8, 5, 60
AddSprite sp1(), 8, 8, 35, 40
AddSprite sp1(), 8, 8, 1, 10
END SUB

SUB MainLoop
' Main program loop
DO WHILE PKEY$ <> CHR$(27)
  DoInput
LOOP
END SUB

SUB PrintScreen
TIMER ON: TS# = TIMER
'Top of screen
SCREEN 0, , 2, 0
LOCATE 1, 1
FOR X = 1 TO 2048
  C = canvas(X) / 1000: A = canvas(X) - C * 1000: COLOR C: PRINT CHR$(A);
NEXT X

'Bottom of screen
SCREEN 0, , 3, 0
LOCATE 1, 1
FOR X = 1 TO 1392
  C = canvas(X + 2048) / 1000: A = canvas(X + 2048) - C * 1000: COLOR C: PRINT CHR$(A);
NEXT X

' Display time required to draw the screen
LOCATE 17, 32: PRINT TIMER - TS#: TIMER OFF

'Display screen to user
PCOPY 2, 0
PCOPY 3, 1
END SUB

