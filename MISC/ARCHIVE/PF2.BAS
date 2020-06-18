REM ROB BASSETT
REM PF2 \\ PRINT FORMAT QUESTION TWO

CLS
DIM MO$(12)
PF$ = "####          \ \       $$###.##        $$#####.##"

GOSUB MONTHS
GOSUB PRINTTOPRINTER
END

ENTER:
  CLS
    INPUT "ENTER YEAR"; Y
    INPUT "ENTER BEGING MONTH\\(NUMBER 0-12)\\0=JAN\\"; M
    INPUT "BEGINING BALANCE"; BB
    INPUT "INTREST RATE"; R
    INPUT "ENTER NUMBER OF MONTHS"; NM
  Y1 = Y
  M1 = M
  BB1 = BB
  R1 = R
  NM1 = NM
RETURN


PAUSE:
  PRINT : PRINT "PRESS ANY KEY TO CONTINUE"
  DO
  LOOP WHILE INKEY$ = ""
RETURN

PRINTDATA:
  CLS
  PRINT "YEAR         MONTH    ITNEREST EARNED    BALANCE"
  FOR X = M TO NM
     M = M + 1
     IF M > 12 THEN
      M = 1
      Y = Y + 1
     END IF
     IE = BB * R / 12
     BB = BB + IE
     NR = NR + 1
     PRINT USING PF$; Y; MO$(M); IE; BB
 
  NEXT X
   GOSUB PAUSE
RETURN


MONTHS:
  FOR X = 1 TO 12
     READ MO$(X)
  NEXT X
  DATA JAN, FEB, MAR, APR, MAY, JUN, JUL, AUG, SEP, OCT, NOV, DEC
 
  GOSUB ENTER
  GOSUB PRINTDATA
RETURN

PRINTTOPRINTER:
  Y = Y1: M = M1: BB = BB1: R = R1: NM = NM1
  LOCATE 20, 22: COLOR 13: PRINT "PRINTING TO PRINTER"
  OPEN "LPT1" FOR OUTPUT AS #1
  PRINT #1, "YEAR         MONTH    INTREST EARNED    BALANCE"
  FOR X = 1 TO NR
    
     M = M + 1
     IF M > 12 THEN
      M = 1
      Y = Y + 1
     END IF
     IE = BB * R / 12
     BB = BB + IE
     
     PRINT #1, USING PF$; Y; MO$(M); IE; BB
  NEXT X
  CLOSE #1
  SLEEP 10: COLOR 7
RETURN

