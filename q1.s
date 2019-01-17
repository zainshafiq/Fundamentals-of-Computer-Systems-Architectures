;ARM1.s Source code for my first program on the ARM Cortex M3
;Function Modify some registers so we can observe the results in the debugger
;Author - Dave Duguid
;Modified August 2012 Trevor Douglas
; Directives
	PRESERVE8
	THUMB
		
; Vector Table Mapped to Address 0 at Reset, Linker requires __Vectors to be exported
	AREA RESET, DATA, READONLY
	EXPORT 	__Vectors


__Vectors DCD 0x20002000 ; stack pointer value when stack is empty
	DCD Reset_Handler ; reset vector
	
	ALIGN

;later
	AREA    MyData, DATA, READWRITE
data1   SPACE   12       ; defines 255 bytes of zeroed store

	
;My program, Linker requires Reset_Handler and it must be exported
	AREA MYCODE, CODE, READONLY		
	ENTRY

	EXPORT Reset_Handler
	

		
	ALIGN	
int_to_ascii proc
	
	

	
	BX lr
	ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; copy an array of bytes from source ptr R1 to dest ptr R2.  R3
;;; contains the number of bytes to copy.
;;; Require:
;;; The destination had better be somewhere in RAM, but that's the
;;; caller's responsibility.  As is the job to ensure the source and 
;;; dest arrays don't overlap.
;;;
;;; Promise: No registers are modified.  The destination buffer is
;;;          modified.
;;; Author: Prof. Karim Naqvi (Oct 2013)
	ALIGN
byte_copy  PROC
	push {r1,r2,r3,r4}

	mov r5, #0
loop
    ldrb r4, [r1]
	strb r4, [r2]
	
	add r1,#1
	add r2,#1
	add r5,#1
	cmp r3,r5
	bne loop
    
	pop	{r1,r2,r3,r4}
	bx	lr
	ENDP

Reset_Handler ;We only have one line of actual application code

	ldr r1,= data1;
	ldr r2,= 0x20000030;
	mov r3, #12
	
	bl byte_copy;
	
	mov r9, #34;
	bl int_to_ascii;

	ALIGN
		
	END