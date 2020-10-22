' R. Bassett Jr.
' 2020.10.20
' Testing the character fill rate of at 80x50
'
' DOSBox 0.74-3 at 5000 (Approx 386DX 33MHz):
' Looks fairly busy with about 414 characters per second.
' 965 Ch/s when commenting out the color and locate lines
' 502 CH/s when commenting out just the color line
'
' DOS 7 (Custom Win98 boot disk), Real Pentium 233MMX:
' 5782 Ch/s which looks super active!
' 8950 Ch/s when commenting out the color and locate lines
' 6758 CH/s when commenting out just the color line
'
' I had to put DOSBox up to 70,224 cycles to match the fill
' rate of the real Pentium system. My host system for DOSBox
' was an AMD FX-8320 locked at 4GHz (Turbo and APM disabled)
' running in Windows 10 Home Version 2004.
' 
' PCem Testing (same host PC as DOSBox):
' Using DOS 6.22 and 32MB RAM
' 386DX 33Mhz: 458 Ch/s
' 486DX/2 66Mhz: 1707 Ch/s
' Pentium 75Mhz: 3740 Ch/s
' Pentium 166MHz: 8244 Ch/s
' Pentium 233MMX: 11714 Ch/s
'
' Clearly something is strange with the PCem emulation of
' Pentium 233MMX, because it was twice as fast the real CPU 
' in my Compaq Deskpro 4000 desktop. Even the emulated P166 
' was faster than the real P233, so that's an interesting
' inaccuracy! However, I think the PCem results forthe 386 
' and 486 look right, as they are close the DOSBox results. 
' Sadly I don't have functional 386 and 486 PCs to confirm.
'
' DOSBox 0.74-2, Intel Celeron N3450 1.1-2.1GHz:
' 415 Ch/s, Confirming that DOSBox running on my much less
' powerful Chromebook-style computer runs this program the
' same as on my desktop. Even on battery power, which sure
' beats 165W for my desktop and 92W for the old Deskpro!
' Hence my preference for using QBasic on my laptop. 

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

