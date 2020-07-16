' Rob's Common Game Framework
' R. Bassett Jr. (Tatwi)
' Started June 2020
'
' Screen Pages
' 0 - Page that is displayed to the user
' 1 - Compositing page / Back buffer
' 2 - Pause screen art
' 3 - Help screen art
' 4 - Scoreboard art
' 5 - Welcome / New Game screen art
' 6 - Demos
' 7 - Temp screen where 0 can be saved
'
DEFINT A-Z
DECLARE SUB DrawBorder (SY, SX, W, H)
DECLARE SUB DrawPause ()
DECLARE SUB DrawHelp ()
DECLARE SUB DrawScoreBoard ()
DECLARE SUB DrawStartScreen ()
DECLARE SUB UpdateSB (HSN$(), HSV%(), HSM$(), PN$, PS$, PM$)
DECLARE SUB SaveData (S$())
DECLARE SUB LoadData (HSN$(), HSV%(), HSM$())
DECLARE SUB LoadSprite (sprite%(), file$, H, W)
DECLARE SUB DoInput ()
DECLARE SUB Pause ()
DECLARE SUB SortScores (HSN$(), HSV%(), HSM$(), PN$, PS%, PM$)
DECLARE SUB ShowHelp ()
DECLARE SUB Demos ()
DECLARE SUB NewGame ()

' Declare Variables
R = 1: i$ = "": DIM sp1%(64): DIM sp2%(64): DIM HSN$(10): DIM HSV%(10): DIM HSM$(10): PN$ = "ROB": PS% = 5543: PM$ = "Normal"

' Load the game
SCREEN 7, 0, 1, 0
LOCATE 12, 16: PRINT "Loading ...": PCOPY 1, 0
LoadData HSN$(), HSV%(), HSM$()
SortScores HSN$(), HSV%(), HSM$(), PN$, PS%, PM$
DrawPause
DrawHelp
DrawScoreBoard
Demos
DrawStartScreen

NewGame

'Main Loop
DO
  i$ = INKEY$: IF i$ <> "" THEN DoInput
LOOP WHILE R

SUB Demos
SHARED sp1%()
SHARED sp2%()

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
LoadSprite sp1%(), "SP1.CSV", 8, 8
LoadSprite sp2%(), "SP2.CSV", 8, 8

'Use the sprites
SCREEN 7, 0, 6, 0
RANDOMIZE TIMER
FOR X = 1 TO 20
 Ty = INT(RND * 120) + 72
 Tx = INT(RND * 312)
 PUT (Tx, Ty), sp1%
NEXT X
FOR X = 1 TO 20
 Ty = INT(RND * 120) + 72
 Tx = INT(RND * 312)
 PUT (Tx, Ty), sp2%
NEXT X
END SUB

SUB DoInput
SHARED i$, HSN$(), HSV%(), HSM$(), PN$, PS%, PM$
SELECT CASE UCASE$(i$)
  CASE IS = CHR$(27)
    Pause
  CASE IS = "1"
    PCOPY 1, 0
  CASE IS = "2"
    PCOPY 2, 0
  CASE IS = "3"
    PCOPY 3, 0
  CASE IS = "4"
    PCOPY 4, 0
  CASE IS = "5"
    PCOPY 5, 0
  CASE IS = "6"
    PCOPY 6, 0
  CASE IS = "7"
    PCOPY 7, 0
  CASE IS = CHR$(0) + CHR$(59)
    ShowHelp
  CASE IS = CHR$(0) + CHR$(60)
    UpdateSB HSN$(), HSV%(), HSM$(), PN$, STR$(PS%), PM$
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
LOCATE 2, 2: PRINT STRING$(38, 176);
LOCATE 2, 19: PRINT "HELP";
END SUB

SUB DrawPause
SCREEN 7, 0, 2, 0
COLOR 3: DrawBorder 11, 15, 3, 10
LOCATE 12, 17: PRINT "PAUSED"
LOCATE 17, 8: PRINT "Press Q to Save and Quit"
LOCATE 20, 9: PRINT "Press N for a New Game"
END SUB

SUB DrawScoreBoard
SCREEN 7, 0, 4, 0
COLOR 14: LOCATE 2, 16: PRINT "HIGH SCORES"
COLOR 1: DrawBorder 3, 8, 16, 26
LOCATE 4, 10: PRINT "NAME"; TAB(18); "SCORE"; TAB(26); "MODE";
LOCATE 5, 9: PRINT STRING$(24, 176);
COLOR 2: LOCATE 20, 16: PRINT "YOUR SCORE"
COLOR 1: DrawBorder 21, 8, 3, 26

END SUB

SUB DrawStartScreen
SCREEN 7, 0, 5, 0: CLS
PRINT "This is a demonstration of the functions"
PRINT "that are common to all the text mode"
PRINT "style games that I am making."
PRINT "": PRINT "Input": PRINT STRING$(14, 196)
PRINT "1-7: Veiw screen pages"
PRINT "ESC: Pause / Quit / New Game"
PRINT "F1:  Help toggle"
PRINT "F2:  Scoreboard"
END SUB

