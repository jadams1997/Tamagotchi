#include p18f87k22.inc

    global  LCD_Setup, LCD_Write_Message, LCD_Send_Byte_D, LCD_shift, LCD_clear
    global  LCD_custom_character_set_BABY, LCD_custom_character_set_SMALL
    global  LCD_custom_character_set_MEDIUM, LCD_custom_character_set_LARGE
    global  LCD_custom_character_set_EGG

acs0    udata_acs   ; named variables in access ram
LCD_cnt_l   res 1   ; reserve 1 byte for variable LCD_cnt_l
LCD_cnt_h   res 1   ; reserve 1 byte for variable LCD_cnt_h
LCD_cnt_ms  res 1   ; reserve 1 byte for ms counter
LCD_tmp	    res 1   ; reserve 1 byte for temporary use
LCD_counter res 1   ; reserve 1 byte for counting through nessage
	constant    LCD_E=5	; LCD enable bit
    	constant    LCD_RS=4	; LCD register select bit

 
LCD	code
    
LCD_Setup
	clrf    LATB
	movlw   b'11000000'	    ; RB0:5 all outputs
	movwf	TRISB
	movlw   .40
	call	LCD_delay_ms	; wait 40ms for LCD to start up properly
	movlw	b'00110000'	; Function set 4-bit
	call	LCD_Send_Byte_I
	movlw	.10		; wait 40us
	call	LCD_delay_x4us
	movlw	b'00101000'	; 2 line display 5x8 dot characters
	call	LCD_Send_Byte_I
	movlw	.10		; wait 40us
	call	LCD_delay_x4us
	movlw	b'00101000'	; repeat, 2 line display 5x8 dot characters
	call	LCD_Send_Byte_I
	movlw	.10		; wait 40us
	call	LCD_delay_x4us
	movlw	b'00001100'	; display on, cursor on, blinking on
	call	LCD_Send_Byte_I
	movlw	.10		; wait 40us
	call	LCD_delay_x4us  ;movlw	b'00000001'	; display clear
	call	LCD_clear ;call	LCD_Send_Byte_I
	movlw	b'00000110'	; entry mode incr by 1 no shift
	call	LCD_Send_Byte_I
	movlw	.10		; wait 40us
	call	LCD_delay_x4us
	call	LCD_custom_character_set_EGG
	return

LCD_Write_Message	    ; Message stored at FSR2, length stored in W
	movwf   LCD_counter
LCD_Loop_message
	movf    POSTINC0, W
	call    LCD_Send_Byte_D
	decfsz  LCD_counter
	bra	LCD_Loop_message
	return

LCD_Send_Byte_I		    ; Transmits byte stored in W to instruction reg
	movwf   LCD_tmp
	swapf   LCD_tmp,W   ; swap nibbles, high nibble goes first
	andlw   0x0f	    ; select just low nibble
	movwf   LATB	    ; output data bits to LCD
	bcf	LATB, LCD_RS	; Instruction write clear RS bit
	call    LCD_Enable  ; Pulse enable Bit 
	movf	LCD_tmp,W   ; swap nibbles, now do low nibble
	andlw   0x0f	    ; select just low nibble
	movwf   LATB	    ; output data bits to LCD
	bcf	LATB, LCD_RS    ; Instruction write clear RS bit
        call    LCD_Enable  ; Pulse enable Bit 
	return

LCD_Send_Byte_D		    ; Transmits byte stored in W to data reg
	movwf   LCD_tmp
	swapf   LCD_tmp,W   ; swap nibbles, high nibble goes first
	andlw   0x0f	    ; select just low nibble
	movwf   LATB	    ; output data bits to LCD
	bsf	LATB, LCD_RS	; Data write set RS bit
	call    LCD_Enable  ; Pulse enable Bit 
	movf	LCD_tmp,W   ; swap nibbles, now do low nibble
	andlw   0x0f	    ; select just low nibble
	movwf   LATB	    ; output data bits to LCD
	bsf	LATB, LCD_RS    ; Data write set RS bit	    
        call    LCD_Enable  ; Pulse enable Bit 
	movlw	.10	    ; delay 40us
	call	LCD_delay_x4us
	return

LCD_Enable	    ; pulse enable bit LCD_E for 500ns
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	bsf	    LATB, LCD_E	    ; Take enable high
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	bcf	    LATB, LCD_E	    ; Writes data to LCD
	return
    
LCD_delay_ms		    ; delay given in ms in W
	movwf	LCD_cnt_ms
lcdlp2	movlw	.250	    ; 1 ms delay
	call	LCD_delay_x4us	
	decfsz	LCD_cnt_ms
	bra	lcdlp2
	return
    
