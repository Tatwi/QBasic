' My QBasic 1.1 Benchmark Program
' R. Bassett Jr.
' 2021.06.29
' This is a series of tasks that simulate the usage of various common aspects
' of QBasic 1.1. The time it takes for each test to complete is recorded in
' seconds, allowing one to compare the performance of the test on different
' computer systems. My primary objective when creating this tool was to use
' it to tune DOSBox so that it runs QBasic similarly to a real 386DX 33MHz to
' 486SX 25MHz computer.

DEFINT A-Z
SCREEN 0
WIDTH 80, 50
RANDOMIZE TIMER
TIMER ON

' Data
DIM wurdswurd(10) AS STRING
wurds$(1) = "Smurfs"
wurds$(2) = "Transformers"
wurds$(3) = "Gummi Bears"
wurds$(4) = "Doctor Snuggles"
wurds$(5) = "Muppets"
wurds$(6) = "DuckTales"
wurds$(7) = "GoBots"
wurds$(8) = "GI Joe"
wurds$(9) = "QBasic"
wurds$(10) = "MS-DOS"

' Result variables, in seconds
SP# = 1   ' Sequential print rate
SF# = 1   ' Sequential character fill rate
RF# = 1   ' Random character fill rate
RFC# = 1  ' Rnd. char. fill rate with random colors
PF# = 1   ' Sequential pixel fill rate
PFC# = 1  ' Seq. pixel fill rate with random colors
FPM# = 1  ' Floating point math
IM# = 1   ' Integer math
mathIfResult# = 1   ' Math based if/else logic
stringIfResult# = 1   ' String based if/else logic


' Sequential print rate test
COLOR 4: LOCATE 1, 1
T# = TIMER
FOR X = 1 TO 4000
  PRINT CHR$(219);
NEXT X
SP# = TIMER - T#

' Sequential fill rate test
CLS
COLOR 2
T# = TIMER
FOR Y = 1 TO 50
  FOR X = 1 TO 80
    LOCATE Y, X: PRINT CHR$(219);
  NEXT X
NEXT Y
SF# = TIMER - T#

' Random fill rate test
CLS
COLOR 1
T# = TIMER
FOR X = 1 TO 4000
  LOCATE RND * 49 + 1, RND * 79 + 1
  PRINT CHR$(219);
NEXT X
RF# = TIMER - T#

' Random fill rate test
CLS
T# = TIMER
FOR X = 1 TO 4000
  COLOR RND * 15: LOCATE RND * 49 + 1, RND * 79 + 1
  PRINT CHR$(219);
NEXT X
RFC# = TIMER - T#

' Pixel fill rate test
SCREEN 7
CLS
T# = TIMER
FOR Y = 1 TO 200
  FOR X = 1 TO 320
    PSET (X, Y), 8
  NEXT X
NEXT Y
PF# = TIMER - T#

' Pixel fill rate test, random color
SCREEN 7
CLS
T# = TIMER
FOR Y = 1 TO 200
  FOR X = 1 TO 320
    PSET (X, Y), RND * 15
  NEXT X
NEXT Y
PFC# = TIMER - T#


' Math tests and logic tests
SCREEN 0
WIDTH 80, 50
CLS
LOCATE 1, 1

PRINT "Testing floating point math..."
TEST# = 12000
T# = TIMER
DO WHILE TEST# > 0
  TEST# = TEST# - 1
LOOP
FPM# = TIMER - T#

PRINT "Testing integer math..."
TEST = 12000
T# = TIMER
DO WHILE TEST > 0
  TEST = TEST - 1
LOOP
IM# = TIMER - T#

PRINT "Testing math if/else logic..."
TEST = 1000
T# = TIMER
DO WHILE TEST > 0
  X = RND * 9 + 1
  IF X = 1 THEN
    TEST = TEST - 1
  ELSEIF X = 2 THEN
    TEST = TEST - 1
  ELSEIF X = 3 THEN
    TEST = TEST - 1
  ELSEIF X = 4 THEN
    TEST = TEST - 1
  ELSEIF X = 5 THEN
    TEST = TEST - 1
  ELSEIF X = 6 THEN
    TEST = TEST - 1
  ELSEIF X = 7 THEN
    TEST = TEST - 1
  ELSEIF X = 8 THEN
    TEST = TEST - 1
  ELSEIF X = 9 THEN
    TEST = TEST - 1
  ELSEIF X = 10 THEN
    TEST = TEST - 1
  END IF
LOOP
mathIfResult# = TIMER - T#

PRINT "Testing string if/else logic..."
TEST = 1000
T# = TIMER
DO WHILE TEST > 0
  wurd$ = wurds$(RND * 9 + 1)
  IF wurd$ = "Smurfs" THEN
    TEST = TEST - 1
  ELSEIF wurd$ = "Transformers" THEN
    TEST = TEST - 1
  ELSEIF wurd$ = "Gummi Bears" THEN
    TEST = TEST - 1
  ELSEIF wurd$ = "Doctor Snuggles" THEN
    TEST = TEST - 1
  ELSEIF wurd$ = "Muppets" THEN
    TEST = TEST - 1
  ELSEIF wurd$ = "DuckTales" THEN
    TEST = TEST - 1
  ELSEIF wurd$ = "GoBots" THEN
    TEST = TEST - 1
  ELSEIF wurd$ = "GI Joe" THEN
    TEST = TEST - 1
  ELSEIF wurd$ = "QBasic" THEN
    TEST = TEST - 1
  ELSEIF wurd$ = "MS-DOS" THEN
    TEST = TEST - 1
  END IF
LOOP
stringIfResult# = TIMER - T#


' Print Results
CLS
COLOR 7
LOCATE 1, 37: PRINT "Results"
LOCATE 4, 5: PRINT "Test Type", , "Seconds", "Units/Second";
LOCATE 5, 1: PRINT STRING$(80, 205)
LOCATE 6, 1
PRINT "Seq Print Rate", SP#, INT(4000 / SP#)
PRINT "Seq Character Rate", SF#, INT(4000 / SF#)
PRINT "Rnd Character Rate", RF#, INT(4000 / RF#)
PRINT "Rnd Clr Char Rate", RFC#, INT(4000 / RFC#)
PRINT "Pixel Fill Rate", PF#, INT(76800 / PF#)
PRINT "Pixel FR Rnd Clr", PFC#, INT(76800 / PFC#)
PRINT "Floating Point Math", FPM#
PRINT "Integer Math", , IM#
PRINT "Math if/else Logic", mathIfResult#
PRINT "String if/else Logic", stringIfResult#

SUB Menu
END SUB

SUB SaveData
END SUB

SUB ShowResults
END SUB

SUB Test1
END SUB

SUB Test10
END SUB

SUB Test2
END SUB

SUB Test3
END SUB

SUB Test4
END SUB

SUB Test5
END SUB

SUB Test6
END SUB

SUB Test7
END SUB

SUB Test8
END SUB

SUB Test9
END SUB

