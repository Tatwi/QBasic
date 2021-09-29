DEFINT A-Z
DECLARE FUNCTION Menu% (M$, DS%)
DECLARE FUNCTION MenuWhereIs% (M$, S$)
DECLARE SUB SaveMenu (M$)
DECLARE SUB LoadMenu (M$)
DECLARE SUB MenuAdd (M$, S$)
DECLARE SUB MenuRemove (M$, E%)
DECLARE SUB MenuChange (M$, E%, S$)
DECLARE SUB MenuSwap (M$, A%, B%)
DECLARE SUB DrawImage (RS%, CS%, F$)
DECLARE SUB FirstRun ()
DECLARE SUB NewGame (I%)
DECLARE SUB LoadProfile (I%)
DECLARE SUB DeleteProfile ()
SCREEN 0: WIDTH 80, 50
RANDOMIZE TIMER

' Active Menu Global Variables
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


TheStart:
CLS
FirstRun
I = Menu("SAVE\PRFSEL", 1)

' Player profile management
IF I < 6 THEN
	' Create or select the active profile
	LoadProfile (I)
ELSEIF I = 6 THEN
 ' Delete a profile
 DeleteProfile
 GOTO TheStart
ELSE
	' Exit the game
	GOTO TheEnd
END IF

' Run the game
CHAIN "MAIN.BAS"


TheEnd:
CLS
I = Menu("MENUS\EXIT", 1)
IF I = 1 THEN GOTO TheStart
CLS
PRINT "Thanks for playing!"

SUB DeleteProfile
P = Menu("SAVE\PRFTODEL", 1)
profName$ = mEntries(P)
profNum% = MenuWhereIs("SAVE\PRFSEL", profName$)

IF P > 1 THEN
	C = Menu("MENUS\PRFDELC", 1)

	IF C = 2 THEN
		' Delete stuff

		' Main Menu entry
		MenuChange "SAVE\PRFSEL", profNum%, "(Empty)"

		' Remove Delete Profile Menu entry, by matching its name
		MenuRemove "SAVE\PRFTODEL", P
	 
		' The save files
		KILL "SAVE\" + LTRIM$(STR$(profNum%)) + "\*.DAT"

		CLS
		LOCATE 25, 30
		PRINT profName$; " has been deleted."
		SLEEP 5
	ELSE
		CLS
		LOCATE 25, 30
		PRINT "No action taken."
		SLEEP 5
	END IF
END IF
END SUB

SUB DrawImage (RS%, CS%, F$)
' RS%/CS% row/column start. Subtract 1 each, as IMG format assumes starting at 1,1.
RS% = RS% - 1
CS% = CS% - 1
H = 0: W = 0

'Read image from file and print it to the screen
OPEN F$ FOR INPUT AS #1
	' Get image size from first two data points
	INPUT #1, D&: H = D&
	INPUT #1, D&: W = D&

FOR y = 1 TO H
	FOR X = 1 TO W
	INPUT #1, D&
	
		' Extract color and ASCII values
		B = D& / 100000
		C = (D& - B * 100000) / 1000
		A = VAL(RIGHT$(STR$(D&), 3))

		' Print image on the screen
		COLOR C, B
		LOCATE y + RS%, X + CS%: PRINT CHR$(A);
	NEXT X
NEXT y

CLOSE #1
END SUB

SUB FirstRun
' Setup up the save folder for the first time
AP$ = "SAVE\AP.DAT"
OPEN AP$ FOR APPEND AS #1
IF LOF(1) THEN
	' File exists already, nothing to do
	CLOSE #1
	EXIT SUB
END IF

' First time setup
PRINT #1, "0": CLOSE #1
SHELL "COPY MENUS\PRFSEL.DAT SAVE\PRFSEL.DAT"
SHELL "COPY MENUS\PRFTODEL.DAT SAVE\PRFTODEL.DAT"
CLS
END SUB

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

SUB LoadProfile (I)
' Set the active profile
OPEN "SAVE\AP.DAT" FOR OUTPUT AS #1
	PRINT #1, I
CLOSE #1

P$ = "SAVE\" + LTRIM$(STR$(I)) + "\PLYR.DAT"
OPEN P$ FOR APPEND AS #1
IF LOF(1) THEN
	CLOSE #1
	' Save file exists, so load it.
	OPEN P$ FOR INPUT AS #1
	 INPUT #1, N$
	CLOSE #1

	CLS
	PRINT "Loading game for "; N$; "..."
	SLEEP 3
ELSE
	CLOSE #1
	NewGame (I)
END IF


END SUB

FUNCTION Menu (M$, DS%)
' (Menu file number, Menu directory, Default selection)
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

SUB NewGame (I)
CLS
' Get data
INPUT "Player Name"; N$
N$ = LEFT$(N$, 20)

'Generate data

' Save data
P$ = "SAVE\" + LTRIM$(STR$(I)) + "\PLYR.DAT"
OPEN P$ FOR APPEND AS #1
	PRINT #1, N$
CLOSE #1

' Update Profile Selection Menu
MenuChange "SAVE\PRFSEL", I, N$

' Update Delete Profile Menu
MenuAdd "SAVE\PRFTODEL", N$
END SUB

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