LCD_delay_x4us		    ; delay given in chunks of 4 microsecond in W
	movwf	LCD_cnt_l   ; now need to multiply by 16
	swapf   LCD_cnt_l,F ; swap nibbles
	movlw	0x0f	    
	andwf	LCD_cnt_l,W ; move low nibble to W
	movwf	LCD_cnt_h   ; then to LCD_cnt_h
	movlw	0xf0	    
	andwf	LCD_cnt_l,F ; keep high nibble in LCD_cnt_l
	call	LCD_delay
	return

LCD_delay			; delay routine	4 instruction loop == 250ns	    
	movlw 	0x00		; W=0
lcdlp1	decf 	LCD_cnt_l,F	; no carry when 0x00 -> 0xff
	subwfb 	LCD_cnt_h,F	; no carry when 0x00 -> 0xff
	bc 	lcdlp1		; carry, then loop again
	return			; carry reset so return

LCD_clear
	movlw	b'00000001'	; display clear
	call	LCD_Send_Byte_I
	movlw	.2		; wait 2ms
	call	LCD_delay_ms
	return
	
LCD_shift
	call LCD_Send_Byte_I
	movlw	.10		
	call	LCD_delay_x4us
	return 
	
LCD_custom_character_set_EGG   ;EGG 0X00,  HEART 0X01,  BABY 0X02, SUN 0X03, MOON 0X04, SMILEY 0X05, NEUTRAL 0X06, SAD 0X07
	
EGG 
	movlw b'0001000000'   ;setting CGRAM address of first line 
	call LCD_Send_Byte_I
	movlw	.10		
	call	LCD_delay_x4us
        movlw b'00000000'    ;writing first line of egg
	call LCD_Send_Byte_D
        movlw	.10		
	call	LCD_delay_x4us
	movlw b'0001000001'   ;setting CGRAM address of second line 
	call LCD_Send_Byte_I
	movlw	.10		
	call	LCD_delay_x4us
        movlw b'00000100'    ;writing second line of egg
	call LCD_Send_Byte_D
        movlw	.10		
	call	LCD_delay_x4us
        movlw b'0001000010'   ;setting CGRAM address of third line 
	call LCD_Send_Byte_I
	movlw	.10		
	call	LCD_delay_x4us
        movlw b'00001010'    ;writing third line of egg
	call LCD_Send_Byte_D
        movlw	.10		
	call	LCD_delay_x4us
	movlw b'0001000011'   ;setting CGRAM address of fourth line 
	call LCD_Send_Byte_I
	movlw	.10		
	call	LCD_delay_x4us
        movlw b'00010101'    ;writing fourth line of egg
	call LCD_Send_Byte_D
        movlw	.10		
	call	LCD_delay_x4us
	movlw b'0001000100'   ;setting CGRAM address of fifth line 
	call LCD_Send_Byte_I
	movlw	.10		
	call	LCD_delay_x4us
        movlw b'00011011'    ;writing fifth line of egg
	call LCD_Send_Byte_D
        movlw	.10		
	call	LCD_delay_x4us
	movlw b'0001000101'   ;setting CGRAM address of sixth line 
	call LCD_Send_Byte_I
	movlw	.10		
	call	LCD_delay_x4us
        movlw b'00010101'    ;writing sixth line of egg
	call LCD_Send_Byte_D
        movlw	.10		
	call	LCD_delay_x4us
	movlw b'0001000110'   ;setting CGRAM address of seventh line 
	call LCD_Send_Byte_I
	movlw	.10		
	call	LCD_delay_x4us
        movlw b'00011011'    ;writing seventh line of egg
	call LCD_Send_Byte_D
        movlw	.10		
	call	LCD_delay_x4us
	movlw b'0001000111'   ;setting CGRAM address of eigth line 
	call LCD_Send_Byte_I
	movlw	.10		
	call	LCD_delay_x4us
        movlw b'00001110'    ;writing eigth line of egg
	call LCD_Send_Byte_D
        movlw	.10		
	call	LCD_delay_x4us
	 
    
