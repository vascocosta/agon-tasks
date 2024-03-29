   10 VER$ = "v0.3.0"
   20 FILE$ = "/.tasks.db"
   30 DIM TASKS$(7), STATES$(7)
   40 VDU 23,240,0,3,7,14,220,248,112,0
   50 VDU 23,241,0,231,102,60,60,102,231,0
   60 REM
   70 REM =====================================================================
   80 REM Main program
   90 REM =====================================================================
  100 REM
  110 MODE 3
  120 VDU 23,1,0;0;0;0;
  130 COLOUR 15: COLOUR 132
  140 CLS
  150 PROC_SHOW_TITLE
  160 PROC_READ_TASKS
  170 PROC_SHOW_TASKS
  180 REPEAT
  190   OPT$ = INKEY$(1000)
  200   IF VAL(OPT$) > 0 AND VAL(OPT$) < 9 THEN  PROC_TOGGLE_STATE(VAL(OPT$) - 1): PROC_SHOW_TASKS
  210   IF OPT$ = "a" OR OPT$ = "A" THEN PROC_EDIT_TASK(0): PROC_SHOW_TASKS
  220   IF OPT$ = "b" OR OPT$ = "B" THEN PROC_EDIT_TASK(1): PROC_SHOW_TASKS
  230   IF OPT$ = "c" OR OPT$ = "C" THEN PROC_EDIT_TASK(2): PROC_SHOW_TASKS
  240   IF OPT$ = "d" OR OPT$ = "D" THEN PROC_EDIT_TASK(3): PROC_SHOW_TASKS
  250   IF OPT$ = "e" OR OPT$ = "E" THEN PROC_EDIT_TASK(4): PROC_SHOW_TASKS
  260   IF OPT$ = "f" OR OPT$ = "F" THEN PROC_EDIT_TASK(5): PROC_SHOW_TASKS
  270   IF OPT$ = "g" OR OPT$ = "G" THEN PROC_EDIT_TASK(6): PROC_SHOW_TASKS
  280   IF OPT$ = "h" OR OPT$ = "H" THEN PROC_EDIT_TASK(7): PROC_SHOW_TASKS
  290   IF OPT$ = "r" OR OPT$ = "R" THEN PROC_CREATE_DB: PROC_READ_TASKS: PROC_SHOW_TASKS
  300 UNTIL OPT$ = "q" OR OPT$ = "Q"
  310 CLS
  320 PRINT CHR$(169); " 2024 gluon - https://github.com/vascocosta/agon-tasks"
  330 VDU 23,1,1;0;0;0;
  340 END
  350 REM
  360 REM =====================================================================
  370 REM Procedure to read tasks
  375 REM =====================================================================
  380 REM
  390 DEF PROC_READ_TASKS
  400 LOCAL FD, I, STATE$, TASK$
  410 FOR I = 0 TO 7
  420   TASKS$(I) = ""
  430   STATES$(I) = ""
  440 NEXT I
  450 FD = OPENIN FILE$
  460 IF FD = 0 THEN PROC_CREATE_DB: FD = OPENIN FILE$
  470 I = 0
  480 REPEAT
  490   INPUT#FD, TASK$
  500   INPUT#FD, STATE$
  510   TASKS$(I) = FN_CLEAN_STR(TASK$)
  520   STATES$(I) = FN_CLEAN_STR(STATE$)
  530   I = I + 1
  540 UNTIL EOF#FD
  550 CLOSE#FD
  560 ENDPROC
  570 REM
  580 REM =====================================================================
  590 REM Procedure to save tasks
  600 REM =====================================================================
  610 REM
  620 DEF PROC_SAVE_TASKS
  630 LOCAL FD, I
  640 FD = OPENOUT FILE$
  650 IF FD = 0 THEN PRINT "COULD NOT OPEN TASKS FILE": END
  660 FOR I = 0 TO 7
  670   IF TASKS$(I) <> "" AND STATES$(I) <> "" THEN PRINT#FD, LEFT$(TASKS$(I), 39), STATES$(I)
  680 NEXT I
  690 CLOSE#FD
  700 ENDPROC
  710 REM
  720 REM =====================================================================
  730 REM Procedure to show tasks
  740 REM =====================================================================
  750 REM
  760 DEF PROC_SHOW_TASKS
  770 CLS
  780 PROC_SHOW_TITLE
  790 MOVE 160,860
  800 GCOL 0, 14: DRAW 1120,860
  810 FOR I = 0 TO 7
  820   COLOUR 10: PRINT TAB(10, I + 6) CHR$(65 + I);
  830   COLOUR 7: PRINT " edit  ";
  840   COLOUR 10: PRINT STR$(I + 1);
  850   COLOUR 7: PRINT " toggle" + "  ";
  860   COLOUR 15: PRINT LEFT$(TASKS$(I), 39);
  870   IF STATES$(I) = CHR$(240) THEN COLOUR 10 ELSE COLOUR 9
  880   PRINT TAB(69, I + 6) STATES$(I)
  890   COLOUR 15
  900 NEXT I
  910 MOVE 160,500
  920 GCOL 0, 14: DRAW 1120,500
  930 PROC_SHOW_MENU
  940 VDU 31,10,18
  950 ENDPROC
  960 REM
  970 REM =====================================================================
  980 REM Function to clean a string
  990 REM =====================================================================
 1000 REM
 1010 DEF FN_CLEAN_STR(S$)
 1020 LOCAL C$, I
 1030 C$ = ""
 1040 FOR I = 1 TO LEN(S$)
 1050   IF MID$(S$, I, 1) <> CHR$(10) THEN C$ = C$ + MID$(S$, I, 1)
 1060 NEXT I
 1070 = C$
 1080 ENDDEF
 1090 REM
 1100 REM =====================================================================
 1110 REM Procedure to toggle the state
 1120 REM =====================================================================
 1130 REM
 1140 DEF PROC_TOGGLE_STATE(I)
 1150 IF STATES$(I) = CHR$(241) THEN STATES$(I) = CHR$(240) ELSE STATES$(I) = CHR$(241)
 1160 SOUND 1,-7,200,1
 1170 PROC_SAVE_TASKS
 1180 ENDPROC
 1190 REM
 1200 REM =====================================================================
 1210 REM Procedure to edit a task
 1220 REM =====================================================================
 1230 REM
 1240 DEF PROC_EDIT_TASK(I)
 1250 LOCAL TEXT$
 1260 VDU 23,1,1;0;0;0;
 1270 INPUT "Description"; TEXT$
 1280 TASKS$(I) = TEXT$
 1290 STATES$(I) = CHR$(241)
 1300 PROC_SAVE_TASKS
 1310 VDU 23,1,0;0;0;0;
 1320 ENDPROC
 1330 REM
 1340 REM =====================================================================
 1350 REM Procedure to show the title
 1360 REM =====================================================================
 1370 REM
 1380 DEF PROC_SHOW_TITLE
 1390 PRINT TAB(33, 1) "TASKS (" + VER$ + ")"
 1400 ENDPROC
 1410 REM
 1420 REM =====================================================================
 1430 REM Procedure to show the menu
 1440 REM =====================================================================
 1450 REM
 1460 DEF PROC_SHOW_MENU
 1470 COLOUR 10: PRINT TAB(10, 16) CHR$(240);
 1480 COLOUR 7: PRINT " finished task / ";
 1490 COLOUR 9: PRINT CHR$(241);
 1500 COLOUR 7: PRINT " unfinished task / 40 char limit per task"
 1510 COLOUR 10: PRINT TAB(10, 20) "A-H";
 1520 COLOUR 7: PRINT " edit corresponding task"
 1530 COLOUR 10: PRINT TAB(45, 20) "R";
 1540 COLOUR 7: PRINT " reset all tasks from db";
 1550 COLOUR 10: PRINT TAB(10, 21) "1-8";
 1560 COLOUR 7: PRINT " toggle corresponding task"
 1570 COLOUR 10: PRINT TAB(45, 21)"Q";
 1580 COLOUR 7: PRINT " leave the tasks program"
 1590 COLOUR 15: PRINT TAB(34, 25) CHR$(169); " 2024 gluon"
 1600 ENDPROC
 1610 REM
 1620 REM =====================================================================
 1630 REM Procedure to create the database
 1640 REM =====================================================================
 1650 REM
 1660 DEF PROC_CREATE_DB
 1670 FD = OPENOUT FILE$
 1680 PRINT#FD, ""
 1690 CLOSE#FD
 1700 ENDPROC
