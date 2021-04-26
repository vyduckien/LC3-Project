; 2. Write a program to input n (input from keyboard) strings of characters with the length unlimited (it is defined by the program, not by the compiler). 
; Sort them in descending or ascending order depending on the request input.
; Attention: 
; These strings are sorted in ascending/descending by the order of dictionary with deleting 
; redundant characters in each string: blank ' ', comma ',' if they exist in string.  

	.ORIG	X3000
	LEA	R0, WELCOME_MES0
	WELCOME_MES0	.STRINGZ "\nWELCOME TO THE LC-3 PROJECT."
	PUTS
	AND	R0, R0, #0
REQUEST	
	LEA	R0, WELCOME_MES1
	WELCOME_MES1	.STRINGZ "\nPRESS ENTER TO PROCEED."
	PUTS
	LEA	R0, WELCOME_MES2
	WELCOME_MES2	.STRINGZ "\nOR PRESS ESC AT ANY POINT TO EXIT THE APPLICATION."
	PUTS
	GETC
	OUT
	LD	R2, ENTER
	ADD	R2, R0, R2
	BRZ	INPUT		;IF PRESS ENTER, PROCEED
	LD	R2, ESC
	ADD	R2, R0, R2
	BRZ	EXIT		;IF PRESS ESC, CLOSE PROGRAM
	BRnp	REQUEST
INPUT	LEA	R0, INPUT_STRING
	INPUT_STRING	.STRINGZ "\nPLEASE ENTER A STRING: "
	PUTS
	AND	R0, R0, #0
	LD	R1, START
LOOP	GETC
	LD	R2, ENTER
	ADD	R2, R0, R2
	BRz	DO_NEXT		;IF PRESS ENTER, PROCEED TO SORT
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
OPT	LEA	R0, OPTION
	OPTION		.STRINGZ "\nPLEASE CHOOSE A SORTING ORDER:\n1 - ASCENDING ORDER\n2 - DESCENDING ORDER"
	PUTS
	LEA	R0, OPTION_INPUT
	OPTION_INPUT	.STRINGZ "\nYOUR OPTION? "
	PUTS
	GETC
	OUT
	LD	R2, one
	ADD	R2, R0, R2
	BRz	SORT_1		;IF USER TYPE 1, SORT IN ASCENDING ORDER
	LD	R2, two
	ADD	R2, R0, R2
	BRz	SORT_2		;IF USER TYPE 2, SORT IN DESCENDING ORDER
	BRnp	OPT
SORT_1	JSR	ASC_SORT
	BR	#1
SORT_2	JSR	DSC_SORT

	;print sorted string
	LEA	R0, RESULT
	RESULT		.STRINGZ "\nSORTED STRING: "
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

;let user choose wether to continue program
CONT	LEA	R0, CONTINUE
	CONTINUE	.STRINGZ "\nCONTINUE? (Y/N)"
	PUTS
	GETC
	OUT
	LD	R2, Y
	ADD	R2, R0, R2
	BRZ	INPUT
	LD	R2, y
	ADD	R2, R0, R2
	BRZ	INPUT
	LD	R2, N
	ADD	R2, R0, R2
	BRZ	EXIT
	LD	R2, n
	ADD	R2, R0, R2
	BRNP	CONT
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
shift	LDR	R1, R0, #1
	STR	R1, R0, #0
	ADD	R0, R0, #1
	LD	R2, END
	ADD	R2, R0, R2
	BRnz	shift
	ADD	R0, R0, #-2
	NOT	R0, R0
	ADD	R0, R0, #1
	ST	R0, END
	LD	R0, START
load_next
	ADD	R0, R0, #1
	LD	R2, END
	ADD	R2, R0, R2
	BRnz	load_0
done_rm	LD	R7, SAVER7
	RET

Comp	NOT	R2, R2
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