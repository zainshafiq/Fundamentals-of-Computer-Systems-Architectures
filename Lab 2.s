;First Program_Lab 2 Muhammad Ishraf Shafiq Zainuddin_200342741, 18th September 2018 

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
		
		
;My program, Linker requires Reset_Handler and it must be exported
	AREA MYCODE, CODE, READONLY
	ENTRY

	EXPORT Reset_Handler
		
	ALIGN
Reset_Handler  PROC ;We only have one line of actual application code
	
	
	;MOV R0, #0x00
	
	
Awesome

	ADD	R0, #1
	CMP	R0, #4
	BNE	Awesome

	MOV R0, #9	;; Just an extra line

    BL function1

	;BL factorial
	
	LDR		R5, = string1
	LDRB 	R6, [R5]
	
	BL vowelCount
	
	LDR		R7, = string2
	LDRB 	R8, [R7]
	
	BL vowelCount

	B Reset_Handler
	
	ENDP



ALIGN
function1  PROC
	PUSH {R3, LR}
	MOV R3, #3
		
anotherSub
		;;This is the guts of the subroutine
		MOV R2, #0x2
		MOV R3, #4
		
		SUBS R2, #1
		SUBS R0, R3
		
		POP {R3, R15}
		
		B anotherSub
		
		BX LR

		ENDP


;Input is R1 (number to calculate factorial)
;Return value is R2
	ALIGN
;factorial PROC
	
	;push {LR}  ;;Important for recursive
	
	;CMP R1, #0
	;BEQ inputZero
	
		
	;SUB R1,R1,#1
	;CMP R1, #0
	;BEQ done
	
	;MUL R2, R2, R1
	
	
	;BL recursive
	
;done
	;pop {LR}
	
;inputZero
	;BX LR
	;ENDP



; comments input/output
	ALIGN
vowelCount	PROC
	
	CMP		R6, #'a'
	BEQ 	vowelCount
	
	CMP		R6, #'e'
	BEQ 	vowelCount
	
	CMP		R6, #'i'
	BEQ 	vowelCount
	
	CMP		R6, #'o'
	BEQ 	vowelCount
	
	CMP		R6, #'u'
	BEQ 	vowelCount	
	
	CMP		R6, #'A'
	BEQ 	vowelCount
	
	CMP		R6, #'E'
	BEQ 	vowelCount
	
	CMP		R6, #'I'
	BEQ 	vowelCount
	
	CMP		R6, #'O'
	BEQ 	vowelCount
	
	CMP		R6, #'U'
	BEQ 	vowelCount
	
	CMP		R8, #'a'
	BEQ 	vowelCount
	
	CMP		R8, #'e'
	BEQ 	vowelCount
	
	CMP		R8, #'i'
	BEQ 	vowelCount
	
	CMP		R8, #'o'
	BEQ 	vowelCount
	
	CMP		R8, #'u'
	BEQ 	vowelCount
	
	CMP		R8, #'A'
	BEQ 	vowelCount
	
	CMP		R8, #'E'
	BEQ 	vowelCount
	
	CMP		R8, #'I'
	BEQ 	vowelCount
	
	CMP		R8, #'O'
	BEQ 	vowelCount
	
	CMP		R8, #'U'
	BEQ 	vowelCount
	
	BX LR
	ENDP
	
	ALIGN
string2
	DCB		"Yes I really love it!",0
	
	
string1
	DCB		"ENSE 352 is fun and I am learning ARM assembly!",0
	
	

	END