' ASCII Image Maker
' R. Bassett Jr. (Tatwi)
' Oct 2020
' For creating ASCII images up to 80x40 characters, with 16 foreground colors
' and 8 background colors.

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
DECLARE SUB ChangeASCII ()
DECLARE SUB DrawMenu ()
DECLARE SUB DrawBar (Start%)
DECLARE SUB FillSwap ()
DECLARE FUNCTION FindCode (AA)
DECLARE SUB Help ()
DECLARE SUB InsertString ()


SCREEN 0: WIDTH 80, 50
CLS

'Declare global variables
CONST TRUE = -1
CONST FALSE = 0
DIM SHARED AA AS INTEGER    ' Active ASCII character
DIM SHARED AC AS INTEGER    ' Active color
DIM SHARED BC AS INTEGER    ' Background color
DIM SHARED CX AS INTEGER    ' Current X position
DIM SHARED CY AS INTEGER    ' Current Y position
DIM SHARED CXO AS INTEGER   ' Previous X position
DIM SHARED CYO AS INTEGER   ' Previous Y postion
DIM SHARED H AS INTEGER     ' Image height, in characters
DIM SHARED W AS INTEGER     ' Image width, in characters
DIM SHARED file AS STRING   ' Active image file
DIM SHARED image(X, X) AS LONG   ' Working image data
DIM SHARED I AS STRING      ' User input
DIM SHARED DWM AS INTEGER   ' Draw when moving bool

' Custom ASCII character chart
DIM SHARED AB AS INTEGER    ' Active ASCII bar index number
DIM SHARED chartSize AS INTEGER: chartSize = 241
DIM SHARED aChart(1 TO chartSize) AS INTEGER
OPEN "ASCII.CSV" FOR INPUT AS #1
  FOR X = 1 TO chartSize
    INPUT #1, aChart(X)
  NEXT X
CLOSE #1

AA = 219: AC = 3: BC = 0: AB = FindCode(AA)
CX = 1: CY = 1: CXO = 1: CYO = 1 'Cursor position
H = 4: W = 4 'Min image size

StartSession
DrawScreen
MainLoop
SaveFile
CLS
END

SUB ChangeASCII
'Input as string to prevent screen scrolling on bad input
COLOR 5, 0: LOCATE 50, 1: PRINT STRING$(80, 219);
COLOR 15, 5: LOCATE 50, 1: INPUT ; "Enter ASCII Number (0-255):"; UIN$

' Recover from bad input
IF LEN(UIN$) > 3 THEN
  COLOR 7, 0
  DrawScreen
  COLOR 5, 0: LOCATE 50, 1: PRINT STRING$(80, 219);
  COLOR 15, 5: LOCATE 50, 1: PRINT "Error: Invalid input";
  SLEEP 4
  COLOR 7, 0
  LOCATE 50, 1: PRINT STRING$(80, " ");
  EXIT SUB
END IF

UC = VAL(UIN$)

' Clamp input to valid range/value
IF UC < 0 THEN UC = 0
IF UC > 254 THEN UC = 0

' Don't allow codes that won't work properly
IF UC = 7 THEN
ELSEIF UC = 9 THEN
ELSEIF UC = 10 THEN
ELSEIF UC = 11 THEN
ELSEIF UC = 12 THEN
ELSEIF UC = 13 THEN
ELSEIF UC = 26 THEN
ELSEIF UC = 30 THEN
ELSEIF UC = 31 THEN
ELSEIF UC = 32 THEN
ELSE
  AA = UC
END IF

COLOR 7, 0
LOCATE 50, 1: PRINT STRING$(80, " ");
DrawActiveColor

' Update the scroll bar
AB = FindCode(AA)
DrawBar (AB)

' Reset input string to avoid triggering other commands
I$ = ""
END SUB