HEART 
	movlw b'0001001000'   ;setting CGRAM address of first line 
	call LCD_Send_Byte_I
	movlw	.10		
	call	LCD_delay_x4us
	movlw b'00000000'    ;writing first line of heart
	call LCD_Send_Byte_D
        movlw	.10		
	call	LCD_delay_x4us
	movlw b'0001001001'   ;setting CGRAM address of second line 
	call LCD_Send_Byte_I
	movlw	.10		
	call	LCD_delay_x4us
        movlw b'00001010'    ;writing second line of heart
	call LCD_Send_Byte_D
        movlw	.10		
	call	LCD_delay_x4us
        movlw b'0001001010'   ;setting CGRAM address of third line 
	call LCD_Send_Byte_I
	movlw	.10		
	call	LCD_delay_x4us
        movlw b'00010101'    ;writing third line of heart
	call LCD_Send_Byte_D
        movlw	.10		
	call	LCD_delay_x4us
	movlw b'0001001011'   ;setting CGRAM address of fourth line 
	call LCD_Send_Byte_I
	movlw	.10		
	call	LCD_delay_x4us
        movlw b'00010001'    ;writing fourth line of heart
	call LCD_Send_Byte_D
        movlw	.10		
	call	LCD_delay_x4us
	movlw b'0001001100'   ;setting CGRAM address of fifth line 
	call LCD_Send_Byte_I
	movlw	.10		
	call	LCD_delay_x4us
        movlw b'00010001'    ;writing fifth line of heart
	call LCD_Send_Byte_D
        movlw	.10		
	call	LCD_delay_x4us
	movlw b'0001001101'   ;setting CGRAM address of sixth line 
	call LCD_Send_Byte_I
	movlw	.10		
	call	LCD_delay_x4us
        movlw b'00001010'    ;writing sixth line of heart
	call LCD_Send_Byte_D
        movlw	.10		
	call	LCD_delay_x4us
	movlw b'0001001110'   ;setting CGRAM address of seventh line 
	call LCD_Send_Byte_I
	movlw	.10		
	call	LCD_delay_x4us
        movlw b'00000100'    ;writing seventh line of heart
	call LCD_Send_Byte_D
        movlw	.10		
	call	LCD_delay_x4us
	movlw b'0001001111'   ;setting CGRAM address of eigth line 
	call LCD_Send_Byte_I
	movlw	.10		
	call	LCD_delay_x4us
        movlw b'00000000'    ;writing eigth line of heart
	call LCD_Send_Byte_D
        movlw	.10		
	call	LCD_delay_x4us
	 
BABY 
	movlw b'0001010000'   ;setting CGRAM address of first line 
	call LCD_Send_Byte_I
	movlw	.10		
	call	LCD_delay_x4us
	movlw b'00000000'    ;writing first line of rabbit
	call LCD_Send_Byte_D
        movlw	.10		
	call	LCD_delay_x4us
	movlw b'0001010001'    ;setting CGRAM address of second line 
	call LCD_Send_Byte_I
	movlw	.10		
	call	LCD_delay_x4us
        movlw b'00000000'    ;writing second line of rabbit 
	call LCD_Send_Byte_D
        movlw	.10		
	call	LCD_delay_x4us
        movlw b'0001010010'    ;setting CGRAM address of third line 
	call LCD_Send_Byte_I
	movlw	.10		
	call	LCD_delay_x4us
        movlw b'00000000'    ;writing third line of rabbit 
	call LCD_Send_Byte_D
        movlw	.10		
	call	LCD_delay_x4us
	movlw b'0001010011'    ;setting CGRAM address of fourth line 
	call LCD_Send_Byte_I
	movlw	.10		
	call	LCD_delay_x4us
        movlw b'00000000'    ;writing fourth line of rabbit 
	call LCD_Send_Byte_D
        movlw	.10		
	call	LCD_delay_x4us
	movlw b'0001010100'    ;setting CGRAM address of fifth line 
	call LCD_Send_Byte_I
	movlw	.10		
	call	LCD_delay_x4us
        movlw b'00000000'    ;writing fifth line of rabbit 
	call LCD_Send_Byte_D
        movlw	.10		
	call	LCD_delay_x4us
	movlw b'0001010101'    ;setting CGRAM address of sixth line 
	call LCD_Send_Byte_I
	movlw	.10		
	call	LCD_delay_x4us
        movlw b'00000000'    ;writing sixth line of rabbit 
	call LCD_Send_Byte_D
        movlw	.10		
	call	LCD_delay_x4us
	movlw b'0001010110'    ;setting CGRAM address of seventh line 
	call LCD_Send_Byte_I
	movlw	.10		
	call	LCD_delay_x4us
        movlw b'00001100'    ;writing seventh line of rabbit 
	call LCD_Send_Byte_D
        movlw	.10		
	call	LCD_delay_x4us
	movlw b'0001010111'    ;setting CGRAM address of eigth line 
	call LCD_Send_Byte_I
	movlw	.10		
	call	LCD_delay_x4us
        movlw b'00001100'    ;writing eigth line of rabbit 
	call LCD_Send_Byte_D
        movlw	.10		
	call	LCD_delay_x4us	

	
