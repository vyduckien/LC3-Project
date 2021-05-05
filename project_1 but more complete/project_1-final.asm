; 2. Write a program to input n (input from keyboard) strings of characters with the length unlimited (it is defined by the program, not by the compiler). 
; Sort them in descending or ascending order depending on the request input.
; Attention: 
; These strings are sorted in ascending/descending by the order of dictionary with deleting 
; redundant characters in each string: blank ' ', comma ',' if they exist in string. 
;
; Author: Vy Duc Kien
; ID: 1951010
; Date: 01/05/2021

;string length: 50
				
	.ORIG	x3000
NEW_BEG	LD	R1, START
	LD	R3, LENGTHS
	LEA	R0, KBINPUT
	PUTS	
	GETC
	;range check
	LD	R2, ZERO
	ADD	R2, R0, R2
	BRn	NEW_BEG
	LD	R2, NINE
	ADD	R2, R0, R2
	BRp	NEW_BEG
	OUT
	LD	R4, ASCII_INVERT
	ADD	R0, R0, R4
	ST	R0, NUMOFSTRINGS
	LD	R4, NUMOFSTRINGS
	BR	#4
NEW_S	LD	R3, LENGTHS
	LD	R1, START_NEW
	ADD	R1, R1, R3
	ADD	R1, R1, #1
	ADD	R4, R4, #-1
	BRn	SORT_LIST
	ST	R1, START_NEW
	LEA	R0, PROMPT	
	PUTS
LOOP	GETC
	LD	R2, ESC		;PRESS ESC TO SORT THE LIST AT ANY TIME
	ADD	R2, R0, R2
	BRz	SORT_LIST
	LD	R2, ENTER
	ADD	R2, R0, R2
	BRz	NEW_S
	OUT
	STR	R0, R1, #0
	ADD	R1, R1, #1
	ADD	R3, R3, #-1
	BRz	NEW_S
	BR	LOOP
SORT_LIST
	JSR	RM_REDUN
	LEA	R0, OPTION	;GET OPTION FROM USER
	PUTS
	GETC
	OUT
	LD	R2, ONE
	ADD	R2, R0, R2
	BRz	AtoZ
	LD	R2, TWO
	ADD	R2, R0, R2
	BRz	ZtoA	
	;SORT THE LIST BY THE BEGINNING CHARACTER FOR EASE OF SORTING IN THE LONG RUN
ZtoA	JSR	SORT_BY_ZA
	;SORT THE LIST FROM THE SECOND CHARACTER
	JSR	SORT_FROM_SEC_ZA
	BR	#2
AtoZ	JSR	SORT_BY_AZ
	JSR	SORT_FROM_SEC_AZ
	;PRINT THE SORTED LIST
	JSR	PR_STRING
	;CLEAR STRING FOR NEXT INPUT
	JSR	CLR_STRING
PRINT	LEA	R0, CONTINUE
	PUTS
	GETC
	OUT
	LD	R2, ONE
	ADD	R2, R0, R2
	BRz	NEW_BEG
	LD	R2, TWO
	ADD	R2, R0, R2
	BRz	FINISH_PROGRAM
	BR	PRINT
FINISH_PROGRAM
	HALT

PR_STRING
	ST	R7, SAVER7_0
	LEA	R0, OUTP	
	PUTS
	LD	R5, LENGTHS
	ADD	R5, R5, #1
	LD	R0, START
	ST	R0, START_NEW
print_next
	LEA	R0, newline
	PUTS
	LD	R0, START_NEW
	PUTS
	ADD	R0, R0, R5
	ST	R0, START_NEW
	LDI	R2, START_NEW
	BRz	DONE
	BRp	print_next
DONE	LD	R7, SAVER7_0
	RET

SAVER7_0	.BLKW	1
ASCII_INVERT	.FILL	X-30
LENGTHS		.FILL	#50
START		.FILL	X4000
END		.FILL	X4033
START_NEW	.FILL	X4000
ESC		.FILL	X-1B
ENTER		.FILL	X-A
ZERO		.FILL	X-30
ONE		.FILL	X-31
TWO		.FILL	X-32
NINE		.FILL	X-39
NUMOFSTRINGS	.BLKW	1
KBINPUT		.STRINGZ "\nEnter number of string: "
PROMPT		.STRINGZ "\nENTER A STRING: "
OPTION		.STRINGZ "\nCHOOSE AN OPTION (1 - 2): "
OUTP		.STRINGZ "\nSORTED ORDER: "
CONTINUE	.STRINGZ "\nContinue? (1 - 2): "
newline		.STRINGZ "\n"

