;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Project: Solution to Q2 and Q3 of assign3
;;; File: crypto.s
;;; Class: ense352
;;; Programmer: K. Naqvi

;;; Directives
	thumb

;;; Equates
RAM_START	equ	0x20000000
string_buffer	equ	RAM_START + 0

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

;;; Procedure definitions

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; This mainline code sets up a RAM buffer with text to be encrypted.
;;; Then it calls the encrypt subroutine to encrypt the text in place.
Reset_Handler proc

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; First test
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;; Copy the plaintext1 from flash to RAM buffer so it 
	;; can be modified.
	ldr	r1,=plaintext1
	ldr	r2,=string_buffer
	ldr	r3,=size1
	ldr	r3,[r3]
	bl	byte_copy
	
	;; Encrypt the plaintext1 buffer
	ldr	r4,=string_buffer
	ldr	r3,=size1
	ldr	r3,[r3]
	orr	r3,r3,#(13 :SHL: 15)  ;; rotate by 13
	bl	encrypt

	;; Verify the results of test 1 are correct
        mov     r1,r4
        ldr     r2,=ciphertext1
        ldr     r3,=size1
        ldr     r3,[r3]
        bl      strncmp
        cbz     r0,test2
error1  b       error1
        
        

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Second test
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;; Copy the plaintext2 from flash to RAM buffer so it 
	;; can be modified.
test2	ldr	r1,=plaintext2
	ldr	r2,=string_buffer
	ldr	r3,=size2
	ldr	r3,[r3]
	bl	byte_copy
	
	;; Encrypt the plaintext2 buffer
	ldr	r4,=string_buffer
	ldr	r3,=size2
	ldr	r3,[r3]
	orr	r3,r3,#(13 :SHL: 15)  ;; rotate by 13
	bl	encrypt

	;; Verify the results of test 2 are correct
        mov     r1,r4
        ldr     r2,=ciphertext2_rot13
        ldr     r3,=size2
        ldr     r3,[r3]
        bl      strncmp
        cbz     r0,test3
error2  b       error2
        
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Third test
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;; Copy the plaintext2 from flash to RAM buffer so it 
	;; can be modified.
test3	ldr	r1,=plaintext2
	ldr	r2,=string_buffer
	ldr	r3,=size2
	ldr	r3,[r3]
	bl	byte_copy
	
	;; Encrypt the plaintext2 buffer
	ldr	r4,=string_buffer
	ldr	r3,=size2
	ldr	r3,[r3]
	orr	r3,r3,#(1 :SHL: 15) ;; rotate by 1
	bl	encrypt
	
	;; Verify the results of test 3 are correct
        mov     r1,r4
        ldr     r2,=ciphertext2_rot1
        ldr     r3,=size2
        ldr     r3,[r3]
        bl      strncmp
        cbz     r0,test4
error3  b       error3

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Fourth test
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;; Now to test the decrypt routine, use the current string_buffer
	;; which has been encrypted with a rotation of 1, and apply decrypt
test4	ldr	r4,=string_buffer
	ldr	r3,=size2
	ldr	r3,[r3]
	orr	r3,r3,#(1 :SHL: 15) ;; unrotate by 1
	bl	decrypt

	;; Verify the results of rot1 decryption are correct
        mov     r1,r4
        ldr     r2,=plaintext2
        ldr     r3,=size2
        ldr     r3,[r3]
        bl      strncmp
        cbz     r0,good
error4  b       error4


	;; we are finished
good	b	good		; finished mainline code.
	endp
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
plaintext1
	dcb	"This is some plaintext.  Very good."
plaintext1size	equ . - plaintext1
;;; expected cipher text for rot13:
ciphertext1
        dcb	"Guvf vf fbzr cynvagrkg.  Irel tbbq."

	align
size1
	dcd	plaintext1size
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
plaintext2
	dcb	"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
plaintext2size	equ . - plaintext2
	
;;; expected cipher text for rot13:
ciphertext2_rot13
	dcb	"NOPQRSTUVWXYZABCDEFGHIJKLMnopqrstuvwxyzabcdefghijklm"

;;; expected cipher text for rot1
ciphertext2_rot1
	dcb	"BCDEFGHIJKLMNOPQRSTUVWXYZAbcdefghijklmnopqrstuvwxyza"
	
	align
size2
	dcd	plaintext2size
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; copy an array of bytes from source ptr R1 to dest ptr R2.  R3
;;; contains the number of bytes to copy.
;;; Require:
;;;   The destination buffer is located in RAM.
;;;   Source and dest arrays must not overlap.
;;;
;;; Promise: No registers are modified.  Flags are modified. The
;;;     	destination buffer is modified.
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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Compare a pair of byte arrays, of size n
;;; Require:
;;;   R1: ptr to first byte array
;;;   R2: ptr to second byte array
;;;   R3: size, n
;;; Promise:
;;;   returns a value in R0: (<0,0,>0) if first array is lexically (less than,
;;;   equal to, greater than) second array.  Similar to strncmp().
;;;   Modifies no registers.  Modifies flags.
strncmp
	push	{r1-r5}

loop_strncmp
	cbz	r3,done_strncmp	; done?
	sub	r3,r3,#1

	;; load a char into r4 and r5, then compare them
	ldrb	r4,[r1],#1
	ldrb	r5,[r2],#1
	subs	r0,r4,r5
	bne	done_strncmp	; return as promised
	b	loop_strncmp

done_strncmp
	pop	{r1-r5}
	bx	lr

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; 
;;  paste your encrypt and decrypt implementations to test them here
;;; 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	ALIGN
encrypt proc
	push {r3};
	mov R3, #0xFF; 
	
	bx lr
	endp
		
	ALIGN		
decrypt proc

	
	bx lr
	endp
		
;;; End of assembly file
	align
	end
