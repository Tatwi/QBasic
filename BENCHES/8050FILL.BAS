' Testing the character fill rate of at 80x50
'
' DOSBox 0.74-3 at 5000 (Approx 386DX 33MHz):
' Looks fairly busy with about 414 characters per second.
' 965 Ch/s when commenting out the color and locate lines
' 502 CH/s when commenting out just the color line
'
' DOS 7, Pentium 233MMX:
' 5782 Ch/s which looks super active!
' 8950 Ch/s when commenting out the color and locate lines
' 6758 CH/s when commenting out just the color line
'
' I had to put DOSBox up to 70,224 cycles to match the fill
' rate of the real Pentium system. My host system for DOSBox
' was an AMD FX-8320 locked at 4GHz (Turbo and APM disabled)
' running in Windows 10 Home Version 2004.

DEFINT A-Z
SCREEN 0
WIDTH 80, 50
CLS
RANDOMIZE TIMER
TIMER ON
T# = TIMER

P = 0

DO WHILE INKEY$ <> CHR$(27)
  COLOR INT(RND * 15)
  LOCATE INT(RND * 49) + 1, INT(RND * 80) + 1
  PRINT CHR$(219);
 
  P = P + 1
  NOW# = TIMER

  IF NOW# - T# > 1 THEN
    COLOR 7
    LOCATE 50, 1: PRINT "Ch/S:"; P;
    P = 0
    T# = TIMER
  END IF
LOOP

