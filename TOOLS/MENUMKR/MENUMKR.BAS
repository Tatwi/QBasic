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

DEFINT A-Z
DECLARE FUNCTION Menu% (M%, DIR$, DS%)
SCREEN 0
WIDTH 80, 50
CLS

' Demo
RANDOMIZE TIMER
P = INT(RND * 5) + 1
S = Menu(P, "MENUS\", 1)
LOCATE 25, 30: PRINT "You selected option"; RTRIM$(STR$(S)); "!"

' (Menu file number, Menu directory, Default selection)
FUNCTION Menu (M%, DIR$, DS%)
name$ = ""
entries = 1
startX = 1
startY = 1
tntSelect = 2
tntTitle = 7
tntBorder = 7
tntEntries = 7
tntBg = 0
minWidth = 8
userSelected = DS%
prevSelection = 1
updateSelection = -1 ' Booleen TRUE

' Load data for this menu from file.
file$ = DIR$ + STR$(M%) + ".DAT"
OPEN file$ FOR INPUT AS #1
  INPUT #1, name$
  INPUT #1, entries
  INPUT #1, startX
  INPUT #1, startY
  INPUT #1, tntSelect
  INPUT #1, tntTitle
  INPUT #1, tntBorder
  INPUT #1, tntEntries
  INPUT #1, tntBg
  minWidth = LEN(name$)
  DIM entryNames(entries) AS STRING

  FOR C = 1 TO entries
    INPUT #1, entryNames(C)
   
    L = LEN(entryNames(C))
    IF L > minWidth THEN minWidth = L
  NEXT C
CLOSE #1

' Print the border and menu entries
' Title border
COLOR tntBorder, tntBg
LOCATE startY, startX: PRINT CHR$(213); CHR$(205); CHR$(209); STRING$(minWidth, 205); CHR$(184);
LOCATE startY + 1, startX: PRINT CHR$(179); CHR$(240); CHR$(179); STRING$(minWidth, 32); CHR$(179);
LOCATE startY + 2, startX: PRINT CHR$(195); CHR$(196); CHR$(197); STRING$(minWidth, 205); CHR$(180)
' Entries
CB = 3
FOR C = 1 TO entries
  S = minWidth - LEN(entryNames(C))
  LOCATE startY + 2 * C + 1, startX
  PRINT CHR$(179); CHR$(32); CHR$(179);
  COLOR tntEntries, tntBg: PRINT entryNames(C);
  COLOR tntBorder, tntBg
  PRINT STRING$(S, 32); CHR$(179)
  LOCATE startY + 2 * C + 2, startX:
  PRINT CHR$(195); CHR$(196); CHR$(197); STRING$(minWidth, 196); CHR$(180)
  CB = CB + 2
NEXT C
' Redraw bottom row border
LOCATE startY + entries * 2 + 2, startX
PRINT CHR$(192); CHR$(196); CHR$(193); STRING$(minWidth, 196); CHR$(217);

' Center and print title text
D = minWidth - LEN(name$)
S = 0
IF D > 1 THEN S = D / 2
LOCATE startY + 1, startX + 3 + S
COLOR tntTitle, tntBg
PRINT name$

' Handle user input
COLOR tntSelect
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
      IF userSelected < entries THEN
        prevSelection = userSelected
        userSelected = userSelected + 1
        updateSelection = -1
      END IF
  END SELECT

  IF updateSelection THEN
    updateSelection = 0
    LOCATE startY + 2 * prevSelection + 1, startX + 1: PRINT CHR$(32)
    LOCATE startY + 2 * userSelected + 1, startX + 1: PRINT CHR$(175)
  END IF
LOOP

COLOR 7, 0
CLS
Menu = userSelected
END FUNCTION

