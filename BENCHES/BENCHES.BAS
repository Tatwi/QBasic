DECLARE FUNCTION Menu$ ()
DECLARE SUB SaveData ()
DECLARE SUB ShowResults ()
DECLARE SUB Test1 ()
DECLARE SUB Test2 ()
DECLARE SUB Test3 ()
DECLARE SUB Test4 ()
DECLARE SUB Test5 ()
DECLARE SUB Test6 ()
DECLARE SUB Test7 ()
DECLARE SUB Test8 ()
DECLARE SUB Test9 ()
DECLARE SUB Test10 ()
DECLARE SUB Test11 ()
DECLARE SUB Test11 ()
DECLARE SUB Test12 ()
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
CLS

' Results for the 12 tests, in seconds
DIM SHARED resultList(12) AS DOUBLE

' Data
DIM SHARED wurds(10) AS STRING
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

' Show the menu and select a test
choice$ = Menu$

' Run the tests
SELECT CASE choice$
  CASE IS = "Q"
    GOTO TheEnd
  CASE IS = "A"
    ' Run all the tests
    Test1
    Test2
    Test3
    Test4
    Test5
    Test6
    Test7
    Test8
    Test9
    Test10
    Test11
    Test12
  CASE IS = "1"
    '
    Test1
  CASE IS = "2"
    '
    Test2
  CASE IS = "3"
    '
    Test3
  CASE IS = "4"
    '
    Test4
  CASE IS = "5"
    '
    Test5
  CASE IS = "6"
    '
    Test6
  CASE IS = "7"
    '
    Test7
  CASE IS = "8"
    '
    Test8
  CASE IS = "9"
    '
    Test9
  CASE IS = "0"
    '
    Test10
  CASE IS = "-"
    '
    Test11
  CASE IS = "="
    '
    Test12
END SELECT

ShowResults
GOTO TheEnd

TheEnd:
CLS
CLEAR
END

FUNCTION Menu$
LOCATE 2, 26: PRINT "Rob's QBasic 1.1 Benchmarks";
LOCATE 46, 14: PRINT "Use up/down arrows and press ENTER to make a selection";
LOCATE 49, 32: PRINT "Press ESC to exit";

LOCATE 6, 30: PRINT "Run All Tests";
LOCATE 8, 30: PRINT "1. Floating Point Math";
LOCATE 10, 30: PRINT "2. Integer Math";
LOCATE 12, 30: PRINT "3. Math IF/ELSE Logic";
LOCATE 14, 30: PRINT "4. String IF/ELSE Logic";
LOCATE 16, 30: PRINT "5. String Select Case Logic";
LOCATE 18, 30: PRINT "6. Array Sort";
LOCATE 20, 30: PRINT "7. Seq. Print Rate";
LOCATE 22, 30: PRINT "8. Seq. Character Fill Rate";
LOCATE 24, 30: PRINT "9. Rnd. Character Fill Rate";
LOCATE 26, 30: PRINT "10. Rnd. Character FR, Rnd. Color";
LOCATE 28, 30: PRINT "11. Seq. Pixel Fill Rate";
LOCATE 30, 30: PRINT "12. Seq. Pixel Fill Rate, Rnd. Color";

S = 6
PS = 4
I$ = ""
DO WHILE I$ <> "GO!"
  I$ = INKEY$
  IF I$ = CHR$(0) + CHR$(72) THEN
    IF S > 6 THEN
      PS = S
      S = S - 2
    END IF
  ELSEIF I$ = CHR$(0) + CHR$(80) THEN
    IF S < 30 THEN
      PS = S
      S = S + 2
    END IF
  ELSEIF I$ = CHR$(27) THEN
    ' User has chosen to quit
    C$ = "Q"
    I$ = "GO!"
  ELSEIF I$ = CHR$(13) THEN
    I$ = "GO!"
  END IF

  LOCATE PS, 28: COLOR 0: PRINT " ";
  LOCATE S, 28: COLOR 2: PRINT CHR$(175);
LOOP

IF C$ <> "Q" THEN
  ' Set choice based on the line highlighted
  SELECT CASE S
    CASE IS = 6
      C$ = "A"
    CASE IS = 8
      C$ = "1"
    CASE IS = 10
      C$ = "2"
    CASE IS = 12
      C$ = "3"
    CASE IS = 14
      C$ = "4"
    CASE IS = 16
      C$ = "5"
    CASE IS = 18
      C$ = "6"
    CASE IS = 20
      C$ = "7"
    CASE IS = 22
      C$ = "8"
    CASE IS = 24
      C$ = "9"
    CASE IS = 26
      C$ = "0"
    CASE IS = 28
      C$ = "-"
    CASE IS = 30
      C$ = "="
  END SELECT
END IF

CLS
COLOR 7
Menu$ = C$
END FUNCTION

SUB SaveData
END SUB

SUB ShowResults
CLS
SCREEN 0
WIDTH 80, 50
COLOR 7
LOCATE 1, 37: PRINT "Results"
LOCATE 4, 5: PRINT "Test Type", , "Seconds", "Units/Second";
LOCATE 5, 1: PRINT STRING$(80, 205)
LOCATE 6, 1
'PRINT "Seq Print Rate", SP#, INT(4000 / SP#)
'PRINT "Seq Character Rate", SF#, INT(4000 / SF#)
'PRINT "Rnd Character Rate", RF#, INT(4000 / RF#)
'PRINT "Rnd Clr Char Rate", RFC#, INT(4000 / RFC#)
'PRINT "Pixel Fill Rate", resultList(11), INT(76800 / resultList(11))
'PRINT "Pixel FR Rnd Clr", PFC#, INT(76800 / PFC#)
'PRINT "Floating Point Math", FPM#
'PRINT "Integer Math", , IM#
'PRINT "Math if/else Logic", mathIfResult#
'PRINT "String if/else Logic", stringIfResult#
LOCATE 48, 30: PRINT "Press ESC to continue"

