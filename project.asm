; 2. Write a program to input n (input from keyboard) strings of characters with the length unlimited (it is defined by the program, not by the compiler). 
; Sort them in descending or ascending order depending on the request input.
; Attention: 
; These strings are sorted in ascending/descending by the order of dictionary with deleting 
; redundant characters in each string: blank ' ', comma ',' if they exist in string. 
;
; Author: Vy Duc Kien
; ID: 1951010
; Date: 25/04/2021 

	.ORIG	X3000
;clear all registers
	JSR	CLR_REGS

	WELCOME_MES0	.STRINGZ "\n              ======= WELCOME TO THE LC-3 PROJECT ======="
	LEA	R0, WELCOME_MES0
	PUTS
	LEA	R0, WELCOME_MES1
	WELCOME_MES1	.STRINGZ "\nPRESS ENTER TO PROCEED."
	PUTS
	WELCOME_MES2	.STRINGZ "\nPRESS ESC AT ANY POINT TO EXIT THE PROGRAM."
	LEA	R0, WELCOME_MES2
	PUTS
REQUEST	GETC
	LD	R2, ENTER
	ADD	R2, R0, R2	
	BRz	INPUT		;IF PRESS ENTER, PROCEED
	LD	R2, ESC
	ADD	R2, R0, R2	
	BRz	EXIT		;IF PRESS ESC, EXIT
	BRnp	REQUEST	
INPUTP	OUT
INPUT	LEA	R0, INPUT_STRING
	INPUT_STRING	.STRINGZ "\n\nPLEASE ENTER A STRING: "
	PUTS
	AND	R0, R0, #0
	LD	R1, START
LOOP	GETC
	LD	R2, ENTER
	ADD	R2, R0, R2
	BRz	DO_NEXT		;IF PRESS ENTER, PROCEED TO SORT
	LD	R2, ESC
	ADD	R2, R0, R2
	BRz	EXIT		;IF PRESS ESC, EXIT 	PROGRAM.
	OUT
	STR	R0, R1, #0
	ADD	R1, R1, #1
	ST	R1, END
	BR	LOOP
DO_NEXT	LD	R1, END
	ADD	R1, R1, #-1
	NOT	R1, R1
	ADD	R1 ,R1, #1	;NEGATE END OF STRING
	ST	R1, END
	JSR	RM_REDUN

;option menu
OPTION_MENU
	LEA	R0, OPTION
	OPTION		.STRINGZ "\n\nCHOOSE A SORTING ORDER:\n1 - ASCENDING ORDER\n2 - DESCENDING ORDER"
	PUTS
	LEA	R0, OPTION_INPUT
	OPTION_INPUT	.STRINGZ "\nYOUR OPTION? "
	PUTS
OPT_INP	GETC
	LD	R2, one
	ADD	R2, R0, R2
	BRz	SORT_1		;IF USER TYPE 1, SORT IN ASCENDING ORDER
	LD	R2, two
	ADD	R2, R0, R2
	BRz	SORT_2		;IF USER TYPE 2, SORT IN DESCENDING ORDER
	LD	R2, ESC
	ADD	R2, R0, R2
	BRz	SORT_2		;IF USER PRESS ESC, EXIT PROGRAM
	BRnp	OPT_INP		;IF USER TYPE NEITHER, FOR USER ENTER EITHER
	
SORT_1	OUT
	JSR	ASC_SORT
	BR	#2
SORT_2	OUT
	JSR	DSC_SORT
;print sorted string
	JSR	PRINT_SORTED

;clear string for next input
	JSR	CLR_STRING

;let user choose whether to continue program
	LEA	R0, CONTINUE
	CONTINUE	.STRINGZ "\nCONTINUE? (Y/N) "
	PUTS
CONT	GETC
	LD	R2, Y
	ADD	R2, R0, R2
	BRZ	INPUT
	LD	R2, y
	ADD	R2, R0, R2
	BRZ	INPUTP
	LD	R2, N
	ADD	R2, R0, R2
	BRz	EXITP
	LD	R2, n
	ADD	R2, R0, R2
	BRz	EXITP
	LD	R2, ESC
	ADD	R2, R0, R2
	BRz	EXIT
	BRnp	CONT
EXITP	OUT
EXIT	LEA	R0, EXIT_PROMPT
	EXIT_PROMPT	.STRINGZ "\nEXITING THE APPLICATION..."
	PUTS
	HALT

