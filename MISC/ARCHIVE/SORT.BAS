CLS

GOSUB INSTUFF
GOSUB SORT
GOSUB DISPLAY
END

INSTUFF:
  DO
    C = C + 1
    INPUT "ENTER SOMETHING"; N$(C)
    IF N$(C) = "XXX" THEN EXIT DO
  LOOP
  C = C - 1
RETURN

SORT:
  FOR Y = 1 TO C - 1
     F = 0
     FOR X = 1 TO C - Y
        IF N$(X) > N$(X + 1) THEN
           T$ = N$(X): N$(X) = N$(X + 1): N$(X + 1) = T$
        END IF
        F = 1
     NEXT X
  NEXT Y
RETURN

DISPLAY:
  FOR X = 1 TO C
     PRINT N$(X)
  NEXT X
  PRINT
RETURN

