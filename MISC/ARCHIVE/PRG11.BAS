REM ROB BASSETT
REM PRG11

CLS
COLOR (8)
INPUT "CHANGE"; C
COLOR (2)
C = INT(C * 100 + .5)
Q = INT(C / 25)
C = C - Q * 25
PRINT Q; " QUARTERS"
COLOR (5)
D = INT(C / 10)
C = C - D * 10
PRINT D; " DIMES"
COLOR (4)
N = INT(C / 5)
C = C - N * 5
PRINT N; " NICKLES"
COLOR (8)
P = INT(C / 1)
C = C - P * 1
PRINT P; " PENNIES"













