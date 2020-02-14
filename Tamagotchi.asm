#include p18f87k22.inc

    extern LCD_Setup, LCD_Send_Byte_D,LCD_shift, LCD_clear, Keyboard_Setup, Keyboard
	
acs0 udata_acs
counter_row res 1
counter_column res 1
counter_happiness res 1 
counter_happiness_decrement res 1
counter_food res 1 
counter_life res 1
counter_output	    res 1   
delay_count res 1 
tables	udata 0x400    
myArray res 0x80 
Key_Pressed res 0x20
 
pdata code
Line_0  data "PRESS A TO HATCH"
	variable Line_Bytes_0= .16


tamagotchi code
 
	org 0x0
	goto	setup
	org 0x100
 
setup	bcf	EECON1, CFGS	; point to Flash program memory  
	bsf	EECON1, EEPGD 	; access Flash program memory
	call	LCD_Setup	; setup LCD
	call    Keyboard_Setup
	goto    main
	
main    
	nop
	nop
	call    output_PRESS_A_TO_HATCH
PRESS_A_TO_HATCH
	movlw   0x00
	movwf   Key_Pressed
        call    Keyboard 
	movwf   Key_Pressed
	movlw   0x41
	cpfseq  Key_Pressed 
	bra     main
	call    output_starting_screen
HATCH_SEQUENCE
	bra     finished
	
output_PRESS_A_TO_HATCH
	call    LCD_clear 
	movlw	upper(Line_0)	; address of data in PM
	movwf	TBLPTRU		; load upper bits to TBLPTRU
	movlw	high(Line_0)	; address of data in PM
	movwf	TBLPTRH		; load high byte to TBLPTRH
	movlw	low(Line_0)	; address of data in PM
	movwf	TBLPTRL		; load low byte to TBLPTRL
	movlw	Line_Bytes_0	; bytes to read
	movwf 	counter_output	; our counter register
loop_0 	tblrd*+			; one byte from PM to TABLAT, increment TBLPRT
	movf    TABLAT, w
        call    LCD_Send_Byte_D
	decfsz	counter_output	; count down to zero
	bra     loop_0
	return 

	
output_starting_screen
	call    LCD_clear
	movlw   0x01
	call    LCD_Send_Byte_D
	movlw   0x01
	call    LCD_Send_Byte_D
	movlw   0x01
	call    LCD_Send_Byte_D
	movlw   b'11000000'
	call    LCD_shift 
	movlw   0x05
	call    LCD_Send_Byte_D
	movlw   0x23
	call    LCD_Send_Byte_D
	movlw   b'11001000'
	call    LCD_shift 
	movlw   0x00
	call    LCD_Send_Byte_D
	return 

	
delay
	movlw 0xFF
	movwf delay_count
d	decfsz	delay_count	; decrement until zero
	bra d
	return

	

finished
	
	end