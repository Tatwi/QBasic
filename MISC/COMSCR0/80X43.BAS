DEFINT A-Z
DECLARE SUB LoadSprite (sprite(), file$)
DECLARE SUB AddSprite (sprite(), RS, CS)
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
DIM SHARED sp1(X) AS INTEGER
' Define the array used to track what is printed on the screen
DIM SHARED canvas(X) AS INTEGER: REDIM canvas(3440) AS INTEGER

' Prepare the initial screen content
HappyFaces
LotsOfSprites
PRINT "Printing the initial screen..."; : PrintScreen

MainLoop
EndGame

SUB AddSprite (sprite(), RS, CS)
' Adds an image to the canvas
RS = RS * 80: P = 1: C = 1: H = sprite(1): W = sprite(2)

FOR X = 1 TO H * W
  P = RS + CS + C
  canvas(P) = sprite(X + 2)
  C = C + 1
  IF C > W THEN
    C = 1
    RS = RS + 80
  END IF
NEXT X

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
    AddSprite sp1(), INT(RND * 35), INT(RND * 72)
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

SUB LoadSprite (sprite() AS INTEGER, file$)
OPEN file$ FOR INPUT AS #1
  ' Get the height and width of the sprite
  INPUT #1, I%: H = I%
  INPUT #1, I%: W = I%

  REDIM sprite(H * W + 2) AS INTEGER
  sprite(1) = H: sprite(2) = W

  FOR X = 1 TO (H * W)
    INPUT #1, I%: sprite(X + 2) = I%
  NEXT X
CLOSE #1
END SUB

SUB LotsOfSprites
PRINT "Loading a sprite from file..."
LoadSprite sp1(), "SP1.IMG"

PRINT "Adding several sprites to the canvas..."
AddSprite sp1(), 20, 20
AddSprite sp1(), 5, 60
AddSprite sp1(), 35, 40
AddSprite sp1(), 1, 10
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