;sort from a - z
SORT_BY_AZ
	ST	R7, SAVER7
	LD	R0, START
	ST	R0, START_ORIG_0
	LD	R0, END
	ST	R0, END_ORIG_0
sort_init
	LD	R0, START_ORIG_0
	ST	R0, START_SORT
	LD	R0, END_ORIG_0
	ST	R0, START_END
begin	LD	R0, START_SORT	;LOAD THE ADDRESS OF THE FIRST CHARACTER IN THE FIRST STRING
	LDR	R1, R0, #0	;LOAD THE FIRST CHARACTER IN THE FIRST STRING
	BRz	swap_word_init
	LD	R0, START_END
	LDR	R2, R0, #0
	BRz	do_this	
	BRz	incre_start
	JSR	COMP		;NEGATE R2 FOR COMPARISON
	ADD	R3, R1, R2
	BRnz	do_this		;IF ALREADY SORTED, POINT TO THE NEXT WORD AND COMPARE. 
				;IF IN THE WRONG ORDER, PROCEED TO SORT
	;init before swapping
swap_word_init
	LD	R5, LENGTH
	LD	R0, START_SORT
	ST	R0, SWAP_START
	LD	R0, START_END
	ST	R0, SWAP_END
	LD	R7, SAVER7
swap_word_0
	LD	R0, SWAP_START
	LDR	R1, R0, #0
	LD	R0, SWAP_END
	LDR	R2, R0, #0
	;SWAP PLACES
	STR	R1, R0, #0
	LD	R0, SWAP_START
	STR	R2, R0, #0
	LD	R0, SWAP_START
	ADD	R0, R0, #1
	ST	R0, SWAP_START
	LD	R0, SWAP_END
	ADD	R0, R0, #1
	ST	R0, SWAP_END
	ADD	R5, R5, #-1
	BRzp	swap_word_0
	BR	sort_init
do_this
	LD	R5, LENGTH
	ADD	R5, R5, #1	;LENGTH DOES NOT INCLUDE NULL TERMINATOR, THUS PLUS 1 TO R5
	LD	R0, START_END
	ADD	R0, R0, R5
	ST	R0, START_END
	LDR	R1, R0, #0
	BRz	incre_start
	BR	begin
incre_start	
	LD	R5, LENGTH
	ADD	R5, R5, #1
	LD	R0, START_ORIG_0
	ADD	R0, R0, R5
	ST	R0, START_ORIG_0
	LDR	R1, R0, #0
	;BRz	finish
	ADD	R0, R0, R5
	ST	R0, END_ORIG_0
	LDR	R1, R0, #0
	BRz	finish
	BR	sort_init
finish	LD	R7, SAVER7
	RET

;sort from z - a
SORT_BY_ZA	
	ST	R7, SAVER7
	LD	R0, START
	ST	R0, START_ORIG_0
	LD	R0, END
	ST	R0, END_ORIG_0
sort_init_1
	LD	R0, START_ORIG_0
	ST	R0, START_SORT
	LD	R0, END_ORIG_0
	ST	R0, START_END
begin_1	LD	R0, START_SORT	;LOAD THE ADDRESS OF THE FIRST CHARACTER IN THE FIRST STRING
	LDR	R1, R0, #0	;LOAD THE FIRST CHARACTER IN THE FIRST STRING
	BRz	swap_word_init_1
	LD	R0, START_END
	LDR	R2, R0, #0
	BRz	do_this_1
	BRz	incre_start_1
	JSR	COMP		;NEGATE R2 FOR COMPARISON
	ADD	R3, R1, R2
	BRzp	do_this_1	;IF ALREADY SORTED, POINT TO THE NEXT WORD AND COMPARE. 
				;IF IN THE WRONG ORDER, PROCEED TO SORT
	;init before swapping
