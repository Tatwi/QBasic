
SORT:
  CLS
  PRINT "ONE MOMENT PLEASE.    SORTING"
  FOR Y = 1 TO NR - 1
     F = 0
     FOR X = 1 TO NR - Y
        IF N$(X) > N$(X + 1) THEN
          SWAP N$(X), N$(X + 1)
          F = 1
        END IF
     NEXT X
     IF F = 0 THEN EXIT FOR
  NEXT Y
F = 0
RETURN

