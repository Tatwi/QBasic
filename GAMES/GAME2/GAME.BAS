DEFINT A-Z
DECLARE FUNCTION GetSetRes% (R%, V%, OP%)
DECLARE FUNCTION Menu% (M$, DS%)
DECLARE FUNCTION MenuWhereIs% (M$, S$)
DECLARE FUNCTION MakeName$ ()
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
	Y AS INTEGER          ' Start row
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
		KILL "SAVE\" + LTRIM$(STR$(profNum%)) + "\RES\*.DAT"

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

FUNCTION GetSetRes (R, V, OP)
' Returns resource quanity or -1 for insufficient quantity
' R is the resouce identifier number
' V is the value to add/subtract. Use 0 when just getting quantity.
' OP is subtract or add. Use 1 for add and -1 for subtract.

' Get active profile
F$ = "SAVE\AP.DAT"
OPEN F$ FOR INPUT AS #1
	INPUT #1, AP
CLOSE #1

profile$ = "SAVE\" + LTRIM$(STR$(AP)) + "\"

F$ = profile$ + "RES\" + LTRIM$(STR$(R)) + ".DAT"

' Read values
DIM VALS(13) AS INTEGER
OPEN F$ FOR INPUT AS #1
	INPUT #1, Q
	INPUT #1, N$

	FOR Z = 1 TO 13
		INPUT #1, VALS(Z)
	NEXT Z
CLOSE #1

' Store original value
S = Q

' Modify quantity
Q = Q + (V * OP)

' Bail without saving if no changes were made
IF S = Q THEN
	GetSetRes = Q
	EXIT FUNCTION
END IF

' Bail if user doesn't have enough resouces to cover cost of subtraction
IF Q < 0 THEN
	GetSetRes = -1
	EXIT FUNCTION
END IF

' Cap the quanity (overflow is lost)
IF Q > 999 THEN Q = 999

' Save changes
saveData$ = LTRIM$(STR$(Q)) + ", " + N$
FOR X = 1 TO 13
	saveData$ = saveData$ + "," + STR$(VALS(X))
NEXT X
OPEN F$ FOR OUTPUT AS #1
	PRINT #1, saveData$
CLOSE #1

GetSetRes = Q
END FUNCTION

SUB LoadMenu (M$)
' Load data for this menu from file.
M$ = M$ + ".DAT"
OPEN M$ FOR INPUT AS #1
	INPUT #1, mTitle
	INPUT #1, mConfig.entries
	INPUT #1, mConfig.X
	INPUT #1, mConfig.Y
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

FUNCTION MakeName$
' Returns a randomized name
DIM P(100) AS STRING
F$ = "GEN\RES\NAMER.DAT"

OPEN F$ FOR INPUT AS #1
	FOR X = 1 TO 100
		INPUT #1, P(X)
	NEXT X
CLOSE #1

MakeName$ = P(INT(RND * 30 + 1)) + P(INT(RND * 50 + 30)) + P(INT(RND * 20 + 80))
END FUNCTION

FUNCTION Menu (M$, DS%)
' (Menu file number, Menu directory, Default selection)
LoadMenu (M$)

userSelected = DS%
prevSelection = 1
updateSelection = -1 ' Booleen TRUE


' Print the border and menu mConfig.entries
' Title border
COLOR mConfig.bc, mConfig.bgc
LOCATE mConfig.Y, mConfig.X: PRINT CHR$(213); CHR$(205); CHR$(209); STRING$(mConfig.minWidth, 205); CHR$(184);
LOCATE mConfig.Y + 1, mConfig.X: PRINT CHR$(179); CHR$(240); CHR$(179); STRING$(mConfig.minWidth, 32); CHR$(179);
LOCATE mConfig.Y + 2, mConfig.X: PRINT CHR$(195); CHR$(196); CHR$(197); STRING$(mConfig.minWidth, 205); CHR$(180)
' Entries
CB = 3
FOR C = 1 TO mConfig.entries
	S = mConfig.minWidth - LEN(mEntries(C))
	LOCATE mConfig.Y + 2 * C + 1, mConfig.X
	PRINT CHR$(179); CHR$(32); CHR$(179);
	COLOR mConfig.ec, mConfig.bgc: PRINT mEntries(C);
	COLOR mConfig.bc, mConfig.bgc
	PRINT STRING$(S, 32); CHR$(179)
	LOCATE mConfig.Y + 2 * C + 2, mConfig.X:
	PRINT CHR$(195); CHR$(196); CHR$(197); STRING$(mConfig.minWidth, 196); CHR$(180)
	CB = CB + 2
NEXT C
' Redraw bottom row border
LOCATE mConfig.Y + mConfig.entries * 2 + 2, mConfig.X
PRINT CHR$(192); CHR$(196); CHR$(193); STRING$(mConfig.minWidth, 196); CHR$(217);

' Center and print title text
D = mConfig.minWidth - LEN(mTitle)
S = 0
IF D > 1 THEN S = D / 2
LOCATE mConfig.Y + 1, mConfig.X + 3 + S
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
		LOCATE mConfig.Y + 2 * prevSelection + 1, mConfig.X + 1: PRINT CHR$(32)
		LOCATE mConfig.Y + 2 * userSelected + 1, mConfig.X + 1: PRINT CHR$(175)
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
' Working with profile I of 5
profile$ = "SAVE\" + LTRIM$(STR$(I)) + "\"

' Get data
INPUT "Player Name"; N$
N$ = LEFT$(N$, 20)

'Generate player data

