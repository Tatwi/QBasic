REM Sprite Motion Demo
REM R. Bassett Jr. (Tatwi)
REM June 2020
REM Requires: SPR1.QBD, SPR2.QBD

DECLARE SUB Update (Sprite%(), H%, W%, C%, R%, S%)
DECLARE SUB MYPUT (Sprite%(), H%, W%, X%, Y%)
SCREEN 7, 0, 1, 0: DEFINT A-Z

DIM sp1%(8, 8)
DIM sp2%(16, 16)
DIM sp3%(64)
DIM sp4%(256)

GOSUB LoadSprites
REM GOSUB MakeAltSprites
GOSUB LoadAltSprites

StartGame:
R = 8: C = 0: Rm% = 183: Cm% = 311: S = 5: A = 1: M = 0

CLS
PRINT "My Sprite Demo:"
PRINT ""
PRINT "W A S D to move"
PRINT "Q and E to change speed"
PRINT "O and P change sprite"
PRINT "M to switch drawing modes"
PRINT ""
PRINT "R to restart"
PRINT "ESC to quit"
PRINT ""
PRINT "Press S to start!"
PCOPY 1, 0

'Main loop
i$ = ""
DO WHILE i$ <> CHR$(27)
  i$ = LCASE$(INKEY$)

  IF i$ = "r" THEN GOTO StartGame

  IF i$ = "m" AND M = 0 THEN
    M = 1
  ELSEIF i$ = "m" AND M = 1 THEN
    M = 0
  END IF

  IF i$ <> "" THEN
    IF i$ = "o" THEN
      A = 1
      Rm% = 183
      Cm% = 311
    ELSEIF i$ = "p" THEN
      A = 2
      Rm% = 175
      Cm% = 303
    END IF
   
    IF i$ = "q" THEN S = S - 1
    IF i$ = "e" THEN S = S + 1
    IF S < 1 THEN S = 1
    IF S > 10 THEN S = 10
   
    IF i$ = "w" THEN R = R - S
    IF i$ = "s" THEN R = R + S
    IF R < 8 THEN R = 8
    IF R > Rm% THEN R = Rm%
   
    IF i$ = "a" THEN C = C - S
    IF i$ = "d" THEN C = C + S
    IF C < 0 THEN C = 0
    IF C > Cm% THEN C = Cm%

    IF M = 0 THEN
      IF A = 1 THEN
        Update sp1%(), 8, 8, C, R, S
      ELSEIF A = 2 THEN
        Update sp2%(), 16, 16, C, R, S
      END IF
    ELSE
      IF A = 1 THEN
        CLS : PUT (C, R), sp3%
        GOSUB AltUpdate
      ELSEIF A = 2 THEN
        CLS : PUT (C, R), sp4%
        GOSUB AltUpdate
      END IF
    END IF
  END IF
LOOP
CLS
END

LoadSprites:
'QBasic can't return arrays, must do this in the global space

OPEN "SPR1.QBD" FOR INPUT AS #1
FOR Y = 1 TO 8
    FOR X = 1 TO 8
        INPUT #1, i
        sp1%(X, Y) = i
    NEXT X
NEXT Y
CLOSE #1

OPEN "SPR2.QBD" FOR INPUT AS #1
FOR Y = 1 TO 16
    FOR X = 1 TO 16
        INPUT #1, i
        sp2%(X, Y) = i
    NEXT X
NEXT Y
CLOSE #1
RETURN

'Use the loaded data to make sprites for use with PUT
MakeAltSprites:
CLS
FOR X = 1 TO 8
  FOR Y = 1 TO 8
    PSET (X, Y), sp1%(X, Y)
  NEXT Y
NEXT X
GET (1, 1)-(8, 8), sp3%

'Save to file in direct memory format
DEF SEG = VARSEG(sp3%(0))
BSAVE "spr3.bsv", VARPTR(sp3%(0)), 64

CLS
FOR X = 1 TO 16
  FOR Y = 1 TO 16
    PSET (X, Y), sp2%(X, Y)
  NEXT Y
NEXT X
GET (1, 1)-(16, 16), sp4%

DEF SEG = VARSEG(sp4%(0))
BSAVE "spr4.bsv", VARPTR(sp4%(0)), 256


CLS
RETURN

AltUpdate:
'Display speed
LOCATE 25, 2: PRINT "Speed:"; S; "[ALT MODE]";
LOCATE 25, 22: PRINT "Row/Col:"; R; C

'Put it on the active screen
PCOPY 1, 0
RETURN

'Load sprites in direct memory format
LoadAltSprites:
DEF SEG = VARSEG(sp3%(0))
BLOAD "spr3.bsv", VARPTR(sp3%(0))

DEF SEG = VARSEG(sp4%(0))
BLOAD "spr4.bsv", VARPTR(sp4%(0))

RETURN

SUB MYPUT (Sprite%(), H, W, X, Y)
  FOR YP = 1 TO H
    FOR XP = 1 TO W
      PSET (X + XP, Y + YP), Sprite%(XP, YP)
    NEXT XP
  NEXT YP
END SUB

SUB Update (Sprite%(), H%, W%, C, R, S)
  CLS
  MYPUT Sprite%(), H%, W%, C, R
  
  'Display speed
  LOCATE 25, 2: PRINT "Speed:"; S;
  LOCATE 25, 20: PRINT "Row/Col:"; R; C

  'Put it on the active screen
  PCOPY 1, 0
END SUB

