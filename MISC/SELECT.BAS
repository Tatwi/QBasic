' Simple highlighting of selected line
' R. Bassett Jr.
' 2021.11.18
' Navigate with the up and down arrows. Press ESC to quit.
DEFINT A-Z
DECLARE SUB DoHighlight (R, C, P, L)
DECLARE SUB ShowStuff ()
SCREEN 0
RANDOMIZE TIMER

CLS
RS = INT(RND * 10) + 3    ' Starting row
RA = RS                   ' Active row
RP = RA                   ' Previously active row
C = INT(RND * 20) + 2     ' Starting column
E = INT(RND * 6) + 3      ' Number of entries
S$ = "This is some text"
L = LEN(S$) + 5           ' Length of longest entry
PRINT E; "Entries"

FOR X = 1 TO E
  LOCATE RS + X, C: PRINT S$; STR$(INT(RND * 9000) + 1);
NEXT X

' Highlight row when using arrow keys
I$ = INKEY$
DO WHILE I$ <> CHR$(27)
  I$ = INKEY$

  IF I$ = CHR$(0) + CHR$(72) THEN
    IF RA > RS + 1 THEN
      ' Up arrow
      RP = RA
      RA = RA - 1
      IF RA < RS THEN RA = RS
      DoHighlight RA, C, RP, L
      ShowStuff
    END IF
  ELSEIF I$ = CHR$(0) + CHR$(80) THEN
    IF RA < RS + E THEN
      RP = RA
      ' Down arrow
      RA = RA + 1
      IF RA > RS + E THEN RA = RS + E
      DoHighlight RA, C, RP, L
      ShowStuff
    END IF
  END IF
LOOP

CLS
END

SUB DoHighlight (R, C, P, L)
' row, column, previous row, number of character to highlight

' Restore previous
COLOR 7
LOCATE P, C - 1
PRINT " ";
FOR X = 0 TO L
  LOCATE P, C + X
  PRINT CHR$(SCREEN(P, C + X));
NEXT X

' Do highlight
COLOR 2: LOCATE R, C - 1
PRINT CHR$(175)
FOR X = 0 TO L
  LOCATE R, C + X
  PRINT CHR$(SCREEN(R, C + X));
NEXT X
END SUB

SUB ShowStuff
LOCATE 1, 20: PRINT STRING$(20, 0);
LOCATE 1, 20: PRINT RND * 5000
END SUB

