; 2. Write a program to input n (input from keyboard) strings of characters with the length unlimited (it is defined by the program, not by the compiler). 
; Sort them in descending or ascending order depending on the request input.
; Attention: 
; These strings are sorted in ascending/descending by the order of dictionary with deleting 
; redundant characters in each string: blank ' ', comma ',' if they exist in string. 
;
; Author: Vy Duc Kien
; ID: 1951010
; Date: 01/05/2021

;string length: 5
				
	.ORIG	x3000
	LD	R1, START
	LD	R3, LENGTH
	AND	R4, R4, #0
	BR	#7
NEW_S	ADD	R4, R4, #1
	ST	R4, NUMOFSTRINGS
	LD	R3, LENGTH
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
	JSR	SORT_ALPHABET
	LEA	R0, OUTP
	PUTS
	LD	R0, START
	ST	R0, START_NEW
gay
	LEA	R0, newline
	PUTS
	LD	R0, START_NEW
	PUTS
	ADD	R0, R0, #6
	ST	R0, START_NEW
	LDI	R2, START_NEW
	BRz	DONE
	BRp	gay
DONE	HALT

NUMOFSTRINGS 	.BLKW	1
START	.FILL	X4000
START_NEW	.FILL	X4000
SORT_END	.FILL	X4006
ENTER	.FILL	X-A
SPACE	.FILL	X-20
LENGTH	.FILL	X5
MES	.STRINGZ "\nENTER A STRING: "
OUTP	.STRINGZ "\nSORTED ORDER: "
newline	.STRINGZ "\n"

SORT	ST	R7, SAVER7
	LD	R4, NUMOFSTRINGS
SORT_NEW
	LD	R3, LENGTH
	LD	R0, START_OFFSET
	ST	R0, START_SORT
	LD	R0, SORT_END
	ST	R0, SORT_OFFSET
	LD	R0, START_SORT	;LOAD THE ADDRESS OF THE FIRST CHARACTER IN THE FIRST STRING
BEGIN	LDR	R1, R0, #0	;LOAD THE FIRST CHARACTER IN THE FIRST STRING
	LD	R0, SORT_OFFSET
	LDR	R2, R0, #0	;LOAD THE FISRT CHARACTER IN THE nth STRING
	BRz	FINISH
	JSR	COMP		;NEGATE R2
	ADD	R3, R1, R2	
	BRnz	DO_THIS
	JSR	COMP
SWAP	LD	R0, SORT_OFFSET
	STR	R1, R0, #0	;SWAP FIRST AND SECOND STRING
	ADD	R0, R0, #1
	ST	R0, SORT_OFFSET
	LD	R0, START_SORT
	STR	R2, R0, #0
	ADD	R0, R0, #1
	ST	R0, START_SORT
	LDR	R1, R0, #0
	LD	R0, SORT_OFFSET
	LDR	R2, R0, #0
	BRp	SWAP
	BRz	SORT_NEW
DO_THIS:
	ADD	R4, R4, #-1
	BRz	DONE_SORT	
	LD	R0, SORT_END
	ADD	R0, R0, #6
	ST	R0, SORT_END
	BR	SORT_NEW
DONE_SORT:	
	LD	R0, START_OFFSET
	ADD	R0, R0, #6
	ST	R0, START_OFFSET
	ADD	R0, R0, #6
	ST	R0, SORT_END
	LD	R4, NUMOFSTRINGS
	ADD	R4, R4, #-1
	ST	R4, NUMOFSTRINGS
	BR	SORT_NEW
FINISH	LD	R7, SAVER7
	RET

COMP	NOT	R2, R2
	ADD	R2, R2, #1
	RET



SORT_ALPHABET
	ST	R7, SAVER7
;INITIALIZE FOR SORTING
	LD	R0, START
	ST	R0, START_SORT
	LD	R0, END
	ST	R0, START_END
;COMPARE BEGINNING
	LD	R0, START_SORT
	LDR	R1, R0, #0
	LD	R0, START_END
	LDR	R2, R0, #0
	JSR	COMP
	ADD	R3, R1, R2 
	BRz	goto_nextchar
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
	BRz	goto_nextchar
	BRp	SWAP_INIT

SWAP_INIT
;INIT BEFORE SWAPPING
	LD	R5, LENGTH
	LD	R0, START
	ST	R0, SWAP_START
	LD	R0, START_END
	ST	R0, SWAP_END
	LD	R7, SAVER7
SWAP_WORD
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
	BRzp	SWAP_WORD
	LD	R7, SAVER7
	RET

END	.FILL	X4006
SORT_OFFSET	.FILL	X4006
START_SORT	.FILL	X4000
START_SORT_NEXT_CHAR	.FILL	X4000
START_OFFSET	.FILL	X4000
START_END	.FILL	X4006
START_END_NEXT_CHAR	.FILL	X4006

SWAP_START	.FILL	X4000
SWAP_END	.FILL	X4006
SAVER7	.BLKW	1
.END