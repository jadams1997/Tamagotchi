#include p18f87k22.inc

    extern LCD_clear, LCD_Send_Byte_D, LCD_shift
    global output_starting_screen, output_hatching sequence, output_PRESS_A_TO_HATCH

acs0		    udata_acs   
delay_counter_1	    res 1   
delay_counter_2	    res 1   
delay_counter_3	    res 1   
counter_output	    res 1  

pdata code
Line_0          data "PRESS A TO HATCH"
	        variable Line_Bytes_0= .16
		
Hatch	code	

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
loop 	tblrd*+			; one byte from PM to TABLAT, increment TBLPRT
	movf    TABLAT, w
        call    LCD_Send_Byte_D
	decfsz	counter_output	; count down to zero
	bra     loop
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
	movlw   0x06
	call    LCD_Send_Byte_D  ;display smiley face for starting happiness 
	movlw   0x41
	call    LCD_Send_Byte_D  ;display an A to show in hatching mode 
	movlw   b'11001000'
	call    LCD_shift 
	movlw   0x00   
	call    LCD_Send_Byte_D   ;output egg in middle of bottom line
	return 	
	
output_hatching_sequence
	call    hatch_delay
	movlw   0x0F
	movwf   0x20  ; register to hold the number of times the egg will vibrate 
dynamic	movlw   b'11000111'     ;dynamic sequence shows the egg vibrating before it hatches 
	call    LCD_shift 
	movlw   0xDE   ;move bracket " to left of egg
	call    LCD_Send_Byte_D
	movlw   b'11001001'
	call    LCD_shift 
	movlw   0xDE   ;move bracket " to right of egg
	call    LCD_Send_Byte_D 
	call    hatch_delay 
	movlw   b'11000111'
	call    LCD_shift 
	movlw   ' ' 
	call    LCD_Send_Byte_D
	movlw   b'110010001'
	call    LCD_shift 
	movlw   ' '    ;make brackets disappear again
	call    LCD_Send_Byte_D 
	call    hatch_delay 
	decfsz  0x20  ;repeat blinking 0x020 times
	bra     dynamic 
	movlw   0x05
	movwf   0x20     ; register to hold the number of times the egg will blink in and out 
egg_blink
	movlw   b'11001000'
	call    LCD_shift 
	movlw   0x00   
	call    LCD_Send_Byte_D 
	call    hatch_delay
	movlw   b'11001000'
	call    LCD_shift 
	movlw   ' '
	call    LCD_Send_Byte_D 
	call    hatch_delay 
	decfsz  0x20
	bra     egg_blink 
crack   movlw   0xA1   
	call    LCD_Send_Byte_D   ;Output 
	movlw   b'11000111'
	call    LCD_shift 
	movlw   0x18  ;(
	call    LCD_Send_Byte_D
	movlw   b'11001001'
	call    LCD_shift 
	movlw   0x19  ;)
	call    LCD_Send_Byte_D 
	call    hatch_delay 
	call    hatch_delay 
	call    hatch_delay 
	movlw   b'11000111'
	call    LCD_shift 
	movlw   ' '
	call    LCD_Send_Byte_D
	movlw   b'11001001'
	call    LCD_shift 
	movlw   ' '
	call    LCD_Send_Byte_D 
	return 

hatch_delay
	movlw   0xFF
	movwf   delay_counter_1
	movlw   0xFF
	movwf   delay_counter_2
	movlw   0xFF
	movwf   delay_counter_3
lb1     decfsz  delay_counter_1
	bra     lb1
lb2     decfsz  delay_counter_2
	bra     lb2
lb3     decfsz  delay_counter_3
	bra     lb3
	return
  
	end