#include p18f87k22.inc

    extern LCD_Send_Byte_D,LCD_shift, LCD_clear,DISCO_1,DISCO_2,GHOST,MOON
    global DANCE
    

    
acs0		    	udata_acs
lifemode_dance 	    	res 1
delay_counter_d1    	res 1
delay_counter_d2    	res 1
delay_counter_d3    	res 1
dance_counter_baby  	res 1    
dance_counter_small_1	res 1
dance_counter_small_2	res 1
wave_counter		res 1

dance code

DBALL_1
	movlw	b'10001111'
	call    LCD_shift
	movlw	0x00
	call	LCD_Send_Byte_D
	return

DBALL_2
	movlw	b'10001111'
	call    LCD_shift
	movlw	0x04
	call	LCD_Send_Byte_D
	return

DBALL_CLEAR
	movlw	b'10001111'
	call    LCD_shift
	movlw	' '
	call	LCD_Send_Byte_D
	return

BOUNCE
	call    DBALL_1
	movlw	b'11001001'
	call    LCD_shift
	movlw	' '
	call	LCD_Send_Byte_D
	movlw	b'10001001'
	call    LCD_shift
	movlw	0x02
	call	LCD_Send_Byte_D
	call	dance_delay
	call	DBALL_2
	movlw	b'10001001'
	call    LCD_shift
	movlw	' '
	call	LCD_Send_Byte_D
	movlw	b'11001001'
	call    LCD_shift
	movlw	0x02
	call	LCD_Send_Byte_D
	call	dance_delay
	return
	
HOPS
	call    DBALL_1
	movlw	b'11001001'
	call    LCD_shift
	movlw	' '
	call	LCD_Send_Byte_D
	movlw	b'10001000'
	call    LCD_shift
	movlw	0x02
	call	LCD_Send_Byte_D
	call    dance_delay
	call    DBALL_2
	movlw	b'10001000'
	call    LCD_shift
	movlw	' '
	call	LCD_Send_Byte_D
	movlw	b'11000111'
	call    LCD_shift
	movlw	0x02
	call	LCD_Send_Byte_D
	call    dance_delay
	call    DBALL_1
	movlw	b'11000111'
	call    LCD_shift
	movlw	' '
	call	LCD_Send_Byte_D
	movlw	b'10000110'
	call    LCD_shift
	movlw	0x02
	call	LCD_Send_Byte_D
	call    dance_delay
	call    DBALL_2
	movlw	b'10000110'
	call    LCD_shift
	movlw	' '
	call	LCD_Send_Byte_D
	movlw	b'11000101'
	call    LCD_shift
	movlw	0x02
	call	LCD_Send_Byte_D
	call    dance_delay
	call    DBALL_1
	movlw	b'11000101'
	call    LCD_shift
	movlw	' '
	call	LCD_Send_Byte_D
	movlw	b'10000110'
	call    LCD_shift
	movlw	0x02
	call	LCD_Send_Byte_D
	call 	dance_delay
	call    DBALL_2
	movlw	b'10000110'
	call    LCD_shift
	movlw	' '
	call	LCD_Send_Byte_D
	movlw	b'11000111'
	call    LCD_shift
	movlw	0x02
	call	LCD_Send_Byte_D
	call    dance_delay
	call    DBALL_1
	movlw	b'11000111'
	call    LCD_shift
	movlw	' '
	call	LCD_Send_Byte_D
	movlw	b'10001000'
	call    LCD_shift
	movlw	0x02
	call	LCD_Send_Byte_D
	call    dance_delay
	call    DBALL_2
	movlw	b'10001000'
	call    LCD_shift
	movlw	' '
	call	LCD_Send_Byte_D
	movlw	b'11001001'
	call    LCD_shift
	movlw	0x02
	call	LCD_Send_Byte_D
	call    dance_delay
	call    DBALL_1
	movlw	b'11001001'
	call    LCD_shift
	movlw	' '
	call	LCD_Send_Byte_D
	movlw	b'10001010'
	call    LCD_shift
	movlw	0x02
	call	LCD_Send_Byte_D
	call    dance_delay
	call    DBALL_2
	movlw	b'10001010'
	call    LCD_shift
	movlw	' '
	call	LCD_Send_Byte_D
	movlw	b'11001011'
	call    LCD_shift
	movlw	0x02
	call	LCD_Send_Byte_D
	call    dance_delay
	call    DBALL_1
	movlw	b'11001011'
	call    LCD_shift
	movlw	' '
	call	LCD_Send_Byte_D
	movlw	b'10001100'
	call    LCD_shift
	movlw	0x02
	call	LCD_Send_Byte_D
	call    dance_delay
	call    DBALL_2
	movlw	b'10001100'
	call    LCD_shift
	movlw	' '
	call	LCD_Send_Byte_D
	movlw	b'11001101'
	call    LCD_shift
	movlw	0x02
	call	LCD_Send_Byte_D
	call    dance_delay
	call    DBALL_1
	movlw	b'11001101'
	call    LCD_shift
	movlw	' '
	call	LCD_Send_Byte_D
	movlw	b'10001100'
	call    LCD_shift
	movlw	0x02
	call	LCD_Send_Byte_D
	call    dance_delay
	call    DBALL_2
	movlw	b'10001100'
	call    LCD_shift
	movlw	' '
	call	LCD_Send_Byte_D
	movlw	b'11001011'
	call    LCD_shift
	movlw	0x02
	call	LCD_Send_Byte_D
	call    dance_delay
	call    DBALL_1
	movlw	b'11001011'
	call    LCD_shift
	movlw	' '
	call	LCD_Send_Byte_D
	movlw	b'10001010'
	call    LCD_shift
	movlw	0x02
	call	LCD_Send_Byte_D
	call    dance_delay
	call    DBALL_2
	movlw	b'10001010'
	call    LCD_shift
	movlw	' '
	call	LCD_Send_Byte_D
	movlw	b'11001001'
	call    LCD_shift
	movlw	0x02
	call	LCD_Send_Byte_D
	call	dance_delay
	return

