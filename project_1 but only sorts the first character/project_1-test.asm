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
	LD	R1, START
	LD	R3, LENGTH
	AND	R4, R4, #0
	BR	#4
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
	BRz	PRINT
	LD	R2, SPACE
	ADD	R2, R0, R2
	BRz	NEW_S
	OUT
	STR	R0, R1, #0
	ADD	R1, R1, #1
	ADD	R3, R3, #-1
	BRz	NEW_S
	BR	LOOP
;PRINT STRING
PRINT	JSR	SORT_BY_BEG
	JSR	SORT_FROM_SEC
	LEA	R0, OUTP
	PUTS
	JSR	PR_STRING
	HALT

PR_STRING
	ST	R7, SAVER7
	LD	R5, LENGTH
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
DONE	LD	R7, SAVER7
	RET

START	.FILL	X4000
END	.FILL	X4033
START_NEW	.FILL	X4000
SORT_END	.FILL	X4033
ENTER	.FILL	X-A
SPACE	.FILL	X-20
LENGTH	.FILL	#50
MES	.STRINGZ "\nENTER A STRING: "
OUTP	.STRINGZ "\nSORTED ORDER: "
newline	.STRINGZ "\n"

SORT_BY_BEG	
	ST	R7, SAVER7
sort_init
	LD	R0, START_ORIG_0
	ST	R0, START_SORT
	LD	R0, END_ORIG_0
	ST	R0, START_END
BEGIN	LD	R0, START_SORT	;LOAD THE ADDRESS OF THE FIRST CHARACTER IN THE FIRST STRING
	LDR	R1, R0, #0	;LOAD THE FIRST CHARACTER IN THE FIRST STRING
	LD	R0, START_END
	LDR	R2, R0, #0
	JSR	COMP		;NEGATE R2
	ADD	R3, R1, R2	
	BRnz	do_this		;if already sorted, compare next word
;INIT BEFORE SWAPPING
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
	BR	BEGIN
incre_start
	LD	R0, START_ORIG_0
	ADD	R0, R0, R5
	ST	R0, START_ORIG_0
	ADD	R0, R0, R5
	ST	R0, END_ORIG_0
	LDR	R0, R0, #0
	BRz	finish
	BR	sort_init
finish	LD	R7, SAVER7
	RET

COMP	NOT	R2, R2
	ADD	R2, R2, #1
	RET

START_ORIG_0	.FILL	X4000
START_ORIG_1	.FILL	X4000
END_ORIG_0	.FILL	X4033
END_ORIG_1	.FILL	X4033

SORT_FROM_SEC
	ST	R7, SAVER7
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
	BRz	goto_nextchar	;if two words have the same beginning character, proceed to compare the next characters
	BRn	goto_nextword	;if already sorted, compare next word
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
	LD	R0, START_ORIG_1
	ADD	R0, R0, R5
	ST	R0, START_ORIG_1
	ADD	R0, R0, R5
	ST	R0, END_ORIG_1
	LDR	R1, R0, #0
	BRz	finish_sort_from_sec	;IF REACHED NULL STRING, FINISH SORTING
	BR	compare_beg_init
finish_sort_from_sec
	LD	R7, SAVER7
	RET	

START_SORT		.FILL	X4033
START_SORT_NEXT_CHAR	.FILL	X4033
START_OFFSET		.FILL	X4000
START_END		.FILL	X4033
START_END_NEXT_CHAR	.FILL	X4033

BEG_CHAR	.BLKW	1
SWAP_START	.FILL	X4000
SWAP_END	.FILL	X4033
SAVER7	.BLKW	1
.END