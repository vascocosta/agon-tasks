REM =====================================================================
REM Procedure to read tasks
REM =====================================================================
:
DEF PROC_READ_TASKS
LOCAL FD, I, STATE$, TASK$
FOR I = 0 TO 7
  TASKS$(I) = ""
  STATES$(I) = ""
NEXT I
FD = OPENIN FILE$
IF FD = 0 THEN PROC_CREATE_DB: FD = OPENIN FILE$
I = 0
REPEAT
  INPUT#FD, TASK$
  INPUT#FD, STATE$
  TASKS$(I) = FN_CLEAN_STR(TASK$)
  STATES$(I) = FN_CLEAN_STR(STATE$)
  I = I + 1
UNTIL EOF#FD
CLOSE#FD
ENDPROC
:
REM =====================================================================
REM Procedure to save tasks
REM =====================================================================
:
DEF PROC_SAVE_TASKS
LOCAL FD, I, T$
FD = OPENOUT FILE$
IF FD = 0 THEN PRINT "COULD NOT OPEN TASKS FILE": END
FOR I = 0 TO 7
  T$ = LEFT$(TASKS$(I), 39)
  IF TASKS$(I) <> "" AND STATES$(I) <> "" THEN PRINT#FD, T$, STATES$(I)
NEXT I
CLOSE#FD
ENDPROC
:
REM =====================================================================
REM Procedure to create the database
REM =====================================================================
:
DEF PROC_CREATE_DB
FD = OPENOUT FILE$
PRINT#FD, ""
CLOSE#FD
ENDPROC
