' Development of the ASCII character scrollbar for IMGMAKER.BAS
' R. Bassett Jr.
' 2020.10.29
 
DEFINT A-Z
SCREEN 0: WIDTH 80, 50
CLS

DIM aChart(1 TO 245) AS LONG

OPEN "ASCII.CSV" FOR INPUT AS #1
  FOR X = 1 TO 245
    INPUT #1, aChart(X)
  NEXT X
CLOSE #1

FOR X = 1 TO 245
  PRINT aChart(X); ",";
NEXT X

Start = 4
AC = 4
GOSUB PrintBorder
GOSUB UpdateBar

I$ = INKEY$
DO WHILE I$ <> CHR$(27)
  I$ = INKEY$
  IF I$ = "," THEN
    Start = Start - 1
    IF Start < 1 THEN Start = 245
    GOSUB UpdateBar
  ELSEIF I$ = "." THEN
    Start = Start + 1
    IF Start > 245 THEN Start = 1
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

IF Start < 20 THEN
  LOCATE 50, 40: PRINT "IF START < 19 ";
  ' Close to the start

  R = Start - 19
  FOR X = 245 + R TO 245
    ' #s that would be less than 0
    LOUT$ = LOUT$ + CHR$(aChart(X)) + " "
  NEXT X

  FOR X = 1 TO 19 + R - 1
   ' #s between 1 and one before Start
   LOUT$ = LOUT$ + CHR$(aChart(X)) + " "
  NEXT X

  FOR X = Start + 1 TO Start + 16
    ' 15 # to the right of Start
    ROUT$ = ROUT$ + CHR$(aChart(X)) + " "
  NEXT X
ELSEIF Start > 226 THEN
  LOCATE 50, 40: PRINT "IF START > 226";
  ' Close to the end

  FOR X = Start - 19 TO Start
    ' Before the starting point
    LOUT$ = LOUT$ + CHR$(aChart(X)) + " "
  NEXT X

  FOR X = Start + 1 TO 245
    ' Right side upto 245
    ROUT$ = ROUT$ + CHR$(aChart(X)) + " "
  NEXT X

  ' How many digits beyond 245?
  B = 245 - Start
  LOCATE 50, 1: PRINT B;

  FOR X = 1 TO 16 - B
    ' Right side beyond 245
    ROUT$ = ROUT$ + CHR$(aChart(X)) + " "
  NEXT X
ELSE
  LOCATE 50, 40: PRINT "ELSE CLAUSE       ";
  ' Far enough in the middle

  FOR X = Start - 19 TO Start
    ' Before the starting point
    LOUT$ = LOUT$ + CHR$(aChart(X)) + " "
  NEXT X

  FOR X = Start + 1 TO Start + 16
    ' Before the starting point
    ROUT$ = ROUT$ + CHR$(aChart(X)) + " "
  NEXT X


END IF

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

