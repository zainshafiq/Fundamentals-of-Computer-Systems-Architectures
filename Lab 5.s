; GPIO Test program - Dave Duguid, 2011
; Modified Trevor Douglas 2014
; Author: Muhammad Ishraf Shafiq Zainuddin
; ID    : 200342741
;;; Directives
            PRESERVE8
            THUMB       

        		 
;;; Equates

INITIAL_MSP	EQU		0x20001000	; Initial Main Stack Pointer Value


;The onboard LEDS are on port C bits 8 and 9
;PORT C GPIO - Base Addr: 0x40011000
GPIOC_CRL	EQU		0x40011000	; (0x00) Port Configuration Register for Px7 -> Px0
GPIOC_CRH 	EQU 	0x40011004	; (0x04) Port Configuration Register for Px15 -> Px8
RCC_APB2ENR	EQU		0x40021018	; APB2 Peripheral Clock Enable Register
GPIO_IDR 	EQU 	0x40010808  ; (0x08) Port Input Data Register
GPIOC_ODR 	EQU 	0x4001100C  ; (0x0C) Port Output Data Register
RCC_CFGR	EQU		0x40021004	; Clock Configuration Register
SET_VALUE 	EQU 	0x44444433
GPIOC_BSRR 	EQU 	0x40011010  ; (0x10) Port Bit Set/Reset Register


; Times for delay routines
        
DELAYTIME	EQU		1600000		; (200 ms/24MHz PLL)
	
;Registers for the systick timer  

STK_CTRL	EQU		0xE000E010
STK_LOAD	EQU		0xE000E014
STK_VAL		EQU		0xE000E018
STK_CALIB	EQU		0xE000E01C


; Vector Table Mapped to Address 0 at Reset
            AREA    RESET, Data, READONLY
            EXPORT  __Vectors

__Vectors	DCD		INITIAL_MSP			;  stack pointer value when stack is empty
        	DCD		Reset_Handler		;  reset vector
			DCD		nmi_ISR				
        	DCD		h_fault_ISR			
        	DCD		m_fault_ISR			
        	DCD		b_fault_ISR			
        	DCD		u_fault_ISR			
	        SPACE	32					;  Need to fill 32 bytes
			DCD		SysTickISR
			
            AREA    MYCODE, CODE, READONLY
			EXPORT	Reset_Handler
			ENTRY
			


Reset_Handler		PROC

	BL GPIO_ClockInit
	BL GPIO_init
	BL sysclkInit
	;;BL Phase_1	
	;;BL Phase_2
	BL Phase_3
	

; mainLoop for students to write in.	
mainLoop
		
		

		B	mainLoop
		ENDP




;;;;;;;;Subroutines ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	
;This routine will enable the clock for the Ports that you need	
	ALIGN
GPIO_ClockInit PROC

	LDR R6,=RCC_APB2ENR  ; APB2 Peripheral Clock Enable Register 
	MOV R0,#0x14
	STR	R0, [R6]


	BX LR
	ENDP
		
		
	ALIGN


;This routine enables the GPIO for the LED;s
GPIO_init  PROC
	
	LDR R7,=GPIOC_CRH   		; (0x04) Port Configuration Register for Px15 -> Px8
	LDR R2,=SET_VALUE
	STR R2,[R7]	


	BX LR
	ENDP

;Default Handlers for NMI and Faults
			AREA    HANDLERS, CODE, READONLY
	
nmi_ISR
				B	.
h_fault_ISR
				B	.
m_fault_ISR
				B	.
b_fault_ISR
				B	.
u_fault_ISR
				B	.
SysTickISR

	BX LR
	
	ALIGN
sysclkInit PROC	
	LDR		R6, = RCC_CFGR 		; Clock Configuration Register	
	LDR		R0, = 0x04000000	
	STR		R0, [R6]


	;; Configure SYSTICK registers

	LDR		R6, = STK_CTRL			
	MOV		R0, #0x00
	STR		R0, [R6]

	LDR		R6, = STK_VAL			
	MOV		R0, #0x0
	STR		R0, [R6]

	LDR		R6, = STK_LOAD			
	LDR		R0, = 0xF42400
	LDR		R0, = 0x142400
	STR		R0, [R6]

	LDR		R6, = STK_CTRL			
	MOV		R0, #0x07
	STR		R0, [R6]

	BX LR
	ENDP

	ALIGN
Phase_1 PROC
	LDR R8,=GPIOC_BSRR	; (0x10) Port Bit Set/Reset Register
	MOV R3,#0x100       ;
	STR R3,[R8]

	BX LR
	ENDP		

	ALIGN
Phase_2 PROC
	
	LDR R11,=1000000
	LDR R7,=GPIOC_CRH	; (0x04) Port Configuration Register for Px15 -> Px8
	LDR R2,=SET_VALUE
	STR R2,[R7]
	LDR R8,=GPIOC_BSRR	; (0x10) Port Bit Set/Reset Register
	
TurnGreenOn
	MOV R4,#0x0	
	MOV r3,#0xFFFFFCFF
	STR R3, [R8]
	MOV r3,#0x0200
	STR R3, [R8]
	
Delay
	CMP R4,R11
	BEQ TurnBlueOn
	ADD R4,#0x1
	B Delay
	
TurnBlueOn
	MOV R4,#0x0
	LDR R8,=GPIOC_BSRR	; (0x10) Port Bit Set/Reset Register
	MOV R3,#0xFFFFFCFF
	STR R3, [R8]
	MOV R3,#0x0100
	STR R3, [R8]
	
Delay1
	CMP R4,R11
	BEQ TurnGreenOn
	ADD R4,#0x1
	B Delay1	
	
	BX LR
	ENDP
	
	ALIGN
Phase_3 PROC
	LDR R8,=GPIOC_ODR	; (0x0C) Port Output Data Register
	
ReadState
	LDR	R10, = GPIO_IDR	; (0x08) Port Input Data Register	    
	LDR	R5,[R10]
	AND R5,R5,#1					
	CMP R5,#0
	BEQ KeepLightsOff
	CMP R5,#1
	BEQ KeepLightsOn
	B ReadState
	
KeepLightsOff	
	MOV R3,#0xFFFFFCFF
	STR R3, [R8]
	B ReadState
	
	
KeepLightsOn
	MOV R3,#0x0300
	STR R3,[R8]	
	B ReadState

	
	BX LR
	ENDP
		
	ALIGN

	END