swap_word_init_1
	LD	R5, LENGTH
	LD	R0, START_SORT
	ST	R0, SWAP_START
	LD	R0, START_END
	ST	R0, SWAP_END
	LD	R7, SAVER7
swap_word_1
	LD	R0, SWAP_START
	LDR	R1, R0, #0
	LD	R0, SWAP_END
	LDR	R2, R0, #0
	;SWAP PLACES
	STR	R1, R0, #0
	LD	R0, SWAP_START
	STR	R2, R0, #0
	LD	R0, SWAP_START
	ADD	R0, R0, #1
	ST	R0, SWAP_START
	LD	R0, SWAP_END
	ADD	R0, R0, #1
	ST	R0, SWAP_END
	ADD	R5, R5, #-1
	BRzp	swap_word_1
	BR	sort_init_1
do_this_1
	LD	R5, LENGTH
	ADD	R5, R5, #1	;LENGTH DOES NOT INCLUDE NULL TERMINATOR, THUS PLUS 1 TO R5
	LD	R0, START_END
	ADD	R0, R0, R5
	ST	R0, START_END
	LDR	R1, R0, #0
	BRz	incre_start_1
	BR	begin_1
incre_start_1	
	LD	R5, LENGTH
	ADD	R5, R5, #1
	LD	R0, START_ORIG_0
	ADD	R0, R0, R5
	ST	R0, START_ORIG_0
	LDR	R1, R0, #0
	;BRz	finish_1
	ADD	R0, R0, R5
	ST	R0, END_ORIG_0
	LDR	R1, R0, #0
	BRz	finish
	BR	sort_init_1
finish_1
	LD	R7, SAVER7
	RET

COMP	NOT	R2, R2
	ADD	R2, R2, #1
	RET

START_ORIG_0	.FILL	X4000
START_ORIG_1	.FILL	X4000
END_ORIG_0	.FILL	X4033
END_ORIG_1	.FILL	X4033
LENGTH		.FILL	#50
SAVER7		.BLKW	1

SORT_FROM_SEC_AZ
	ST	R7, SAVER7
	LD	R0, START_CONST
	ST	R0, START_ORIG_1
	LD	R0, END_CONST
	ST	R0, END_ORIG_1
compare_beg_init
	LD	R0, START_ORIG_1
	ST	R0, START_SORT
	LD	R0, END_ORIG_1
	ST	R0, START_END
compare_beg
	LD	R0, START_SORT
	LDR	R1, R0, #0
	ST	R1, BEG_CHAR
	LD	R0, START_END
	LDR	R2, R0, #0
	BRz	increase_start
	JSR	COMP
	ADD	R3, R1, R2 
	BRz	goto_nextchar_init	;if two beginning match, compare next char
	BRn	increase_start
goto_nextchar_init
	LD	R0, START_SORT
	ST	R0, START_SORT_NEXT_CHAR
	LD	R0, START_END
	ST	R0, START_END_NEXT_CHAR
goto_nextchar
	LD	R0, START_SORT_NEXT_CHAR
	ADD	R0, R0, #1
	ST	R0, START_SORT_NEXT_CHAR
	LDR 	R1, R0, #0
	LD	R0, START_END_NEXT_CHAR
	ADD	R0, R0, #1
	ST	R0, START_END_NEXT_CHAR
	LDR	R2, R0, #0
	JSR	COMP
	ADD	R3, R1, R2
	BRz	goto_nextchar		;if two words have the same beginning character, proceed to compare the next characters
	BRn	goto_nextword		;if already sorted, compare next word
;INIT BEFORE SWAPPING
	LD	R5, LENGTH
	LD	R0, START_SORT
	ST	R0, SWAP_START
	LD	R0, START_END
	ST	R0, SWAP_END
	LD	R7, SAVER7
swap_word
	LD	R0, SWAP_START
	LDR	R1, R0, #0
	LD	R0, SWAP_END
	LDR	R2, R0, #0
	;SWAP PLACES
	STR	R1, R0, #0
	LD	R0, SWAP_START
	STR	R2, R0, #0
	;INCREASE SWAP ADDRESS
	LD	R0, SWAP_START
	ADD	R0, R0, #1
	ST	R0, SWAP_START
	LD	R0, SWAP_END
	ADD	R0, R0, #1
	ST	R0, SWAP_END
	ADD	R5, R5, #-1
	BRzp	swap_word
	BR	compare_beg_init