SUB Commands
SELECT CASE I$
  CASE IS = CHR$(0) + CHR$(62)
    SaveFile
  CASE IS = CHR$(0) + CHR$(63)
    DrawScreen
  CASE IS = CHR$(0) + CHR$(61)
    NameFile
  CASE IS = "m"
    ChangeASCII
  CASE IS = CHR$(0) + CHR$(115)
    ' ASCII scroll bar <<
    AB = AB - 1
    IF AB = 0 THEN AB = chartSize
    DrawBar (AB)
    AA = aChart(AB)
    DrawActiveColor
  CASE IS = CHR$(0) + CHR$(116)
    ' ASCII scroll bar >>
    AB = AB + 1
    IF AB > chartSize THEN AB = 1
    DrawBar (AB)
    AA = aChart(AB)
    DrawActiveColor
  CASE IS = CHR$(0) + CHR$(67)
    FillSwap
  CASE IS = CHR$(0) + CHR$(134)
    ' Set active to match what's under the cursor
    BC = image(CY, CX) / 100000
    AC = (image(CY, CX) - BC * 100000) / 1000
    AA = VAL(RIGHT$(STR$(image(CY, CX)), 3))
    AB = FindCode(AA)
    DrawBar (AB)
    DrawActiveColor
  CASE IS = CHR$(6)
    ' CTL+F Memory status message
    COLOR 5: LOCATE 50, 1: PRINT STRING$(80, 219);
    COLOR 15, 5: LOCATE 50, 1
    PRINT "Free Memory:"; FRE(0); "Array:"; FRE(-1); "Stack:"; FRE(-2);
    SLEEP 10
    COLOR 7, 0
    LOCATE 50, 1: PRINT STRING$(80, " ");
  CASE IS = CHR$(0) + CHR$(59)
    Help
  CASE IS = CHR$(0) + CHR$(66)
    InsertString
  CASE IS = CHR$(0) + CHR$(79)
    ' Toggle draw when moving
    IF DWM THEN
      DWM = 0
      COLOR 2: LOCATE 45, 52: PRINT STRING$(20, " ")
    ELSE
      DWM = -1
      COLOR 2: LOCATE 45, 52: PRINT "Draw On Move Enabled"; : COLOR 7
    END IF
END SELECT

END SUB

SUB DrawActiveColor
COLOR 7, 0
LOCATE 46, 44
  PRINT "Colors ("; LTRIM$(STR$(AC)); ","; LTRIM$(STR$(BC)); "):";
  COLOR AC, 0: PRINT STRING$(2, 219);
  COLOR BC, 0: PRINT STRING$(2, 219);
  COLOR 7, 0: PRINT "    "
LOCATE 46, 65
  COLOR 7: PRINT "ASCII ("; LTRIM$(STR$(AA)); "):";
  COLOR AC, BC: PRINT CHR$(AA);
  COLOR 7, 0: PRINT "  ";
END SUB

SUB DrawBar (Start)
LOUT$ = ""
ROUT$ = ""

' Before (left side)
Z = 19
FOR X = 1 TO 19
  TP = Start - Z
  IF TP = 0 THEN TP = chartSize
  IF TP < 0 THEN TP = chartSize - ABS(TP)

  LOUT$ = LOUT$ + CHR$(aChart(TP)) + " "

  Z = Z - 1
NEXT X
                           
' After (right side)
FOR X = 1 TO 16
  TP = Start + X
  IF TP < 1 THEN TP = chartSize + 1 - X
  IF TP > chartSize THEN TP = TP - chartSize

  ROUT$ = ROUT$ + CHR$(aChart(TP)) + " "
NEXT X

' Print results
COLOR 7, 0
LOCATE 42, 3: PRINT LOUT$;
LOCATE 42, 41:
  PRINT CHR$(179); " ";
  COLOR AC, BC
  PRINT CHR$(aChart(Start));
  COLOR 7, 0
  PRINT " "; CHR$(179);
LOCATE 42, 47: PRINT ROUT$;
END SUB

SUB DrawMenu
' ASCII choice bar borders
COLOR 7, 0:
LOCATE 41, 1
  PRINT CHR$(201);
  PRINT STRING$(39, 205);
  PRINT CHR$(209); STRING$(3, 205); ; CHR$(209);
  PRINT STRING$(34, 205);
  PRINT CHR$(187);
LOCATE 43, 1
  PRINT CHR$(200);
  PRINT STRING$(39, 205);
  PRINT CHR$(207); STRING$(3, 205); ; CHR$(207);
  PRINT STRING$(34, 205);
  PRINT CHR$(188);
' Arrows
COLOR 0, 7
LOCATE 42, 1: PRINT "<";
LOCATE 42, 80: PRINT ">";

' Color blocks
COLOR 7, 0
P = 10
FOR X = 1 TO 15
  COLOR X
  LOCATE 44, P + X
  PRINT CHR$(219);
  P = P + 1
NEXT X

' Color keys
COLOR 7, 0
LOCATE 46, 2: PRINT "Color: 0 1 2 3 4 5 6 7 8 9 q w e r t y";
LOCATE 47, 2: PRINT "Blink: ) ! @ # $ % ^ & * ( Q W E R T Y";

' Commands
COLOR 7, 0
LOCATE 49, 2: PRINT file$;
PRINT " [ESC]Exit [F1]Help [F3]Rename [F4]Save [F5]Redraw [m]ASCII";

' ASCII bar contents
DrawBar (FindCode(AA))

' Reset colors
COLOR 7, 0
END SUB

SUB DrawPixel

SELECT CASE I$
  CASE IS = " "
    ' Store color in thousands position, ASCII code in hundreds position
    image(CY, CX) = BC * 100000 + AC * 1000 + AA
    COLOR AC, BC: LOCATE CY, CX: PRINT CHR$(AA)
  CASE IS = "c"
    ' Change only the colors at cursor postion
    A = image(CY, CX) - (image(CY, CX) / 1000) * 1000
    image(CY, CX) = BC * 100000 + AC * 1000 + A
    COLOR AC: LOCATE CY, CX: PRINT CHR$(AA)
