SCREEN 13
CLS : PRINT "Generating Map..."
U = 0: Px = 1: Py = 1: i$ = "": h% = 0: ht% = 0
GOSUB CreateMap
GOSUB DrawMap
LOCATE 23, 1
PRINT "Hearts: "; h%

'Game Loop
DO
  i$ = INKEY$
  IF i$ <> "q" THEN
   IF h% = ht% THEN GOTO YouWin

   GOSUB MovePlayer
   IF U = 1 THEN
    U = 0
    GOSUB DrawMap
    LOCATE 23, 1
    PRINT "Hearts: "; h%
   END IF
  ELSE
   CLS : LOCATE 12, 15: PRINT "Game Over"
  END IF
LOOP WHILE i$ <> "q"
END

YouWin:
CLS : LOCATE 12, 16: PRINT "You Win!"
END

CreateMap:
DIM map(22, 40) AS STRING
FOR R = 1 TO 22
 FOR C = 1 TO 40
  RANDOMIZE TIMER
  x% = INT(RND * 100) + 1
  IF x% > 95 THEN
   map(R, C) = CHR$(3)
   ht% = ht% + 1
  ELSEIF x% > 70 THEN
   map(R, C) = CHR$(219)
  ELSE
   map(R, C) = ""
  END IF
 NEXT C
NEXT R
map(1, 1) = CHR$(1)
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
 IF map(Py, Px) = CHR$(3) THEN h% = h% + 1

 'Update Screen
 U = 1
 map(Pyo, Pxo) = ""
 map(Py, Px) = CHR$(1)
RETURN

