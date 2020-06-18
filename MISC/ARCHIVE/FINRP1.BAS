CLS

GOSUB INSTUFF
GOSUB SORT
GOSUB DISPLAY
END

INSTUFF:
  DO
    c = c + 1
    INPUT "ENTER SOMETHING"; n$(c)
    IF n$(c) = "XXX" THEN EXIT DO
    IF n$(c) = "xxx" THEN EXIT DO
  LOOP
  c = c - 1
RETURN

SORT:
  FOR Y = 1 TO c - 1
     F = 0
     FOR X = 1 TO c - Y
        IF n$(X) > n$(X + 1) THEN
           T$ = n$(X): n$(X) = n$(X + 1): n$(X + 1) = T$
        END IF
        F = 1
     NEXT X
  NEXT Y
RETURN

DISPLAY:
  FOR X = 1 TO c
     PRINT n$(X)
  NEXT X
  PRINT
RETURN

