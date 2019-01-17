;First Program_Lab 1 Muhammad Ishraf Shafiq Zainuddin_200342741, 18th September 2018 

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


;My program, Linker requires Reset_Handler and it must be exported
	AREA MYCODE, CODE, READONLY
	ENTRY

	EXPORT Reset_Handler
		
		
Reset_Handler ;We only have one line of actual application code


	;MOV R0, #0x76 ; Move the 8 bit Hex number 76
	
	; Lab 1
	
	LDR R1, = 0x00000001   ; Load the number 0x00000001 into Ry 
	LDR R2, = 0x00000002   ; Load the number 0x00000002 into Rz
	ADD R3, R1, R2         ; Add Ry and Rz without affecting the condition codes, and store the result in Rx. 
    LDR R2, =  0xFFFFFFFF  ; Load 0xFFFFFFFF into Rz
	ADD R3, R1, R2         ; Add Ry and Rz with affecting the condition codes, and store the result in Rx. Note what the condition flags are. 
    PUSH {R1, R2, R3}      ; Push Rx, Ry, Rz onto the stack. Look at the Stack Pointer register. 
	LDR R1, = 0x2          ; Load 0x2 into Ry 
	ADD R3, R1, R2         ; Add Ry and Rz with affecting the condition codes, and store the result in Rx. Note what the condition flags are.
	LDR R1, = 0x7FFFFFFF   ; Load the number 0x7FFFFFFF into Ry
    LDR R2, = 0x7FFFFFFF   ; Load the number 0x7FFFFFFF into Rz
	ADD R3, R1, R2         ; Add Ry and Rz with affecting the condition codes, and store the result in Rx. Note what the condition flags are. 
	B Reset_Handler        ; Loop	



	ALIGN
		
	END