   10 VER$ = "v0.1.0"
   20 FILE$ = "/.tasks.db"
   30 DIM TASKS$(7), STATES$(7)
   40 VDU 23,240,0,3,7,14,220,248,112,0
   50 VDU 23,241,0,231,102,60,60,102,231,0
   60 :
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
  170   IF OPT$ = "a" OR OPT$ = "A" THEN INPUT "Description"; TEXT$: PROC_EDIT_TASK(0, TEXT$): PROC_SHOW_TASKS
  180   IF OPT$ = "b" OR OPT$ = "B" THEN INPUT "Description"; TEXT$: PROC_EDIT_TASK(1, TEXT$): PROC_SHOW_TASKS
  190   IF OPT$ = "c" OR OPT$ = "C" THEN INPUT "Description"; TEXT$: PROC_EDIT_TASK(2, TEXT$): PROC_SHOW_TASKS
  200   IF OPT$ = "d" OR OPT$ = "D" THEN INPUT "Description"; TEXT$: PROC_EDIT_TASK(3, TEXT$): PROC_SHOW_TASKS
  210   IF OPT$ = "e" OR OPT$ = "E" THEN INPUT "Description"; TEXT$: PROC_EDIT_TASK(4, TEXT$): PROC_SHOW_TASKS
  220   IF OPT$ = "f" OR OPT$ = "F" THEN INPUT "Description"; TEXT$: PROC_EDIT_TASK(5, TEXT$): PROC_SHOW_TASKS
  230   IF OPT$ = "g" OR OPT$ = "G" THEN INPUT "Description"; TEXT$: PROC_EDIT_TASK(6, TEXT$): PROC_SHOW_TASKS
  240   IF OPT$ = "h" OR OPT$ = "H" THEN INPUT "Description"; TEXT$: PROC_EDIT_TASK(7, TEXT$): PROC_SHOW_TASKS
  250   IF OPT$ = "r" OR OPT$ = "R" THEN PROC_CREATE_DB: PROC_READ_TASKS: PROC_SHOW_TASKS
  260 UNTIL OPT$ = "q" OR OPT$ = "Q"
  270 CLS
  280 END
  290 :
  300 DEF PROC_READ_TASKS
  310 LOCAL FD, I, STATE$, TASK$
  320 FOR I = 0 TO 7
  330   TASKS$(I) = ""
  340   STATES$(I) = ""
  350 NEXT I
  360 FD = OPENIN FILE$
  370 IF FD = 0 THEN PROC_CREATE_DB: FD = OPENIN FILE$
  380 I = 0
  390 REPEAT
  400   INPUT#FD, TASK$
  410   INPUT#FD, STATE$
  420   TASKS$(I) = FN_CLEAN_STR(TASK$)
  430   STATES$(I) = FN_CLEAN_STR(STATE$)
  440   I = I + 1
  450 UNTIL EOF#FD
  460 CLOSE#FD
  470 ENDPROC
  480 :
  490 DEF PROC_SAVE_TASKS
  500 LOCAL FD, I
  510 FD = OPENOUT FILE$
  520 IF FD = 0 THEN PRINT "COULD NOT OPEN TASKS FILE": END
  530 FOR I = 0 TO 7
  540   IF TASKS$(I) <> "" AND STATES$(I) <> "" THEN PRINT#FD, LEFT$(TASKS$(I), 39), STATES$(I)
  550 NEXT I
  560 CLOSE#FD
  570 ENDPROC
  580 :
  590 DEF PROC_SHOW_TASKS
  600 CLS
  610 PROC_SHOW_TITLE
  620 MOVE 160,860
  630 GCOL 0, 14: DRAW 1120,860
  640 FOR I = 0 TO 7
  650   COLOUR 10: PRINT TAB(10, I + 6) CHR$(65 + I);
  660   COLOUR 7: PRINT " edit  ";
  670   COLOUR 10: PRINT STR$(I + 1);
  680   COLOUR 7: PRINT " toggle" + "  ";
  690   COLOUR 15: PRINT LEFT$(TASKS$(I), 39);
  700   IF STATES$(I) = CHR$(240) THEN COLOUR 10 ELSE COLOUR 9
  710   PRINT TAB(69, I + 6) STATES$(I)
  720   COLOUR 15
  730 NEXT I
  740 MOVE 160,500
  750 GCOL 0, 14: DRAW 1120,500
  760 PROC_SHOW_MENU
  770 VDU 31,10,18
  780 ENDPROC
  790 :
  800 DEF FN_CLEAN_STR(S$)
  810 LOCAL C$, I
  820 C$ = ""
  830 FOR I = 1 TO LEN(S$)
  840   IF MID$(S$, I, 1) <> CHR$(10) THEN C$ = C$ + MID$(S$, I, 1)
  850 NEXT I
  860 = C$
  870 ENDDEF
  880 :
  890 DEF PROC_TOGGLE_STATE(I)
  900 IF STATES$(I) = CHR$(240) THEN STATES$(I) = CHR$(241) ELSE STATES$(I) = CHR$(240)
  910 SOUND 1,-7,200,1
  920 PROC_SAVE_TASKS
  930 ENDPROC
  940 :
  950 DEF PROC_EDIT_TASK(I, TEXT$)
  960 TASKS$(I) = TEXT$
  970 PROC_SAVE_TASKS
  980 ENDPROC
  990 :
 1000 DEF PROC_SHOW_TITLE
 1010 PRINT TAB(33, 1) "TASKS (" + VER$ + ")"
 1020 ENDPROC
 1030 :
 1040 DEF PROC_SHOW_MENU
 1050 COLOUR 10: PRINT TAB(10, 16) CHR$(240);
 1060 COLOUR 7: PRINT " finished task / ";
 1070 COLOUR 9: PRINT CHR$(241);
 1080 COLOUR 7: PRINT " unfinished task / 40 char limit per task"
 1090 COLOUR 10: PRINT TAB(10, 20) "A-H";
 1100 COLOUR 7: PRINT " edit corresponding task"
 1110 COLOUR 10: PRINT TAB(45, 20) "R";
 1120 COLOUR 7: PRINT " reset all tasks from db";
 1130 COLOUR 10: PRINT TAB(10, 21) "1-8";
 1140 COLOUR 7: PRINT " toggle corresponding task"
 1150 COLOUR 10: PRINT TAB(45, 21)"Q";
 1160 COLOUR 7: PRINT " leave the tasks program"
 1170 COLOUR 15: PRINT TAB(10, 25) CHR$(169); " 2024 by gluon --- https://github.com/vascocosta/agon-tasks"
 1180 ENDPROC
 1190 :
 1200 DEF PROC_CREATE_DB
 1210 FD = OPENOUT FILE$
 1220 PRINT#FD, ""
 1230 CLOSE#FD
 1240 ENDPROC