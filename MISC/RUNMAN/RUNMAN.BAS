DECLARE SUB Running ()
'Rob's Common Game Framework
'R. Bassett Jr. (Tatwi)
'Started July 2020
'Screens:
'0 - Page that is displayed to the user
'1 - Compositing page / Back buffer
'2 - Paused screen
'3 - Help screen
'4 - Available (Inventory, Stats, Help screen 2, etc)
'5 - Available
'6 - Available
'7 - Temp screen where 0 can be saved
'
DEFINT A-Z
DECLARE SUB DrawBorder (SY, SX, W, H)
DECLARE SUB DrawPause ()
DECLARE SUB DrawHelp ()
DECLARE SUB SaveData ()
DECLARE SUB LoadData ()
DECLARE SUB LoadSprite (sprite%(), file$, H, W)
DECLARE SUB DoInput ()
DECLARE SUB Pause ()

' Declare Variables
IC = 1000: R = 1: i$ = "": DIM frm1%(64): DIM frm2%(64): DIM frm3%(64): DIM frm4%(64): F = 3: L = 1

' Load Sprites
LoadSprite frm1%(), "MAN1.CSV", 8, 8
LoadSprite frm2%(), "MAN2.CSV", 8, 8
LoadSprite frm3%(), "MAN3.CSV", 8, 8
LoadSprite frm4%(), "MAN4.CSV", 8, 8

SCREEN 7, 0, 1, 0
LOCATE 12, 16: PRINT "Loading ...": PCOPY 1, 0
DrawPause
DrawHelp

'Show start screen
Running

'Main Loop
DO
  i$ = INKEY$
  IF i$ <> "" THEN
    DoInput
    IC = IC + 200: IF IC > 1000 THEN IC = 1000
  ELSE
    IC = IC - 1: IF IC < 0 THEN IC = 0
  END IF
 
  ' Stand
  IF IC = 0 THEN
    IF F <> 3 THEN
      F = 3
      CLS
      PCOPY 3, 1
      PUT (120, L), frm3%
      PCOPY 1, 0
    END IF
  END IF
LOOP WHILE R

SUB DoInput
SHARED i$
SELECT CASE UCASE$(i$)
  CASE IS = CHR$(27)
    Pause
  CASE IS = "R"
    Running
END SELECT
END SUB

'   Min Max (40x25)
'SY 1   23
'SX 1   37
'H  3   25
'W  3   40
SUB DrawBorder (SY, SX, H, W)
  LOCATE SY, SX
  PRINT CHR$(201); STRING$(W - 2, CHR$(205)); CHR$(187);
  FOR C = 1 TO H - 2
    LOCATE SY + C, SX: PRINT CHR$(186);
    LOCATE SY + C, SX + W - 1: PRINT CHR$(186);
  NEXT C
  LOCATE SY + H - 1, SX
  PRINT CHR$(200); STRING$(W - 2, CHR$(205)); CHR$(188);
END SUB

SUB DrawHelp
SCREEN 7, 0, 3, 0
COLOR 5: DrawBorder 1, 1, 25, 40
LOCATE 2, 18: PRINT "HELP";
COLOR 7
'To do: Put this in a character window for automatic overflow
LOCATE 4, 2: PRINT "Press the R key to move the man!"
LOCATE 23, 14: PRINT "[ESC to exit]"
END SUB

SUB DrawPause
SCREEN 7, 0, 2, 0
COLOR 3: DrawBorder 11, 15, 3, 10
LOCATE 12, 17: PRINT "PAUSED"
LOCATE 20, 7: PRINT "(Press Q to Save and Quit)"
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

SUB Pause
SHARED R
PCOPY 0, 7: PCOPY 2, 0
DO
  i$ = INKEY$
  IF UCASE$(i$) = "Q" THEN
    R = 0
    CLS : LOCATE 12, 12: PRINT "Game Over": PCOPY 1, 0
    EXIT SUB
  END IF
LOOP WHILE i$ <> CHR$(27)
PCOPY 7, 0
END SUB

SUB Running
SHARED F, L, frm1%(), frm2%(), frm3%(), frm4%()
SCREEN 7, 0, 1, 0
CLS

' Test speed of writing over a screen
PCOPY 3, 1

' Location
L = L + 1: IF L > 192 THEN L = 1

' Frame limit
IF L MOD 5 = 1 THEN F = F + 1: IF F = 5 THEN F = 1

SELECT CASE F
  CASE IS = 1
    PUT (120, L), frm1%
  CASE IS = 2
    PUT (120, L), frm2%
  CASE IS = 3
    PUT (120, L), frm3%
  CASE IS = 4
    PUT (120, L), frm4%
END SELECT

PCOPY 1, 0
END SUB

