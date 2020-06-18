SCREEN 12
CLS
LOCATE 3, 30: PRINT "Press q to quit..."
DO WHILE INKEY$ <> "q"
FOR x = 1 TO 100
  COLOR 3
  CIRCLE (x * 8, x * TAN(SIN(x * 3) ^ 2) + 240), 50, 12
  IF x > 1 THEN
    CIRCLE ((x - 1) * 8, (x - 1) * TAN(SIN((x - 1) * 3) ^ 2) + 240), 50, 0
  END IF
NEXT x
LOOP