goto_nextword
	LD	R5, LENGTH
	ADD	R5, R5, #1
	LD	R0, START_END
	ADD	R0, R0, R5
	ST	R0, START_END
	LDR	R1, R0, #0
	LD	R2, BEG_CHAR
	JSR	COMP
	ADD	R3, R1, R2
	BRz  	compare_beg
	BRp	increase_start	
increase_start
	LD	R5, LENGTH
	ADD	R5, R5, #1
	LD	R0, START_ORIG_1
	ADD	R0, R0, R5
	ST	R0, START_ORIG_1
	LDR	R1, R0, #0
	BRz	finish_sort_from_sec
	ADD	R0, R0, R5
	ST	R0, END_ORIG_1
	LDR	R1, R0, #0
	BRz	finish_sort_from_sec	;IF REACHED NULL STRING, FINISH SORTING
	BR	compare_beg_init
finish_sort_from_sec
	LD	R7, SAVER7
	RET

START_SORT		.FILL	X4000
START_SORT_NEXT_CHAR	.FILL	X4000
START_END		.FILL	X4033
START_END_NEXT_CHAR	.FILL	X4033
SWAP_START		.FILL	X4000
SWAP_END		.FILL	X4033
START_CONST		.FILL	X4000
END_CONST		.FILL	X4033

SORT_FROM_SEC_ZA
	ST	R7, SAVER7
	LD	R0, START_CONST
	ST	R0, START_ORIG_1
	LD	R0, END_CONST
	ST	R0, END_ORIG_1
compare_beg_init_1
	LD	R0, START_ORIG_1
	ST	R0, START_SORT
	LD	R0, END_ORIG_1
	ST	R0, START_END
compare_beg_1
	LD	R0, START_SORT
	LDR	R1, R0, #0
	ST	R1, BEG_CHAR
	LD	R0, START_END
	LDR	R2, R0, #0
	BRz	increase_start_1
	JSR	COMP
	ADD	R3, R1, R2 
	BRz	goto_nextchar_init_1	;if two beginning match, compare next char
	BRp	increase_start_1
goto_nextchar_init_1
	LD	R0, START_SORT
	ST	R0, START_SORT_NEXT_CHAR
	LD	R0, START_END
	ST	R0, START_END_NEXT_CHAR
goto_nextchar_1
	LD	R0, START_SORT_NEXT_CHAR
	ADD	R0, R0, #1
	ST	R0, START_SORT_NEXT_CHAR
	LDR 	R1, R0, #0

	LD	R0, START_END_NEXT_CHAR
	ADD	R0, R0, #1
	ST	R0, START_END_NEXT_CHAR
	LDR	R2, R0, #0
	JSR	COMP
	ADD	R3, R1, R2
	BRz	goto_nextchar_1	;if two words have the same beginning character, proceed to compare the next characters
	BRp	goto_nextword_1	;if already sorted, compare next word
;INIT BEFORE SWAPPING
	LD	R5, LENGTH
	LD	R0, START_SORT
	ST	R0, SWAP_START
	LD	R0, START_END
	ST	R0, SWAP_END
	LD	R7, SAVER7
swap_sec_1
	LD	R0, SWAP_START
	LDR	R1, R0, #0
	LD	R0, SWAP_END
	LDR	R2, R0, #0
	;SWAP PLACES
	STR	R1, R0, #0
	LD	R0, SWAP_START
	STR	R2, R0, #0
	
	;INCREASE SWAP ADDRESS
	LD	R0, SWAP_START
	ADD	R0, R0, #1
	ST	R0, SWAP_START
	LD	R0, SWAP_END
	ADD	R0, R0, #1
	ST	R0, SWAP_END
	ADD	R5, R5, #-1
	BRzp	swap_sec_1
	BR	compare_beg_init_1
goto_nextword_1
	LD	R5, LENGTH
	ADD	R5, R5, #1
	LD	R0, START_END
	ADD	R0, R0, R5
	ST	R0, START_END
	LDR	R1, R0, #0
	LD	R2, BEG_CHAR
	JSR	COMP
	ADD	R3, R1, R2
	BRz  	compare_beg_1
	BRn	increase_start_1	
