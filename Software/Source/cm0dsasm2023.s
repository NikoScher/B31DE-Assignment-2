;-----------------------------------------------------------------------------------
; B31DE laboratory exercise #3 2023
;------------------------------------------------------------------------------------------------------
; Design and Implementation of an AHB timer, a GPIO peripheral, and a 7-segment display peripheral
; on Basys 3 board.  
;
; Displays text string "GPIO" on VGA.
; Timer is free running.
; Loops forever reading input data from switches and writing this data to LEDs,
; reading value of timer output and displaying 16 MSBs as four hex digits on a 7-segment display.
;-----------------------------------------------------------------------------------

VGA_base_address	    EQU	0x50000000
UART_base_address	    EQU	0x51000000

timer_limitVal_reg    	EQU	0x52000000
timer_currVal_reg    	EQU	0x52000004
timer_control_reg    	EQU	0x52000008

GPIO_base_address	    EQU	0x53000000

SEVEN_SEG_DIGIT1 	EQU	0x54000000
SEVEN_SEG_DIGIT2 	EQU	0x54000004
SEVEN_SEG_DIGIT3 	EQU	0x54000008
SEVEN_SEG_DIGIT4 	EQU	0x5400000C

LED_base_address	    EQU	0x55000000

initial_SP		    	EQU	0x00004000	; initial stack pointer value

IRQ_enable_register		EQU 0xE000E100
enable_IRQ0				EQU 0x00000001


			; interrupt vector table starts at address 0x00000000 
			PRESERVE8
			THUMB

        	AREA	RESET, DATA, READONLY
        	EXPORT 	__Vectors
					
__Vectors	DCD	initial_SP		; stack pointer
			DCD	Reset_Handler	; start execution here on reset
        	DCD	0
        	DCD	0
        	DCD	0
        	DCD	0
        	DCD	0
        	DCD	0
        	DCD	0
        	DCD	0
        	DCD	0
        	DCD	0
        	DCD	0
        	DCD	0
        	DCD	0
        	DCD	0
        			
			DCD	Timer_Handler
        	DCD	0
        	DCD	0
        	DCD	0
        	DCD	0
        	DCD	0
			DCD	0
        	DCD	0
        	DCD	0
        	DCD	0
        	DCD	0
        	DCD	0
        	DCD	0
        	DCD	0
        	DCD	0
        	DCD	0

			AREA |.text|, CODE, READONLY

Reset_Handler   PROC
                GLOBAL Reset_Handler
                ENTRY

				LDR		R1, =IRQ_enable_register	; enable IRQ #0 interrupts
				LDR		R0, =enable_IRQ0
				STR		R0, [R1]

				LDR 	R0, =0x5FFFFFFF				;define limit
				LDR 	R1, =timer_limitVal_reg		;output to TIMER LIMIT
				STR		R0,	[R1]

main_loop		
				;Read from switch, and output to LEDs
				LDR 	R1, =0x53000004		;GPIO direction reg
				MOVS	R0, #00				;direction input
				STR		R0,	[R1]
				
				LDR 	R1, =0x53000000		;GPIO data reg
				LDR		R2, [R1]			;input data from the switch
				
				LDR 	R1, =0x53000004		;change direction to output
				MOVS	R0, #01
				STR		R0,	[R1]

				LDR 	R1, =0x53000000		;output to LED
				STR		R2,	[R1]

				LDR 	R1, =timer_control_reg		;output to TIMER
				STR		R2,	[R1]
				
				B		main_loop
				ENDP

Timer_Handler	PROC
                EXPORT Timer_Handler

				PUSH	{R6, R7}				; save R6 and R7 as they are used
					
				LDR		R6, =timer_currVal_reg	; read 32-bit timer value into R7
				LDR		R7, [R6]

				LDR 	R2, =0x0F				; R2 used to mask off all but 4 LSBs

				LSRS	R0, R7, #16				; right shift R7 16 bits into R0		
				ANDS    R0, R0, R2				; mask all but 4 LSBs of R0
				LDR		R1, =SEVEN_SEG_DIGIT1	; display that 4-bit hex digit
				STR		R0, [R1]				; right most seven segment digit

				LSRS	R0, R7, #20				; right shift R7 20 bits into R0
				ANDS    R0, R0, R2				; mask all but 4 LSBs of R0
				LDR		R1, =SEVEN_SEG_DIGIT2	; display that 4-bit hex digit
				STR		R0, [R1]				; right most but one seven segment digit

				LSRS	R0, R7, #24				; right shift R7 24 bits into R0		
				ANDS    R0, R0, R2				; mask all but 4 LSBs of R0
				LDR		R1, =SEVEN_SEG_DIGIT3	; display that 4-bit hex digit
				STR		R0, [R1]				; right most but two seven segment digit

				LSRS	R0, R7, #28				; right shift R7 28 bits into R0
				ANDS    R0, R0, R2				; mask all but 4 LSBs of R0
				LDR		R1, =SEVEN_SEG_DIGIT4	; display that 4-bit hex digit
				STR		R0, [R1]				; left most seven segment digit

				; ASCII Shenangins
				LDR 	R5, =VGA_base_address
				LDR 	R4, =0x08
				STR		R4, [R5]

				MOVS	R4, #0
				MOVS	R6, #9
				CMP		R6, R0
				MOV		R12, PC
				BMI		add_over

				ADDS	R4, R4, #48
				ADD		R4, R4, R0

				STR		R4, [R5]
				; End of ASCII
					
				POP		{R6, R7}				; restore R6 and R7
				
				BX		LR						; return from interrupt service routine
				ENDP							; matches PROC at start of Timer_Handler

add_over
				ADDS	R4, R4, #7
				MOV		PC, R12

				ALIGN 		4		; Align to a word boundary
			END                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    
   