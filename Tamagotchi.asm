#include p18f87k22.inc

    extern LCD_Setup, LCD_Send_Byte_D,LCD_shift, LCD_clear
	
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
 
pdata code

Line_1	data "ABC111DEF100"
        variable Line_Bytes_1 = .12


tamagotchi code
 
	org 0x0
	goto	setup
	org 0x100
 
;rst	code	0    ; reset vector
setup	bcf	EECON1, CFGS	; point to Flash program memory  
	bsf	EECON1, EEPGD 	; access Flash program memory
	nop
	nop
	nop 
	call	LCD_Setup	; setup LCD
	goto main


main    
	call output_starting_screen
	bra finished
	
output_starting_screen
	movlw	upper(Line_1)	; address of data in PM
	movwf	TBLPTRU		; load upper bits to TBLPTRU
	movlw	high(Line_1)	; address of data in PM
	movwf	TBLPTRH		; load high byte to TBLPTRH
	movlw	low(Line_1)	; address of data in PM
	movwf	TBLPTRL		; load low byte to TBLPTRL
	movlw	Line_Bytes_1	; bytes to read
	movwf 	counter_output	; our counter register
loop 	tblrd*+			; one byte from PM to TABLAT, increment TBLPRT
	movf    TABLAT, w
        call    LCD_Send_Byte_D
	decfsz	counter_output	; count down to zero
	bra     shift_checks
	return 
shift_checks
	movlw   0x09
	cpfseq  counter_output
	bra     check_1
	call    shift_1
check_1 
	movlw   0x06
	cpfseq  counter_output
	bra     check_2
	call    shift_2
check_2
	movlw   0x03
	cpfseq  counter_output 
	bra     check_3
	call    shift_3
check_3
	bra     loop
	
	
shift_1	
	movlw   b'10001101'
	call    LCD_shift 
	return
shift_2
	movlw   b'11000000'
	call    LCD_shift 
	return 
shift_3
	movlw   b'11001101'
	call    LCD_shift 
	return 

	
delay
	movlw 0xFF
	movwf delay_count
d	decfsz	delay_count	; decrement until zero
	bra d
	return

	

finished
	nop 
	nop 
	nop 
	nop
	
	end