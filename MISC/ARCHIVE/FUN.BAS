CLS
DO
FOR Y = 1 TO 3
CLS
FOR X = 1 TO 75
   L1 = INT(22 * RND + 1)
   L2 = INT(70 * RND + 1)
   S = INT(14 * RND + 1)
   B = INT(15 * RND + 1)
   COLOR S: LOCATE L1, L2
   PRINT "*"
   PRINT
NEXT X
NEXT Y
IF B = 6 THEN B = B + 1
LOCATE L1, L1: PRINT "HELLO": FOR T = 1 TO 500: NEXT T
COLOR , B
LOOP WHILE INKEY$ = ""



