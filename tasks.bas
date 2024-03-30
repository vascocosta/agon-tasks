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
  250 PROC_SHOW_APP
  260 REPEAT
  270   K$ = GET$
  280   V = VAL(K$)
  290   IF ASC(K$) < 97 THEN K$ = CHR$(ASC(K$) + 32)
  300   IF V > 0 AND V < 9 THEN  PROC_TOGGLE_STATE(V - 1): PROC_SHOW_TASKS
  310   IF K$ = "a" THEN PROC_EDIT_TASK(0): PROC_SHOW_TASKS
  320   IF K$ = "b" THEN PROC_EDIT_TASK(1): PROC_SHOW_TASKS
  330   IF K$ = "c" THEN PROC_EDIT_TASK(2): PROC_SHOW_TASKS
  340   IF K$ = "d" THEN PROC_EDIT_TASK(3): PROC_SHOW_TASKS
  350   IF K$ = "e" THEN PROC_EDIT_TASK(4): PROC_SHOW_TASKS
  360   IF K$ = "f" THEN PROC_EDIT_TASK(5): PROC_SHOW_TASKS
  370   IF K$ = "g" THEN PROC_EDIT_TASK(6): PROC_SHOW_TASKS
  380   IF K$ = "h" THEN PROC_EDIT_TASK(7): PROC_SHOW_TASKS
  390   IF K$ = "r" THEN PROC_CREATE_DB: PROC_SHOW_APP
  400 UNTIL K$ = "q"
  410 CLS
  420 PRINT CHR$(169); " 2024 gluon - https://github.com/vascocosta/agon-tasks"
  430 VDU 23,1,1;0;0;0;
  440 END
  450 :
  460 REM =====================================================================
  470 REM Procedure to read tasks
  480 REM =====================================================================
  490 :
  500 DEF PROC_READ_TASKS
  510 LOCAL FD, I, STATE$, TASK$
  520 FOR I = 0 TO 7
  530   TASKS$(I) = ""
  540   STATES$(I) = ""
  550 NEXT I
  560 FD = OPENIN FILE$
  570 IF FD = 0 THEN PROC_CREATE_DB: FD = OPENIN FILE$
  580 I = 0
  590 REPEAT
  600   INPUT#FD, TASK$
  610   INPUT#FD, STATE$
  620   TASKS$(I) = FN_CLEAN_STR(TASK$)
  630   STATES$(I) = FN_CLEAN_STR(STATE$)
  640   I = I + 1
  650 UNTIL EOF#FD
  660 CLOSE#FD
  670 ENDPROC
  680 :
  690 REM =====================================================================
  700 REM Procedure to save tasks
  710 REM =====================================================================
  720 :
  730 DEF PROC_SAVE_TASKS
  740 LOCAL FD, I, T$
  750 FD = OPENOUT FILE$
  760 IF FD = 0 THEN PRINT "COULD NOT OPEN TASKS FILE": END
  770 FOR I = 0 TO 7
  780   T$ = LEFT$(TASKS$(I), 39)
  790   IF TASKS$(I) <> "" AND STATES$(I) <> "" THEN PRINT#FD, T$, STATES$(I)
  800 NEXT I
  810 CLOSE#FD
  820 ENDPROC
  830 :
  840 REM =====================================================================
  850 REM Procedure to show tasks
  860 REM =====================================================================
  870 :
  880 DEF PROC_SHOW_TASKS
  890 MOVE 160,860
  900 GCOL 0, 14: DRAW 1120,860
  910 FOR I = 0 TO 7
  920   COLOUR 10: PRINT TAB(10, I + 6) CHR$(65 + I);
  930   COLOUR 7: PRINT " edit  ";
  940   COLOUR 10: PRINT STR$(I + 1);
  950   COLOUR 7: PRINT " toggle" + "  ";
  960   COLOUR 15: PRINT LEFT$(TASKS$(I), 39);
  970   FOR J = 1 TO (39 - LEN(TASKS$(I)))
  980     PRINT " ";
  990   NEXT J
 1000   IF STATES$(I) = CHR$(240) THEN COLOUR 10 ELSE COLOUR 9
 1010   PRINT TAB(69, I + 6) STATES$(I)
 1020   COLOUR 15
 1030 NEXT I
 1040 MOVE 160,500
 1050 GCOL 0, 14: DRAW 1120,500
 1060 ENDPROC
 1070 :
 1080 REM =====================================================================
 1090 REM Procedure to toggle the state
 1100 REM =====================================================================
 1110 :
 1120 DEF PROC_TOGGLE_STATE(I)
 1130 IF STATES$(I) = CROSS$ THEN STATES$(I) = TICK$ ELSE STATES$(I) = CROSS$
 1140 SOUND 1,-7,200,1
 1150 PROC_SAVE_TASKS
 1160 ENDPROC
 1170 :
 1180 REM =====================================================================
 1190 REM Procedure to edit a task
 1200 REM =====================================================================
 1210 :
 1220 DEF PROC_EDIT_TASK(I)
 1230 LOCAL TEXT$, BLANK$, LT
 1240 VDU 23,1,1;0;0;0;
 1250 INPUT TAB(10, 18); "Description"; TEXT$
 1260 BLANK$ = "                                                            "
 1270 PRINT TAB(10,18); BLANK$
 1280 TASKS$(I) = TEXT$
 1290 STATES$(I) = CHR$(241)
 1300 PROC_SAVE_TASKS
 1310 VDU 23,1,0;0;0;0;
 1320 LT = LEN(TEXT$)
 1330 IF LT > 47 THEN PROC_SHOW_APP
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
 1650 REM Procedure to show the app
 1660 REM =====================================================================
 1670 :
 1680 DEF PROC_SHOW_APP
 1690 CLS
 1700 PROC_READ_TASKS
 1710 PROC_SHOW_TITLE
 1720 PROC_SHOW_TASKS
 1730 PROC_SHOW_MENU
 1740 ENDPROC
 1750 :
 1760 REM =====================================================================
 1770 REM Procedure to create the database
 1780 REM =====================================================================
 1790 :
 1800 DEF PROC_CREATE_DB
 1810 FD = OPENOUT FILE$
 1820 PRINT#FD, ""
 1830 CLOSE#FD
 1840 ENDPROC
 1850 :
 1860 REM =====================================================================
 1870 REM Function to clean a string
 1880 REM =====================================================================
 1890 :
 1900 DEF FN_CLEAN_STR(S$)
 1910 LOCAL C$, I
 1920 C$ = ""
 1930 FOR I = 1 TO LEN(S$)
 1940   IF MID$(S$, I, 1) <> CHR$(10) THEN C$ = C$ + MID$(S$, I, 1)
 1950 NEXT I
 1960 = C$
 1970 ENDDEF
