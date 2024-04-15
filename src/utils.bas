REM =====================================================================
REM Function to clean a string
REM =====================================================================
:
DEF FN_CLEAN_STR(S$)
LOCAL C$, I
C$ = ""
FOR I = 1 TO LEN(S$)
  IF MID$(S$, I, 1) <> CHR$(10) THEN C$ = C$ + MID$(S$, I, 1)
NEXT I
= C$
ENDDEF