SUN
	movlw b'0001011000'   ;setting CGRAM address of first line 
	call LCD_Send_Byte_I
	movlw	.10		
	call	LCD_delay_x4us
	movlw b'00000000'    ;writing first line
	call LCD_Send_Byte_D
        movlw	.10		
	call	LCD_delay_x4us
	movlw b'0001011001'    ;setting CGRAM address of second line 
	call LCD_Send_Byte_I
	movlw	.10		
	call	LCD_delay_x4us
        movlw b'00010101'    ;writing second line
	call LCD_Send_Byte_D
        movlw	.10		
	call	LCD_delay_x4us
        movlw b'0001011010'    ;setting CGRAM address of third line 
	call LCD_Send_Byte_I
	movlw	.10		
	call	LCD_delay_x4us
        movlw b'00001110'    ;writing third line
	call LCD_Send_Byte_D
        movlw	.10		
	call	LCD_delay_x4us
	movlw b'0001011011'    ;setting CGRAM address of fourth line 
	call LCD_Send_Byte_I
	movlw	.10		
	call	LCD_delay_x4us
        movlw b'00011111'    ;writing fourth line
	call LCD_Send_Byte_D
        movlw	.10		
	call	LCD_delay_x4us
	movlw b'0001011100'    ;setting CGRAM address of fifth line 
	call LCD_Send_Byte_I
	movlw	.10		
	call	LCD_delay_x4us
        movlw b'00001110'    ;writing fifth line
	call LCD_Send_Byte_D
        movlw	.10		
	call	LCD_delay_x4us
	movlw b'0001011101'    ;setting CGRAM address of sixth line 
	call LCD_Send_Byte_I
	movlw	.10		
	call	LCD_delay_x4us
        movlw b'00010101'    ;writing sixth line
	call LCD_Send_Byte_D
        movlw	.10		
	call	LCD_delay_x4us
	movlw b'0001011110'    ;setting CGRAM address of seventh line 
	call LCD_Send_Byte_I
	movlw	.10		
	call	LCD_delay_x4us
        movlw b'00000000'    ;writing seventh line
	call LCD_Send_Byte_D
        movlw	.10		
	call	LCD_delay_x4us
	movlw b'0001011111'    ;setting CGRAM address of eigth line 
	call LCD_Send_Byte_I
	movlw	.10		
	call	LCD_delay_x4us
        movlw b'00000000'    ;writing eigth line
	call LCD_Send_Byte_D
        movlw	.10		
	call	LCD_delay_x4us
	
	
MOON
	movlw b'0001100000'   ;setting CGRAM address of first line 
	call LCD_Send_Byte_I
	movlw	.10		
	call	LCD_delay_x4us
	movlw b'00000000'    ;writing first line of rabbit
	call LCD_Send_Byte_D
        movlw	.10		
	call	LCD_delay_x4us
	movlw b'0001100001'    ;setting CGRAM address of second line 
	call LCD_Send_Byte_I
	movlw	.10		
	call	LCD_delay_x4us
        movlw b'00001111'    ;writing second line of rabbit 
	call LCD_Send_Byte_D
        movlw	.10		
	call	LCD_delay_x4us
        movlw b'0001100010'    ;setting CGRAM address of third line 
	call LCD_Send_Byte_I
	movlw	.10		
	call	LCD_delay_x4us
        movlw b'00011100'    ;writing third line of rabbit 
	call LCD_Send_Byte_D
        movlw	.10		
	call	LCD_delay_x4us
	movlw b'0001100011'    ;setting CGRAM address of fourth line 
	call LCD_Send_Byte_I
	movlw	.10		
	call	LCD_delay_x4us
        movlw b'00011000'    ;writing fourth line of rabbit 
	call LCD_Send_Byte_D
        movlw	.10		
	call	LCD_delay_x4us
	movlw b'0001100100'    ;setting CGRAM address of fifth line 
	call LCD_Send_Byte_I
	movlw	.10		
	call	LCD_delay_x4us
        movlw b'00011000'    ;writing fifth line of rabbit 
	call LCD_Send_Byte_D
        movlw	.10		
	call	LCD_delay_x4us
	movlw b'0001100101'    ;setting CGRAM address of sixth line 
	call LCD_Send_Byte_I
	movlw	.10		
	call	LCD_delay_x4us
        movlw b'00011100'    ;writing sixth line of rabbit 
	call LCD_Send_Byte_D
        movlw	.10		
	call	LCD_delay_x4us
	movlw b'0001100110'    ;setting CGRAM address of seventh line 
	call LCD_Send_Byte_I
	movlw	.10		
	call	LCD_delay_x4us
        movlw b'00001111'    ;writing seventh line of rabbit 
	call LCD_Send_Byte_D
        movlw	.10		
	call	LCD_delay_x4us
	movlw b'0001100111'    ;setting CGRAM address of eigth line 
	call LCD_Send_Byte_I
	movlw	.10		
	call	LCD_delay_x4us
        movlw b'00000000'    ;writing eigth line of rabbit 
	call LCD_Send_Byte_D
        movlw	.10		
	call	LCD_delay_x4us

	
