' GAME1
' Collect all the hearts before the caverns cave in.
' R. Bassett Jr.
' Spring 2020

'Colors: Player, Ground, Walls, Text, Heart
Pc = 2: Gc = 0: Wc = 8: Tc = 15: Hc = 4
SCREEN 7: COLOR Tc, Gc: CLS

Start:
TIMER ON
U = 0: Px = 1: Py = 1: Pxo = 1: Pyo = 1: i$ = "": h% = 0: ht% = 20: mo% = 1

'Fr is how quickly to fill in the map (Normal, Easy, Hard, Counter)
Fr% = 180: Fe% = 320: Fh% = 96: Fi% = 0

'Initial density of obstructions (Normal, Easy, Hard)
Md% = 70: Mde% = 78: Mdh% = 65

'Bomb quantity (Normal, Easy, Hard)
bq% = 12: Bqe% = 20: Bqh% = 8

'Score variables
Score% = 0: Sn% = 0: Se% = 0: Sh% = 0: LevelTime% = 0: MaxLevelTime% = 120
'Points per  hearts collected, bombs remaining, seconds remaining
Pph% = 25: Ppb% = 52: Pps% = 2

'Max high score for instant level completetion is 1000 by default
' Hearts * PointsPerHeart + PointsPerBomb * 5 + MaxLevelTime * 2

GOSUB LoadScore
GOSUB Welcome
GOSUB CreateMap
GOSUB DrawMap
GOSUB UpdateScreen

StartTime = TIMER

'Game Loop
DO
  'Update Player
  i$ = INKEY$
  IF i$ <> CHR$(27) THEN
   IF h% = ht% THEN
    LOCATE 12, 16: PRINT "You Win!"
    EXIT DO
   END IF
  
   GOSUB Shoot
   GOSUB MovePlayer

   IF U = 1 THEN
    U = 0
    GOSUB UpdateScreen
   END IF
  ELSE
   CLS : LOCATE 12, 16: PRINT "Game Over"
  END IF

  'Fill in map over time
  IF Fi% > Fr% THEN
   GOSUB FillMap
  END IF
  Fi% = Fi% + 1
LOOP WHILE i$ <> CHR$(27)

LevelTime% = INT(TIMER - StartTime)

GOSUB SaveScore

LOCATE 25, 15: PRINT "Score:"; Score%;

LOCATE 24, 2: INPUT ; "Play again (Y/N)"; YN$
IF YN$ = "y" OR YN$ = "Y" THEN
 CLS
 GOTO Start
END IF

END
' Program exits here


' Functions Below
' -----------------------------------------
CreateMap:
DIM map(23, 40) AS STRING
FOR R = 1 TO 22
 FOR C = 1 TO 40
  RANDOMIZE TIMER
  X% = INT(RND * 100) + 1

  'Heart, Wall, or Path
  IF X% > Md% THEN
   map(R, C) = CHR$(219)
  ELSE
   map(R, C) = " "
  END IF
 NEXT C
NEXT R
'Game bottom
FOR X = 1 TO 40
 map(23, X) = CHR$(223)
NEXT X

'Add hearts
FOR X = 1 TO ht%
  RANDOMIZE TIMER
  R = INT(RND * 21) + 1
  C = INT(RND * 39) + 1
  map(R, C) = CHR$(3)
NEXT X


'Player
IF map(1, 1) = CHR$(3) THEN ht% = ht% - 1
map(1, 1) = " "
RETURN

DrawMap:
CLS
FOR R = 1 TO 23
 FOR C = 1 TO 40
  t$ = map(R, C)
  COLOR Wc
  IF t$ = CHR$(3) THEN COLOR Hc
  LOCATE R, C
  PRINT t$
 NEXT C
NEXT R
RETURN

MovePlayer:
 Pxo = Px: Pyo = Py

 'Input
 IF i$ = "" THEN
  RETURN
 ELSEIF i$ = "w" THEN
  Py = Py - 1
 ELSEIF i$ = "s" THEN
  Py = Py + 1
 ELSEIF i$ = "a" THEN
  Px = Px - 1
 ELSEIF i$ = "d" THEN
  Px = Px + 1
 END IF

 'Keep in bounds
 IF Py > 22 THEN
  Py = 22
  RETURN
 ELSEIF Py < 1 THEN
  Py = 1
  RETURN
 ELSEIF Px > 40 THEN
  Px = 40
  RETURN
 ELSEIF Px < 1 THEN
  Px = 1
  RETURN
 END IF

 'Collide with walls
 IF map(Py, Px) = CHR$(219) THEN
  Px = Pxo
  Py = Pyo
  RETURN
 END IF

 'Collect heart
 IF map(Py, Px) = CHR$(3) THEN
  h% = h% + 1
  map(Py, Px) = ""
  PLAY "L16O3G"
 END IF

 'Update Screen
 U = 1
