DECLARE SUB SaveFile ()
'CSV Sprite Maker
'R. Bassett Jr. (Tatwi)
'June 2020

DEFINT A-Z
DECLARE SUB StartSession ()
DECLARE SUB MainLoop ()
DECLARE SUB DrawScreen ()
DECLARE SUB MoveCursor ()
DECLARE SUB DrawActiveColor ()
DECLARE SUB UpdateActiveColor ()
DECLARE SUB DrawPixel ()
DECLARE SUB Commands ()
DECLARE SUB NameFile ()

SCREEN 0: WIDTH 80, 43
CLS

'Declare global variables
DIM SHARED AC AS INTEGER
DIM SHARED CX AS INTEGER
DIM SHARED CY AS INTEGER
DIM SHARED CXO AS INTEGER
DIM SHARED CXY AS INTEGER
DIM SHARED H AS INTEGER
DIM SHARED W AS INTEGER
DIM SHARED file AS STRING
DIM SHARED image(X, X) AS INTEGER
DIM SHARED i$

AC = 3 'Active color
CX = 1: CY = 1: CXO = 1: CYO = 1 'Cursor position
H = 4: W = 4 'Min image size

StartSession
DrawScreen
MainLoop
CLS
END

DATA "q","w","e","r","t","y"
DATA ")","!","@","#","$","%","^","&","*","(","Q","W","E","R","T","Y"

SUB Commands
SELECT CASE i$
  CASE IS = "s"
    SaveFile
  CASE IS = "S"
    NameFile
END SELECT
END SUB

SUB DrawActiveColor
COLOR 15
LOCATE 35, 67: PRINT "Active Color";
LOCATE 37, 68: PRINT CHR$(201); STRING$(7, CHR$(205)); CHR$(187);
LOCATE 38, 68:
  PRINT CHR$(186);
  COLOR AC: PRINT STRING$(7, CHR$(219));
  COLOR 15: PRINT CHR$(186);
LOCATE 39, 68: PRINT CHR$(200); STRING$(7, CHR$(205)); CHR$(188);
LOCATE 41, 69: PRINT "[space]"
END SUB

SUB DrawPixel
  IF i$ = " " THEN
    image(CY, CX) = AC
    COLOR AC: LOCATE CY, CX: PRINT CHR$(219)
  END IF
END SUB

SUB DrawScreen
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

FOR X = 10 TO 15
  COLOR 15
  LOCATE 2 + X * 2, 67
  READ name$
  PRINT name$; " "; : COLOR X: PRINT STRING$(3, CHR$(219));
NEXT X
LOCATE 1, 74: PRINT "Blink";
FOR X = 0 TO 15
  LOCATE X * 2 + 2, 76
  READ name$
  PRINT name$;
NEXT X
RESTORE

'Bottom stuff
LOCATE 35, 2: PRINT "File: "; file$
LOCATE 37, 2: PRINT "[s]Save [S]Rename [ESC]Exit";

DrawActiveColor
END SUB

SUB MainLoop
MoveCursor
DO
  i$ = INKEY$
  IF i$ <> "" THEN
    MoveCursor
    UpdateActiveColor
    DrawPixel
    Commands
  END IF
LOOP WHILE i$ <> CHR$(27)
END SUB

SUB MoveCursor
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
END SUB

SUB NameFile
LOCATE 41, 1: INPUT ; "New File Name"; f$
f$ = LEFT$(f$, 8)
file$ = UCASE$(f$) + ".CSV"
LOCATE 41, 1: PRINT "File name changed                         ";
SLEEP 2
DrawScreen
END SUB

SUB SaveFile
LOCATE 41, 1: INPUT "Really save file (Y/N)"; a$

IF UCASE$(a$) <> "Y" THEN
  LOCATE 41, 1: PRINT "                                 ";
  EXIT SUB
END IF

ln$ = ""
OPEN file$ FOR OUTPUT AS #1
  FOR Y = 1 TO H
    FOR X = 1 TO W
      'Create line
      ln$ = ln$ + LTRIM$(STR$(image(Y, X)))
      IF X <> W THEN ln$ = ln$ + ","
    NEXT X
  'Print line to file
  PRINT #1, ln$
  ln$ = ""
  NEXT Y
