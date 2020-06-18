
READDATA:
  DO
    NR = NR + 1
    READ N$(NR)
    IF N$(NR) = "XXX" THEN EXIT DO
  LOOP
  NR = NR - 1

  DATA SAM,BOB,JANE,MARY,FRED
RETURN



