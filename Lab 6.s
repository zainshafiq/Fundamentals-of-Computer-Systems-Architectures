; GPIO Test program - Dave Duguid, 2011
; Modified Trevor Douglas 2014

;;; Directives
            PRESERVE8
            THUMB       

        		 
;;; Equates

INITIAL_MSP	EQU		0x20001000	; Initial Main Stack Pointer Value


;PORT A GPIO - Base Addr: 0x40010800
GPIOA_CRL	EQU		0x40010800	; (0x00) Port Configuration Register for Px7 -> Px0
GPIOA_CRH	EQU		0x40010804	; (0x04) Port Configuration Register for Px15 -> Px8
GPIOA_IDR	EQU		0x40010808	; (0x08) Port Input Data Register
GPIOA_ODR	EQU		0x4001080C	; (0x0C) Port Output Data Register
GPIOA_BSRR	EQU		0x40010810	; (0x10) Port Bit Set/Reset Register
GPIOA_BRR	EQU		0x40010814	; (0x14) Port Bit Reset Register
GPIOA_LCKR	EQU		0x40010818	; (0x18) Port Configuration Lock Register

;PORT B GPIO - Base Addr: 0x40010C00
GPIOB_CRL	EQU		0x40010C00	; (0x00) Port Configuration Register for Px7 -> Px0
GPIOB_CRH	EQU		0x40010C04	; (0x04) Port Configuration Register for Px15 -> Px8
GPIOB_IDR	EQU		0x40010C08	; (0x08) Port Input Data Register
GPIOB_ODR	EQU		0x40010C0C	; (0x0C) Port Output Data Register
GPIOB_BSRR	EQU		0x40010C10	; (0x10) Port Bit Set/Reset Register
GPIOB_BRR	EQU		0x40010C14	; (0x14) Port Bit Reset Register
GPIOB_LCKR	EQU		0x40010C18	; (0x18) Port Configuration Lock Register

;The onboard LEDS are on port C bits 8 and 9
;PORT C GPIO - Base Addr: 0x40011000
GPIOC_CRL	EQU		0x40011000	; (0x00) Port Configuration Register for Px7 -> Px0
GPIOC_CRH	EQU		0x40011004	; (0x04) Port Configuration Register for Px15 -> Px8
GPIOC_IDR	EQU		0x40011008	; (0x08) Port Input Data Register
GPIOC_ODR	EQU		0x4001100C	; (0x0C) Port Output Data Register
GPIOC_BSRR	EQU		0x40011010	; (0x10) Port Bit Set/Reset Register
GPIOC_BRR	EQU		0x40011014	; (0x14) Port Bit Reset Register
GPIOC_LCKR	EQU		0x40011018	; (0x18) Port Configuration Lock Register

;Registers for configuring and enabling the clocks
;RCC Registers - Base Addr: 0x40021000
RCC_CR		EQU		0x40021000	; Clock Control Register
RCC_CFGR	EQU		0x40021004	; Clock Configuration Register
RCC_CIR		EQU		0x40021008	; Clock Interrupt Register
RCC_APB2RSTR	EQU	0x4002100C	; APB2 Peripheral Reset Register
RCC_APB1RSTR	EQU	0x40021010	; APB1 Peripheral Reset Register
RCC_AHBENR	EQU		0x40021014	; AHB Peripheral Clock Enable Register

RCC_APB2ENR	EQU		0x40021018	; APB2 Peripheral Clock Enable Register  -- Used

RCC_APB1ENR	EQU		0x4002101C	; APB1 Peripheral Clock Enable Register
RCC_BDCR	EQU		0x40021020	; Backup Domain Control Register
RCC_CSR		EQU		0x40021024	; Control/Status Register
RCC_CFGR2	EQU		0x4002102C	; Clock Configuration Register 2

; Times for delay routines
        
DELAYTIME	EQU		1600000		; (200 ms/24MHz PLL)
	
; Set_value
SET_VALUE 	EQU 	0x44444433
	
;Registers for the systick timer  

STK_CTRL	EQU		0xE000E010
STK_LOAD	EQU		0xE000E014
STK_VAL		EQU		0xE000E018
STK_CALIB	EQU		0xE000E01C


; Vector Table Mapped to Address 0 at Reset
            AREA    RESET, Data, READONLY
            EXPORT  __Vectors

__Vectors	DCD		INITIAL_MSP			; stack pointer value when stack is empty
        	DCD		Reset_Handler		; reset vector
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
		BL lightLED
	
mainLoop
		
		

		B	mainLoop
		ENDP




;;;;;;;;Subroutines ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


	
;This routine will enable the clock for the Ports that you need	
	ALIGN
GPIO_ClockInit PROC

	; Students to write.  Registers   .. RCC_APB2ENR
	; ENEL 384 Pushbuttons: SW2(Red): PB8, SW3(Black): PB9, SW4(Blue): PC12 *****NEW for 2015**** SW5(Green): PA5
	; ENEL 384 board LEDs: D1 - PA9, D2 - PA10, D3 - PA11, D4 - PA12
	
	LDR R6,=RCC_APB2ENR  ; APB2 Peripheral Clock Enable Register 	
	MOV R0,#0x14
	STR	R0, [R6]
	
	BX LR
	ENDP		
	
	
;This routine enables the GPIO for the LED's.  By default the I/O lines are input so we only need to configure for ouptut.
	ALIGN
GPIO_init  PROC
	
	; ENEL 384 board LEDs: D1 - PA9, D2 - PA10, D3 - PA11, D4 - PA12
	
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
lightLED PROC
	LDR R8,=GPIOC_BSRR	; (0x10) Port Bit Set/Reset Register
	MOV R3,#0x200
	STR R3,[R8]

	BX LR
	ENDP

	ALIGN
	END