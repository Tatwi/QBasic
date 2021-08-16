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
' not a floppy drive from 1982, so drive speed/space wasn't an issue. That
' said, testing running from a 3.5" floppy on a real Pentium 233MMX system
' showed identical (instant!) loading/saving of the menu files. The disk was
' even vintage 1998 or so.
'
' All functions/subs that manipulate menus always load the menu in question,
' which over-writes the previously active menu. As such, you will need to
' make use of the user's selection on the previous menu before using any of
' these functions. This was intended; "Do one thing until it's done".
DEFINT A-Z
DECLARE FUNCTION Menu% (M$, DS%)
DECLARE FUNCTION MenuWhereIs% (M$, S$)
DECLARE SUB SaveMenu (M$)
DECLARE SUB LoadMenu (M$)
DECLARE SUB MenuAdd (M$, S$)
DECLARE SUB MenuRemove (M$, E%)
DECLARE SUB MenuChange (M$, E%, S$)
DECLARE SUB MenuSwap (M$, A%, B%)
SCREEN 0
WIDTH 80, 50
RANDOMIZE TIMER

' Global Variables
DIM SHARED mEntries(X) AS STRING ' Allows for variable width
DIM SHARED mTitle AS STRING       ' Allows for variable width
TYPE menuConfig
	entries AS INTEGER    ' Number of entries in the menu
	X AS INTEGER          ' Start column
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
S = Menu("MENUS\MAIN", 1)

SELECT CASE S
	CASE IS = 1
		CLS
		M$ = "MENUS\" + LTRIM$(STR$(INT(RND * 5) + 1))
		S = Menu(M$, 1)
		CLS
		LOCATE 3, 3: PRINT "You selected option"; RTRIM$(STR$(S)); "!"
	CASE IS = 2
		LOCATE 3, 3: PRINT "Choose menu item to change.";
		S = Menu("MENUS\1", 1)
		CLS
		LOCATE 3, 3
		INPUT "New Entry:"; I$
		IF LEN(I$) > 20 THEN I$ = LEFT$(I$, 20)
		MenuChange "MENUS\1", S, I$
		CLS
		LOCATE 3, 3: PRINT "Here is the new menu!";
		S = Menu("MENUS\1", 1)
	CASE IS = 3
		CLS
		LOCATE 3, 3: PRINT "Add to a menu of snacks."
		LOCATE 5, 3: INPUT "New Entry"; I$
		IF LEN(I$) > 20 THEN I$ = LEFT$(I$, 20)
		MenuAdd "MENUS\1", I$
		CLS
		LOCATE 3, 3: PRINT "Here is the new menu!";
		S = Menu("MENUS\1", 1)
	CASE IS = 4
		LOCATE 3, 3: PRINT "Choose menu item to remove.";
		S = Menu("MENUS\1", 1)
		CLS
		MenuRemove "MENUS\1", S
		CLS
		LOCATE 3, 3: PRINT "Here is the new menu!";
		S = Menu("MENUS\1", 1)
	CASE IS = 5
		LOCATE 3, 3: PRINT "Choose first entry to swap."
		A = Menu("MENUS\1", 1)
		CLS
		LOCATE 3, 3: PRINT "Choose second entry to swap."
		B = Menu("MENUS\1", 1)
		MenuSwap "MENUS\1", A, B
		LOCATE 3, 3: PRINT "Here is the new menu."
		S = Menu("MENUS\1", 1)
END SELECT

' WhereIs demo
X = MenuWhereIs("MENUS\1", "Potato Chips")
LOCATE 8, 3
IF X > 0 THEN
	PRINT "Potato Chips were located at entry"; X; "in the snacks menu."
ELSE
	PRINT "Potato Chips weren't located in the snacks menu."
END IF

