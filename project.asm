; 2. Write a program to input n (input from keyboard) strings of characters with the length unlimited (it is defined by the program, not by the compiler). 
; Sort them in descending or ascending order depending on the request input.
; Attention: 
; These strings are sorted in ascending/descending by the order of dictionary with deleting 
<<<<<<< HEAD
; redundant characters in each string: blank ' ', comma ',' if they exist in string. 



;string length: 50
				
	.ORIG	x3000
	LEA	R0, WELCOME
	PUTS
	WELCOME		.STRINGZ "\n                  --------WELCOME TO THE LC-3 PROJECT--------"
	LEA	R0, OPTION_0
	PUTS
	OPTION_0	.STRINGZ "\n\nPRESS ENTER TO PROCEED, OR PRESS ESC TO EXIT."
	GETC			;#-8
	LD	R2, ENTER
	ADD	R2, R0, R2
	BRz	NEW_BEG
	LD	R2, ESC
	ADD	R2, R0, R2
	BRz	FINISH_PROGRAM
	BR	#-8
NEW_BEG	
	;CLEAR STRING FOR NEXT INPUT
	JSR	CLR_STRING
	LD	R1, START
	LD	R3, LENGTH_STR
	LEA	R0, NUMSTR_INPUT
	PUTS	
	GETC		
	;range check
	LD	R2, ZERO
	ADD	R2, R0, R2
	BRn	#4			;if not a number, make user re-enter number
	LD	R2, NINE
	ADD	R2, R0, R2
	BRp	#-7
	OUT
	LD	R4, ASCII_INVERT
	ADD	R0, R0, R4
	ST	R0, NUMOFSTRINGS	;store the number of strings for sorting
	LD	R4, NUMOFSTRINGS	
	BR	#4
NEW_STR	LD	R3, LENGTH_STR
	LD	R1, START_NEW
	ADD	R1, R1, R3
	ADD	R1, R1, #1
	ADD	R4, R4, #-1
	BRn	SORT_LIST
	ST	R1, START_NEW
	LEA	R0, PROMPT	
	PUTS
LOOP	GETC
	LD	R2, ESC		;press Esc to sort without typing all strings
	ADD	R2, R0, R2
	BRz	SORT_LIST
	LD	R2, ENTER
	ADD	R2, R0, R2
	BRz	NEW_STR
	OUT
	STR	R0, R1, #0
	ADD	R1, R1, #1
	ADD	R3, R3, #-1
	BRz	NEW_STR
	BR	LOOP
SORT_LIST
	JSR	RM_REDUN	;remove redundant characters
	LEA	R0, OPT_choose	
	PUTS
	LEA 	R0, OPT_1
	PUTS
	LEA	R0, OPT_2
	PUTS
	LEA	R0, OPTION	;ask user for sorting option
	PUTS
	GETC
	LD	R2, ONE
	ADD	R2, R0, R2
	BRz	AtoZ
	LD	R2, TWO
	ADD	R2, R0, R2
	BRz	ZtoA
	BR	#-8

;SORT THE LIST BY THE BEGINNING CHARACTER FOR EASE OF SORTING IN THE LONG RUN
ZtoA	OUT
	JSR	check_for_only_null
	;SORT THE LIST FROM THE SECOND CHARACTER
	JSR	SORT_FROM_SEC_ZA
	BR	PR_STRING
AtoZ	OUT
	JSR	check_for_only_null
	JSR	SORT_FROM_SEC_AZ

;PRINT THE SORTED LIST
PR_STRING
	LEA	R0, OUTP	
	PUTS
	LD	R5, LENGTH_STR
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
	BRz	PRINT
	BRp	print_next

;ASK IF USER WANTS TO CONTINUE THE PROGRAM
PRINT	LEA	R0, CONTINUE
	PUTS
	LEA	R0, OPTION
	PUTS
	GETC
	OUT
	LD	R2, ONE
	ADD	R2, R0, R2	
	BRz	NEW_BEG		;if pressed 1, to back to the beginning 
	LD	R2, ZERO
	ADD	R2, R0, R2
	BRz	FINISH_PROGRAM	;if pressed 0, exit the program
	BR	#-11		;if pressed neither 1 nor 0, make user re-enter input
FINISH_PROGRAM
	HALT
	RET

SAVER7_0	.BLKW	1
ASCII_INVERT	.FILL	X-30
START		.FILL	X4000	;starting address of the first string
END		.FILL	X4033	;ending address of the first string
LENGTH_STR	.FILL	#50
ESC		.FILL	X-1B
ENTER		.FILL	X-A
ZERO		.FILL	X-30
ONE		.FILL	X-31
TWO		.FILL	X-32
NINE		.FILL	X-39
START_NEW	.FILL	X4000
NUMOFSTRINGS	.BLKW	1
NUMSTR_INPUT	.STRINGZ "\nENTER NUMBER OF STRINGS (1 - 9): "
PROMPT		.STRINGZ "\nENTER A STRING, THEN PRESS ENTER: "
OPT_choose	.STRINGZ "\n\nCHOOSE AN OPTION: "
OPT_1		.STRINGZ "\n1 - ASCENDING ORDER"
OPT_2		.STRINGZ "\n2 - DESCENDING ORDER"
OPTION		.STRINGZ "\nYOUR OPTION? "
OUTP		.STRINGZ "\nSORTED ORDER: "
CONTINUE	.STRINGZ "\n\nPRESS 1 TO CONTINUE, OR 0 TO EXIT."
newline		.STRINGZ "\n"