END SELECT

' Draw what was previously under the cursor
B = image(CYO, CXO) / 100000
C = (image(CYO, CXO) - B * 100000) / 1000
A = VAL(RIGHT$(STR$(image(CYO, CXO)), 3))
COLOR C, B
LOCATE CYO, CXO: PRINT CHR$(A)


' Draw the cursor
COLOR 0, 15: LOCATE CY, CX: PRINT CHR$(4);

' Reset to the default color
COLOR 7, 0
END SUB

SUB DrawScreen
CLS
'Draw image
FOR Y = 1 TO H
  FOR X = 1 TO W
    ' Extract color and ASCII values
    B = image(Y, X) / 100000
    C = (image(Y, X) - B * 100000) / 1000
    A = VAL(RIGHT$(STR$(image(Y, X)), 3))

    ' Print image on the screen
    COLOR C, B
    LOCATE Y, X: PRINT CHR$(A)
  NEXT X
NEXT Y

'Draw border
COLOR 8, 0
IF W < 80 THEN
  FOR X = 1 TO H
    LOCATE X, W + 1: PRINT CHR$(176)
  NEXT X
END IF

IF H < 40 THEN
  LOCATE H + 1, 1: PRINT STRING$(W + 1, 176)
END IF

DrawMenu
DrawActiveColor
END SUB

SUB FillSwap
' Fill the image with the active color/character where it matches
' the color/character at the cursor location.
T& = image(CY, CX)
FOR Y = 1 TO H
  FOR X = 1 TO W
    IF image(Y, X) = T& THEN image(Y, X) = BC * 100000 + AC * 1000 + AA
  NEXT X
NEXT Y
DrawScreen
END SUB

FUNCTION FindCode (AA)
' Return the custom ASCII chart index value that matches the active character
Z = 1
FOR X = 1 TO chartSize
  IF AA = aChart(X) THEN
    Z = X
    GOSUB Break
  END IF
NEXT X

Break:
FindCode = Z
END FUNCTION

SUB Help
CLS
LOCATE 1, 33: PRINT "--== Help ==--"
LOCATE 50, 30: PRINT "Press F1 to return";

LOCATE 3, 2: PRINT "[ARROW KEYS] Move the cursor"
LOCATE 5, 2: PRINT "[SPACE] Draw character at cursor"
LOCATE 7, 2: PRINT "[C] Change only color at cursor"
LOCATE 9, 2: PRINT "[1 - 0] and [Q - Y] Select foreground color"
LOCATE 11, 2: PRINT "[-] [=] Select background color by scrolling through them"
LOCATE 13, 2: PRINT "[CTL + L/R ARROW] Scroll the character selection bar"
LOCATE 15, 2: PRINT "[m] Manually set the ASCII character"
LOCATE 17, 2: PRINT "[F8] Insert a sting of text starting at the cursor location"
LOCATE 19, 2: PRINT "[F9] Replace same to what's at cursor with selected char/color"
LOCATE 21, 2: PRINT "[F12] Set selected char/color to match what's at cursor"
LOCATE 23, 2: PRINT "[END] Toggle Draw on Move (snake) mode on/off"

I$ = ""
DO WHILE I$ <> CHR$(0) + CHR$(59)
  I$ = INKEY$
LOOP
DrawScreen
DrawPixel
END SUB

SUB InsertString
' Type some letters from the cursor position.
' Truncates string at the right side of the image.

COLOR 5, 0: LOCATE 50, 1: PRINT STRING$(80, 219);
COLOR 15, 5: LOCATE 50, 1
  PRINT "Enter your line of text here and press ENTER.";
  SLEEP 3
COLOR 5, 0: LOCATE 50, 1: PRINT STRING$(80, 219);
COLOR 15, 5: LOCATE 50, 1: INPUT ; ""; UINP$
COLOR 7, 0: LOCATE 50, 1: PRINT STRING$(80, " ");

' Truncate
UINP$ = LEFT$(UINP$, W - CX + 1)

Z = LEN(UINP$)

' Save the active character
OLDAA = AA

FOR X = 1 TO Z
  AA = ASC(MID$(UINP$, X, 1))
  image(CY, CX + X - 1) = BC * 100000 + AC * 1000 + AA
  COLOR AC, BC: LOCATE CY, CX + X - 1: PRINT CHR$(AA)
NEXT X

' Restore the active character
AA = OLDAA
END SUB

SUB MainLoop
DrawPixel
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
  CASE ELSE
    EXIT SUB
END SELECT

