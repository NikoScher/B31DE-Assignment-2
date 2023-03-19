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

SEG7_digit_1_register 	EQU	0x54000000
SEG7_digit_2_register 	EQU	0x54000004
SEG7_digit_3_register 	EQU	0x54000008
SEG7_digit_4_register 	EQU	0x5400000C

LED_base_address	    EQU	0x55000000

initial_SP		    	EQU	0x00004000	; initial stack pointer value


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
        	DCD	0

			AREA |.text|, CODE, READONLY

Reset_Handler   PROC
                GLOBAL Reset_Handler
                ENTRY

				; write "GPIO" to the text console and the UART

				LDR 	R1, =VGA_base_address
				MOVS	R0, #'G'
				STR		R0, [R1]
				MOVS	R0, #'P'
				STR		R0, [R1]
				MOVS	R0, #'I'
				STR		R0, [R1]
				MOVS	R0, #'O'
				STR		R0, [R1]

				;LDR 	R0, =0xFFFFFFFF				;define limit
				;LDR 	R1, =timer_limitVal_reg		;output to TIMER LIMIT
				;STR		R0,	[R1]

				;LDR 	R2, =0xFF000000
				;LDR 	R1, =timer_currVal_reg		;output to TIMER
				;STR	R2,	[R1]

				LDR 	R2, =0x7
				LDR 	R1, =timer_control_reg		;output to TIMER
				STR		R2,	[R1]

				LDR 	R1, =VGA_base_address
				MOVS	R0, #'L'
				STR		R0, [R1]
				
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

				; read the current timer value, and write to 7-segment display
				
				LDR 	R1, =timer_currVal_reg		; read timer value into R3
				LDR		R3,	[R1]
				
				LSRS	R3,	R3, #16					; move 16 MSBs to 16 LSBs in R3

				MOVS	R0,	R3						; copy R3 to R0
				
				LDR 	R2, =0x0F					; read 4 LSBs into R2
				ANDS	R0, R0, R2					; and write to 7-segment 
				LDR 	R1, =SEG7_digit_1_register	; display digit #1
				STR		R0, [R1]

				LSRS	R0,	R3, #4					; right shift R3 by 4 bits to R0
				
				LDR 	R2, =0x0F					; read 4 LSBs into R2
				ANDS	R0, R0, R2					; and write to 7-segment
				LDR 	R1, =SEG7_digit_2_register	; display digit #2
				STR		R0, [R1]
				
				LSRS	R0,	R3, #8					; right shift R3 by 8 bits to R0
				
				LDR 	R2, =0x0F					; read 4 LSBs into R2
				ANDS	R0, R0, R2					; and write to 7-segment
				LDR 	R1, =SEG7_digit_3_register	; display digit #3
				STR		R0, [R1]
				
				LSRS	R0,	R3, #12					; right shift R3 by 12 bits to R0
								
				LDR 	R2, =0x0F					; read 4 LSBs into R2
				ANDS	R0, R0, R2					; and write to 7-segment
				LDR 	R1, =SEG7_digit_4_register	; display digit #4
				STR		R0, [R1]
				
				B		main_loop


				ENDP

				ALIGN 		4		; Align to a word boundary

		END                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    
   