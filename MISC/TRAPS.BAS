' Using the ON KEY function to trap user input
' R. Bassett Jr.
' 2020.11.11
'
' WARNING DOSBox USERS!!
' I noticed in testing that holding the CTL key while holding random arrow
' keys will put the DOSBox session into a strange state where the keyboard
' doesn't work properly. Closing and running DOSBox again fixes the issue.


DIM UPDATE AS INTEGER: UPDATE = -1
DIM X AS INTEGER: X = 1
DIM Y AS INTEGER: Y = 1
DIM UI AS STRING
DIM N AS INTEGER
DIM H AS INTEGER
DIM W AS INTEGER

' Numpad arrow keys 8 2 4 6
ON KEY(11) GOSUB UpMove: KEY(11) ON
ON KEY(12) GOSUB LeftMove: KEY(12) ON
ON KEY(13) GOSUB RightMove: KEY(13) ON
ON KEY(14) GOSUB DownMove: KEY(14) ON

' Other arrow keys must be defined in custom key space 15-25
' And the Num Lock state must be off for them to register in this manner
KEY 15, CHR$(128) + CHR$(72)
  ON KEY(15) GOSUB UpMove: KEY(15) ON
KEY 16, CHR$(128) + CHR$(80) ' Down
  ON KEY(16) GOSUB DownMove: KEY(16) ON
KEY 17, CHR$(128) + CHR$(75) ' Left
  ON KEY(17) GOSUB LeftMove: KEY(17) ON
KEY 18, CHR$(128) + CHR$(77) ' Right
  ON KEY(18) GOSUB RightMove: KEY(18) ON

SCREEN 0

CLS

PRINT "On Key Input Tester"
PRINT ""
PRINT "Num Lock ON: Use numpad arrow keys"
PRINT "Num Lock OFF: Use either arrow key sets"
PRINT ""
PRINT "Choose a screen mode:"
PRINT "1. 40x25"
PRINT "2. 40x43"
PRINT "3. 40x50"
PRINT "4. 80x25"
PRINT "5. 80x43"
PRINT "6. 80x50"
INPUT UI

N = VAL(UI) ' So user can enter anything crashing the program...

SELECT CASE N
  CASE IS = 1
    W = 40: H = 25
  CASE IS = 2
    W = 40: H = 43
  CASE IS = 3
    W = 40: H = 50
  CASE IS = 4
    W = 80: H = 25
  CASE IS = 5
    W = 80: H = 43
  CASE IS = 6
    W = 80: H = 50
  CASE ELSE
   W = 40: H = 25
END SELECT

WIDTH W, H

RANDOMIZE TIMER

CLS
LOCATE H, W - 5: PRINT USING "##x##"; W; H

WHILE INKEY$ <> CHR$(27)
  IF UPDATE THEN
    UPDATE = 0
    LOCATE H, 2: PRINT "Location:"; X; Y;
    COLOR INT(RND * 14) + 1
    LOCATE Y, X: PRINT CHR$(2);
    COLOR 7
  END IF
WEND
END

UpMove:
  IF Y = 1 THEN RETURN

  Y = Y - 1
  UPDATE = -1
RETURN

LeftMove:
  IF X = 1 THEN RETURN
  X = X - 1
  UPDATE = -1
RETURN

RightMove:
  IF X = W THEN RETURN

  X = X + 1
  UPDATE = -1
RETURN

DownMove:
  IF Y = H - 1 THEN RETURN

  Y = Y + 1
  UPDATE = -1
RETURN

