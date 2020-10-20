DECLARE SUB ChangeASCII ()
' ASCII Image Maker
' R. Bassett Jr. (Tatwi)
' Oct 2020
' For creating 16 color ASCII images.

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
DECLARE SUB SaveFile ()

SCREEN 0: WIDTH 80, 43
CLS

'Declare global variables
DIM SHARED AA AS INTEGER    ' Active ASCII character
DIM SHARED AC AS INTEGER    ' Active color
DIM SHARED CX AS INTEGER    ' Current X position
DIM SHARED CY AS INTEGER    ' Current Y position
DIM SHARED CXO AS INTEGER   ' Previous X position
DIM SHARED CXY AS INTEGER   ' Previous Y postion
DIM SHARED H AS INTEGER     ' Image height, in characters
DIM SHARED W AS INTEGER     ' Image width, in characters
DIM SHARED file AS STRING   ' Active image file
DIM SHARED image(X, X) AS INTEGER   ' Working image data
DIM SHARED I$               ' User input

AA = 219: AC = 3
CX = 1: CY = 1: CXO = 1: CYO = 1 'Cursor position
H = 4: W = 4 'Min image size

StartSession
DrawScreen
MainLoop
CLS
END

DATA "q","w","e","r","t","y"
DATA ")","!","@","#","$","%","^","&","*","(","Q","W","E","R","T","Y"

SUB ChangeASCII


LOCATE 41, 1: INPUT ; "Enter ASCII Number (0-255):"; I$
I = VAL(I$)
IF I < 0 THEN I = 0
IF I > 255 THEN I = 255

' Don't allow codes that won't work properly
IF I = 9 THEN
ELSEIF I = 10 THEN
ELSEIF I = 11 THEN
ELSEIF I = 12 THEN
ELSEIF I = 13 THEN
ELSEIF I = 26 THEN
ELSEIF I = 30 THEN
ELSEIF I = 32 THEN
ELSE
  AA = I
END IF

LOCATE 41, 1: PRINT "                                 ";
UpdateActiveColor
END SUB

SUB Commands
SELECT CASE I$
  CASE IS = "s"
    SaveFile
  CASE IS = "S"
    NameFile
  CASE IS = "m"
    ChangeASCII
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
LOCATE 41, 67: PRINT "[m]ASCII: "; CHR$(AA);
END SUB

SUB DrawPixel
  IF I$ = " " THEN
    ' Store color in thousands position, ASCII code in hundreds position
    image(CY, CX) = AC * 1000 + AA
    COLOR AC: LOCATE CY, CX: PRINT CHR$(AA)
  END IF
END SUB

SUB DrawScreen
CLS
'Draw image
FOR Y = 1 TO H
  FOR X = 1 TO W
    C = image(Y, X) / 1000
    A = image(Y, X) - C * 1000
    COLOR C
    LOCATE Y, X: PRINT CHR$(A)
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
  I$ = INKEY$
  IF I$ <> "" THEN
    MoveCursor
    UpdateActiveColor
    DrawPixel
    Commands
  END IF
LOOP WHILE I$ <> CHR$(27)
END SUB

SUB MoveCursor
CXO = CX: CYO = CY

SELECT CASE I$
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

C = image(CYO, CXO) / 1000
A = image(CYO, CXO) - C * 1000

' Print what was previously under the cursor
COLOR C: LOCATE CYO, CXO: PRINT CHR$(A);

' Print the cursor
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
LOCATE 41, 1: INPUT "Really save file (Y/N)"; A$

IF UCASE$(A$) <> "Y" THEN
  LOCATE 41, 1: PRINT "                                 ";
  EXIT SUB
END IF

ln$ = ""
OPEN file$ FOR OUTPUT AS #1
  ' First line is the height and width, for human readability.
  WRITE #1, H, W

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
LOCATE 14, 30: INPUT A

CLS
IF A = 1 THEN
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
  file$ = f$ + ".IMG"

  REDIM image(H, W)
  FOR Y = 1 TO H
    FOR X = 1 TO W
        image%(Y, X) = 0
    NEXT X
  NEXT Y
ELSEIF A = 2 THEN
  'Load image from file
  LOCATE 14, 25: PRINT "(without file extention)"
  LOCATE 10, 30: INPUT ; "File Name"; f$
  file$ = f$ + ".IMG"

  OPEN file$ FOR INPUT AS #1
  ' Get image size from first two data points
  INPUT #1, I: H = I
  INPUT #1, I: W = I

  'Load data
  REDIM image(H, W)
  FOR Y = 1 TO H
    FOR X = 1 TO W
        INPUT #1, I
        image(Y, X) = I
    NEXT X
  NEXT Y
  CLOSE #1
ELSE
  CLS : StartSession
END IF
END SUB

SUB UpdateActiveColor
SELECT CASE I$
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

