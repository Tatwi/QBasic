DECLARE SUB DeleteProfile ()
DECLARE SUB EditMenu (F$, M$, E%, S$)
DECLARE SUB NewGame (I%)
DECLARE SUB LoadProfile (I%)
DEFINT A-Z
DECLARE FUNCTION Menu% (M%, DIR$, DS%)
DECLARE SUB DrawImage (RS%, CS%, F$)
SCREEN 0: WIDTH 80, 50
RANDOMIZE TIMER

' Global Variables
DIM SHARED lastMenuItem AS STRING


TheStart:
CLS
I = Menu(2, "MENUS\", 1)

' Load profile 1 to 5, else exit game.
IF I < 6 THEN
	LoadProfile (I)
ELSEIF I = 6 THEN
 DeleteProfile
 GOTO TheStart
ELSE
	GOTO TheEnd
END IF


TheEnd:
CLS
I = Menu(1, "MENUS\", 1)
IF I = 1 THEN GOTO TheStart
CLS
PRINT "Thanks for playing!"

SUB DeleteProfile
P = Menu(3, "MENUS\", 1)
profNum = VAL(LEFT$(lastMenuItem, 1))
profName$ = RIGHT$(lastMenuItem, LEN(lastMenuItem) - 3)
profFullName$ = lastMenuItem

IF P > 1 THEN
	C = Menu(4, "MENUS\", 1)

	IF C = 2 THEN
		' Delete stuff

		' Main Menu entry
		EditMenu "C", "MENUS\2.DAT", profNum, "(Empty)"
	 
		' Delete Profile Menu entry, by matching its name
		EditMenu "R", "MENUS\3.DAT", 0, profFullName$
	 
		' The save files
		KILL "SAVE\" + LTRIM$(STR$(profNum)) + "\*.DAT"

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

FOR Y = 1 TO H
	FOR X = 1 TO W
	INPUT #1, D&
	
		' Extract color and ASCII values
		B = D& / 100000
		C = (D& - B * 100000) / 1000
		A = VAL(RIGHT$(STR$(D&), 3))

		' Print image on the screen
		COLOR C, B
		LOCATE Y + RS%, X + CS%: PRINT CHR$(A);
	NEXT X
NEXT Y

CLOSE #1
END SUB

' (Function, Menu File, Entry, New String)
SUB EditMenu (F$, M$, E%, S$)
OPEN M$ FOR INPUT AS #1
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
	NEXT C
CLOSE #1

' Perform action: Change, Remove, Add
SELECT CASE F$
	CASE IS = "C"
		entryNames(E%) = S$
	CASE IS = "R"
		DIM tmpNames(entries - 1) AS STRING
	 
		X = 1
		IF E% = 0 THEN
			' Match by entry value provided
			FOR C = 1 TO entries
				IF entryNames(C) <> S$ THEN
					tmpNames(X) = entryNames(C)
					X = X + 1
				END IF
			NEXT C
		ELSE
			' Match by entry number
			FOR C = 1 TO entries
				IF C <> E% THEN
					tmpNames(X) = entryNames(C)
					X = X + 1
				END IF
			NEXT C
		END IF
	 
		entries = entries - 1
		REDIM entryNames(entries)
		FOR C = 1 TO entries
			entryNames(C) = tmpNames(C)
		NEXT C
	CASE IS = "A"
		DIM tmpNames(entries + 1) AS STRING
 
		FOR C = 1 TO entries
			tmpNames(C) = entryNames(C)
		NEXT C
	 
		entries = entries + 1

		tmpNames(entries) = S$
	 
		REDIM entryNames(entries)
		
		FOR C = 1 TO entries
			entryNames(C) = tmpNames(C)
		NEXT C
END SELECT

OPEN M$ FOR OUTPUT AS #1
	PRINT #1, name$
	PRINT #1, entries
	PRINT #1, startX
	PRINT #1, startY
	PRINT #1, tntSelect
	PRINT #1, tntTitle
	PRINT #1, tntBorder
	PRINT #1, tntEntries
	PRINT #1, tntBg

	FOR C = 1 TO entries
		PRINT #1, entryNames(C)
	NEXT C
CLOSE #1
END SUB

SUB LoadProfile (I)
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

' Save a global reference to the text in the menu item selected
lastMenuItem = entryNames(userSelected)

Menu = userSelected
END FUNCTION

SUB NewGame (I)
CLS
' Get data
INPUT "Player Name"; N$

'Generate data

' Save data
P$ = "SAVE\" + LTRIM$(STR$(I)) + "\PLYR.DAT"
OPEN P$ FOR APPEND AS #1
	PRINT #1, N$
CLOSE #1

' Update Profile Selection Menu
EditMenu "C", "MENUS\2.DAT", I, N$

' Update Delete Profile Menu
N$ = LTRIM$(STR$(I)) + ". " + N$ ' Add profile # so it can be easily referenced later
EditMenu "A", "MENUS\3.DAT", 0, N$
END SUB

