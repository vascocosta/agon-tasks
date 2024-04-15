  10 REM =====================================================================
  20 REM TASKS - Copyright (c) 2024 Vasco Costa (gluon)
  30 REM Simple tasks/todo list program for the Agon Light 8-bit computer
  40 REM =====================================================================
  50 :
  60 REM =====================================================================
  70 REM Global definitions
  80 REM =====================================================================
  90 :
 100 VER$ = "v1.0.0"
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
 470 REM IMPORT INTERFACE.BAS
 480 REM =====================================================================
 490 :
 500 REM =====================================================================
 510 REM Procedure to show tasks
 520 REM =====================================================================
 530 :
 540 DEF PROC_SHOW_TASKS
 550 MOVE 160,860
 560 GCOL 0, 14: DRAW 1120,860
 570 FOR I = 0 TO 7
 580   COLOUR 10: PRINT TAB(10, I + 6) CHR$(65 + I);
 590   COLOUR 7: PRINT " edit  ";
 600   COLOUR 10: PRINT STR$(I + 1);
 610   COLOUR 7: PRINT " toggle" + "  ";
 620   COLOUR 15: PRINT LEFT$(TASKS$(I), 39);
 630   FOR J = 1 TO (39 - LEN(TASKS$(I)))
 640     PRINT " ";
 650   NEXT J
 660   IF STATES$(I) = CHR$(240) THEN COLOUR 10 ELSE COLOUR 9
 670   PRINT TAB(69, I + 6) STATES$(I)
 680   COLOUR 15
 690 NEXT I
 700 MOVE 160,500
 710 GCOL 0, 14: DRAW 1120,500
 720 ENDPROC
 730 :
 740 REM =====================================================================
 750 REM Procedure to toggle the state
 760 REM =====================================================================
 770 :
 780 DEF PROC_TOGGLE_STATE(I)
 790 IF STATES$(I) = CROSS$ THEN STATES$(I) = TICK$ ELSE STATES$(I) = CROSS$
 800 SOUND 1,-7,200,1
 810 PROC_SAVE_TASKS
 820 ENDPROC
 830 :
 840 REM =====================================================================
 850 REM Procedure to edit a task
 860 REM =====================================================================
 870 :
 880 DEF PROC_EDIT_TASK(I)
 890 LOCAL TEXT$, BLANK$, LT
 900 VDU 23,1,1;0;0;0;
 910 INPUT TAB(10, 18); "Description"; TEXT$
 920 BLANK$ = "                                                            "
 930 PRINT TAB(10,18); BLANK$
 940 TASKS$(I) = TEXT$
 950 STATES$(I) = CHR$(241)
 960 PROC_SAVE_TASKS
 970 VDU 23,1,0;0;0;0;
 980 LT = LEN(TEXT$)
 990 IF LT > 47 THEN PROC_SHOW_APP
1000 ENDPROC
1010 :
1020 REM =====================================================================
1030 REM Procedure to show the title
1040 REM =====================================================================
1050 :
1060 DEF PROC_SHOW_TITLE
1070 PRINT TAB(33, 1) "TASKS (" + VER$ + ")"
1080 ENDPROC
1090 :
1100 REM =====================================================================
1110 REM Procedure to show the menu
1120 REM =====================================================================
1130 :
1140 DEF PROC_SHOW_MENU
1150 COLOUR 10: PRINT TAB(10, 16) CHR$(240);
1160 COLOUR 7: PRINT " finished task / ";
1170 COLOUR 9: PRINT CHR$(241);
1180 COLOUR 7: PRINT " unfinished task / 40 char limit per task"
1190 COLOUR 10: PRINT TAB(10, 20) "A-H";
1200 COLOUR 7: PRINT " edit corresponding task"
1210 COLOUR 10: PRINT TAB(45, 20) "R";
1220 COLOUR 7: PRINT " reset all tasks from db";
1230 COLOUR 10: PRINT TAB(10, 21) "1-8";
1240 COLOUR 7: PRINT " toggle corresponding task"
1250 COLOUR 10: PRINT TAB(45, 21)"Q";
1260 COLOUR 7: PRINT " leave the tasks program"
1270 COLOUR 15: PRINT TAB(34, 25) CHR$(169); " 2024 gluon"
1280 ENDPROC
1290 :
1300 REM =====================================================================
1310 REM Procedure to show the app
1320 REM =====================================================================
1330 :
1340 DEF PROC_SHOW_APP
1350 CLS
1360 PROC_READ_TASKS
1370 PROC_SHOW_TITLE
1380 PROC_SHOW_TASKS
1390 PROC_SHOW_MENU
1400 ENDPROC
1410 :
1420 REM =====================================================================
1430 REM IMPORT UTILS.BAS
1440 REM =====================================================================
1450 :
1460 REM =====================================================================
1470 REM Function to clean a string
1480 REM =====================================================================
1490 :
1500 DEF FN_CLEAN_STR(S$)
1510 LOCAL C$, I
1520 C$ = ""
1530 FOR I = 1 TO LEN(S$)
1540   IF MID$(S$, I, 1) <> CHR$(10) THEN C$ = C$ + MID$(S$, I, 1)
1550 NEXT I
1560 = C$
1570 ENDDEF
1580 :
1590 REM =====================================================================
1600 REM IMPORT DATA.BAS
1610 REM =====================================================================
1620 :
1630 REM =====================================================================
1640 REM Procedure to read tasks
1650 REM =====================================================================
1660 :
1670 DEF PROC_READ_TASKS
1680 LOCAL FD, I, STATE$, TASK$
1690 FOR I = 0 TO 7
1700   TASKS$(I) = ""
1710   STATES$(I) = ""
1720 NEXT I
1730 FD = OPENIN FILE$
1740 IF FD = 0 THEN PROC_CREATE_DB: FD = OPENIN FILE$
1750 I = 0
1760 REPEAT
1770   INPUT#FD, TASK$
1780   INPUT#FD, STATE$
1790   TASKS$(I) = FN_CLEAN_STR(TASK$)
1800   STATES$(I) = FN_CLEAN_STR(STATE$)
1810   I = I + 1
1820 UNTIL EOF#FD
1830 CLOSE#FD
1840 ENDPROC
1850 :
1860 REM =====================================================================
1870 REM Procedure to save tasks
1880 REM =====================================================================
1890 :
1900 DEF PROC_SAVE_TASKS
1910 LOCAL FD, I, T$
1920 FD = OPENOUT FILE$
1930 IF FD = 0 THEN PRINT "COULD NOT OPEN TASKS FILE": END
1940 FOR I = 0 TO 7
1950   T$ = LEFT$(TASKS$(I), 39)
1960   IF TASKS$(I) <> "" AND STATES$(I) <> "" THEN PRINT#FD, T$, STATES$(I)
1970 NEXT I
1980 CLOSE#FD
1990 ENDPROC
2000 :
2010 REM =====================================================================
2020 REM Procedure to create the database
2030 REM =====================================================================
2040 :
2050 DEF PROC_CREATE_DB
2060 FD = OPENOUT FILE$
2070 PRINT#FD, ""
2080 CLOSE#FD
2090 ENDPROC