IF CX < 1 THEN CX = 1
IF CX > W THEN CX = W
IF CY < 1 THEN CY = 1
IF CY > H THEN CY = H

' Draw when moving the cursor
' Sets up DrawPixel routine as though user also pressed the space bar
IF DWM THEN I$ = " "

' Drawing the cursor happens next in the DrawPixel routine
END SUB

SUB NameFile
COLOR 5, 0: LOCATE 50, 1: PRINT STRING$(80, 219);
COLOR 15, 5: LOCATE 50, 1: INPUT ; "New File Name:"; f$

f$ = LEFT$(f$, 8)
file$ = UCASE$(f$) + ".IMG"
COLOR 7, 0
DrawScreen
END SUB

SUB SaveFile
COLOR 5, 0: LOCATE 50, 1: PRINT STRING$(80, 219);
COLOR 15, 5: LOCATE 50, 1: INPUT ; "Save file (Y/N):"; A$

IF UCASE$(A$) <> "Y" THEN
  COLOR 7, 0
  EXIT SUB
END IF

ln1$ = ""
ln2$ = ""
ln3$ = ""
OPEN file$ FOR OUTPUT AS #1
  ' First line is the height and width, for human readability.
  WRITE #1, H, W

  FOR Y = 1 TO H
    FOR X = 1 TO W
      ' Each 80 col line = 2.5 lines of data file
      IF X < 33 THEN
        ln1$ = ln1$ + LTRIM$(STR$(image(Y, X)))
        IF X <> 32 THEN
          IF X <> W THEN
            ln1$ = ln1$ + ","
          END IF
        END IF
      ELSEIF X < 65 THEN
        ln2$ = ln2$ + LTRIM$(STR$(image(Y, X)))
        IF X <> 64 THEN
          IF X <> W THEN
            ln2$ = ln2$ + ","
          END IF
        END IF
      ELSE
        ln3$ = ln3$ + LTRIM$(STR$(image(Y, X)))
        IF X <> W THEN ln3$ = ln3$ + ","
      END IF

    NEXT X
    ' Print lines to file
    PRINT #1, ln1$
    IF W > 31 THEN PRINT #1, ln2$
    IF W > 63 THEN PRINT #1, ln3$

    ' Reset for next loop
    ln1$ = ""
    ln2$ = ""
    ln3$ = ""
  NEXT Y
CLOSE #1

' Let user know file was saved
COLOR 5, 0: LOCATE 50, 1: PRINT STRING$(80, 219);
COLOR 15, 5: LOCATE 50, 1: PRINT "File saved!";
SLEEP 2
COLOR 7, 0
LOCATE 50, 1: PRINT STRING$(80, " ");
END SUB

SUB StartSession
'New file or load file
LOCATE 10, 30: PRINT "1. New Image"
LOCATE 11, 30: PRINT "2. Load Image"
LOCATE 14, 30: INPUT A

CLS
IF A = 1 THEN
  ' Set new image size
  LOCATE 10, 30: INPUT ; "Height (4 - 40)"; H
  LOCATE 11, 30: INPUT ; "Width (4 - 80)"; W
  LOCATE 12, 30: INPUT ; "File Name (8 max, no extention)"; f$

  ' Clamp value
  IF H > 32 THEN H = 40
  IF H < 4 THEN H = 4
  IF W > 64 THEN W = 80
  IF W < 4 THEN W = 4

  IF f$ = "" THEN f$ = "TEST"
  f$ = LEFT$(f$, 8)
  f$ = UCASE$(f$)
  file$ = f$ + ".IMG"

  REDIM image(H, W)
  FOR Y = 1 TO H
    FOR X = 1 TO W
        image(Y, X) = 0
    NEXT X
  NEXT Y
ELSEIF A = 2 THEN
  'Load image from file
  LOCATE 14, 25: PRINT "(without file extention)"
  LOCATE 10, 30: INPUT ; "File Name"; f$
  file$ = UCASE$(f$) + ".IMG"

  OPEN file$ FOR INPUT AS #1
  ' Get image size from first two data points
  INPUT #1, D&: H = D&
  INPUT #1, D&: W = D&

  'Load data
  REDIM image(H, W)
  FOR Y = 1 TO H
    FOR X = 1 TO W
        INPUT #1, D&
        image(Y, X) = D&
    NEXT X
  NEXT Y
  CLOSE #1
ELSE
  CLS : StartSession
END IF
END SUB

SUB UpdateActiveColor
ACO = AC
BC0 = BC
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
  CASE IS = "-"
    BC = BC - 1
    IF BC < 0 THEN BC = 7
  CASE IS = "="
    BC = BC + 1
    IF BC > 7 THEN BC = 0
END SELECT

' Only update if changed
IF AC <> ACO OR BC <> BC0 THEN
  DrawActiveColor
  DrawBar (AB)
END IF
END SUB

