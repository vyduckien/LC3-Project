; 2. Write a program to input n (input from keyboard) strings of characters with the length unlimited (it is defined by the program, not by the compiler). 
; Sort them in descending or ascending order depending on the request input.
; Attention: 
; These strings are sorted in ascending/descending by the order of dictionary with deleting 
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


	.END