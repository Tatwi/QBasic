REM ROB BASSETT
REM FOQ2//EXAM SCHEDULE

T$ = "\ \      \   \         \     \         \  \"
D$ = " #   \         \      \        \        ###"

CLS
GOSUB ENTER
GOSUB PRINTDATA
GOSUB PRINTTOPRINTER
END

ENTER:
  CLS
 
    NR = NR + 1
    INPUT "ENTER NAME"; N$
    PRINT
    FOR X = 1 TO 4
       COLOR 14: PRINT "PERIOD "; X: COLOR 7
       INPUT "ENTER COURSE CODE ", CD$(X)
       INPUT "ENTER CLASS ROOM ", RN(X)
       PRINT
   NEXT
CD1$(X) = CD$(X): RN1(X) = RN(X)
RETURN

PRINTDATA:
  CLS
  PRINT TAB(20); "ENSS": PRINT
  PRINT TAB(5); N$, "EXAM SCHEDULE": PRINT
  PRINT USING T$; "DAY"; "DATE"; "COURSE"; "ROOM"
  FOR X = 1 TO 4
     READ DA$
     PRINT USING D$; X; DA$; CD$(X); RN(X)
 NEXT X
DATA FRI. MAY 17, MON. MAY 20, TUE. MAY 21, WED. MAY 22
 PRINT
 PRINT "PRESS ANY KEY TO CONTINUE"
 DO
 LOOP WHILE INKEY$ = ""
RETURN

PRINTTOPRINTER:
  CD$(X) = CD1$(X): RN(X) = RN1(X)
  LOCATE 15, 20: COLOR 13: PRINT "PRINTING TO PRINTER": COLOR 7
  OPEN "LPT1" FOR OUTPUT AS #1
        PRINT #1, CHR$(27) + "W" + CHR$(1)
   PRINT #1, TAB(10); "ENSS": PRINT #1,
        PRINT #1, CHR$(27) + "W" + CHR$(0)
        PRINT #1, CHR$(27) + "E"
   PRINT #1, TAB(5); N$, "EXAM SCHEDULE": PRINT #1,
        PRINT #1, CHR$(27) + "F"
        PRINT #1, CHR$(27) + "-" + CHR$(1)
   PRINT #1, USING T$; "DAY"; "DATE"; "COURSE"; "ROOM"
        PRINT #1, CHR$(27) + "-" + CHR$(0)
   FOR X = 1 TO 4
      READ DA$
      PRINT #1, USING D$; X; DA$; CD$(X); RN(X)
   NEXT X
DATA FRI. MAY 17, MON. MAY 20, TUE. MAY 21, WED. MAY 22
CLOSE #1
RETURN

