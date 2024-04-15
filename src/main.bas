REM =====================================================================
REM TASKS - Copyright (c) 2024 Vasco Costa (gluon)
REM Simple tasks/todo list program for the Agon Light 8-bit computer
REM =====================================================================
:
REM =====================================================================
REM Global definitions
REM =====================================================================
:
VER$ = "v1.0.0"
FILE$ = "/.tasks.db"
DIM TASKS$(7), STATES$(7)
TICK$ = CHR$(240)
CROSS$ = CHR$(241)
VDU 23,240,0,3,7,14,220,248,112,0
VDU 23,241,0,231,102,60,60,102,231,0
:
REM =====================================================================
REM Main program
REM =====================================================================
:
MODE 3
VDU 23,1,0;0;0;0;
COLOUR 15: COLOUR 132
PROC_SHOW_APP
REPEAT
  K$ = GET$
  V = VAL(K$)
  IF ASC(K$) < 97 THEN K$ = CHR$(ASC(K$) + 32)
  IF V > 0 AND V < 9 THEN  PROC_TOGGLE_STATE(V - 1): PROC_SHOW_TASKS
  IF K$ = "a" THEN PROC_EDIT_TASK(0): PROC_SHOW_TASKS
  IF K$ = "b" THEN PROC_EDIT_TASK(1): PROC_SHOW_TASKS
  IF K$ = "c" THEN PROC_EDIT_TASK(2): PROC_SHOW_TASKS
  IF K$ = "d" THEN PROC_EDIT_TASK(3): PROC_SHOW_TASKS
  IF K$ = "e" THEN PROC_EDIT_TASK(4): PROC_SHOW_TASKS
  IF K$ = "f" THEN PROC_EDIT_TASK(5): PROC_SHOW_TASKS
  IF K$ = "g" THEN PROC_EDIT_TASK(6): PROC_SHOW_TASKS
  IF K$ = "h" THEN PROC_EDIT_TASK(7): PROC_SHOW_TASKS
  IF K$ = "r" THEN PROC_CREATE_DB: PROC_SHOW_APP
UNTIL K$ = "q"
CLS
PRINT CHR$(169); " 2024 gluon - https://github.com/vascocosta/agon-tasks"
VDU 23,1,1;0;0;0;
END