WAVE	
	movlw	0x0A
	movwf	wave_counter
wave	call	DBALL_1
	movlw	b'11001010'
	call    LCD_shift
	movlw	0xCD
	call	LCD_Send_Byte_D
	movlw	b'11001000'
	call    LCD_shift
	movlw	0xCD
	call	LCD_Send_Byte_D
	call 	dance_delay
	call	DBALL_2
	movlw	b'11001010'
	call    LCD_shift
	movlw	' ' 
	call	LCD_Send_Byte_D
	movlw	b'11001000'
	call    LCD_shift
	movlw	' '
	call	LCD_Send_Byte_D
	movlw	b'10001010'
	call    LCD_shift
	movlw	0x2E
	call	LCD_Send_Byte_D
	movlw	b'10001000'
	call    LCD_shift
	movlw	0x2E
	call	LCD_Send_Byte_D
	call 	dance_delay
	movlw	b'10001010'
	call    LCD_shift
	movlw	' '
	call	LCD_Send_Byte_D
	movlw	b'10001000'
	call    LCD_shift
	movlw	' '
	call	LCD_Send_Byte_D
	decfsz	wave_counter
	bra	wave
	call 	DBALL_1
	movlw	b'11001010'
	call    LCD_shift
	movlw	0xCD
	call	LCD_Send_Byte_D
	movlw	b'11001000'
	call    LCD_shift
	movlw	0xCD
	call	LCD_Send_Byte_D
	call 	dance_delay
	call	DBALL_2
	movlw	b'11001010'
	call    LCD_shift
	movlw	' '
	call	LCD_Send_Byte_D
	movlw	b'11001000'
	call    LCD_shift
	movlw	' '
	call	LCD_Send_Byte_D
	call    dance_delay
	return
	
DANCE 
	call	DISCO_1
	call	DISCO_2
	movlw	0x0A
	movwf	dance_counter_baby
	movlw	0x04
	movwf	dance_counter_small_1
	movlw	0x02
	movwf	dance_counter_small_2
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
	call    DBALL_1
	call	dance_delay
	call 	DBALL_2
	call	dance_delay
	call	BOUNCE
	decfsz  dance_counter_baby
	bra	BABY
	call	DBALL_1
	call	dance_delay
	call	DBALL_2
	call 	dance_delay
	call 	DBALL_CLEAR
	call	GHOST
	call	MOON
	return

SMALL 
	call    DBALL_1
	call	dance_delay
	call	DBALL_2
	call	dance_delay
	call	BOUNCE
	decfsz  dance_counter_small_1
	bra	SMALL
	call	DBALL_1
	call	dance_delay
	call	DBALL_2
	call	dance_delay
hops	call 	HOPS
	decfsz	dance_counter_small_2
	bra	hops
	call	DBALL_1
	call	dance_delay
	call	DBALL_2
	call	dance_delay
	call 	DBALL_CLEAR
	call	GHOST
	call	MOON
	return
	
MEDIUM 	
	call    DBALL_1
	call	dance_delay
	call	DBALL_2
	call	dance_delay
	call 	WAVE
	call 	HOPS
	call	WAVE
	call	HOPS
	call	WAVE
	call    DBALL_1
	call	dance_delay
	call    DBALL_2
	call	dance_delay
	call	DBALL_CLEAR
	call	GHOST
	call	MOON
	return
LARGE 
	call    DBALL_1
	call	dance_delay
	call	DBALL_2
	call	dance_delay
	call	BOUNCE
	call	BOUNCE
	call	WAVE
	call    BOUNCE
	call	BOUNCE
	call	HOPS
	call	BOUNCE
	call	BOUNCE
	call	WAVE
	call	BOUNCE
	call 	BOUNCE
	call    DBALL_1
	call	dance_delay
	call	DBALL_2
	call	dance_delay
	call	DBALL_CLEAR
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
