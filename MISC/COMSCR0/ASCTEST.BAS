' Development of the ASCII character scrollbar for IMGMAKER.BAS
' R. Bassett Jr.
' 2020.10.29
 
DEFINT A-Z
SCREEN 0: WIDTH 80, 50
CLS

chartSize = 244
DIM aChart(1 TO chartSize) AS LONG

OPEN "ASCII.CSV" FOR INPUT AS #1
  FOR X = 1 TO chartSize
    INPUT #1, aChart(X)
  NEXT X
CLOSE #1

FOR X = 1 TO chartSize
  PRINT aChart(X); ",";
NEXT X

Start = 16
AC = 4
GOSUB PrintBorder
GOSUB UpdateBar

I$ = INKEY$
DO WHILE I$ <> CHR$(27)
  I$ = INKEY$
  IF I$ = "," THEN
    Start = Start - 1
    IF Start < 1 THEN Start = chartSize
    GOSUB UpdateBar
  ELSEIF I$ = "." THEN
    Start = Start + 1
    IF Start > chartSize THEN Start = 1
    GOSUB UpdateBar
  END IF
LOOP
END

UpdateBar:
LOCATE 35, 1: PRINT "Start: "; Start; "   "
PRINT "Start ASCII#: "; aChart(Start); "    "
LOCATE 42, 2: PRINT STRING$(78, " ")
LOUT$ = ""
ROUT$ = ""

' Before (left side)
Z = 19
FOR X = 1 TO 19
  TP = Start - Z
  IF TP = 0 THEN TP = chartSize
  IF TP < 0 THEN TP = chartSize - ABS(TP)

  LOUT$ = LOUT$ + CHR$(aChart(TP)) + " "

  Z = Z - 1
NEXT X

' After (right side)
FOR X = 1 TO 16
  TP = Start + X
  IF TP < 1 THEN TP = chartSize + 1 - X
  IF TP > chartSize THEN TP = TP - chartSize

  ROUT$ = ROUT$ + CHR$(aChart(TP)) + " "
NEXT X

' Print results
LOCATE 42, 3: PRINT LOUT$;
LOCATE 42, 41:
  PRINT CHR$(179); " ";
  COLOR AC
  PRINT CHR$(aChart(Start));
  COLOR 7
  PRINT " "; CHR$(179);
LOCATE 42, 47: PRINT ROUT$;
RETURN


PrintBorder:
' ASCII choice bar borders
COLOR 7:
LOCATE 41, 1
  PRINT CHR$(201);
  PRINT STRING$(39, CHR$(205));
  PRINT CHR$(209); STRING$(3, CHR$(205)); ; CHR$(209);
  PRINT STRING$(34, CHR$(205));
  PRINT CHR$(187);
LOCATE 43, 1
  PRINT CHR$(200);
  PRINT STRING$(39, CHR$(205));
  PRINT CHR$(207); STRING$(3, CHR$(205)); ; CHR$(207);
  PRINT STRING$(34, CHR$(205));
  PRINT CHR$(188);
' Arrows
COLOR 0, 7
LOCATE 42, 1: PRINT "<";
LOCATE 42, 80: PRINT ">";
COLOR 7, 0
RETURN