DO WHILE INKEY$ <> CHR$(27)
LOOP
END SUB

SUB Test1
PRINT "Testing floating point math..."
Test# = 12000
T# = TIMER
DO WHILE Test# > 0
  Test# = Test# - 1
LOOP
resultList(1) = TIMER - T#
END SUB

SUB Test10
' Random fill rate test
CLS
T# = TIMER
FOR X = 1 TO 4000
  COLOR RND * 15: LOCATE RND * 49 + 1, RND * 79 + 1
  PRINT CHR$(219);
NEXT X
resultList(10) = TIMER - T#
END SUB

SUB Test11
' Sequential pixel fill rate test
SCREEN 7
CLS
T# = TIMER
FOR Y = 1 TO 200
  FOR X = 1 TO 320
    PSET (X, Y), 8
  NEXT X
NEXT Y
resultList(11) = TIMER - T#
END SUB

SUB Test12
' Sequential pixel fill rate test, random color
SCREEN 7
CLS
T# = TIMER
FOR Y = 1 TO 200
  FOR X = 1 TO 320
    PSET (X, Y), RND * 15
  NEXT X
NEXT Y
resultList(12) = TIMER - T#
END SUB

SUB Test2
PRINT "Testing integer math..."
Test = 12000
T# = TIMER
DO WHILE Test > 0
  Test = Test - 1
LOOP
resultList(2) = TIMER - T#
END SUB

SUB Test3
PRINT "Testing math if/else logic..."
Test = 1000
T# = TIMER
DO WHILE Test > 0
  X = RND * 9 + 1
  IF X = 1 THEN
    Test = Test - 1
  ELSEIF X = 2 THEN
    Test = Test - 1
  ELSEIF X = 3 THEN
    Test = Test - 1
  ELSEIF X = 4 THEN
    Test = Test - 1
  ELSEIF X = 5 THEN
    Test = Test - 1
  ELSEIF X = 6 THEN
    Test = Test - 1
  ELSEIF X = 7 THEN
    Test = Test - 1
  ELSEIF X = 8 THEN
    Test = Test - 1
  ELSEIF X = 9 THEN
    Test = Test - 1
  ELSEIF X = 10 THEN
    Test = Test - 1
  END IF
LOOP
resultList(3) = TIMER - T#
END SUB

SUB Test4
PRINT "Testing string if/else logic..."
Test = 1000
T# = TIMER
DO WHILE Test > 0
  wurd$ = wurds$(RND * 9 + 1)
  IF wurd$ = "Smurfs" THEN
    Test = Test - 1
  ELSEIF wurd$ = "Transformers" THEN
    Test = Test - 1
  ELSEIF wurd$ = "Gummi Bears" THEN
    Test = Test - 1
  ELSEIF wurd$ = "Doctor Snuggles" THEN
    Test = Test - 1
  ELSEIF wurd$ = "Muppets" THEN
    Test = Test - 1
  ELSEIF wurd$ = "DuckTales" THEN
    Test = Test - 1
  ELSEIF wurd$ = "GoBots" THEN
    Test = Test - 1
  ELSEIF wurd$ = "GI Joe" THEN
    Test = Test - 1
  ELSEIF wurd$ = "QBasic" THEN
    Test = Test - 1
  ELSEIF wurd$ = "MS-DOS" THEN
    Test = Test - 1
  END IF
LOOP
resultList(4) = TIMER - T#
END SUB

SUB Test5
PRINT "Testing string select case logic..."
Test = 1000
T# = TIMER
DO WHILE Test > 0
  wurd$ = wurds$(RND * 9 + 1)
  IF wurd$ = "Smurfs" THEN
    Test = Test - 1
  ELSEIF wurd$ = "Transformers" THEN
    Test = Test - 1
  ELSEIF wurd$ = "Gummi Bears" THEN
    Test = Test - 1
  ELSEIF wurd$ = "Doctor Snuggles" THEN
    Test = Test - 1
  ELSEIF wurd$ = "Muppets" THEN
    Test = Test - 1
  ELSEIF wurd$ = "DuckTales" THEN
    Test = Test - 1
  ELSEIF wurd$ = "GoBots" THEN
    Test = Test - 1
  ELSEIF wurd$ = "GI Joe" THEN
    Test = Test - 1
  ELSEIF wurd$ = "QBasic" THEN
    Test = Test - 1
  ELSEIF wurd$ = "MS-DOS" THEN
    Test = Test - 1
  END IF
LOOP
resultList(5) = TIMER - T#
END SUB

SUB Test6
' Array sort test
END SUB

SUB Test7
' Sequential print rate test
COLOR 4: LOCATE 1, 1
T# = TIMER
FOR X = 1 TO 4000
  PRINT CHR$(219);
NEXT X
resultList(7) = TIMER - T#
END SUB

SUB Test8
' Sequential fill rate test
CLS
COLOR 2
T# = TIMER
FOR Y = 1 TO 50
  FOR X = 1 TO 80
    LOCATE Y, X: PRINT CHR$(219);
  NEXT X
NEXT Y
resultList(8) = TIMER - T#
END SUB

SUB Test9
' Random character fill rate test
CLS
COLOR 1
T# = TIMER
FOR X = 1 TO 4000
  LOCATE RND * 49 + 1, RND * 79 + 1
  PRINT CHR$(219);
NEXT X
resultList(9) = TIMER - T#
END SUB

