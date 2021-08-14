DECLARE SUB LoadMenu (M$)
' Menu System for Screen 0, 80x50
' R. Bassett Jr.
' 2021.07.26
'
' Menus are stored in plain text data files, organized by number, and placed
' into your choice of subdirectory. MENUS\1.DAT, MENUS\2.DAT, etc.
' Max of 20 entries.
' Create your menu files, copy Menu% function to your program, and call the
' function where you need it. You can draw the other elements on your screen
' first, then add the menu where you want.
'
' Change Selection: Up / Down Arrow Keys
' Confirm Selection: Enter Key
'
' Note: I tested using random access files/records and while some aspects
' were fast, it just overall wasn't as practical (and Git friendly) as using
' plain text files read sequentially. I made this using a solid state drive,
' not a floppy drive from 1982, so drive speed/space wasn't an issue.
DEFINT A-Z
DECLARE FUNCTION Menu% (M$, DS%)
SCREEN 0
WIDTH 80, 50
RANDOMIZE TIMER

' Global Variables
DIM SHARED mEntries(20) AS STRING ' Allows for variable width
DIM SHARED mTitle AS STRING       ' Allows for variable width
TYPE menuConfig
  entries AS INTEGER    ' Number of entries in the menu
  x AS INTEGER          ' Start column
  y AS INTEGER          ' Start row
  sc AS INTEGER         ' Selector color
  tc AS INTEGER         ' Title color
  bc AS INTEGER         ' Border color
  ec AS INTEGER         ' Entries color
  bgc AS INTEGER        ' Background color
  minWidth AS INTEGER   ' Min width of the menu (calculated, not stored)
END TYPE
DIM SHARED mConfig AS menuConfig

' Demo
CLS
M$ = "MENUS\" + STR$(INT(RND * 5) + 1)
S = Menu(M$, 1)
LOCATE 25, 30: PRINT "You selected option"; RTRIM$(STR$(S)); "!"

SUB LoadMenu (M$)
' Load data for this menu from file.
file$ = M$ + ".DAT"
OPEN file$ FOR INPUT AS #1
  INPUT #1, mTitle
  INPUT #1, mConfig.entries
  INPUT #1, mConfig.x
  INPUT #1, mConfig.y
  INPUT #1, mConfig.sc
  INPUT #1, mConfig.tc
  INPUT #1, mConfig.bc
  INPUT #1, mConfig.ec
  INPUT #1, mConfig.bgc
  mConfig.minWidth = LEN(mTitle)
 
  FOR C = 1 TO mConfig.entries
    INPUT #1, mEntries(C)
  
    L = LEN(mEntries(C))
    IF L > mConfig.minWidth THEN mConfig.minWidth = L
  NEXT C
CLOSE #1
END SUB

' (Menu file number, Menu directory, Default selection)
FUNCTION Menu (M$, DS%)
LoadMenu (M$)

userSelected = DS%
prevSelection = 1
updateSelection = -1 ' Booleen TRUE


' Print the border and menu mConfig.entries
' Title border
COLOR mConfig.bc, mConfig.bgc
LOCATE mConfig.y, mConfig.x: PRINT CHR$(213); CHR$(205); CHR$(209); STRING$(mConfig.minWidth, 205); CHR$(184);
LOCATE mConfig.y + 1, mConfig.x: PRINT CHR$(179); CHR$(240); CHR$(179); STRING$(mConfig.minWidth, 32); CHR$(179);
LOCATE mConfig.y + 2, mConfig.x: PRINT CHR$(195); CHR$(196); CHR$(197); STRING$(mConfig.minWidth, 205); CHR$(180)
' Entries
CB = 3
FOR C = 1 TO mConfig.entries
  S = mConfig.minWidth - LEN(mEntries(C))
  LOCATE mConfig.y + 2 * C + 1, mConfig.x
  PRINT CHR$(179); CHR$(32); CHR$(179);
  COLOR mConfig.ec, mConfig.bgc: PRINT mEntries(C);
  COLOR mConfig.bc, mConfig.bgc
  PRINT STRING$(S, 32); CHR$(179)
  LOCATE mConfig.y + 2 * C + 2, mConfig.x:
  PRINT CHR$(195); CHR$(196); CHR$(197); STRING$(mConfig.minWidth, 196); CHR$(180)
  CB = CB + 2
NEXT C
' Redraw bottom row border
LOCATE mConfig.y + mConfig.entries * 2 + 2, mConfig.x
PRINT CHR$(192); CHR$(196); CHR$(193); STRING$(mConfig.minWidth, 196); CHR$(217);

' Center and print title text
D = mConfig.minWidth - LEN(mTitle)
S = 0
IF D > 1 THEN S = D / 2
LOCATE mConfig.y + 1, mConfig.x + 3 + S
COLOR mConfig.tc, mConfig.bgc
PRINT mTitle

' DEBUG INFO
LOCATE 49, 3: PRINT "Free Memory:"; FRE(0); "  Array:"; FRE(-1); "   Stack:"; FRE(-2);

' Handle user input
COLOR mConfig.sc
I$ = ""
DO WHILE I$ <> "GO!"
  I$ = INKEY$

  SELECT CASE I$
    CASE IS = CHR$(13)
      ' Enter key
      I$ = "GO!"
    CASE IS = CHR$(0) + CHR$(72)
      ' Up arrow
      IF userSelected > 1 THEN
        prevSelection = userSelected
        userSelected = userSelected - 1
        updateSelection = -1
      END IF
    CASE IS = CHR$(0) + CHR$(80)
      ' Down arrow
      IF userSelected < mConfig.entries THEN
        prevSelection = userSelected
        userSelected = userSelected + 1
        updateSelection = -1
      END IF
  END SELECT

  IF updateSelection THEN
    updateSelection = 0
    LOCATE mConfig.y + 2 * prevSelection + 1, mConfig.x + 1: PRINT CHR$(32)
    LOCATE mConfig.y + 2 * userSelected + 1, mConfig.x + 1: PRINT CHR$(175)
  END IF
LOOP

COLOR 7, 0
CLS
Menu = userSelected
END FUNCTION

SUB MenuAdd (M$, S$)
END SUB

SUB MenuChange (M$, E%, S$)

END SUB

SUB MenuRemove (M$, E%)
END SUB

