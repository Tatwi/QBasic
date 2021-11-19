DEFINT A-Z
DECLARE FUNCTION Menu% (M$, DS%)
DECLARE SUB LoadMenu (M$)
DECLARE SUB DrawImage (RS%, CS%, F$)
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

' DEBUG INFO
LOCATE 49, 3: PRINT "Free Memory:"; FRE(0); "  Array:"; FRE(-1); "   Stack:"; FRE(-2);

I = Menu("MENUS\MAIN", 1)

SELECT CASE I
	CASE IS = 1
		CHAIN "CRAFTA.BAS"
	CASE IS = 2
		CHAIN "CRAFTT.BAS"
	CASE IS = 3
		CHAIN "CRAFTW.BAS"
	CASE IS = 4
		CHAIN "STORE.BAS"
	CASE IS = 5
		CHAIN "INV.BAS"
	CASE IS = 6
		CHAIN "MARKET.BAS"
	CASE IS = 7
		CHAIN "JOB.BAS"
	CASE IS = 8
		CHAIN "SMITHY.BAS"
	CASE IS = 9
		CHAIN "SHEET.BAS"
	CASE IS = 10
		CHAIN "EMPLOY.BAS"
	CASE IS = 11
		CHAIN "ACTIV.BAS"
END SELECT

TheEnd:
CLS
I = Menu("MENUS\EXIT", 1)
IF I = 1 THEN GOTO TheStart
CLS
PRINT "Thanks for playing!"

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

