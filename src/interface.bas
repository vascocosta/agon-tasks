REM =====================================================================
REM Procedure to show tasks
REM =====================================================================
:
DEF PROC_SHOW_TASKS
MOVE 160,860
GCOL 0, 14: DRAW 1120,860
FOR I = 0 TO 7
  COLOUR 10: PRINT TAB(10, I + 6) CHR$(65 + I);
  COLOUR 7: PRINT " edit  ";
  COLOUR 10: PRINT STR$(I + 1);
  COLOUR 7: PRINT " toggle" + "  ";
  COLOUR 15: PRINT LEFT$(TASKS$(I), 39);
  FOR J = 1 TO (39 - LEN(TASKS$(I)))
    PRINT " ";
  NEXT J
  IF STATES$(I) = CHR$(240) THEN COLOUR 10 ELSE COLOUR 9
  PRINT TAB(69, I + 6) STATES$(I)
  COLOUR 15
NEXT I
MOVE 160,500
GCOL 0, 14: DRAW 1120,500
ENDPROC
:
REM =====================================================================
REM Procedure to toggle the state
REM =====================================================================
:
DEF PROC_TOGGLE_STATE(I)
IF STATES$(I) = CROSS$ THEN STATES$(I) = TICK$ ELSE STATES$(I) = CROSS$
SOUND 1,-7,200,1
PROC_SAVE_TASKS
ENDPROC
:
REM =====================================================================
REM Procedure to edit a task
REM =====================================================================
:
DEF PROC_EDIT_TASK(I)
LOCAL TEXT$, BLANK$, LT
VDU 23,1,1;0;0;0;
INPUT TAB(10, 18); "Description"; TEXT$
BLANK$ = "                                                            "
PRINT TAB(10,18); BLANK$
TASKS$(I) = TEXT$
STATES$(I) = CHR$(241)
PROC_SAVE_TASKS
VDU 23,1,0;0;0;0;
LT = LEN(TEXT$)
IF LT > 47 THEN PROC_SHOW_APP
ENDPROC
:
REM =====================================================================
REM Procedure to show the title
REM =====================================================================
:
DEF PROC_SHOW_TITLE
PRINT TAB(33, 1) "TASKS (" + VER$ + ")"
ENDPROC
:
REM =====================================================================
REM Procedure to show the menu
REM =====================================================================
:
DEF PROC_SHOW_MENU
COLOUR 10: PRINT TAB(10, 16) CHR$(240);
COLOUR 7: PRINT " finished task / ";
COLOUR 9: PRINT CHR$(241);
COLOUR 7: PRINT " unfinished task / 40 char limit per task"
COLOUR 10: PRINT TAB(10, 20) "A-H";
COLOUR 7: PRINT " edit corresponding task"
COLOUR 10: PRINT TAB(45, 20) "R";
COLOUR 7: PRINT " reset all tasks from db";
COLOUR 10: PRINT TAB(10, 21) "1-8";
COLOUR 7: PRINT " toggle corresponding task"
COLOUR 10: PRINT TAB(45, 21)"Q";
COLOUR 7: PRINT " leave the tasks program"
COLOUR 15: PRINT TAB(34, 25) CHR$(169); " 2024 gluon"
ENDPROC
:
REM =====================================================================
REM Procedure to show the app
REM =====================================================================
:
DEF PROC_SHOW_APP
CLS
PROC_READ_TASKS
PROC_SHOW_TITLE
PROC_SHOW_TASKS
PROC_SHOW_MENU
ENDPROC