ESC	.FILL	X-1B
ENTER	.FILL	X-A
Y	.FILL	X-59
y	.FILL	X-79
N	.FILL	X-4E
n	.FILL	X-6E
one	.FILL	x-31
two	.FILL	x-32
START	.FILL	X6000
END	.FILL	x0000

;clear all register EXCEPT R7
CLR_REGS
	AND	R0, R0, #0
	AND	R1, R1, #0
	AND	R2, R2, #0
	AND	R3, R3, #0
	AND	R4, R4, #0
	AND	R5, R5, #0
	AND	R6, R6, #0
	RET
	
;ascending sort subroutine
ASC_SORT
	ST	R7, SAVER7
BEGIN	LD	R0, START	;load address inside START into R0
LOOPS	LDR	R1, R0, #0	;load first element of string into R1
	ADD	R0, R0, #1
	LD	R4, END
	ADD	R6, R4, R0	;check for end of string
	BRp	EXIT_ASC_SORT
	LDR	R2, R0, #0	;load second
	JSR	COMP		;negate R2
	ADD	R3, R1, R2
	BRnz	LOOPS		;if R1 < R2, load second element into R1 and so on
	STR	R1, R0, #0	;store larger element into location M[R0] 
	JSR	COMP		;re-negate R2
	STR	R2, R0, #-1	;store smaller element back into location M[R0] - 1
	LD	R4, END
	ADD	R6, R4, R0	;check for end of string
	BRnz	BEGIN
EXIT_ASC_SORT
	LD	R7, SAVER7
	RET

;descending sort subroutine
DSC_SORT
	ST	R7, SAVER7
BEGINs	LD	R0, START	;load address inside START into R0
LOOPSs	LDR	R1, R0, #0	;load first element of string into R1
	ADD	R0, R0, #1
	LD	R4, END
	ADD	R6, R4, R0	;check for end of string
	BRp	EXIT_DSC_SORT
	LDR	R2, R0, #0	;load second
	JSR	COMP		;negate R2
	ADD	R3, R1, R2
	BRzp	LOOPSs		;if R1 > R2, load second element into R1 and so on
	STR	R1, R0, #0	;store larger element into location M[R0] 
	JSR	COMP		;re-negate R2
	STR	R2, R0, #-1	;store larger element back into location M[R0] - 1
	LD	R4, END
	ADD	R6, R4, R0	;check for end of string
	BRnz	BEGINs
EXIT_DSC_SORT
	LD	R7, SAVER7
	RET

;remove redundant characters
RM_REDUN
	ST	R7, SAVER7
	LD	R0, START
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
	LD	R2, END
	ADD	R2, R0, R2
	BRnz	load_0
load_next 
	ADD	R0, R0, #1
	LD	R2, END
	ADD	R2, R0, R2
	BRnz	load_0
shiftl	LD	R0, START
	AND	R3, R3, #0	;null counter
	LD	R2, END
	ADD	R2, R0, R2
	BRz	done_rm		;if START = END (string contains only redundant characters), return
;shift left
shift	LDR	R1, R0, #0
	BRnp	#5
	LDR	R1, R0, #1
	STR	R1, R0, #0
	ADD	R3, R3, #1
	AND	R1, R1, #0
	STR	R1, R0, #1	;remove index
	ADD	R0, R0, #1
	LD	R2, END
	ADD	R2, R0, R2
	BRnz	shift
	ADD	R3, R3, #0
	BRz	done_rm
	ADD	R0, R0, #-2
	NOT	R0, R0
	ADD	R0, R0, #1	
	ST	R0, END
	BR	shiftl
done_rm	LD	R7, SAVER7
	RET	

;print sorted string
PRINT_SORTED
	ST	R7, SAVER7
	LEA	R0, RESULT
	RESULT		.STRINGZ "\n\nSORTED STRING: "
	PUTS
	LD	R0, START
	PUTS
	LD	R7, SAVER7
	RET

;clear string for next input
CLR_STRING
	LD	R1, START
	LDR	R0, R1, #0
	AND	R0, R0, #0
	STR	R0, R1, #0
	ADD	R1, R1, #1
	LD	R2, END
	ADD	R0, R1, R2
	BRnz	#-7
	RET

COMP	NOT	R2, R2
	ADD	R2, R2, #1
	RET

A	.FILL	x-41
Z	.FILL	X-5A
a	.FILL	X-61
z	.FILL	X-7A
nine	.FILL	x-39
zero	.FILL	x-30
SAVER7	.BLKW	1
	.END