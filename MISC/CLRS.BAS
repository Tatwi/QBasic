CLS
box$ = STRING$(3, CHR$(219))
PRINT ""
FOR X = 0 TO 15
  READ name$
  COLOR 7
  IF X < 10 THEN PRINT " ";
  PRINT X; " ";
  COLOR X
  PRINT box$; " ";
  COLOR 7
  PRINT " "; name$
NEXT

DATA "Black", "Blue", "Green", "Cyan", "Red", "Magenta/Purple", Brown/Orange"
DATA "Light Grey (White)", "Grey", "Light Blue", "Light Green", "Light Cyan"
DATA "Light Red", "Light Magenta/Purple", "Yellow", "White (Bright White)"

