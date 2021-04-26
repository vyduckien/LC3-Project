; 2. Write a program to input n (input from keyboard) strings of characters with the length unlimited (it is defined by the program, not by the compiler). 
; Sort them in descending or ascending order depending on the request input.
; Attention: 
; These strings are sorted in ascending/descending by the order of dictionary with deleting 
; redundant characters in each string: blank ' ', comma ',' if they exist in string.  

	.ORIG	X3000
;INTPUT STRING
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
	GETC
	OUT
	LD	R2, one
	ADD	R2, R0, R2
	BRz	SORT_1
	LD	R2, two
	ADD	R2, R0, R2
	BRz	SORT_2
SORT_1	JSR	ASC_SORT
	BR	#1
SORT_2	JSR	DSC_SORT
	LEA	R0, RESULT
	PUTS
	LD	R0, START
	PUTS
EXIT	HALT

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
	BRn	LOOPS		;if R1 < R2, load second element into R1 and so on
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
	BRp	LOOPSs		;if R1 < R2, load second element into R1 and so on
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

OPTION	.STRINGZ "TYPE 1 TO SORT IN ASCENDING ORDER. TYPE 2 TO SORT IN DESCENDING ORDER: "
RESULT	.STRINGZ "\nSorted string: "
one	.FILL	x-31
two	.FILL	x-32
SAVER7	.BLKW	1
ENTER	.FILL	X-A
START	.FILL	X4000
END	.FILL	x0000
	.END