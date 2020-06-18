SCREEN 7: COLOR 2, 15
CLS : PRINT "Generating Map..."
U = 0: Px = 1: Py = 1: Pxo = 1: Pyo = 1: i$ = "": h% = 0: ht% = 0: Bq% = 3
GOSUB CreateMap
GOSUB DrawMap
GOSUB UpdateScreen

'Game Loop
DO
  'Update Player
  i$ = INKEY$
  IF i$ <> "q" THEN
   IF h% = ht% THEN GOTO YouWin
  
   GOSUB Shoot
   GOSUB MovePlayer

   IF U = 1 THEN
    U = 0
    GOSUB UpdateScreen
   END IF
  ELSE
   CLS : LOCATE 12, 15: PRINT "Game Over"
  END IF
LOOP WHILE i$ <> "q"
END

YouWin:
LOCATE 12, 16: PRINT "You Win!"
END

CreateMap:
DIM map(22, 40) AS STRING
FOR R = 1 TO 22
 FOR C = 1 TO 40
  RANDOMIZE TIMER
  X% = INT(RND * 100) + 1

  'Heart, Wall, or Path
  IF X% > 98 THEN
   map(R, C) = CHR$(3)
   ht% = ht% + 1
  ELSEIF X% > 70 THEN
   map(R, C) = CHR$(219)
  ELSE
   map(R, C) = " "
  END IF
 NEXT C
NEXT R

'Player
IF map(1, 1) = CHR$(3) THEN ht% = ht% - 1
map(1, 1) = " "
RETURN

DrawMap:
CLS
FOR R = 1 TO 22
 FOR C = 1 TO 40
  t$ = map(R, C)
 
  COLOR 2
 
  IF t$ = CHR$(3) THEN
   COLOR 4
  ELSEIF t$ = CHR$(219) THEN
   COLOR 8
  END IF

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
COLOR 2

LOCATE Pyo, Pxo
PRINT " "
LOCATE Py, Px
PRINT CHR$(1)

LOCATE 23, 3
PRINT "Hearts"; ":"; h%; "/"; ht%
LOCATE 23, 30
PRINT "Shots:"; Bq%
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