SMILEY
	movlw b'0001101000'   ;setting CGRAM address of first line 
	call LCD_Send_Byte_I
	movlw	.10		
	call	LCD_delay_x4us
	movlw b'00000000'    ;writing first line 
	call LCD_Send_Byte_D
        movlw	.10		
	call	LCD_delay_x4us
	movlw b'0001101001'    ;setting CGRAM address of second line 
	call LCD_Send_Byte_I
	movlw	.10		
	call	LCD_delay_x4us
        movlw b'00000000'    ;writing second line 
	call LCD_Send_Byte_D
        movlw	.10		
	call	LCD_delay_x4us
        movlw b'0001101010'    ;setting CGRAM address of third line 
	call LCD_Send_Byte_I
	movlw	.10		
	call	LCD_delay_x4us
        movlw b'00001010'    ;writing third line 
	call LCD_Send_Byte_D
        movlw	.10		
	call	LCD_delay_x4us
	movlw b'0001101011'    ;setting CGRAM address of fourth line 
	call LCD_Send_Byte_I
	movlw	.10		
	call	LCD_delay_x4us
        movlw b'00000000'    ;writing fourth line 
	call LCD_Send_Byte_D
        movlw	.10		
	call	LCD_delay_x4us
	movlw b'0001101100'    ;setting CGRAM address of fifth line 
	call LCD_Send_Byte_I
	movlw	.10		
	call	LCD_delay_x4us
        movlw b'00000000'    ;writing fifth line 
	call LCD_Send_Byte_D
        movlw	.10		
	call	LCD_delay_x4us
	movlw b'0001101101'    ;setting CGRAM address of sixth line 
	call LCD_Send_Byte_I
	movlw	.10		
	call	LCD_delay_x4us
        movlw b'00001010'    ;writing sixth line 
	call LCD_Send_Byte_D
        movlw	.10		
	call	LCD_delay_x4us
	movlw b'0001101110'    ;setting CGRAM address of seventh line 
	call LCD_Send_Byte_I
	movlw	.10		
	call	LCD_delay_x4us
        movlw b'00001110'    ;writing seventh line 
	call LCD_Send_Byte_D
        movlw	.10		
	call	LCD_delay_x4us
	movlw b'0001101111'    ;setting CGRAM address of eigth line 
	call LCD_Send_Byte_I
	movlw	.10		
	call	LCD_delay_x4us
        movlw b'00000000'    ;writing eigth line 
	call    LCD_Send_Byte_D
        movlw	.10		
	call	LCD_delay_x4us
	
	
NEUTRAL   
	movlw b'0001110000'   ;setting CGRAM address of first line 
	call LCD_Send_Byte_I
	movlw	.10		
	call	LCD_delay_x4us
	movlw b'00000000'    ;writing first line 
	call LCD_Send_Byte_D
        movlw	.10		
	call	LCD_delay_x4us
	movlw b'0001110001'    ;setting CGRAM address of second line 
	call LCD_Send_Byte_I
	movlw	.10		
	call	LCD_delay_x4us
        movlw b'00000000'    ;writing second line 
	call LCD_Send_Byte_D
        movlw	.10		
	call	LCD_delay_x4us
        movlw b'0001110010'    ;setting CGRAM address of third line 
	call LCD_Send_Byte_I
	movlw	.10		
	call	LCD_delay_x4us
        movlw b'00001010'    ;writing third line 
	call LCD_Send_Byte_D
        movlw	.10		
	call	LCD_delay_x4us
	movlw b'0001110011'    ;setting CGRAM address of fourth line 
	call LCD_Send_Byte_I
	movlw	.10		
	call	LCD_delay_x4us
        movlw b'00000000'    ;writing fourth line 
	call LCD_Send_Byte_D
        movlw	.10		
	call	LCD_delay_x4us
	movlw b'0001110100'    ;setting CGRAM address of fifth line 
	call LCD_Send_Byte_I
	movlw	.10		
	call	LCD_delay_x4us
        movlw b'00000000'    ;writing fifth line 
	call LCD_Send_Byte_D
        movlw	.10		
	call	LCD_delay_x4us
	movlw b'0001110101'    ;setting CGRAM address of sixth line 
	call LCD_Send_Byte_I
	movlw	.10		
	call	LCD_delay_x4us
        movlw b'00001110'    ;writing sixth line 
	call LCD_Send_Byte_D
        movlw	.10		
	call	LCD_delay_x4us
	movlw b'0001110110'    ;setting CGRAM address of seventh line 
	call LCD_Send_Byte_I
	movlw	.10		
	call	LCD_delay_x4us
        movlw b'00000000'    ;writing seventh line 
	call LCD_Send_Byte_D
        movlw	.10		
	call	LCD_delay_x4us
	movlw b'0001110111'    ;setting CGRAM address of eigth line 
	call LCD_Send_Byte_I
	movlw	.10		
	call	LCD_delay_x4us
        movlw b'00000000'    ;writing eigth line 
	call    LCD_Send_Byte_D
        movlw	.10		
	call	LCD_delay_x4us
	
	
