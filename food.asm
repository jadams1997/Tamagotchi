#include p18f87k22.inc

    extern LCD_Send_Byte_D, LCD_shift, LCD_clear, LCD_custom_character_set_BABY
    extern LCD_custom_character_set_SMALL, LCD_custom_character_set_MEDIUM
    extern LCD_custom_character_set_LARGE
    global FOOD, FOOD_Setup


acs0		    udata_acs
lifemode_food	    res 1
delay_counter_f1    res 1
delay_counter_f2    res 1
delay_counter_f3    res 1
flash_counter	    res 1
counter_flash_1	    res 1
counter_flash_2	    res 1
counter_blank       res 1 
food_counter	    res 1
    
fdata code
 
flash_line_1	data	    "* * * * * * *"
		constant    flash_bytes_l=.13	
flash_line_2	data	    " * * * * * * "
		constant    flash_bytes_2=.13
blank_line      data        "             "
                constant    blank_bytes= .13
	
Food code

FOOD_Setup 
        movlw   0x00
	movwf   food_counter
	return

output_flash_1
	movlw	upper(flash_line_1)	; address of data in PM
	movwf	TBLPTRU		; load upper bits to TBLPTRU
	movlw	high(flash_line_1)	; address of data in PM
	movwf	TBLPTRH		; load high byte to TBLPTRH
	movlw	low(flash_line_1)	; address of data in PM
	movwf	TBLPTRL		; load low byte to TBLPTRL
	movlw	flash_bytes_l	; bytes to read
	movwf 	counter_flash_1	; our counter register
loopf1 	tblrd*+			; one byte from PM to TABLAT, increment TBLPRT
	movf    TABLAT, w
        call    LCD_Send_Byte_D
	decfsz	counter_flash_1	; count down to zero
	bra     loopf1
	return 	
	
output_flash_2
	movlw	upper(flash_line_2)	; address of data in PM
	movwf	TBLPTRU		; load upper bits to TBLPTRU
	movlw	high(flash_line_2)	; address of data in PM
	movwf	TBLPTRH		; load high byte to TBLPTRH
	movlw	low(flash_line_2)	; address of data in PM
	movwf	TBLPTRL		; load low byte to TBLPTRL
	movlw	flash_bytes_2	; bytes to read
	movwf 	counter_flash_2  ; our counter register
loopf2 	tblrd*+			; one byte from PM to TABLAT, increment TBLPRT
	movf    TABLAT, w
        call    LCD_Send_Byte_D
	decfsz	counter_flash_2	; count down to zero
	bra     loopf2
	return 	
 
output_blank
	movlw	upper(blank_line)	; address of data in PM
	movwf	TBLPTRU		; load upper bits to TBLPTRU
	movlw	high(blank_line)	; address of data in PM
	movwf	TBLPTRH		; load high byte to TBLPTRH
	movlw	low(blank_line)	; address of data in PM
	movwf	TBLPTRL		; load low byte to TBLPTRL
	movlw	blank_bytes	; bytes to read
	movwf 	counter_blank	; our counter register
loopb 	tblrd*+			; one byte from PM to TABLAT, increment TBLPRT
	movf    TABLAT, w
        call    LCD_Send_Byte_D
	decfsz	counter_blank	; count down to zero
	bra     loopb
	return 	
	
	
	
	
	
FOOD 
	movwf   lifemode_food
	movlw   0x01
	addwf   food_counter, 1
