'Rob's Common Game Framework
'R. Bassett Jr. (Tatwi)
'Started June 2020
'Uses screen pages for game states and quick building of screens.
'Used for character graphics games with graphics mode enhancements.

DEFINT A-Z
DECLARE SUB DrawBorder (SY, SX, W, H)
DECLARE SUB CreatePaused ()
DECLARE SUB CreateHelp ()
DECLARE SUB SaveData ()
DECLARE SUB LoadData ()
DECLARE SUB LoadSprite (sprite%(), file$, H, W)


SCREEN 7, 0, 1, 0

'Screens:
'0 - Page that is displayed to the user
'1 - Compositing page / Back buffer
'2 - Paused screen
'3 - Help screen
'4 - Available
'5 - Available
'6 - Available
'7 - Temp screen where 0 can be saved

LOCATE 12, 16: PRINT "Loading ...": PCOPY 1, 0

'Draw paused screen
SCREEN 7, 0, 2, 0
COLOR 3: DrawBorder 11, 15, 3, 10
LOCATE 12, 17: PRINT "PAUSED"

'Draw help screen
SCREEN 7, 0, 3, 0
COLOR 5: DrawBorder 1, 1, 25, 40
LOCATE 2, 18: PRINT "HELP";
COLOR 7
'To do: Put this in a character window for automatic overflow
LOCATE 4, 2: PRINT "This is where you'd put some help"
LOCATE 5, 2: PRINT "information!"


'Demos:
'----------------------------------

'Draw color number reminders
SCREEN 7, 0, 6, 0
j = 1: P = 0
FOR X = 2 TO 9
    COLOR X - 1
    LOCATE 1 + P, X - 1 + j: PRINT CHR$(219); CHR$(219)
    LOCATE 3 + P, X - 2 + j: PRINT X;
    j = j + 2
NEXT X
j = 2
FOR X = 1 TO 6
    COLOR X - 1 + 10
    LOCATE 6 + P, X - 1 + j: PRINT CHR$(219); CHR$(219)
    LOCATE 8 + P, X - 2 + j: PRINT X + 10;
    j = j + 2
NEXT X

'Load some sprites
DIM sp1%(64): LoadSprite sp1%(), "SP1.CSV", 8, 8
DIM sp2%(64): LoadSprite sp2%(), "SP2.CSV", 8, 8

'Use the sprites
SCREEN 7, 0, 5, 0
RANDOMIZE TIMER
FOR X = 1 TO 20
 Ty = INT(RND * 192)
 Tx = INT(RND * 312)
 PUT (Tx, Ty), sp1%
NEXT X
FOR X = 1 TO 20
 Ty = INT(RND * 192)
 Tx = INT(RND * 312)
 PUT (Tx, Ty), sp2%
NEXT X

'Show a screen
PCOPY 2, 0

'Demonstrate screen changing
DO WHILE i$ <> CHR$(27)
  i$ = INKEY$
  IF i$ = "1" THEN PCOPY 1, 0
  IF i$ = "2" THEN PCOPY 2, 0
  IF i$ = "3" THEN PCOPY 3, 0
  IF i$ = "4" THEN PCOPY 4, 0
  IF i$ = "5" THEN PCOPY 5, 0
  IF i$ = "6" THEN PCOPY 6, 0
  IF i$ = "7" THEN PCOPY 7, 0
LOOP

'   Min Max (40x25)
'SY 1   23
'SX 1   37
'H  3   25
'W  3   40
SUB DrawBorder (SY, SX, H, W)
  LOCATE SY, SX
  PRINT CHR$(201); : FOR C = 1 TO W - 2: PRINT CHR$(205); : NEXT C: PRINT CHR$(187);
  FOR C = 1 TO H - 2
    LOCATE SY + C, SX: PRINT CHR$(186);
    LOCATE SY + C, SX + W - 1: PRINT CHR$(186);
  NEXT C
  LOCATE SY + H - 1, SX
  PRINT CHR$(200); : FOR C = 1 TO W - 2: PRINT CHR$(205); : NEXT C: PRINT CHR$(188);
END SUB

'Load sprite from CSV file
SUB LoadSprite (sprite%(), file$, H, W)
SCREEN 7, 0, 1, 0 'Switch to the back buffer
CLS

OPEN file$ FOR INPUT AS #1
FOR X = 1 TO H
  FOR Y = 1 TO W
    INPUT #1, i
    PSET (X, Y), i
  NEXT Y
NEXT X
CLOSE #1

GET (1, 1)-(H, W), sprite%

CLS 'Leave the back buffer clean
END SUB

