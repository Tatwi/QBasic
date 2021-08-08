DECLARE SUB GetDateTime ()
DECLARE SUB UpdateClock ()
DECLARE SUB DrawBorders ()
DEFINT A-Z
SCREEN 0: WIDTH 80, 50
TIMER ON
RANDOMIZE TIMER

' Global Variables
DIM SHARED tStart AS LONG
DIM SHARED tNow AS LONG
DIM SHARED tDelta AS LONG
DIM SHARED tDay AS INTEGER
DIM SHARED tHour AS INTEGER
DIM SHARED tMin AS INTEGER
DIM SHARED tSeason AS INTEGER
DIM SHARED seasons(1 TO 4) AS STRING
DIM SHARED tClockUpdate AS SINGLE
DIM SHARED tClockStep

' Game Time
' R. Bassett Jr.
' 2021.08.08
' A clock and calendar for use in a game.
' - Approx 1 second = 1 minute in game-universe time.
' - 24 hours in a day, 30 days in a season, 4 seasons in a year.
' - Clock updates every 5 game minutes (to be less distracting).

' Intial values
tStart = TIMER
tNow = TIMER
tDelta = 0
tDay = 1
tHour = 0
tMin = 0
tSeason = 1
tClockUpdate = 4.89  ' Clock update interval (approx seconds). Use -1 to speed through
tClockStep = 5 ' How many minutes to step per update

CLS
DrawBorders
GetDateTime

I$ = ""
DO WHILE I$ <> CHR$(27)
	I$ = INKEY$
	UpdateClock
LOOP
END

SUB DrawBorders
COLOR 1, 0
LOCATE 1, 2: PRINT STRING$(78, 205);
LOCATE 1, 1: PRINT CHR$(201)
LOCATE 1, 10: PRINT CHR$(209)
LOCATE 1, 60: PRINT CHR$(209)
LOCATE 1, 72: PRINT CHR$(209)
LOCATE 1, 80: PRINT CHR$(187)

LOCATE 2, 1: PRINT CHR$(186)
LOCATE 2, 10: PRINT CHR$(179)
LOCATE 2, 60: PRINT CHR$(179)
LOCATE 2, 72: PRINT CHR$(179)
LOCATE 2, 80: PRINT CHR$(186)

LOCATE 3, 2: PRINT STRING$(78, 205);
LOCATE 3, 10: PRINT CHR$(207)
LOCATE 3, 60: PRINT CHR$(207)
LOCATE 3, 72: PRINT CHR$(207)
LOCATE 3, 80: PRINT CHR$(187)
LOCATE 3, 1: PRINT CHR$(200)
LOCATE 3, 80: PRINT CHR$(188)

' Show some flavor text
COLOR 2
LOCATE 2, 3: PRINT "$15975"
COLOR 7
LOCATE 2, 28: PRINT "My Awesome Game!"
END SUB

SUB GetDateTime
' Could load the date/time from the last session (from a file) here.
seasons(1) = "Winter"
seasons(2) = "Spring"
seasons(3) = "Summer"
seasons(4) = "  Fall"

COLOR 7, 0
LOCATE 2, 62: PRINT seasons(tSeason); tDay;

tStyleStart$ = ""
tStyleMid$ = ":"
IF tMin < 10 THEN tStyleMid$ = ":0"
IF tHour < 10 THEN tStyleStart$ = "0"
LOCATE 2, 74: PRINT tStyleStart$; LTRIM$(RTRIM$(STR$(tHour))); tStyleMid$; LTRIM$(STR$(tMin));

END SUB

SUB UpdateClock
COLOR 7, 0

tDelta = TIMER - tNow

IF tDelta > tClockUpdate THEN
	IF tMin < 50 THEN
		tMin = tMin + tClockStep
	ELSE
		tMin = 0
		tHour = tHour + 1
		IF tHour > 23 THEN
			tHour = 0
			tDay = tDay + 1
			IF tDay > 30 THEN
				tDay = 1
				tSeason = tSeason + 1
				IF tSeason > 4 THEN tSeason = 1
			END IF

			LOCATE 2, 62: PRINT seasons(tSeason); tDay;
		END IF
	END IF

	tStyleStart$ = ""
	tStyleMid$ = ":"
	IF tMin < 10 THEN tStyleMid$ = ":0"
	IF tHour < 10 THEN tStyleStart$ = "0"
	LOCATE 2, 74: PRINT tStyleStart$; LTRIM$(RTRIM$(STR$(tHour))); tStyleMid$; LTRIM$(STR$(tMin));
 
	tNow = TIMER
END IF
END SUB