SUB LoadMenu (M$)
' Load data for this menu from file.
M$ = M$ + ".DAT"
OPEN M$ FOR INPUT AS #1
	INPUT #1, mTitle
	INPUT #1, mConfig.entries
	INPUT #1, mConfig.X
	INPUT #1, mConfig.y
	INPUT #1, mConfig.sc
	INPUT #1, mConfig.tc
	INPUT #1, mConfig.bc
	INPUT #1, mConfig.ec
	INPUT #1, mConfig.bgc
	mConfig.minWidth = LEN(mTitle)
	REDIM mEntries(mConfig.entries)

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
LOCATE mConfig.y, mConfig.X: PRINT CHR$(213); CHR$(205); CHR$(209); STRING$(mConfig.minWidth, 205); CHR$(184);
LOCATE mConfig.y + 1, mConfig.X: PRINT CHR$(179); CHR$(240); CHR$(179); STRING$(mConfig.minWidth, 32); CHR$(179);
LOCATE mConfig.y + 2, mConfig.X: PRINT CHR$(195); CHR$(196); CHR$(197); STRING$(mConfig.minWidth, 205); CHR$(180)
' Entries
CB = 3
FOR C = 1 TO mConfig.entries
	S = mConfig.minWidth - LEN(mEntries(C))
	LOCATE mConfig.y + 2 * C + 1, mConfig.X
	PRINT CHR$(179); CHR$(32); CHR$(179);
	COLOR mConfig.ec, mConfig.bgc: PRINT mEntries(C);
	COLOR mConfig.bc, mConfig.bgc
	PRINT STRING$(S, 32); CHR$(179)
	LOCATE mConfig.y + 2 * C + 2, mConfig.X:
	PRINT CHR$(195); CHR$(196); CHR$(197); STRING$(mConfig.minWidth, 196); CHR$(180)
	CB = CB + 2
NEXT C
' Redraw bottom row border
LOCATE mConfig.y + mConfig.entries * 2 + 2, mConfig.X
PRINT CHR$(192); CHR$(196); CHR$(193); STRING$(mConfig.minWidth, 196); CHR$(217);

' Center and print title text
D = mConfig.minWidth - LEN(mTitle)
S = 0
IF D > 1 THEN S = D / 2
LOCATE mConfig.y + 1, mConfig.X + 3 + S
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
		LOCATE mConfig.y + 2 * prevSelection + 1, mConfig.X + 1: PRINT CHR$(32)
		LOCATE mConfig.y + 2 * userSelected + 1, mConfig.X + 1: PRINT CHR$(175)
	END IF
LOOP

COLOR 7, 0
CLS
Menu = userSelected
END FUNCTION

SUB MenuAdd (M$, S$)
LoadMenu (M$)

' Bail if the menu is already full
IF mConfig.entries > 19 THEN EXIT SUB

DIM tmpNames(mConfig.entries + 1) AS STRING

FOR C = 1 TO mConfig.entries
	tmpNames(C) = mEntries(C)
NEXT C

mConfig.entries = mConfig.entries + 1
tmpNames(mConfig.entries) = S$

REDIM mEntries(mConfig.entries)

FOR C = 1 TO mConfig.entries
	mEntries(C) = tmpNames(C)
NEXT C

SaveMenu (M$)
END SUB

SUB MenuChange (M$, E%, S$)
LoadMenu (M$)
mEntries(E%) = S$
SaveMenu (M$)
END SUB

SUB MenuRemove (M$, E%)
LoadMenu (M$)

' Bail if the menu only has one item left
IF mConfig.entries < 2 THEN EXIT SUB

DIM tmpNames(mConfig.entries - 1) AS STRING

X = 1
FOR C = 1 TO mConfig.entries
	IF C <> E% THEN
		tmpNames(X) = mEntries(C)
		X = X + 1
	END IF
NEXT C

mConfig.entries = mConfig.entries - 1
REDIM mEntries(mConfig.entries)

FOR C = 1 TO mConfig.entries
	mEntries(C) = tmpNames(C)
NEXT C

SaveMenu (M$)
END SUB

SUB MenuSwap (M$, A%, B%)
LoadMenu (M$)

' Bail if no change is required
IF A% = B% THEN EXIT SUB

X$ = mEntries(A%)
mEntries(A%) = mEntries(B%)
mEntries(B%) = X$

SaveMenu (M$)
END SUB

FUNCTION MenuWhereIs (M$, S$)
LoadMenu (M$)
X = 0

FOR C = 1 TO mConfig.entries
	IF mEntries(C) = S$ THEN
		X = C
		EXIT FOR
	END IF
NEXT C

MenuWhereIs = X
END FUNCTION

SUB SaveMenu (M$)
M$ = M$ + ".DAT"
OPEN M$ FOR OUTPUT AS #1
	PRINT #1, mTitle
	PRINT #1, mConfig.entries
	PRINT #1, mConfig.X
	PRINT #1, mConfig.y
	PRINT #1, mConfig.sc
	PRINT #1, mConfig.tc
	PRINT #1, mConfig.bc
	PRINT #1, mConfig.ec
	PRINT #1, mConfig.bgc
 
	FOR C = 1 TO mConfig.entries
		PRINT #1, mEntries(C)
	NEXT C
CLOSE #1
END SUB