FOOD_ANIMATE
	movlw   0x05
	call    LCD_shift 
	movlw   0x27
	call    LCD_Send_Byte_D
	call    food_delay
	movlw   0x05
	call    LCD_shift
	movlw   0x2C
	call    LCD_Send_Byte_D
	call    food_delay
	movlw   0x45
	call    LCD_shift 
	movlw   0x27
	call    LCD_Send_Byte_D
	call    food_delay
	movlw   0x45
	call    LCD_shift
	movlw   0x2C
	call    LCD_Send_Byte_D
	call    food_delay  ;food dropped
	movlw   0x49
	call    LCD_shift 
	movlw   ' '
	call    LCD_Send_Byte_D
	movlw   0x48
	call    LCD_shift 
	movlw   0x02
	call    LCD_Send_Byte_D
	call    food_delay 
	movlw   ' '
	call    LCD_Send_Byte_D
	movlw   0x47
	call    LCD_shift 
	movlw   0x02
	call    LCD_Send_Byte_D
	call    food_delay 
	movlw   ' '
	call    LCD_Send_Byte_D
	movlw   0x46
	call    LCD_shift 
	movlw   0x02
	call    LCD_Send_Byte_D
	call    food_delay 
	movlw   ' '
	call    LCD_Send_Byte_D
	movlw   0x45
	call    LCD_shift 
	movlw   0x02
	call    LCD_Send_Byte_D ;eaten
	movlw   0x45
	call    LCD_shift 
	movlw   ' '
	call    LCD_Send_Byte_D
	movlw   0x02
	call    LCD_Send_Byte_D
	call    food_delay 
	movlw   0x46
	call    LCD_shift 
	movlw   ' '
	call    LCD_Send_Byte_D
	movlw   0x02
	call    LCD_Send_Byte_D
	call    food_delay 
	movlw   0x47
	call    LCD_shift 
	movlw   ' '
	call    LCD_Send_Byte_D
	movlw   0x02
	call    LCD_Send_Byte_D
	call    food_delay 
	movlw   0x48
	call    LCD_shift 
	movlw   ' '
	call    LCD_Send_Byte_D
	movlw   0x02
	call    LCD_Send_Byte_D ;back at centre
CHECK_GROWTH
check_10
	movlw   0x0A
	cpfseq  food_counter 
	bra     check_25
	bra     GROWTH
check_25 
	movlw   0x19
	cpfseq  food_counter 
	bra     check_50
	bra     GROWTH
check_50
	movlw   0x32
	cpfseq  food_counter
	return 
	call    GROWTH
	
	return
	
	
GROWTH
	movlw   0x01
	addwf   lifemode_food, 1
