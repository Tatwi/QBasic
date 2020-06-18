REM ROB BASSETT
REM PRG33

CLS

DO
  DO
  A$ = INKEY$
  LOOP WHILE INKEY$ = ""
  IF A$ = CHR$(13) THEN A$ = A$
  IF A$ >= CHR$(97) AND A$ <= CHR$(122) THEN
   WORD$ = WORD$ + A$
   PRINT A$;
  END IF
LOOP

