#include p18f87k22.inc

    extern LCD_Setup
	
    
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
 
myTable data	    "ABC.................DEF............"	; message, plus carriage return
	constant    myTable_l=.32	; length of data

tamagotchi code 
 
output
 
rst	code	0    ; reset vector
	goto	setup

setup	bcf	EECON1, CFGS	; point to Flash program memory  
	bsf	EECON1, EEPGD 	; access Flash program memory
	call	LCD_Setup	; setup LCD
	goto	start
	
start   movlw	upper(myTable)	; address of data in PM
	movwf	TBLPTRU		; load upper bits to TBLPTRU
	movlw	high(myTable)	; address of data in PM
	movwf	TBLPTRH		; load high byte to TBLPTRH
	movlw	low(myTable)	; address of data in PM
	movwf	TBLPTRL		; load low byte to TBLPTRL
	movlw	myTable_l	; bytes to read
	movwf 	counter_output	; our counter register
loop 	tblrd*+			; one byte from PM to TABLAT, increment TBLPRT
	movf    TABLAT, w
	call    LCD_Send_Byte_D
	decfsz	counter_output	; count down to zero
	bra	loop		; keep going until finished

	goto	$		; goto current line in code

 
main
     bra output
     
  
    


	
	
delay	decfsz	delay_count	; decrement until zero
	bra delay
	return

 end