CLOSE #1

LOCATE 41, 1: PRINT "File saved!                         ";
SLEEP 2
LOCATE 41, 1: PRINT "                         ";
END SUB

SUB StartSession
'New file or load file
LOCATE 10, 30: PRINT "1. New Image"
LOCATE 11, 30: PRINT "2. Load Image"
LOCATE 14, 30: INPUT a

CLS
IF a = 1 THEN
  'Set new image size
  LOCATE 10, 30: INPUT ; "Height (4 - 32)"; H
  LOCATE 11, 30: INPUT ; "Width (4 - 64)"; W
  LOCATE 12, 30: INPUT ; "File Name (8 max, no extention)"; f$

  IF H > 32 THEN H = 32
  IF H < 4 THEN H = 4
  IF W > 64 THEN W = 64
  IF W < 4 THEN W = 4

  IF f$ = "" THEN f$ = "TEST"
  f$ = LEFT$(f$, 8)
  f$ = UCASE$(f$)
  file$ = f$ + ".CSV"

  REDIM image(H, W)
  FOR Y = 1 TO H
    FOR X = 1 TO W
        image%(Y, X) = 0
    NEXT X
  NEXT Y
ELSEIF a = 2 THEN
  'Load image from file
  LOCATE 14, 25: PRINT "(without file extention)"
  LOCATE 10, 30: INPUT ; "File Name"; f$
  file$ = f$ + ".CSV"

  OPEN file$ FOR INPUT AS #1
  LINE INPUT #1, ln$
 
  'Determine width
  W = LEN(ln$)
  COMMAS = 0
  FOR X = 1 TO W
    P = INSTR(X, ln$, ",")
    IF P <> 0 THEN
      X = P
      COMMAS = COMMAS + 1
    END IF
  NEXT X
  W = COMMAS + 1

  'Get height
  H = 0
  SEEK #1, 1
  DO WHILE NOT EOF(1)
    LINE INPUT #1, ln$
    IF ln$ <> "" THEN H = H + 1
  LOOP

  'Load data
  SEEK #1, 1
  REDIM image(H, W)
  FOR Y = 1 TO H
    FOR X = 1 TO W
        INPUT #1, i
        image(Y, X) = i
    NEXT X
  NEXT Y
  CLOSE #1
ELSE
  CLS : StartSession
END IF
END SUB

SUB UpdateActiveColor
SELECT CASE i$
  CASE IS = "0"
    AC = 0
  CASE IS = "1"
    AC = 1
  CASE IS = "2"
    AC = 2
  CASE IS = "3"
    AC = 3
  CASE IS = "4"
    AC = 4
  CASE IS = "5"
    AC = 5
  CASE IS = "6"
    AC = 6
  CASE IS = "7"
    AC = 7
  CASE IS = "8"
    AC = 8
  CASE IS = "9"
    AC = 9
  CASE IS = "q"
    AC = 10
  CASE IS = "w"
    AC = 11
  CASE IS = "e"
    AC = 12
  CASE IS = "r"
    AC = 13
  CASE IS = "t"
    AC = 14
  CASE IS = "y"
    AC = 15
  CASE IS = ")"
    AC = 16
  CASE IS = "!"
    AC = 17
  CASE IS = "@"
    AC = 18
  CASE IS = "#"
    AC = 19
  CASE IS = "$"
    AC = 20
  CASE IS = "%"
    AC = 21
  CASE IS = "^"
    AC = 22
  CASE IS = "&"
    AC = 23
  CASE IS = "*"
    AC = 24
  CASE IS = "("
    AC = 25
  CASE IS = "Q"
    AC = 26
  CASE IS = "W"
    AC = 27
  CASE IS = "E"
    AC = 28
  CASE IS = "R"
    AC = 29
  CASE IS = "T"
    AC = 30
  CASE IS = "Y"
    AC = 31
END SELECT
DrawActiveColor
END SUB