START_0		.FILL	X4000
END_0 		.FILL	X4033

check_for_only_null
	ST	R7, SAVER7_0
	LD	R4, NUMOFSTRINGS
	LD	R5, LENGTH_STR
	ADD	R5, R5, #1
	LD	R0, START_SORT	;LOAD THE ADDRESS OF THE FIRST CHARACTER IN THE FIRST STRING
	LDR	R1, R0, #0	;LOAD THE FIRST CHARACTER IN THE FIRST STRING
	BRnp	okay		;return if the string contains characters
	ADD	R0, R0, R5
	ADD	R4, R4, #-1
	BRz	print_empty
	BR	#-6
print_empty
	JSR	PR_STRING
okay	LD	R7, SAVER7_0
	RET

COMP	NOT	R2, R2
	ADD	R2, R2, #1
	RET

START_ORIG_1	.FILL	X4000
END_ORIG_1	.FILL	X4033
LENGTH		.FILL	#50

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
	BRp	init_swap
	BRz	goto_nextchar_init	;if two beginning match, compare next characters
	BRn	do_this_0		;if sorted, move 2nd word pointer down
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
	BRz	goto_nextword
	JSR	COMP
	ADD	R3, R1, R2
	BRz	goto_nextchar		;if two words have the same beginning character, proceed to compare the next characters
	BRn	goto_nextword		;if already sorted, compare next word
;INIT BEFORE SWAPPING
init_swap
	LD	R5, LENGTH
	LD	R0, START_SORT
	ST	R0, SWAP_START
	LD	R0, START_END
	ST	R0, SWAP_END
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
do_this_0
	LD	R5, LENGTH
	ADD	R5, R5, #1	;add null terminator to string, the length will be 51
	LD	R0, START_END
	ADD	R0, R0, R5
	ST	R0, START_END
	LDR	R1, R0, #0
	BRz	increase_start
	BR	compare_beg	
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
	BRz	finish_sort_from_sec	;if reached null terminator, finish sorting
	BR	compare_beg_init
finish_sort_from_sec
	LD	R7, SAVER7
	RET

SAVER7			.BLKW	1
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
	BRn	init_swap_1
	BRz	goto_nextchar_init_1	;if two beginning match, compare next char
	BRp	do_this_1
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
init_swap_1
	LD	R5, LENGTH
	LD	R0, START_SORT
	ST	R0, SWAP_START
	LD	R0, START_END
	ST	R0, SWAP_END
swap_word_e
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
	BRzp	swap_word_e
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
do_this_1
	LD	R5, LENGTH
	ADD	R5, R5, #1	;add null terminator to string, the length will be 51
	LD	R0, START_END
	ADD	R0, R0, R5
	ST	R0, START_END
	LDR	R1, R0, #0
	BRz	increase_start_1
	BR	compare_beg_1	
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
	BRz	finish_sort_from_sec_1	;if reached null terminator, finish sorting
	BR	compare_beg_init_1
finish_sort_from_sec_1
	LD	R7, SAVER7
	RET

BEG_CHAR	.BLKW	1

RM_REDUN
	ST	R7, SAVER7
	LD	R0, START_CONST
	ST	R0, START_RM
	LD	R0, END_RM_CONST
	ST	R0, END_RM
rm_init	LD	R0, START_RM
;check conditions
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
load_next 
	ADD	R0, R0, #1
	LD	R2, END_RM
	ADD	R2, R0, R2
	BRnz	load_0
shift_init
	LD	R0, START_RM
	AND	R3, R3, #0	;null terminator counter
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
;loads next string
done_rm		
	LD	R5, LENGTH
	ADD	R5, R5, #1
	LD	R0, START_RM
	ADD	R0, R0, R5
	ST	R0, START_RM	
	LDR	R1, R0, #0
	BRz	finish_rm
	ADD	R5, R5, #-2
	ADD	R0, R0, R5
	NOT	R0, R0
	ADD	R0, R0, #1
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
START_RM	.FILL	X4000
END_RM_CONST	.FILL	X-4031
END_RM		.FILL	X-4031
A		.FILL	x-41
Z		.FILL	X-5A
a		.FILL	X-61
z		.FILL	X-7A
nine		.FILL	x-39
zero		.FILL	x-30
=======
; redundant characters in each string: blank ' ', comma ',' if they exist in string.  

	.ORIG	X3000
	WELCOME_MES0	.STRINGZ "\nWelcome to the LC-3 project."
	WELCOME_MES1	.STRINGZ "\nPRESS ENTER TO PROCEED."
	WELCOME_MES2	.STRINGZ "\nOR PRESS ESC AT ANY POINT TO EXIT THE APPLICATION."
	LEA	R0, WELCOME_MES0
	PUTS
	AND	R0, R0, #0
