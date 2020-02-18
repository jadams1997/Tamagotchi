#include p18f87k22.inc

    extern LCD_Send_Byte_D,LCD_shift, LCD_clear,DISCO_1,DISCO_2,GHOST,MOON
    global DANCE
    

    
acs0		    udata_acs
lifemode_dance 	    res 1
delay_counter_d1    res 1
delay_counter_d2    res 1
delay_counter_d3    res 1
dance_counter	    res 1    
 
dance code
 
DANCE 
	call	DISCO_1
	call	DISCO_2
	movlw	0x05
	movwf	dance_counter
	movwf   lifemode_dance
	movlw   0x0
        cpfseq  lifemode_dance 
	bra     check_1
	bra     BABY
check_1 movlw   0x01
	cpfseq  lifemode_dance 
	bra     check_2
	bra     SMALL
check_2 movlw   0x02
	cpfseq  lifemode_dance
	bra     LARGE 
	bra     MEDIUM 
BABY 
	movlw	b'10001111'
	call    LCD_shift
	movlw	0x00
	call	LCD_Send_Byte_D
	movlw	b'11001001'
	call    LCD_shift
	movlw	' '
	call	LCD_Send_Byte_D
	movlw	b'10001001'
	call    LCD_shift
	movlw	0x02
	call	LCD_Send_Byte_D
	call	dance_delay
	movlw	b'10001111'
	call    LCD_shift
	movlw	0x04
	call	LCD_Send_Byte_D
	movlw	b'10001001'
	call    LCD_shift
	movlw	' '
	call	LCD_Send_Byte_D
	movlw	b'11001001'
	call    LCD_shift
	movlw	0x02
	call	LCD_Send_Byte_D
	call	dance_delay
	decfsz  dance_counter
	bra	BABY
	movlw	b'11001001'
	call    LCD_shift
	movlw	' '
	call	LCD_Send_Byte_D
	movlw	b'10001001'
	call    LCD_shift
	movlw	0x02
	call	LCD_Send_Byte_D
	call	GHOST
	call	MOON
	return
SMALL 
	movlw	b'10001111'
	call    LCD_shift
	movlw	0x00
	call	LCD_Send_Byte_D
	movlw	b'11001001'
	call    LCD_shift
	movlw	' '
	call	LCD_Send_Byte_D
	movlw	b'10001001'
	call    LCD_shift
	movlw	0x02
	call	LCD_Send_Byte_D
	call	dance_delay
	movlw	b'10001111'
	call    LCD_shift
	movlw	0x04
	call	LCD_Send_Byte_D
	movlw	b'10001001'
	call    LCD_shift
	movlw	' '
	call	LCD_Send_Byte_D
	movlw	b'11001001'
	call    LCD_shift
	movlw	0x02
	call	LCD_Send_Byte_D
	call	dance_delay
	decfsz  dance_counter
	bra	SMALL
	movlw	b'11001001'
	call    LCD_shift
	movlw	' '
	call	LCD_Send_Byte_D
	movlw	b'10001001'
	call    LCD_shift
	movlw	0x02
	call	LCD_Send_Byte_D
	call	GHOST
	call	MOON
	return
	
MEDIUM 
	movlw	b'10001111'
	call    LCD_shift
	movlw	0x00
	call	LCD_Send_Byte_D
	call	dance_delay
	movlw	b'10001111'
	call    LCD_shift
	movlw	0x04
	call	LCD_Send_Byte_D
	call	dance_delay
	decfsz  dance_counter
	bra	MEDIUM
	call	GHOST
	call	MOON
	return
LARGE 
	movlw	b'10001111'
	call    LCD_shift
	movlw	0x00
	call	LCD_Send_Byte_D
	call	dance_delay
	movlw	b'10001111'
	call    LCD_shift
	movlw	0x04
	call	LCD_Send_Byte_D
	call	dance_delay
	decfsz  dance_counter
	bra	LARGE
	call	GHOST
	call	MOON
	return 
    
    
dance_delay
	movlw   0x90
	movwf   delay_counter_d1
delay_1       
	decfsz  delay_counter_d1
	bra     nested_2
	return
	
nested_2
	movlw   0x90
	movwf   delay_counter_d2
delay_2	decfsz  delay_counter_d2
	bra     nested_3
	bra     delay_1

nested_3
	movlw   0x90
	movwf   delay_counter_d3
delay_3
	decfsz  delay_counter_d3
	bra     delay_3
	bra     delay_2
    
    
    end 