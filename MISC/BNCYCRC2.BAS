DEFINT A-Z
SCREEN 7, , 1, 0

CLS
COLOR 6
LOCATE 1, 30: PRINT "Press q to quit..."

COLOR 3
DO WHILE INKEY$ <> "q"

FOR x = 1 TO 300
  CLS
  PCOPY 1, 2 'Help message
  SCREEN 7, , 2, 0
  CIRCLE (x + 2, 100 + SIN(x / 10) * 14), 10, 10
  PCOPY 2, 0 'Display image on the screen
NEXT x
LOOP

