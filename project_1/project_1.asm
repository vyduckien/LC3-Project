; 2. Write a program to input n (input from keyboard) strings of characters with the length unlimited (it is defined by the program, not by the compiler). 
; Sort them in descending or ascending order depending on the request input.
; Attention: 
; These strings are sorted in ascending/descending by the order of dictionary with deleting 
; redundant characters in each string: blank ' ', comma ',' if they exist in string. 
;
; Author: Vy Duc Kien
; ID: 1951010
; Date: 01/05/2021

;string length: 4
				
	.ORIG	x3000
	LD	R1, START
	LD	R3, LENGTH
	BR	#5
NEW_S	LD	R3, LENGTH
	LD	R1, START_NEW
	ADD	R1, R1, R3
	ADD	R1, R1, #1
	ST	R1, START_NEW
	LEA	R0, MES
	PUTS
LOOP	GETC
	LD	R2, ENTER
	ADD	R2, R0, R2
	BRz	PR_STRING
	LD	R2, SPACE
	ADD	R2, R0, R2
	BRz	NEW_S
	OUT
	STR	R0, R1, #0
	ADD	R1, R1, #1
	ADD	R3, R3, #-1
	BRz	NEW_S
	BR	LOOP
PR_STRING
	JSR	SORT
	LD	R0, START
	ST	R0, START_NEW
gay
	LEA	R0, OUTP
	PUTS
	LD	R0, START_NEW
	PUTS
	ADD	R0, R0, #6
	ST	R0, START_NEW
	LDI	R2, START_NEW
	BRz	DONE
	BRp	gay
DONE	HALT

START	.FILL	X4000
START_NEW	.FILL	X4000
END	.FILL	X-4005
ENTER	.FILL	X-A
SPACE	.FILL	X-20
LENGTH	.FILL	X5
MES	.STRINGZ "\nENTER A STRING: "
OUTP	.STRINGZ "\nOUTPUT STRING: "

SORT	ST	R7, SAVER7
	LD	R0, START	;LOAD THE ADDRESS OF THE FIRST CHARACTER IN THE FIRST STRING
	AND	R4, R4, #0	;MATCH COUNTER
	AND	R5, R5, #0	;SORTED COUNTER
BEGIN	ADD	R0, R0, #1
	LD	R3, END
	ADD	R3, R0, R3
	BRp	DONE_SORT
	LDR	R1, R0, #-1	;LOAD THE FIRST CHARACTER IN THE FIRST STRING
	LDR	R2, R0, #5	;LOAD THE FISRT CHARACTER IN THE SECOND STRING
	JSR	COMP		;NEGATE R2
	ADD	R3, R1, R2	
	BRp	SWAP_C		;COMPARE TWO CHARACTERS
	BRz	BEGIN
INCR_SORT
	ADD	R5, R5, #1
	BR	BEGIN

SWAP_C	ADD	R5, R5, #-1
	BRzp	DONE_SORT
	JSR	COMP
SWAP	STR	R1, R0, #5	;SWAP FIRST AND SECOND STRING
	STR	R2, R0, #-1	;
	ADD	R0, R0, #1	;X4001
	LDR	R1, R0, #-1
	LDR	R2, R0, #5
	LD	R3, END
	ADD	R3, R0, R3
	BRnz	SWAP
DONE_SORT
	LD	R7, SAVER7
	RET

COMP	NOT	R2, R2
	ADD	R2, R2, #1
	RET

SAVER7	.BLKW	1
.END