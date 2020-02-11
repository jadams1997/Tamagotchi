#include p18f87k22.inc

    extern LCD_Setup, LCD_Send_Byte_D,LCD_shift
	
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

Line1	data "PRESS A TO START"
        variable Line_Bytes = .16
Line2	data "PRESS B FORDEATH"     
	
	
tamagotchi code 
 
rst	code	0    ; reset vector
	goto	setup
setup	bcf	EECON1, CFGS	; point to Flash program memory  
	bsf	EECON1, EEPGD 	; access Flash program memory
	call	LCD_Setup	; setup LCD
	
 
main    
	#define Line Line1
	bra output
	#undefine Line
	#define Line Line2
	bra output
	
	
	
	

 
output  movlw	upper(Line)	; address of data in PM
	movwf	TBLPTRU		; load upper bits to TBLPTRU
	movlw	high(Line)	; address of data in PM
	movwf	TBLPTRH		; load high byte to TBLPTRH
	movlw	low(Line)	; address of data in PM
	movwf	TBLPTRL		; load low byte to TBLPTRL
	movlw	Line_Bytes	; bytes to read
	movwf 	counter_output	; our counter register
loop 	tblrd*+			; one byte from PM to TABLAT, increment TBLPRT
	movf    TABLAT, w
	call    LCD_Send_Byte_D
	decfsz	counter_output	; count down to zero
	bra	loop		; keep going until finished

	goto	$		; goto current line in code
	
	
delay	decfsz	delay_count	; decrement until zero
	bra delay
	return

 end