SAD 
	movlw b'0001111000'   ;setting CGRAM address of first line 
	call LCD_Send_Byte_I
	movlw	.10		
	call	LCD_delay_x4us
	movlw b'00000000'    ;writing first line 
	call LCD_Send_Byte_D
        movlw	.10		
	call	LCD_delay_x4us
	movlw b'0001111001'    ;setting CGRAM address of second line 
	call LCD_Send_Byte_I
	movlw	.10		
	call	LCD_delay_x4us
        movlw b'00000000'    ;writing second line 
	call LCD_Send_Byte_D
        movlw	.10		
	call	LCD_delay_x4us
        movlw b'0001111010'    ;setting CGRAM address of third line 
	call LCD_Send_Byte_I
	movlw	.10		
	call	LCD_delay_x4us
        movlw b'00001010'    ;writing third line 
	call LCD_Send_Byte_D
        movlw	.10		
	call	LCD_delay_x4us
	movlw b'0001111011'    ;setting CGRAM address of fourth line 
	call LCD_Send_Byte_I
	movlw	.10		
	call	LCD_delay_x4us
        movlw b'00000000'    ;writing fourth line 
	call LCD_Send_Byte_D
        movlw	.10		
	call	LCD_delay_x4us
	movlw b'0001111100'    ;setting CGRAM address of fifth line 
	call LCD_Send_Byte_I
	movlw	.10		
	call	LCD_delay_x4us
        movlw b'00000000'    ;writing fifth line 
	call LCD_Send_Byte_D
        movlw	.10		
	call	LCD_delay_x4us
	movlw b'0001111101'    ;setting CGRAM address of sixth line 
	call LCD_Send_Byte_I
	movlw	.10		
	call	LCD_delay_x4us
        movlw b'00001110'    ;writing sixth line 
	call LCD_Send_Byte_D
        movlw	.10		
	call	LCD_delay_x4us
	movlw b'0001111110'    ;setting CGRAM address of seventh line 
	call LCD_Send_Byte_I
	movlw	.10		
	call	LCD_delay_x4us
        movlw b'00001010'    ;writing seventh line 
	call LCD_Send_Byte_D
        movlw	.10		
	call	LCD_delay_x4us
	movlw b'0001111111'    ;setting CGRAM address of eigth line 
	call LCD_Send_Byte_I
	movlw	.10		
	call	LCD_delay_x4us
        movlw b'00000000'    ;writing eigth line 
	call    LCD_Send_Byte_D
        movlw	.10		
	call	LCD_delay_x4us
	
	return 
	
LCD_custom_character_set_BABY  ;GHOST 0X00,  HEART 0X01,  BABY 0X02, SUN 0X03, MOON 0X04, SMILEY 0X05, NEUTRAL 0X06, SAD 0X07
	
GHOST
	movlw b'0001000000'   ;setting CGRAM address of first line 
	call LCD_Send_Byte_I
	movlw	.10		
	call	LCD_delay_x4us
	movlw b'00001110'    ;writing first line 
	call LCD_Send_Byte_D
        movlw	.10		
	call	LCD_delay_x4us
	movlw b'0001000001'    ;setting CGRAM address of second line 
	call LCD_Send_Byte_I
	movlw	.10		
	call	LCD_delay_x4us
        movlw b'00011111'    ;writing second line 
	call LCD_Send_Byte_D
        movlw	.10		
	call	LCD_delay_x4us
        movlw b'0001000010'    ;setting CGRAM address of third line 
	call LCD_Send_Byte_I
	movlw	.10		
	call	LCD_delay_x4us
        movlw b'00010101'    ;writing third line 
	call LCD_Send_Byte_D
        movlw	.10		
	call	LCD_delay_x4us
	movlw b'0001000011'    ;setting CGRAM address of fourth line 
	call LCD_Send_Byte_I
	movlw	.10		
	call	LCD_delay_x4us
        movlw b'00011111'    ;writing fourth line 
	call LCD_Send_Byte_D
        movlw	.10		
	call	LCD_delay_x4us
	movlw b'0001000100'    ;setting CGRAM address of fifth line 
	call LCD_Send_Byte_I
	movlw	.10		
	call	LCD_delay_x4us
        movlw b'00011111'    ;writing fifth line 
	call LCD_Send_Byte_D
        movlw	.10		
	call	LCD_delay_x4us
	movlw b'0001000101'    ;setting CGRAM address of sixth line 
	call LCD_Send_Byte_I
	movlw	.10		
	call	LCD_delay_x4us
        movlw b'00011111'    ;writing sixth line 
	call LCD_Send_Byte_D
        movlw	.10		
	call	LCD_delay_x4us
	movlw b'0001000110'    ;setting CGRAM address of seventh line 
	call LCD_Send_Byte_I
	movlw	.10		
	call	LCD_delay_x4us
        movlw b'00010101'    ;writing seventh line 
	call LCD_Send_Byte_D
        movlw	.10		
	call	LCD_delay_x4us
	movlw b'0001000111'    ;setting CGRAM address of eigth line 
	call LCD_Send_Byte_I
	movlw	.10		
	call	LCD_delay_x4us
        movlw b'00000000'    ;writing eigth line 
	call    LCD_Send_Byte_D
        movlw	.10		
	call	LCD_delay_x4us 

	return
	
