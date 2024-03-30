   10 REM =====================================================================
   20 REM TASKS - Copyright (c) 2024 Vasco Costa (gluon)
   30 REM Simple tasks/todo list program for the Agon Light 8-bit computer
   40 REM =====================================================================
   50 :
   60 REM =====================================================================
   70 REM Global definitions
   80 REM =====================================================================
   90 :
  100 VER$ = "v0.3.2"
  110 FILE$ = "/.tasks.db"
  120 DIM TASKS$(7), STATES$(7)
  130 TICK$ = CHR$(240)
  140 CROSS$ = CHR$(241)
  150 VDU 23,240,0,3,7,14,220,248,112,0
  160 VDU 23,241,0,231,102,60,60,102,231,0
  170 :
  180 REM =====================================================================
  190 REM Main program
  200 REM =====================================================================
  210 :
  220 MODE 3
  230 VDU 23,1,0;0;0;0;
  240 COLOUR 15: COLOUR 132
  250 CLS
  260 PROC_SHOW_TITLE
  270 PROC_READ_TASKS
  280 PROC_SHOW_TASKS
  290 REPEAT
  300   K$ = GET$
  310   V = VAL(K$)
  320   IF ASC(K$) < 97 THEN K$ = CHR$(ASC(K$) + 32)
  330   IF V > 0 AND V < 9 THEN  PROC_TOGGLE_STATE(V - 1): PROC_SHOW_TASKS
  340   IF K$ = "a" THEN PROC_EDIT_TASK(0): PROC_SHOW_TASKS
  350   IF K$ = "b" THEN PROC_EDIT_TASK(1): PROC_SHOW_TASKS
  360   IF K$ = "c" THEN PROC_EDIT_TASK(2): PROC_SHOW_TASKS
  370   IF K$ = "d" THEN PROC_EDIT_TASK(3): PROC_SHOW_TASKS
  380   IF K$ = "e" THEN PROC_EDIT_TASK(4): PROC_SHOW_TASKS
  390   IF K$ = "f" THEN PROC_EDIT_TASK(5): PROC_SHOW_TASKS
  400   IF K$ = "g" THEN PROC_EDIT_TASK(6): PROC_SHOW_TASKS
  410   IF K$ = "h" THEN PROC_EDIT_TASK(7): PROC_SHOW_TASKS
  420   IF K$ = "r" THEN PROC_CREATE_DB: PROC_READ_TASKS: PROC_SHOW_TASKS
  430 UNTIL K$ = "q"
  440 CLS
  450 PRINT CHR$(169); " 2024 gluon - https://github.com/vascocosta/agon-tasks"
  460 VDU 23,1,1;0;0;0;
  470 END
  480 :
  490 REM =====================================================================
  500 REM Procedure to read tasks
  510 REM =====================================================================
  520 :
  530 DEF PROC_READ_TASKS
  540 LOCAL FD, I, STATE$, TASK$
  550 FOR I = 0 TO 7
  560   TASKS$(I) = ""
  570   STATES$(I) = ""
  580 NEXT I
  590 FD = OPENIN FILE$
  600 IF FD = 0 THEN PROC_CREATE_DB: FD = OPENIN FILE$
  610 I = 0
  620 REPEAT
  630   INPUT#FD, TASK$
  640   INPUT#FD, STATE$
  650   TASKS$(I) = FN_CLEAN_STR(TASK$)
  660   STATES$(I) = FN_CLEAN_STR(STATE$)
  670   I = I + 1
  680 UNTIL EOF#FD
  690 CLOSE#FD
  700 ENDPROC
  710 :
  720 REM =====================================================================
  730 REM Procedure to save tasks
  740 REM =====================================================================
  750 :
  760 DEF PROC_SAVE_TASKS
  770 LOCAL FD, I, T$
  780 FD = OPENOUT FILE$
  790 IF FD = 0 THEN PRINT "COULD NOT OPEN TASKS FILE": END
  800 FOR I = 0 TO 7
  810   T$ = LEFT$(TASKS$(I), 39)
  820   IF TASKS$(I) <> "" AND STATES$(I) <> "" THEN PRINT#FD, T$, STATES$(I)
  830 NEXT I
  840 CLOSE#FD
  850 ENDPROC
  860 :
  870 REM =====================================================================
  880 REM Procedure to show tasks
  890 REM =====================================================================
  900 :
  910 DEF PROC_SHOW_TASKS
  920 CLS
  930 PROC_SHOW_TITLE
  940 MOVE 160,860
  950 GCOL 0, 14: DRAW 1120,860
  960 FOR I = 0 TO 7
  970   COLOUR 10: PRINT TAB(10, I + 6) CHR$(65 + I);
  980   COLOUR 7: PRINT " edit  ";
  990   COLOUR 10: PRINT STR$(I + 1);
 1000   COLOUR 7: PRINT " toggle" + "  ";
 1010   COLOUR 15: PRINT LEFT$(TASKS$(I), 39);
 1020   IF STATES$(I) = CHR$(240) THEN COLOUR 10 ELSE COLOUR 9
 1030   PRINT TAB(69, I + 6) STATES$(I)
 1040   COLOUR 15
 1050 NEXT I
 1060 MOVE 160,500
 1070 GCOL 0, 14: DRAW 1120,500
 1080 PROC_SHOW_MENU
 1090 VDU 31,10,18
 1100 ENDPROC
 1110 :
 1120 REM =====================================================================
 1130 REM Procedure to toggle the state
 1140 REM =====================================================================
 1150 :
 1160 DEF PROC_TOGGLE_STATE(I)
 1170 IF STATES$(I) = CROSS$ THEN STATES$(I) = TICK$ ELSE STATES$(I) = CROSS$
 1180 SOUND 1,-7,200,1
 1190 PROC_SAVE_TASKS
 1200 ENDPROC
 1210 :
 1220 REM =====================================================================
 1230 REM Procedure to edit a task
 1240 REM =====================================================================
 1250 :
 1260 DEF PROC_EDIT_TASK(I)
 1270 LOCAL TEXT$
 1280 VDU 23,1,1;0;0;0;
 1290 INPUT "Description"; TEXT$
 1300 TASKS$(I) = TEXT$
 1310 STATES$(I) = CHR$(241)
 1320 PROC_SAVE_TASKS
 1330 VDU 23,1,0;0;0;0;
 1340 ENDPROC
 1350 :
 1360 REM =====================================================================
 1370 REM Procedure to show the title
 1380 REM =====================================================================
 1390 :
 1400 DEF PROC_SHOW_TITLE
 1410 PRINT TAB(33, 1) "TASKS (" + VER$ + ")"
 1420 ENDPROC
 1430 :
 1440 REM =====================================================================
 1450 REM Procedure to show the menu
 1460 REM =====================================================================
 1470 :
 1480 DEF PROC_SHOW_MENU
 1490 COLOUR 10: PRINT TAB(10, 16) CHR$(240);
 1500 COLOUR 7: PRINT " finished task / ";
 1510 COLOUR 9: PRINT CHR$(241);
 1520 COLOUR 7: PRINT " unfinished task / 40 char limit per task"
 1530 COLOUR 10: PRINT TAB(10, 20) "A-H";
 1540 COLOUR 7: PRINT " edit corresponding task"
 1550 COLOUR 10: PRINT TAB(45, 20) "R";
 1560 COLOUR 7: PRINT " reset all tasks from db";
 1570 COLOUR 10: PRINT TAB(10, 21) "1-8";
 1580 COLOUR 7: PRINT " toggle corresponding task"
 1590 COLOUR 10: PRINT TAB(45, 21)"Q";
 1600 COLOUR 7: PRINT " leave the tasks program"
 1610 COLOUR 15: PRINT TAB(34, 25) CHR$(169); " 2024 gluon"
 1620 ENDPROC
 1630 :
 1640 REM =====================================================================
 1650 REM Procedure to create the database
 1660 REM =====================================================================
 1670 :
 1680 DEF PROC_CREATE_DB
 1690 FD = OPENOUT FILE$
 1700 PRINT#FD, ""
 1710 CLOSE#FD
 1720 ENDPROC
 1730 :
 1740 REM =====================================================================
 1750 REM Function to clean a string
 1760 REM =====================================================================
 1770 :
 1780 DEF FN_CLEAN_STR(S$)
 1790 LOCAL C$, I
 1800 C$ = ""
 1810 FOR I = 1 TO LEN(S$)
 1820   IF MID$(S$, I, 1) <> CHR$(10) THEN C$ = C$ + MID$(S$, I, 1)
 1830 NEXT I
 1840 = C$
 1850 ENDDEF
