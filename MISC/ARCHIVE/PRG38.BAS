REM ROB BASSETT
REM PRG38

CLS

COLOR (10)

INPUT "ENTER A PRICE"; M:
M = INT(M * 100 + .5) / 100
M$ = STR$(M)
L = LEN(M$)

IF MID$(M$, L - 1, 1) = "." THEN
 M$ = M$ + "0"
 L = LEN(M$)
END IF

IF L = 2 THEN
 M$ = M$ + ".00"
 L = LEN(M$)
END IF

IF MID$(M$, L - 2, 1) <> "." THEN
 M$ = M$ + ".00"
 L = LEN(M$)
END IF
COLOR (14)
PRINT M$



