DEFINT A-Z
DECLARE SUB LoadSprite (sprite(), file$, H, W)
DECLARE SUB PrintScreen ()
WIDTH 80, 43
' R. Bassett Jr.
' 2020.10.01
' The full screen in this mode is displayed as
' Top Half: Page 0
' Bottom Half: Page 1
' And there is a back buffer for each on Pages 2 and 3.

' Define the arrays used to track what is printed on the screen
DIM SHARED canvas(43, 80)
DIM SHARED colours(43, 80)

' Fill both arrays with some test junk
PRINT "Generating screen data..."
character = 1
FOR R = 1 TO 43
  FOR C = 1 TO 80
    IF R > 26 THEN character = 2
   
    IF R = 26 THEN
      IF C = 48 THEN
        character = 219
      ELSEIF C = 49 THEN
        character = 4
      ELSE
        character = 1
      END IF
    END IF

    canvas(R, C) = character
    colours(R, C) = INT(RND * 15) + 1
  NEXT C
NEXT R

' Test row 26
'FOR x = 1 TO 80
' LOCATE 1, x: COLOR colours(26, x): PRINT CHR$(canvas(26, x))
'NEXT x

PrintScreen

i$ = ""
DO WHILE i$ = ""
  i$ = INKEY$
LOOP

SUB LoadSprite (sprite(), file$, H, W)

OPEN file$ FOR INPUT AS #1
FOR x = 1 TO H
  FOR Y = 1 TO W
    INPUT #1, i
    sprite(Y, x) = i
  NEXT Y
NEXT x
CLOSE #1

END SUB

SUB PrintScreen
'Top of screen
SCREEN 0, , 2, 0
FOR R = 1 TO 26
  FOR C = 1 TO 80
    LOCATE R, C: COLOR colours(R, C): PRINT CHR$(canvas(R, C));
  NEXT C
NEXT R

' Bottom  of screen
SCREEN 0, , 3, 0

' Start printing from col 49 on row 26
FOR x = 49 TO 80
  LOCATE 1, x - 48: COLOR colours(26, x): PRINT CHR$(canvas(26, x));
NEXT x

'FOR x = 1 TO 48
'  LOCATE 1, x: COLOR colours(27, x): PRINT CHR$(canvas(27, x));
'NEXT x

FOR R = 27 TO 43
  FOR C = 1 TO 80
    LOCATE R - 26, C: COLOR colours(R, C): PRINT CHR$(canvas(R, C));
  NEXT C
NEXT R

PCOPY 2, 0
PCOPY 3, 1
END SUB

