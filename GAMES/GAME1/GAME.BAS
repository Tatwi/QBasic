' GAME1
' Collect all the hearts before the caverns cave in.
' R. Bassett Jr.
' Spring 2020

'Colors: Player, Ground, Walls, Text, Heart
Pc = 5: Gc = 2: Wc = 8: Tc = 15: Hc = 4
SCREEN 7: COLOR Tc, Gc: CLS

Start:
U = 0: Px = 1: Py = 1: Pxo = 1: Pyo = 1: i$ = "": h% = 0: ht% = 0

'Fr is how quickly to fill in the map (Normal, Easy, Hard, Counter)
Fr% = 180: Fe% = 320: Fh% = 96: Fi% = 0

'Initial density of obstructions (Normal, Easy, Hard)
Md% = 70: Mde% = 78: Mdh% = 65

'Bullet quantity (Normal, Easy, Hard)
Bq% = 12: Bqe% = 20: Bqh% = 8

GOSUB Welcome
GOSUB CreateMap
GOSUB DrawMap
GOSUB UpdateScreen

'Game Loop
DO
  'Update Player
  i$ = INKEY$
  IF i$ <> CHR$(27) THEN
   IF h% = ht% THEN
    LOCATE 12, 16: PRINT "You Win!"
    GOTO PlayAgain
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

GOTO PlayAgain
END

PlayAgain:
LOCATE 24, 2: INPUT ; "Play again (Y/N)"; YN$
IF YN$ = "y" OR YN$ = "Y" THEN
 CLS
 GOTO Start
END IF
END

CreateMap:
DIM map(23, 40) AS STRING
FOR R = 1 TO 22
 FOR C = 1 TO 40
  RANDOMIZE TIMER
  X% = INT(RND * 100) + 1

  'Heart, Wall, or Path
  IF X% > 98 THEN
   map(R, C) = CHR$(3)
   ht% = ht% + 1
  ELSEIF X% > Md% THEN
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
PRINT "Shots:"; Bq%;
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

IF Bq% < 1 THEN RETURN

Bq% = Bq% - 1


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
LOCATE 2, 20: PRINT "Collect the hearts!";
LOCATE 6, 20: PRINT "Move: W A S D";
LOCATE 8, 20: PRINT "Shoot: Arrow Keys";
LOCATE 11, 20: PRINT "ESC to quit."
LOCATE 15, 20: PRINT "About Shooting:"
LOCATE 16, 20: PRINT "Destroys the block"
LOCATE 17, 20: PRINT "directly beside you."

'Pick player color
LOCATE 2, 1
COLOR 15
PRINT "Pick "; CHR$(1); " Color:"
COLOR 1: PRINT "1 - Blue"
COLOR 4: PRINT "4 - Red"
COLOR 5: PRINT "5 - Magenta"
COLOR 6: PRINT "6 - Brown"
COLOR 10: PRINT "10 - Light Green"
COLOR 11: PRINT "11 - Light Cyan"
COLOR 14: PRINT "14 - Yellow"
COLOR 15: PRINT "________________"

COLOR Tc
INPUT Pc

IF Pc > 15 THEN Pc = 1
IF Pc < 1 THEN Pc = 1

PRINT " "
PRINT "Choose Mode:"
PRINT "1 - Normal"
PRINT "2 - Easy"
PRINT "3 - Hard"
PRINT "________________"
INPUT mo%

mo$ = "Normal"

IF mo% = 3 THEN
 Bq% = Bqh%
 Fr% = Fh%
 Md% = Mdh%
 mo$ = "Hard"
ELSEIF mo% = 2 THEN
 Bq% = Bqe%
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
 LOCATE Y%, X%: PRINT CHR$(219)
END IF
RETURN