SUB LoadData (HSN$(), HSV%(), HSM$())
OPEN "SAVE.DAT" FOR INPUT AS #1
  FOR X = 1 TO 10
    INPUT #1, HSN$(X)
    INPUT #1, HSV%(X)
    INPUT #1, HSM$(X)
  NEXT X
CLOSE #1
END SUB

'Load sprite from CSV file
SUB LoadSprite (sprite%(), file$, H, W)
SCREEN 7, 0, 1, 0 'Switch to the back buffer
CLS

OPEN file$ FOR INPUT AS #1
FOR X = 1 TO H
  FOR Y = 1 TO W
    INPUT #1, i
    PSET (Y, X), i
  NEXT Y
NEXT X
CLOSE #1

GET (1, 1)-(H, W), sprite%

CLS 'Leave the back buffer clean
END SUB

SUB NewGame
PCOPY 5, 0
END SUB

SUB Pause
SHARED R
PCOPY 0, 7: PCOPY 2, 0
SCREEN 7, 0, 1, 0
DO
  i$ = UCASE$(INKEY$)
  SELECT CASE i$
    CASE IS = "Q"
      R = 0
      CLS : COLOR 15: LOCATE 12, 15: PRINT "Game Over": PCOPY 1, 0
      EXIT SUB
    CASE IS = "N"
      NewGame
      EXIT SUB
  END SELECT
LOOP WHILE i$ <> CHR$(27)
PCOPY 7, 0
END SUB

SUB SaveData (S$())
O$ = ""
'Stringify
FOR X = 1 TO 30
  O$ = O$ + S$(X) + ","
NEXT X
'Drop trailing comma
L = LEN(O$): O$ = LEFT$(O$, L - 1)
'Save to file
OPEN "SAVE.DAT" FOR OUTPUT AS #1
  PRINT #1, O$
CLOSE #1
END SUB

SUB ShowHelp
' Save current screen
SCREEN 7, 0, 7, 0: CLS : PCOPY 0, 7

' Work on back buffer
SCREEN 7, 0, 1, 0

P = 1
GOSUB Page1

DO
  i$ = INKEY$

  IF i$ <> "" THEN
    SELECT CASE i$
      CASE IS = CHR$(0) + CHR$(75)
        P = P - 1
        IF P < 1 THEN P = 1
      CASE IS = CHR$(0) + CHR$(77)
        P = P + 1
        IF P > 3 THEN P = 3
    END SELECT

    SELECT CASE P
      CASE IS = 1
        GOSUB Page1
      CASE IS = 2
        GOSUB Page2
      CASE IS = 3
        GOSUB Page3
    END SELECT
  END IF
LOOP WHILE i$ <> CHR$(0) + CHR$(59)

' Restore screen
PCOPY 7, 0
EXIT SUB

Page1:
CLS : PCOPY 3, 1: COLOR 15
LOCATE 3, 3: PRINT "This is the help page 1!"
COLOR 5: LOCATE 24, 2: PRINT CHR$(17); STRING$(12, 178); STRING$(24, 176); CHR$(16);
PCOPY 1, 0
RETURN


Page2:
CLS : PCOPY 3, 1: COLOR 15
LOCATE 3, 3: PRINT "This is the help page 2!"
COLOR 5: LOCATE 24, 2: PRINT CHR$(17); STRING$(12, 176); STRING$(12, 178); STRING$(12, 176); CHR$(16);
PCOPY 1, 0
RETURN


Page3:
CLS : PCOPY 3, 1: COLOR 15
LOCATE 3, 3: PRINT "This is the help page 3!"
COLOR 5: LOCATE 24, 2: PRINT CHR$(17); STRING$(24, 176); STRING$(12, 178); CHR$(16);
PCOPY 1, 0
RETURN

END SUB

SUB SortScores (HSN$(), HSV%(), HSM$(), PN$, PS%, PM$)
'TEST OUTPUT
SCREEN 7, 0, 5, 0

FOR X = 1 TO 10
  PRINT HSN$(X); TAB(10); HSV%(X); TAB(20); HSM$(X)
NEXT X

FOR Y = 1 TO 10 - 1
  FOR Z = Y + 1 TO 10
    IF HSV%(Z) > HSV%(Y) THEN
      SWAP HSN$(Z), HSN$(Y)
      SWAP HSV%(Z), HSV%(Y)
      SWAP HSM$(Z), HSM$(Y)
    END IF
  NEXT Z
NEXT Y

PRINT ""
FOR X = 1 TO 10
  PRINT HSN$(X); TAB(10); HSV%(X); TAB(20); HSM$(X)
NEXT X


END SUB

SUB UpdateSB (HSN$(), HSV%(), HSM$(), PN$, PS$, PM$)
SCREEN 7, 0, 1, 0
CLS : PCOPY 4, 1: COLOR 7
FOR X = 1 TO 10
  LOCATE 6 + X, 10
  PRINT HSN$(X); TAB(18); LTRIM$(STR$(HSV%(X))); TAB(26); HSM$(X)
NEXT X
COLOR 10: LOCATE 22, 10: PRINT PN$; TAB(18); PS$; TAB(26); PM$
PCOPY 1, 0: CLS
END SUB

