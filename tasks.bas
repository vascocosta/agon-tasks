   10 VER$ = "v0.3.1"
   20 FILE$ = "/.tasks.db"
   30 DIM TASKS$(7), STATES$(7)
   40 VDU 23,240,0,3,7,14,220,248,112,0
   50 VDU 23,241,0,231,102,60,60,102,231,0
   60 :
   70 REM =====================================================================
   80 REM Main program
   90 REM =====================================================================
  100 :
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
  350 :
  360 REM =====================================================================
  370 REM Procedure to read tasks
  380 REM =====================================================================
  390 :
  400 DEF PROC_READ_TASKS
  410 LOCAL FD, I, STATE$, TASK$
  420 FOR I = 0 TO 7
  430   TASKS$(I) = ""
  440   STATES$(I) = ""
  450 NEXT I
  460 FD = OPENIN FILE$
  470 IF FD = 0 THEN PROC_CREATE_DB: FD = OPENIN FILE$
  480 I = 0
  490 REPEAT
  500   INPUT#FD, TASK$
  510   INPUT#FD, STATE$
  520   TASKS$(I) = FN_CLEAN_STR(TASK$)
  530   STATES$(I) = FN_CLEAN_STR(STATE$)
  540   I = I + 1
  550 UNTIL EOF#FD
  560 CLOSE#FD
  570 ENDPROC
  580 :
  590 REM =====================================================================
  600 REM Procedure to save tasks
  610 REM =====================================================================
  620 :
  630 DEF PROC_SAVE_TASKS
  640 LOCAL FD, I
  650 FD = OPENOUT FILE$
  660 IF FD = 0 THEN PRINT "COULD NOT OPEN TASKS FILE": END
  670 FOR I = 0 TO 7
  680   IF TASKS$(I) <> "" AND STATES$(I) <> "" THEN PRINT#FD, LEFT$(TASKS$(I), 39), STATES$(I)
  690 NEXT I
  700 CLOSE#FD
  710 ENDPROC
  720 :
  730 REM =====================================================================
  740 REM Procedure to show tasks
  750 REM =====================================================================
  760 :
  770 DEF PROC_SHOW_TASKS
  780 CLS
  790 PROC_SHOW_TITLE
  800 MOVE 160,860
  810 GCOL 0, 14: DRAW 1120,860
  820 FOR I = 0 TO 7
  830   COLOUR 10: PRINT TAB(10, I + 6) CHR$(65 + I);
  840   COLOUR 7: PRINT " edit  ";
  850   COLOUR 10: PRINT STR$(I + 1);
  860   COLOUR 7: PRINT " toggle" + "  ";
  870   COLOUR 15: PRINT LEFT$(TASKS$(I), 39);
  880   IF STATES$(I) = CHR$(240) THEN COLOUR 10 ELSE COLOUR 9
  890   PRINT TAB(69, I + 6) STATES$(I)
  900   COLOUR 15
  910 NEXT I
  920 MOVE 160,500
  930 GCOL 0, 14: DRAW 1120,500
  940 PROC_SHOW_MENU
  950 VDU 31,10,18
  960 ENDPROC
  970 :
  980 REM =====================================================================
  990 REM Procedure to toggle the state
 1000 REM =====================================================================
 1010 :
 1020 DEF PROC_TOGGLE_STATE(I)
 1030 IF STATES$(I) = CHR$(241) THEN STATES$(I) = CHR$(240) ELSE STATES$(I) = CHR$(241)
 1040 SOUND 1,-7,200,1
 1050 PROC_SAVE_TASKS
 1060 ENDPROC
 1070 :
 1080 REM =====================================================================
 1090 REM Procedure to edit a task
 1100 REM =====================================================================
 1110 :
 1120 DEF PROC_EDIT_TASK(I)
 1130 LOCAL TEXT$
 1140 VDU 23,1,1;0;0;0;
 1150 INPUT "Description"; TEXT$
 1160 TASKS$(I) = TEXT$
 1170 STATES$(I) = CHR$(241)
 1180 PROC_SAVE_TASKS
 1190 VDU 23,1,0;0;0;0;
 1200 ENDPROC
 1210 :
 1220 REM =====================================================================
 1230 REM Procedure to show the title
 1240 REM =====================================================================
 1250 :
 1260 DEF PROC_SHOW_TITLE
 1270 PRINT TAB(33, 1) "TASKS (" + VER$ + ")"
 1280 ENDPROC
 1290 :
 1300 REM =====================================================================
 1310 REM Procedure to show the menu
 1320 REM =====================================================================
 1330 :
 1340 DEF PROC_SHOW_MENU
 1350 COLOUR 10: PRINT TAB(10, 16) CHR$(240);
 1360 COLOUR 7: PRINT " finished task / ";
 1370 COLOUR 9: PRINT CHR$(241);
 1380 COLOUR 7: PRINT " unfinished task / 40 char limit per task"
 1390 COLOUR 10: PRINT TAB(10, 20) "A-H";
 1400 COLOUR 7: PRINT " edit corresponding task"
 1410 COLOUR 10: PRINT TAB(45, 20) "R";
 1420 COLOUR 7: PRINT " reset all tasks from db";
 1430 COLOUR 10: PRINT TAB(10, 21) "1-8";
 1440 COLOUR 7: PRINT " toggle corresponding task"
 1450 COLOUR 10: PRINT TAB(45, 21)"Q";
 1460 COLOUR 7: PRINT " leave the tasks program"
 1470 COLOUR 15: PRINT TAB(34, 25) CHR$(169); " 2024 gluon"
 1480 ENDPROC
 1490 :
 1500 REM =====================================================================
 1510 REM Procedure to create the database
 1520 REM =====================================================================
 1530 :
 1540 DEF PROC_CREATE_DB
 1550 FD = OPENOUT FILE$
 1560 PRINT#FD, ""
 1570 CLOSE#FD
 1580 ENDPROC
 1590 :
 1600 REM =====================================================================
 1610 REM Function to clean a string
 1620 REM =====================================================================
 1630 :
 1640 DEF FN_CLEAN_STR(S$)
 1650 LOCAL C$, I
 1660 C$ = ""
 1670 FOR I = 1 TO LEN(S$)
 1680   IF MID$(S$, I, 1) <> CHR$(10) THEN C$ = C$ + MID$(S$, I, 1)
 1690 NEXT I
 1700 = C$
 1710 ENDDEF