GROWTH_ANIMATE
	movlw   0x49   ;position
	call    LCD_shift 
	movlw   0x2A  ;star
	call    LCD_Send_Byte_D
	call    food_delay
	call    food_delay
	call    food_delay
	movlw   0x4A 
	call    LCD_shift 
	movlw   0x2A
	call    LCD_Send_Byte_D
	movlw   0x09
	call    LCD_shift 
	movlw   0x2A
	call    LCD_Send_Byte_D
	movlw   0x48
	call    LCD_shift 
	movlw   0x2A
	call    LCD_Send_Byte_D
	call    food_delay
	call    food_delay
	call    food_delay
	movlw   0x4B
	call    LCD_shift 
	movlw   0x2A
	call    LCD_Send_Byte_D
	movlw   0x0A
	call    LCD_shift 
	movlw   0x2A
	call    LCD_Send_Byte_D
	movlw   0x08
	call    LCD_shift 
	movlw   0x2A
	call    LCD_Send_Byte_D
	movlw   0x47
	call    LCD_shift 
	movlw   0x2A
	call    LCD_Send_Byte_D
	call    food_delay
	call    food_delay
	call    food_delay
	movlw   0x4C
	call    LCD_shift 
	movlw   0x2A
	call    LCD_Send_Byte_D
	movlw   0x0B
	call    LCD_shift 
	movlw   0x2A
	call    LCD_Send_Byte_D
	movlw   0x07
	call    LCD_shift 
	movlw   0x2A
	call    LCD_Send_Byte_D
	movlw   0x46
	call    LCD_shift 
	movlw   0x2A
	call    LCD_Send_Byte_D
	call    food_delay
	call    food_delay
	call    food_delay
	movlw   0x4D
	call    LCD_shift 
	movlw   0x2A
	call    LCD_Send_Byte_D
	movlw   0x0C
	call    LCD_shift 
	movlw   0x2A
	call    LCD_Send_Byte_D
	movlw   0x06
	call    LCD_shift 
	movlw   0x2A
	call    LCD_Send_Byte_D
	movlw   0x45
	call    LCD_shift 
	movlw   0x2A
	call    LCD_Send_Byte_D
	call    food_delay
	call    food_delay
	call    food_delay
	movlw   0x4E
	call    LCD_shift 
	movlw   0x2A
	call    LCD_Send_Byte_D
	movlw   0x0D
	call    LCD_shift 
	movlw   0x2A
	call    LCD_Send_Byte_D
	movlw   0x05
	call    LCD_shift 
	movlw   0x2A
	call    LCD_Send_Byte_D
	movlw   0x44
	call    LCD_shift 
	movlw   0x2A
	call    LCD_Send_Byte_D
	call    food_delay
	call    food_delay
	call    food_delay
	movlw   0x4F
	call    LCD_shift 
	movlw   0x2A
	call    LCD_Send_Byte_D
	movlw   0x0E
	call    LCD_shift 
	movlw   0x2A
	call    LCD_Send_Byte_D
	movlw   0x04
	call    LCD_shift 
	movlw   0x2A
	call    LCD_Send_Byte_D
	movlw   0x43
	call    LCD_shift 
	movlw   0x2A
	call    LCD_Send_Byte_D
	call    food_delay
	call    food_delay
	call    food_delay
	movlw   0x0F
	call    LCD_shift 
	movlw   0x2A
	call    LCD_Send_Byte_D
	movlw   0x03
	call    LCD_shift 
	movlw   0x2A
	call    LCD_Send_Byte_D
	movlw   0x05
	movwf   flash_counter
flashes	
	call    food_delay
	call    food_delay
	call    food_delay
	movlw	0x03
	call	LCD_shift 
	call	output_flash_1
	movlw	0x43
	call	LCD_shift 
	call    output_flash_2
	call	food_delay
	call	food_delay
	call	food_delay
	movlw	0x03
	call	LCD_shift 
	call    output_flash_2
	movlw	0x43
	call	LCD_shift 
	call    output_flash_1
	decfsz  flash_counter
	bra	flashes
	movlw	0x03
	call	LCD_shift 
	call    output_blank
	movlw	0x43
	call	LCD_shift 
	call    output_blank
NEW_FORM
	movlw   0x01
	cpfseq  lifemode_food
	bra     check_medium
	bra     small
check_medium
	movlw   0x02
	cpfseq  lifemode_food
	bra     large 
	bra     medium
small 
	call    LCD_custom_character_set_SMALL
	movlw   0x49
	call    LCD_shift
	movlw   0x02
	call    LCD_Send_Byte_D   ;small rabbit created from baby 
	movf    lifemode_food, W
	return 
medium 
	call    LCD_custom_character_set_MEDIUM
	movlw   0x49
	call    LCD_shift
	movlw   0x02
	call    LCD_Send_Byte_D
	movf    lifemode_food, W
	return 
large 
	call    LCD_custom_character_set_LARGE
	movlw   0x49
	call    LCD_shift
	movlw   0x02
	call    LCD_Send_Byte_D
	movf    lifemode_food, W
	return 
	;alternate flashes to go here followed by change of rabbit character


food_delay
	movlw   0x40
	movwf   delay_counter_f1
delay_1       
	decfsz  delay_counter_f1
	bra     nested_2
	return
	
nested_2
	movlw   0x40
	movwf   delay_counter_f2
delay_2	decfsz  delay_counter_f2
	bra     nested_3
	bra     delay_1

nested_3
	movlw   0x40
	movwf   delay_counter_f3
delay_3
	decfsz  delay_counter_f3
	bra     delay_3
	bra     delay_2
     
    
    end 