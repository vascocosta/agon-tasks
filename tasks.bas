   10 VER$ = "v0.3.0"
   20 FILE$ = "/.tasks.db"
   30 DIM TASKS$(7), STATES$(7)
   40 VDU 23,240,0,3,7,14,220,248,112,0
   50 VDU 23,241,0,231,102,60,60,102,231,0
   51 REM
   52 REM =============================================================================================================
   60 REM Main program
   61 REM =============================================================================================================
   62 REM
   70 MODE 3
   80 VDU 23,1,0;0;0;0;
   90 COLOUR 15: COLOUR 132
  100 CLS
  110 PROC_SHOW_TITLE
  120 PROC_READ_TASKS
  130 PROC_SHOW_TASKS
  140 REPEAT
  150   OPT$ = INKEY$(1000)
  160   IF VAL(OPT$) > 0 AND VAL(OPT$) < 9 THEN  PROC_TOGGLE_STATE(VAL(OPT$) - 1): PROC_SHOW_TASKS
  170   IF OPT$ = "a" OR OPT$ = "A" THEN PROC_EDIT_TASK(0): PROC_SHOW_TASKS
  180   IF OPT$ = "b" OR OPT$ = "B" THEN PROC_EDIT_TASK(1): PROC_SHOW_TASKS
  190   IF OPT$ = "c" OR OPT$ = "C" THEN PROC_EDIT_TASK(2): PROC_SHOW_TASKS
  200   IF OPT$ = "d" OR OPT$ = "D" THEN PROC_EDIT_TASK(3): PROC_SHOW_TASKS
  210   IF OPT$ = "e" OR OPT$ = "E" THEN PROC_EDIT_TASK(4): PROC_SHOW_TASKS
  220   IF OPT$ = "f" OR OPT$ = "F" THEN PROC_EDIT_TASK(5): PROC_SHOW_TASKS
  230   IF OPT$ = "g" OR OPT$ = "G" THEN PROC_EDIT_TASK(6): PROC_SHOW_TASKS
  240   IF OPT$ = "h" OR OPT$ = "H" THEN PROC_EDIT_TASK(7): PROC_SHOW_TASKS
  250   IF OPT$ = "r" OR OPT$ = "R" THEN PROC_CREATE_DB: PROC_READ_TASKS: PROC_SHOW_TASKS
  260 UNTIL OPT$ = "q" OR OPT$ = "Q"
  270 CLS
  280 PRINT CHR$(169); " 2024 gluon - https://github.com/vascocosta/agon-tasks"
  290 VDU 23,1,1;0;0;0;
  300 END
  301 REM
  310 REM =============================================================================================================
  311 REM Procedure to read tasks
  312 REM =============================================================================================================
  312 REM
  320 DEF PROC_READ_TASKS
  330 LOCAL FD, I, STATE$, TASK$
  340 FOR I = 0 TO 7
  350   TASKS$(I) = ""
  360   STATES$(I) = ""
  370 NEXT I
  380 FD = OPENIN FILE$
  390 IF FD = 0 THEN PROC_CREATE_DB: FD = OPENIN FILE$
  400 I = 0
  410 REPEAT
  420   INPUT#FD, TASK$
  430   INPUT#FD, STATE$
  440   TASKS$(I) = FN_CLEAN_STR(TASK$)
  450   STATES$(I) = FN_CLEAN_STR(STATE$)
  460   I = I + 1
  470 UNTIL EOF#FD
  480 CLOSE#FD
  490 ENDPROC
  491 REM
  500 REM =============================================================================================================
  501 REM Procedure to save tasks
  502 REM =============================================================================================================
  503 REM
  510 DEF PROC_SAVE_TASKS
  520 LOCAL FD, I
  530 FD = OPENOUT FILE$
  540 IF FD = 0 THEN PRINT "COULD NOT OPEN TASKS FILE": END
  550 FOR I = 0 TO 7
  560   IF TASKS$(I) <> "" AND STATES$(I) <> "" THEN PRINT#FD, LEFT$(TASKS$(I), 39), STATES$(I)
  570 NEXT I
  580 CLOSE#FD
  590 ENDPROC
  591 REM
  592 REM =============================================================================================================
  600 REM Procedure to show tasks
  601 REM =============================================================================================================
  602 REM
  610 DEF PROC_SHOW_TASKS
  620 CLS
  630 PROC_SHOW_TITLE
  640 MOVE 160,860
  650 GCOL 0, 14: DRAW 1120,860
  660 FOR I = 0 TO 7
  670   COLOUR 10: PRINT TAB(10, I + 6) CHR$(65 + I);
  680   COLOUR 7: PRINT " edit  ";
  690   COLOUR 10: PRINT STR$(I + 1);
  700   COLOUR 7: PRINT " toggle" + "  ";
  710   COLOUR 15: PRINT LEFT$(TASKS$(I), 39);
  720   IF STATES$(I) = CHR$(240) THEN COLOUR 10 ELSE COLOUR 9
  730   PRINT TAB(69, I + 6) STATES$(I)
  740   COLOUR 15
  750 NEXT I
  760 MOVE 160,500
  770 GCOL 0, 14: DRAW 1120,500
  780 PROC_SHOW_MENU
  790 VDU 31,10,18
  800 ENDPROC
  810 REM
  811 REM =============================================================================================================
  812 REM Function to clean a string
  813 REM =============================================================================================================
  814 REM
  820 DEF FN_CLEAN_STR(S$)
  830 LOCAL C$, I
  840 C$ = ""
  850 FOR I = 1 TO LEN(S$)
  860   IF MID$(S$, I, 1) <> CHR$(10) THEN C$ = C$ + MID$(S$, I, 1)
  870 NEXT I
  880 = C$
  890 ENDDEF
  900 REM
  901 REM =============================================================================================================
  902 REM Procedure to toggle the state
  903 REM =============================================================================================================
  904 REM
  910 DEF PROC_TOGGLE_STATE(I)
  920 IF STATES$(I) = CHR$(241) THEN STATES$(I) = CHR$(240) ELSE STATES$(I) = CHR$(241)
  930 SOUND 1,-7,200,1
  940 PROC_SAVE_TASKS
  950 ENDPROC
  960 REM
  961 REM =============================================================================================================
  962 REM Procedure to edit a task
  963 REM =============================================================================================================
  964 REM
  970 DEF PROC_EDIT_TASK(I)
  980 LOCAL TEXT$
  990 VDU 23,1,1;0;0;0;
 1000 INPUT "Description"; TEXT$
 1010 TASKS$(I) = TEXT$
 1020 STATES$(I) = CHR$(241)
 1030 PROC_SAVE_TASKS
 1040 VDU 23,1,0;0;0;0;
 1050 ENDPROC
 1060 REM
 1061 REM =============================================================================================================
 1062 REM Procedure to show the title
 1063 REM =============================================================================================================
 1064 REM
 1070 DEF PROC_SHOW_TITLE
 1080 PRINT TAB(33, 1) "TASKS (" + VER$ + ")"
 1090 ENDPROC
 1100 REM
 1101 REM =============================================================================================================
 1102 REM Procedure to show the menu
 1103 REM =============================================================================================================
 1104 REM
 1110 DEF PROC_SHOW_MENU
 1120 COLOUR 10: PRINT TAB(10, 16) CHR$(240);
 1130 COLOUR 7: PRINT " finished task / ";
 1140 COLOUR 9: PRINT CHR$(241);
 1150 COLOUR 7: PRINT " unfinished task / 40 char limit per task"
 1160 COLOUR 10: PRINT TAB(10, 20) "A-H";
 1170 COLOUR 7: PRINT " edit corresponding task"
 1180 COLOUR 10: PRINT TAB(45, 20) "R";
 1190 COLOUR 7: PRINT " reset all tasks from db";
 1200 COLOUR 10: PRINT TAB(10, 21) "1-8";
 1210 COLOUR 7: PRINT " toggle corresponding task"
 1220 COLOUR 10: PRINT TAB(45, 21)"Q";
 1230 COLOUR 7: PRINT " leave the tasks program"
 1240 COLOUR 15: PRINT TAB(34, 25) CHR$(169); " 2024 gluon"
 1250 ENDPROC
 1260 REM
 1261 REM =============================================================================================================
 1263 REM Procedure to create the database
 1264 REM =============================================================================================================
 1265 REM
 1270 DEF PROC_CREATE_DB
 1280 FD = OPENOUT FILE$
 1290 PRINT#FD, ""
 1300 CLOSE#FD
 1310 ENDPROC
