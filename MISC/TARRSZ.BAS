' Array Memory Usage Testing
' R. Bassett Jr.
' 2020.11.4
' I use plain text data file to store ASCII art images of up to 80x40
' character for use in Screen Mode 0. Up until now I have left out
' 8 possible background colors, as they don't fit well in a 16 Bit INT
' variable. Storing the data like so,
'
' 31255 = [31][255] = [Color][ASCII Code]
'
' From this testing it seems that the best way to add the background
' color would be to use 32 Bit INT like so,
'
' 731255 = [7][31][255] = [BG Color][FG Color][ASCII Code]

CLS

' Set size of the image
CONST W = 80
CONST H = 50

' Set lenth of STRING array (Max 15 at 80x50)
CONST SL = 6
CONST TESTSTR$ = "731255"

PRINT FRE(-1); "Bytes available for arrays, max 64K each"
PRINT USING " ## x ## image size selected"; H; W
PRINT ""
PRINT "Array Type"; SPC(10); "Mem Used"; SPC(10); "Test Value"
PRINT STRING$(50, 205)

' INTEGER ==============================
' 1D
S = FRE(-1)
DIM i1(X) AS INTEGER
REDIM i1(H * W)

FOR X = 1 TO H * W
  i1(X) = 31255
NEXT X

E = FRE(-1)
PRINT "1D INTEGER"; SPC(12); S - E; SPC(15); "31255"

CLEAR

' 2D
S = FRE(-1)
DIM i2(X, X) AS INTEGER
REDIM i2(H, W)

FOR Y = 1 TO H
 FOR X = 1 TO W
  i2(Y, X) = 31255
 NEXT X
NEXT Y

E = FRE(-1)
PRINT "2D INTEGER"; SPC(12); S - E; SPC(15); "31255"

CLEAR

' LONG ==============================
' 1D
S = FRE(-1)
DIM l1(X) AS LONG
REDIM l1(H * W)

FOR X = 1 TO H * W
  l1(X) = 731255
NEXT X

E = FRE(-1)
PRINT "1D LONG"; SPC(14); S - E; SPC(14); "731255"

CLEAR

' 2D
S = FRE(-1)
DIM l2(X, X) AS LONG
REDIM l2(H, W)

FOR Y = 1 TO H
 FOR X = 1 TO W
  l2(Y, X) = 731255
 NEXT X
NEXT Y

E = FRE(-1)
PRINT "2D LONG"; SPC(14); S - E; SPC(14); "731255"

CLEAR

' STRING  ==============================
' 1D
S = FRE(-1)
DIM s1(X) AS STRING * SL
REDIM s1(H * W)

FOR X = 1 TO H * W
  s1(X) = "731255"
NEXT X

E = FRE(-1)
PRINT USING "1D STRING*#"; SL;
PRINT SPC(10); S - E; SPC(14); TESTSTR$

CLEAR

' 2D
S = FRE(-1)
DIM s2(X, X) AS STRING * SL
REDIM s2(H, W)

FOR Y = 1 TO H
 FOR X = 1 TO W
  s2(Y, X) = "731255"
 NEXT X
NEXT Y

E = FRE(-1)
PRINT USING "2D STRING*#"; SL;
PRINT SPC(10); S - E; SPC(14); TESTSTR$

CLEAR

' SINGLE ==============================
' 1D
S = FRE(-1)
DIM si1(X) AS SINGLE
REDIM si1(H * W)

FOR X = 1 TO H * W
  si1(X) = 1.731255
NEXT X

E = FRE(-1)
PRINT "1D SINGLE"; SPC(12); S - E; SPC(12); "1.731255"

CLEAR

' 2D
S = FRE(-1)
DIM si2(X, X) AS SINGLE
REDIM si2(H, W)

FOR Y = 1 TO H
 FOR X = 1 TO W
  si2(Y, X) = 1.731255
 NEXT X
NEXT Y

E = FRE(-1)
PRINT "2D SINGLE"; SPC(12); S - E; SPC(12); "1.731255"

CLEAR

' DOUBLE ==============================
' 1D
S = FRE(-1)
DIM di1(X) AS DOUBLE
REDIM di1(H * W)

FOR X = 1 TO H * W
  di1(X) = 1.731255
NEXT X

E = FRE(-1)
PRINT "1D DOUBLE"; SPC(12); S - E; SPC(12); "1.731255"

CLEAR

' 2D
S = FRE(-1)
DIM di2(X, X) AS DOUBLE
REDIM di2(H, W)

FOR Y = 1 TO H
 FOR X = 1 TO W
  di2(Y, X) = 1.731255
 NEXT X
NEXT Y

E = FRE(-1)
PRINT "2D DOUBLE"; SPC(12); S - E; SPC(12); "1.731255"