REQUEST	
	LEA	R0, WELCOME_MES1
	PUTS
	LEA	R0, WELCOME_MES2
	PUTS
	GETC
	OUT
	LD	R2, ENTER
	ADD	R2, R0, R2
	BRZ	INPUT		;IF PRESS ENTER, PROCEED
	LD	R2, ESC
	ADD	R2, R0, R2
	BRZ	EXIT
	BRnp	REQUEST
INPUT	LEA	R0, INPUT_STRING
	PUTS
	AND	R0, R0, #0
	LD	R1, START
LOOP	GETC
	OUT
	LD	R2, ENTER
	ADD	R2, R0, R2
	BRz	DO_NEXT
	STR	R0, R1, #0
	ADD	R1, R1, #1
	ST	R1, END
	BR	LOOP
DO_NEXT	LD	R1, END
	ADD	R1, R1, #-1
	NOT	R1, R1
	ADD	R1 ,R1, #1	;NEGATE END OF STRING
	ST	R1, END
	LEA	R0, OPTION
	PUTS
	LEA	R0, OPTION_1
	PUTS
	GETC
	OUT
	LD	R2, one
	ADD	R2, R0, R2
	BRz	SORT_1		;IF USER TYPE 1, SORT IN ASCENDING ORDER
	LD	R2, two
	ADD	R2, R0, R2
	BRz	SORT_2		;IF USER TYPE 1, SORT IN ASCENDING ORDER
SORT_1	JSR	ASC_SORT
	BR	#1
SORT_2	JSR	DSC_SORT
	LEA	R0, RESULT
	PUTS
	LD	R0, START
	PUTS
;clear string for next input
	LD	R1, START
CLR_STRING
	LDR	R0, R1, #0
	AND	R0, R0, #0
	STR	R0, R1, #0
	ADD	R1, R1, #1
	LD	R2, END
	ADD	R0, R1, R2
	BRnz	CLR_STRING
	BR	INPUT
EXIT	HALT

WELCOME_USER
	ST	R7, SAVER7
	
ASC_SORT
	ST	R7, SAVER7
BEGIN	LD	R0, START	;load x4000 into R0
LOOPS	LDR	R1, R0, #0	;load first element of array into R1
	ADD	R0, R0, #1
	LD	R4, END
	ADD	R6, R4, R0	;check for end of array
	BRp	EXIT_ASC_SORT
	LDR	R2, R0, #0	;load second
	JSR	Comp		;negate R2
	ADD	R3, R1, R2
	BRnz	LOOPS		;if R1 < R2, load second element into R1 and so on
	STR	R1, R0, #0
	JSR	Comp		;re-negate R2
	STR	R2, R0, #-1
	LD	R4, END
	ADD	R6, R4, R0	;check for end of array
	BRnz	BEGIN
EXIT_ASC_SORT
	LD	R7, SAVER7
	RET

DSC_SORT
	ST	R7, SAVER7
BEGINs	LD	R0, START	;load x4000 into R0
LOOPSs	LDR	R1, R0, #0	;load first element of array into R1
	ADD	R0, R0, #1
	LD	R4, END
	ADD	R6, R4, R0	;check for end of array
	BRp	EXIT_DSC_SORT
	LDR	R2, R0, #0	;load second
	JSR	Comp		;negate R2
	ADD	R3, R1, R2
	BRzp	LOOPSs		;if R1 < R2, load second element into R1 and so on
	STR	R1, R0, #0
	JSR	Comp		;re-negate R2
	STR	R2, R0, #-1
	LD	R4, END
	ADD	R6, R4, R0	;check for end of array
	BRnz	BEGINs
EXIT_DSC_SORT
	LD	R7, SAVER7
	RET


Comp	NOT	R2, R2
	ADD	R2, R2, #1
	RET

INPUT_STRING	.STRINGZ "\nPLEASE ENTER A STRING: "
OPTION		.STRINGZ "TYPE 1 TO SORT IN ASCENDING ORDER. TYPE 2 TO SORT IN DESCENDING ORDER."
OPTION_1	.STRINGZ "\nCHOOSE AN OPTION (1 - 2): "
RESULT		.STRINGZ "\nSorted string: "
one	.FILL	x-31
two	.FILL	x-32
SAVER7	.BLKW	1
ENTER	.FILL	X-A
START	.FILL	X6000
END	.FILL	x0000
ESC	.FILL	X-1B


>>>>>>> b8f0aa904a72e2ead0afb53643c6320c09c8e446
	.END