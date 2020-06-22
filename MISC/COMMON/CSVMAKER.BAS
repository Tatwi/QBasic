'CSV Sprite Maker
'R. Bassett Jr. (Tatwi)
'June 2020

DEFINT A-Z
SCREEN 0: WIDTH 80, 43
CLS

AC = 3 'Active color
CX = 1: CY = 1: CXO = 1: CYO = 1 'Cursor position
H = 4: W = 4 'Min image size

GOSUB StartSession
GOSUB DrawScreen
GOSUB DrawActiveColor
GOSUB MainLoop
CLS
END


MainLoop:
GOSUB MoveCursor
DO
  i$ = INKEY$
  IF i$ <> "" THEN
    GOSUB MoveCursor
    GOSUB UpdateActiveColor
    GOSUB DrawPixel
  END IF
LOOP WHILE i$ <> CHR$(27)
RETURN

StartSession:
'New file or load file
LOCATE 10, 30: PRINT "1. New Image"
LOCATE 11, 30: PRINT "2. Load Image"
LOCATE 14, 30: INPUT a

CLS
IF a = 1 THEN
  'Set new image size
  LOCATE 10, 30: INPUT ; "Height (4 - 32)"; H
  LOCATE 11, 30: INPUT ; "Width (4 - 64)"; W
  LOCATE 12, 30: INPUT ; "File Name (8 max)"; f$

  IF H > 32 THEN H = 32
  IF H < 4 THEN H = 4
  IF W > 64 THEN W = 64
  IF W < 4 THEN W = 4

  IF f$ = "" THEN f$ = "TEST"
  IF LEN(f$) > 8 THEN f$ = LEFT$(f$, 8)
  f$ = UCASE$(f$)

  DIM image(H, W)
  FOR Y = 1 TO H
    FOR X = 1 TO W
        image%(Y, X) = 0
    NEXT X
  NEXT Y
ELSEIF a = 2 THEN
  'Load image from file
  LOCATE 10, 30: INPUT ; "File Name"; f$
  file$ = f$ + ".CSV"

  OPEN file$ FOR INPUT AS #1
  LINE INPUT #1, ln$
 
  'Get width
  W = INT(LEN(ln$) / 2 + 1)
 
  'Get height
  H = 0
  SEEK #1, 1
  DO WHILE NOT EOF(1)
    LINE INPUT #1, ln$
    IF ln$ <> "" THEN H = H + 1
  LOOP

  'Load data
  SEEK #1, 1
  DIM image%(H, W)
  FOR Y = 1 TO H
    FOR X = 1 TO W
        INPUT #1, i
        image%(Y, X) = i
    NEXT X
  NEXT Y
  CLOSE #1
ELSE
  CLS : GOTO StartSession
END IF
RETURN


DrawScreen:
CLS
'Draw image
FOR Y = 1 TO H
  FOR X = 1 TO W
    COLOR image(Y, X)
    LOCATE Y, X: PRINT CHR$(219)
  NEXT X
NEXT Y

'Draw border
COLOR 8
FOR X = 1 TO H
  LOCATE X, W + 1: PRINT CHR$(176)
NEXT X
b$ = CHR$(176)
LOCATE H + 1, 1: PRINT STRING$(W + 1, CHR$(176))

'Right side legend
FOR X = 0 TO 9
  COLOR 15
  LOCATE 2 + X * 2, 66
  PRINT X; : COLOR X: PRINT STRING$(3, CHR$(219));
NEXT X

DATA "q","w","e","r","t","y","u","i"
FOR X = 10 TO 15
  COLOR 15
  LOCATE 2 + X * 2, 67
  READ name$
  PRINT name$; " "; : COLOR X: PRINT STRING$(3, CHR$(219));
NEXT X

'Bottom stuff
LOCATE 35, 2: PRINT "File: "; f$; ".CSV"
RETURN

DrawActiveColor:
LOCATE 35, 60: PRINT "Active Color"
LOCATE 37, 60: COLOR AC: PRINT STRING$(3, CHR$(219));
RETURN

MoveCursor:
CXO = CX: CYO = CY

SELECT CASE i$
  CASE IS = CHR$(0) + CHR$(72) 'Up
    CY = CY - 1
  CASE IS = CHR$(0) + CHR$(80) 'Down
    CY = CY + 1
  CASE IS = CHR$(0) + CHR$(75) 'Left
    CX = CX - 1
  CASE IS = CHR$(0) + CHR$(77) 'Right
      CX = CX + 1
END SELECT

IF CX < 1 THEN CX = 1
IF CX > W THEN CX = W
IF CY < 1 THEN CY = 1
IF CY > H THEN CY = H

COLOR image%(CYO, CXO): LOCATE CYO, CXO: PRINT CHR$(219)
COLOR 0, 15: LOCATE CY, CX: PRINT CHR$(4);
COLOR 15, 0
RETURN


UpdateActiveColor:
RETURN

DrawPixel:

RETURN

