SCREEN 7: COLOR 2, 15
CLS: PRINT "Generating Map..."
U = 0: Px = 1: Py = 1: Pxo = 1: Pyo = 1: i$ = "": h% = 0: ht% = 0
GOSUB CreateMap
GOSUB DrawMap
GOSUB UpdateScreen

'Game Loop
DO
    i$ = INKEY$
    IF i$ <> "q" THEN
        IF h% = ht% THEN GOTO YouWin

        GOSUB MovePlayer
        IF U = 1 THEN
            U = 0
            GOSUB UpdateScreen
        END IF
    ELSE
        CLS: LOCATE 12, 15: PRINT "Game Over"
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
        x% = INT(RND * 100) + 1

        'Heart, Wall, or Path
        IF x% > 98 THEN
            map(R, C) = CHR$(3)
            ht% = ht% + 1
        ELSEIF x% > 70 THEN
            map(R, C) = CHR$(219)
        ELSE
            map(R, C) = ""
        END IF
    NEXT C
NEXT R

'Player
IF map(1, 1) = CHR$(3) THEN ht% = ht% - 1
map(1, 1) = ""
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

LOCATE 23, 1
PRINT CHR$(3); ":"; h%; "/"; ht%
RETURN