LCD_custom_character_set_SMALL  ;GHOST 0X00,  HEART 0X01,  SMALL_RABBIT 0X02, SUN 0X03, MOON 0X04, SMILEY 0X05, NEUTRAL 0X06, SAD 0X07
	
SMALL_RABBIT
	movlw b'0001010000'   ;setting CGRAM address of first line 
	call LCD_Send_Byte_I
	movlw	.10		
	call	LCD_delay_x4us
	movlw b'00000000'    ;writing first line of small rabbit
	call LCD_Send_Byte_D
        movlw	.10		
	call	LCD_delay_x4us
	movlw b'0001010001'    ;setting CGRAM address of second line 
	call LCD_Send_Byte_I
	movlw	.10		
	call	LCD_delay_x4us
        movlw b'00000000'    ;writing second line of small rabbit 
	call LCD_Send_Byte_D
        movlw	.10		
	call	LCD_delay_x4us
        movlw b'0001010010'    ;setting CGRAM address of third line 
	call LCD_Send_Byte_I
	movlw	.10		
	call	LCD_delay_x4us
        movlw b'00000000'    ;writing third line of small rabbit 
	call LCD_Send_Byte_D
        movlw	.10		
	call	LCD_delay_x4us
	movlw b'0001010011'    ;setting CGRAM address of fourth line 
	call LCD_Send_Byte_I
	movlw	.10		
	call	LCD_delay_x4us
        movlw b'00001010'    ;writing fourth line of small rabbit 
	call LCD_Send_Byte_D
        movlw	.10		
	call	LCD_delay_x4us
	movlw b'0001010100'    ;setting CGRAM address of fifth line 
	call LCD_Send_Byte_I
	movlw	.10		
	call	LCD_delay_x4us
        movlw b'00001010'    ;writing fifth line of small rabbit 
	call LCD_Send_Byte_D
        movlw	.10		
	call	LCD_delay_x4us
	movlw b'0001010101'    ;setting CGRAM address of sixth line 
	call LCD_Send_Byte_I
	movlw	.10		
	call	LCD_delay_x4us
        movlw b'00001110'    ;writing sixth line of small rabbit 
	call LCD_Send_Byte_D
        movlw	.10		
	call	LCD_delay_x4us
	movlw b'0001010110'    ;setting CGRAM address of seventh line 
	call LCD_Send_Byte_I
	movlw	.10		
	call	LCD_delay_x4us
        movlw b'00001110'    ;writing seventh line of small rabbit 
	call LCD_Send_Byte_D
        movlw	.10		
	call	LCD_delay_x4us
	movlw b'0001010111'    ;setting CGRAM address of eigth line 
	call LCD_Send_Byte_I
	movlw	.10		
	call	LCD_delay_x4us
        movlw b'00001110'    ;writing eigth line of small rabbit 
	call LCD_Send_Byte_D
        movlw	.10		
	call	LCD_delay_x4us
	 
	return

	
LCD_custom_character_set_MEDIUM   ;GHOST 0X00,  HEART 0X01,  MEDIUM_RABBIT 0X02, SUN 0X03, MOON 0X04, SMILEY 0X05, NEUTRAL 0X06, SAD 0X07
	