' Save player data
F$ = profile$ + "PLYR.DAT"
OPEN F$ FOR APPEND AS #1
	PRINT #1, N$
CLOSE #1

' Update Profile Selection Menu
MenuChange "SAVE\PRFSEL", I, N$

' Update Delete Profile Menu
MenuAdd "SAVE\PRFTODEL", N$

' Generate resources
N$ = ""
DIM RMIN(13) AS INTEGER
DIM RMAX(13) AS INTEGER
DIM NEWRES(13) AS INTEGER

FOR X = 1 TO 41
	' Get min values
	F$ = "GEN\RES\" + LTRIM$(STR$(X)) + "\MIN.DAT"
	OPEN F$ FOR INPUT AS #1
		INPUT #1, N$
		FOR Z = 1 TO 13
			INPUT #1, RMIN(Z)
		NEXT Z
	CLOSE #1
 
	' Get max values
	F$ = "GEN\RES\" + LTRIM$(STR$(X)) + "\MAX.DAT"
	OPEN F$ FOR INPUT AS #1
		INPUT #1, N$
		FOR Z = 1 TO 13
			INPUT #1, RMAX(Z)
		NEXT Z
	CLOSE #1

	' Gen 2 randoms and one balanced V/C
	FOR R = 1 TO 3
		newName$ = N$ + " (" + MakeName$ + ")"
		CLS : PRINT "Creating... "; newName$
 
		FOR Q = 1 TO 13
			NEWRES(Q) = INT(RND * RMAX(Q))
			IF NEWRES(Q) < RMIN(Q) THEN NEWRES(Q) = RMIN(Q)
		NEXT Q
			 
		' Convert 3rd random into a balanced V/C resource
		IF R = 3 THEN
			NEWRES(8) = INT(RND * 10 + 45)
			NEWRES(9) = INT(RND * 10 + 45)
		END IF
		
		' Save data to file
		saveData$ = "0, " + newName$
		FOR OP = 1 TO 13
			saveData$ = saveData$ + "," + STR$(NEWRES(OP))
		NEXT OP
		F$ = profile$ + "RES\" + LTRIM$(STR$(X)) + "0" + LTRIM$(STR$(R)) + ".DAT"
		OPEN F$ FOR OUTPUT AS #1
			PRINT #1, saveData$
		CLOSE #1
	NEXT R

	' Gen virtuous
	F$ = "GEN\RES\NAMEV.DAT"
	rndName$ = ""
	OPEN F$ FOR INPUT AS #1
		FOR Z = 1 TO INT(RND * 19 + 1)
			INPUT #1, rndName$
		NEXT Z
	CLOSE #1
	newName$ = N$ + " (" + rndName$ + ")"
	CLS : PRINT "Creating... "; newName$
 
	FOR Q = 1 TO 13
		NEWRES(Q) = INT(RND * RMAX(Q))
		IF NEWRES(Q) < RMIN(Q) THEN NEWRES(Q) = RMIN(Q)
	NEXT Q
	NEWRES(8) = INT(RND * 15 + 85)
	NEWRES(9) = INT(RND * 20)
 
	' Save data to file
	saveData$ = "0, " + newName$
	FOR OP = 1 TO 13
		saveData$ = saveData$ + "," + STR$(NEWRES(OP))
	NEXT OP
	F$ = profile$ + "RES\" + LTRIM$(STR$(X)) + "04.DAT"
	OPEN F$ FOR OUTPUT AS #1
		PRINT #1, saveData$
	CLOSE #1

	' Gen corrupt
	F$ = "GEN\RES\NAMEC.DAT"
	rndName$ = ""
	OPEN F$ FOR INPUT AS #1
		FOR Z = 1 TO INT(RND * 19 + 1)
			INPUT #1, rndName$
		NEXT Z
	CLOSE #1
	newName$ = N$ + " (" + rndName$ + ")"
	CLS : PRINT "Creating... "; newName$
	
	FOR Q = 1 TO 13
		NEWRES(Q) = INT(RND * RMAX(Q))
		IF NEWRES(Q) < RMIN(Q) THEN NEWRES(Q) = RMIN(Q)
	NEXT Q
	NEWRES(8) = INT(RND * 20)
	NEWRES(9) = INT(RND * 15 + 85)

	' Save data to file
	saveData$ = "0, " + newName$
	FOR OP = 1 TO 13
		saveData$ = saveData$ + "," + STR$(NEWRES(OP))
	NEXT OP
	F$ = profile$ + "RES\" + LTRIM$(STR$(X)) + "05.DAT"
	OPEN F$ FOR OUTPUT AS #1
		PRINT #1, saveData$
	CLOSE #1
NEXT X

' Give the player some resources
TMP = GetSetRes(101, 50, 1)
TMP = GetSetRes(201, 50, 1)
TMP = GetSetRes(901, 5, 1)
TMP = GetSetRes(1401, 5, 1)
TMP = GetSetRes(2001, 50, 1)
TMP = GetSetRes(2201, 50, 1)
TMP = GetSetRes(2601, 50, 1)
TMP = GetSetRes(3301, 50, 1)
TMP = GetSetRes(3701, 50, 1)
TMP = GetSetRes(4101, 100, 1)
END SUB

SUB SaveMenu (M$)
M$ = M$ + ".DAT"
OPEN M$ FOR OUTPUT AS #1
	PRINT #1, mTitle
	PRINT #1, mConfig.entries
	PRINT #1, mConfig.X
	PRINT #1, mConfig.Y
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

