DEFINT A-Z
SCREEN 7
FOR Y = 1 TO 200
  FOR X = 1 TO 320
    IF INKEY$ = CHR$(27) THEN GOTO Bail
    RANDOMIZE TIMER
    C = INT(RND * 15) + 1
    PSET (X, Y), C
  NEXT X
NEXT Y

Bail:
END

