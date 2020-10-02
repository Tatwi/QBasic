DEFINT A-Z
' R. Bassett Jr.
' 2020.10.01
' Testing storing color and ascii character values in a single variable.

GOSUB Roll
i$ = ""
DO WHILE i$ <> CHR$(27)
  i$ = INKEY$
  IF i$ = CHR$(32) THEN GOSUB Roll
LOOP
END

Roll:
CLS
PRINT " Press SPACE for a new roll, ESC to exit.": PRINT ""

x = (INT(RND * 31) * 1000) + INT(RND * 255)
c = x / 1000
a = x - c * 1000

PRINT "Variable: ", x
PRINT "Color: ", c
PRINT "ASCII Code: ", a
RETURN

