;ARM1.s Source code for 4th program on the ARM Cortex M3
;Function Bit manipulations using the ARM assembly instruction set
;Author - Muhammad Ishraf Shafiq Zainuddin

; Directives
	PRESERVE8
	THUMB
		
; Vector Table Mapped to Address 0 at Reset, Linker requires __Vectors to be exported
	AREA RESET, DATA, READONLY
	EXPORT 	__Vectors


__Vectors DCD 0x20002000 ; stack pointer value when stack is empty
	DCD Reset_Handler ; reset vector
	
	ALIGN


;My program, Linker requires Reset_Handler and it must be exported
	AREA MYCODE, CODE, READONLY
	ENTRY

	EXPORT Reset_Handler
		
		
Reset_Handler ;We only have one line of actual application code

	bl subCheck
	bl setBit
	bl countBit
	bl rot_left_right
	
	
	ALIGN
subCheck PROC
	push{R0,R1}
	LDR R0, =0x11111111
	LSL R1,R0,#10 
	CMP R1, #0		;Check if its 0, store result in R1
	BEQ zero
	
	CMP R1, #1    	;Check if its 1, store result in R1
	BEQ one

one
	pop {R1}		;Return true
	
zero
	BX LR			;Return false
	ENDP
		
	ALIGN
setBit PROC
	;;
	push{R0}
	AND R0,R0,#0xFFFFFF7F	 ;Clearing bit 7 in R0
	ORR R0,R0,#0x8           ;Setting bit 3 in R0
	
	pop{R0}
	BX LR
	ENDP
		
	ALIGN
countBit PROC
	;;
	push{R0,R1}
	LDR R0, =0x11111111
	MOV	R2, #0
	
Loop
	LSL R1,R0,#1
	CMP R1, #1
	ADD	R2, #1  
	CMP R2, #8
    BEQ Done
	B	Loop
	
Done
        
	pop{R1}
	
	BX LR
	ENDP
		
	ALIGN
rot_left_right PROC
	;;
	push{R3,R4,R5}
	LDR R3, =0x12345678
	LDR R4, =0xFFFF0000
	LDR R5, =0x0000FFFF
	AND R6, R5, R3
	AND R7, R4, R3
	LSR R6, #1
	LSL R6, #2
	ORR R8, R6, R7
	
	BX LR
	ENDP
		
	ALIGN
		
	END