MEDIUM_RABBIT
	movlw b'0001010000'   ;setting CGRAM address of first line 
	call LCD_Send_Byte_I
	movlw	.10		
	call	LCD_delay_x4us
	movlw b'00000000'    ;writing first line of rabbit
	call LCD_Send_Byte_D
        movlw	.10		
	call	LCD_delay_x4us
	movlw b'0001010001'    ;setting CGRAM address of second line 
	call LCD_Send_Byte_I
	movlw	.10		
	call	LCD_delay_x4us
        movlw b'00001010'    ;writing second line of rabbit 
	call LCD_Send_Byte_D
        movlw	.10		
	call	LCD_delay_x4us
        movlw b'0001010010'    ;setting CGRAM address of third line 
	call LCD_Send_Byte_I
	movlw	.10		
	call	LCD_delay_x4us
        movlw b'00001010'    ;writing third line of rabbit 
	call LCD_Send_Byte_D
        movlw	.10		
	call	LCD_delay_x4us
	movlw b'0001010011'    ;setting CGRAM address of fourth line 
	call LCD_Send_Byte_I
	movlw	.10		
	call	LCD_delay_x4us
        movlw b'00011111'    ;writing fourth line of rabbit 
	call LCD_Send_Byte_D
        movlw	.10		
	call	LCD_delay_x4us
	movlw b'0001010100'    ;setting CGRAM address of fifth line 
	call LCD_Send_Byte_I
	movlw	.10		
	call	LCD_delay_x4us
        movlw b'00010101'    ;writing fifth line of rabbit 
	call LCD_Send_Byte_D
        movlw	.10		
	call	LCD_delay_x4us
	movlw b'0001010101'    ;setting CGRAM address of sixth line 
	call LCD_Send_Byte_I
	movlw	.10		
	call	LCD_delay_x4us
        movlw b'00011011'    ;writing sixth line of rabbit 
	call LCD_Send_Byte_D
        movlw	.10		
	call	LCD_delay_x4us
	movlw b'0001010110'    ;setting CGRAM address of seventh line 
	call LCD_Send_Byte_I
	movlw	.10		
	call	LCD_delay_x4us
        movlw b'00011111'    ;writing seventh line of rabbit 
	call LCD_Send_Byte_D
        movlw	.10		
	call	LCD_delay_x4us
	movlw b'0001010111'    ;setting CGRAM address of eigth line 
	call LCD_Send_Byte_I
	movlw	.10		
	call	LCD_delay_x4us
        movlw b'00001110'    ;writing eigth line of rabbit 
	call LCD_Send_Byte_D
        movlw	.10		
	call	LCD_delay_x4us	

	return

LCD_custom_character_set_LARGE   ;GHOST 0X00,  HEART 0X01,  LARGE_RABBIT 0X02, SUN 0X03, MOON 0X04, SMILEY 0X05, NEUTRAL 0X06, SAD 0X07
	
LARGE_RABBIT
	movlw b'0001010000'   ;setting CGRAM address of first line 
	call LCD_Send_Byte_I
	movlw	.10		
	call	LCD_delay_x4us
	movlw b'00011011'    ;writing first line of rabbit
	call LCD_Send_Byte_D
        movlw	.10		
	call	LCD_delay_x4us
	movlw b'0001010001'    ;setting CGRAM address of second line 
	call LCD_Send_Byte_I
	movlw	.10		
	call	LCD_delay_x4us
        movlw b'00001010'    ;writing second line of rabbit 
	call LCD_Send_Byte_D
        movlw	.10		
	call	LCD_delay_x4us
        movlw b'0001010010'    ;setting CGRAM address of third line 
	call LCD_Send_Byte_I
	movlw	.10		
	call	LCD_delay_x4us
        movlw b'00011111'    ;writing third line of rabbit 
	call LCD_Send_Byte_D
        movlw	.10		
	call	LCD_delay_x4us
	movlw b'0001010011'    ;setting CGRAM address of fourth line 
	call LCD_Send_Byte_I
	movlw	.10		
	call	LCD_delay_x4us
        movlw b'00010101'    ;writing fourth line of rabbit 
	call LCD_Send_Byte_D
        movlw	.10		
	call	LCD_delay_x4us
	movlw b'0001010100'    ;setting CGRAM address of fifth line 
	call LCD_Send_Byte_I
	movlw	.10		
	call	LCD_delay_x4us
        movlw b'00011011'    ;writing fifth line of rabbit 
	call LCD_Send_Byte_D
        movlw	.10		
	call	LCD_delay_x4us
	movlw b'0001010101'    ;setting CGRAM address of sixth line 
	call LCD_Send_Byte_I
	movlw	.10		
	call	LCD_delay_x4us
        movlw b'00011111'    ;writing sixth line of rabbit 
	call LCD_Send_Byte_D
        movlw	.10		
	call	LCD_delay_x4us
	movlw b'0001010110'    ;setting CGRAM address of seventh line 
	call LCD_Send_Byte_I
	movlw	.10		
	call	LCD_delay_x4us
        movlw b'00001110'    ;writing seventh line of rabbit 
	call LCD_Send_Byte_D
        movlw	.10		
	call	LCD_delay_x4us
	movlw b'0001010111'    ;setting CGRAM address of eigth line 
	call LCD_Send_Byte_I
	movlw	.10		
	call	LCD_delay_x4us
        movlw b'00011111'    ;writing eigth line of rabbit 
	call LCD_Send_Byte_D
        movlw	.10		
	call	LCD_delay_x4us
	
	return 
	
	
	end