RETURN

UpdateScreen:
'Player
LOCATE Pyo, Pxo
PRINT " "
LOCATE Py, Px
COLOR Pc
PRINT CHR$(1)

'Stats
COLOR Tc
LOCATE 24, 3
PRINT "Hearts"; ":"; h%; "/"; ht%;
LOCATE 24, 30
PRINT "Bombs:"; bq%;
RETURN

Shoot:
Bx = Px: By = Py: s% = 0

'Input Up, Down, Left, Right
IF i$ = CHR$(0) + CHR$(72) THEN
 By = By - 1
ELSEIF i$ = CHR$(0) + CHR$(80) THEN
 By = By + 1
ELSEIF i$ = CHR$(0) + CHR$(75) THEN
 Bx = Bx - 1
ELSEIF i$ = CHR$(0) + CHR$(77) THEN
 Bx = Bx + 1
ELSE
 RETURN
END IF

IF bq% < 1 THEN RETURN

bq% = bq% - 1


'Target in bounds?
IF By > 22 THEN
 RETURN
ELSEIF By < 1 THEN
 RETURN
ELSEIF Bx > 40 THEN
 RETURN
ELSEIF Bx < 1 THEN
 RETURN
END IF

IF map(By, Bx) = CHR$(219) THEN
   map(By, Bx) = " "
   LOCATE By, Bx
   PRINT " "
   s% = 1
END IF

IF s% = 1 THEN
 PLAY "L4O0D"
ELSE
 PLAY "L16O5DL8O4F"
END IF

RETURN

Welcome:
COLOR 4
LOCATE 2, 10: PRINT "Collect the Hearts!";
COLOR Tc
LOCATE 6, 20: PRINT "Move: W A S D";
LOCATE 8, 20: PRINT "Bomb: Arrow Keys";
LOCATE 11, 20: PRINT "ESC to quit."
LOCATE 13, 20: PRINT "About Bombs:"
LOCATE 14, 20: PRINT "Destroys the block"
LOCATE 15, 20: PRINT "directly beside you."
LOCATE 18, 20: PRINT "--== HIGH SCORES ==--"
LOCATE 20, 20: PRINT "Normal:"; Sn%;
LOCATE 21, 20: PRINT "Easy:  "; Se%;
LOCATE 22, 20: PRINT "Hard:  "; Sh%;

LOCATE 6, 1
PRINT "Choose Mode:"
PRINT "1 - Normal"
PRINT "2 - Easy"
PRINT "3 - Hard"
PRINT "________________"
INPUT mo%

mo$ = "Normal"

IF mo% = 3 THEN
 bq% = Bqh%
 Fr% = Fh%
 Md% = Mdh%
 mo$ = "Hard"
ELSEIF mo% = 2 THEN
 bq% = Bqe%
 Fr% = Fe%
 Md% = Mde%
 mo$ = "Easy"
END IF

CLS : LOCATE 12, 7: PRINT "Generating "; mo$; " Map ..."
RETURN

FillMap:
Fi% = 0
X% = INT(RND * 100) + 1
IF X% > 40 THEN RETURN

Y% = INT(RND * 22) + 1

IF map(Y%, X%) = " " THEN
 map(Y%, X%) = CHR$(219)
 COLOR Wc
 LOCATE Y%, X%: PRINT CHR$(219)
 COLOR Tc
END IF
RETURN

LoadScore:
f% = FREEFILE
OPEN "HS.DAT" FOR APPEND AS #f%
  IF LOF(f%) THEN
    ' If high score file exists, reopen and read its values.
    ' This avoids the file not found error.
    CLOSE #f%
    OPEN "HS.DAT" FOR INPUT AS #f%
      INPUT #1, Sn%
      INPUT #1, Se%
      INPUT #1, Sh%
  ELSE
    Sn% = 0: Se% = 0: Sh% = 0
  END IF
CLOSE #f%
RETURN

SaveScore:
IF bq% > 5 THEN bq% = 5

IF h% = 0 THEN
  Score% = 0
ELSEIF ht% > h% THEN
  Score% = h% * Pph% + bq% * Ppb%
ELSE
  'WINNER!
  Score% = h% * Pph% + bq% * Ppb%

  IF LevelTime% < MaxLevelTime% THEN
    Score% = Score% + (MaxLevelTime% - LevelTime%) * Pps%
  END IF
END IF

IF mo% = 1 THEN
  IF Score% > Sn% THEN Sn% = Score%
ELSEIF mo% = 2 THEN
  IF Score% > Se% THEN Se% = Score%
ELSEIF mo% = 3 THEN
  IF Score% > Sh% THEN Sh% = Score%
END IF

OPEN "HS.DAT" FOR OUTPUT AS #1
  WRITE #1, Sn%, Se%, Sh%
CLOSE #1
RETURN

