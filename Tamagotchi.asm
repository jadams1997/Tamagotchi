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

Line1	data "ABC"
        variable Line_Bytes = .3
Line2   data "DEF" 
Line3   data 0x30
   
	
	
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
	# Line = Line1
	call output
	;#undefine Line
	;movlw b'11000000'
	;call LCD_shift
	;#define Line Line2
	;call output
	;movlw 0x00
	;movwf Line
	;#undefine Line
	;movlw b'11001000'
	;call LCD_shift
	;movlw 0x30
	;call LCD_Send_Byte_D
	;movlw b'10001101'
	;call LCD_shift
	;movlw 0x30
	;call LCD_Send_Byte_D
	;movlw 0x30
	;call LCD_Send_Byte_D
	;movlw 0x30
	;call LCD_Send_Byte_D
	;movlw b'11001101'
	;call LCD_shift
	;movlw 0x30
	;call LCD_Send_Byte_D
	;movlw 0x30
	;call LCD_Send_Byte_D
	;movlw 0x30
	;call LCD_Send_Byte_D
	;;#define Line b'11100010'
	;#define Line_Bytes .1
	;bra output
	bra finished
	
	

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
	return  		; goto current line in code
	
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