increase_start_1
	LD	R5, LENGTH
	ADD	R5, R5, #1
	LD	R0, START_ORIG_1
	ADD	R0, R0, R5
	ST	R0, START_ORIG_1
	LDR	R1, R0, #0
	BRz	finish_sort_from_sec_1
	ADD	R0, R0, R5
	ST	R0, END_ORIG_1
	LDR	R1, R0, #0
	BRz	finish_sort_from_sec_1	;IF REACHED NULL STRING, FINISH SORTING
	BR	compare_beg_init_1
finish_sort_from_sec_1
	LD	R7, SAVER7
	RET

BEG_CHAR	.BLKW	1

RM_REDUN
	ST	R7, SAVER7
	LD	R0, START_RM_CONST
	ST	R0, START_RM
	LD	R0, END_RM_CONST
	ST	R0, END_RM
rm_init	LD	R0, START_RM
load_0	LDR	R1, R0, #0
	LD	R2, zero
	ADD	R2, R1, R2
	BRn	crossout	;if a redundant, remove
	LD	R2, nine
	ADD	R2, R1, R2
	BRnz	load_next	;if in range 0 - 9, load next index
	LD	R2, A	
	ADD	R2, R1, R2	
	BRn	crossout
	LD	R2, Z	
	ADD	R2, R1, R2	
	BRnz	load_next
	LD	R2, a
	ADD	R2, R1, R2
	BRn	crossout	;if Z < R1 < a, remove
	LD	R2, z
	ADD	R2, R1, R2
	BRnz	load_next	;if a < R1 < z, load next index
crossout
	AND	R1, R1, #0
	STR	R1, R0, #0
	ADD	R0, R0, #1
	LD	R2, END_RM
	ADD	R2, R0, R2
	BRnz	load_0
load_next 
	ADD	R0, R0, #1
	LD	R2, END_RM
	ADD	R2, R0, R2
	BRnz	load_0
shift_init
	LD	R0, START_RM
	AND	R3, R3, #0	;null counter
	LD	R2, END_RM
	ADD	R2, R0, R2
	BRz	done_rm		;if START = END (string contains only redundant characters), return
;shift the remaining characters to the left
shift	LDR	R1, R0, #0
	BRnp	#5
	LDR	R1, R0, #1
	STR	R1, R0, #0
	ADD	R3, R3, #1
	AND	R1, R1, #0
	STR	R1, R0, #1	;remove index
	ADD	R0, R0, #1
	LD	R2, END_RM
	ADD	R2, R0, R2
	BRnz	shift
	ADD	R3, R3, #0
	BRz	done_rm
	ADD	R0, R0, #-2
	NOT	R0, R0
	ADD	R0, R0, #1	
	ST	R0, END_RM
	BR	shift_init
done_rm	
	LD	R5, LENGTH
	ADD	R5, R5, #1
	LD	R0, START_RM
	ADD	R0, R0, R5
	ST	R0, START_RM
	LDR	R1, R0, #0
	BRz	finish_rm
	LD	R0, END_RM
	NOT	R5, R5
	ADD	R5, R5, #-1
	ADD	R0, R0, R5
	ST	R0, END_RM
	BR	rm_init
finish_rm
	LD	R7, SAVER7
	RET

;clear string for next input
CLR_STRING
	LD	R0, START_CLR
CLR	LDR	R1, R0, #0
	AND	R1, R1, #0
	STR	R1, R0, #0
	ADD	R0, R0, #1
	LD	R2, END_ClR
	ADD	R2, R0, R2
	BRnz	CLR		;erase next character
	RET

START_CLR	.FILL	X4000
END_ClR		.FILL	X-7DFF
START_RM_CONST	.FILL	X4000
START_RM	.FILL	X4000
END_RM_CONST	.FILL	X-4031
END_RM		.FILL	X-4031
A		.FILL	x-41
Z		.FILL	X-5A
a		.FILL	X-61
z		.FILL	X-7A
nine		.FILL	x-39
zero		.FILL	x-30
	.END