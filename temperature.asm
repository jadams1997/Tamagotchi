#include p18f87k22.inc
    
    
    global ADC_Setup,  TEMPERATURE, Temperature_hex_1, Temperature_hex_2
    
   
    
acs9 udata_acs
 
Temperature_hex_1 res 1
Temperature_hex_2 res 1 
LCD_hex_tmp     res 1
LCD_tmp  res 1

 

temp code
 
 
TEMPERATURE 
     call  measure 
     return 
    
ADC_Setup
    bsf TRISA,RA3 ; use pin A3(==AN0) for input
    bsf ANCON0,ANSEL3 ; set A3 to analog
    movlw 0x01 ; select AN0 for measurement
    movwf ADCON0 ; and turn ADC on
    movlw 0x30 ; Select 4.096V positive reference
    movwf ADCON1 ; 0V for -ve reference and -ve input
    movlw 0xF6 ; Right justified output
    movwf ADCON2 ; Fosc/64 A/D clock and 20x acquisition time
    return
ADC_Read
    bsf ADCON0,GO ; Start conversion
adc_loop
    btfsc ADCON0,GO ; check to see if finished
    bra adc_loop
    return


measure 
    call  ADC_Read 
    movf  ADRESH, W 
    ;call  LCD_Write_Hex
    movwf Temperature_hex_2
    movf  ADRESL, W
    ;call  LCD_Write_Hex
    movwf Temperature_hex_1
    return 
    
LCD_Write_Hex	    ; Writes byte stored in W as hex
	movwf	LCD_hex_tmp
	swapf	LCD_hex_tmp,W	; high nibble first
	call	LCD_Hex_Nib
	movf	LCD_hex_tmp,W	; then low nibble
LCD_Hex_Nib	    ; writes low nibble as hex character
	andlw	0x0F
	movwf	LCD_tmp
	movlw	0x0A
	cpfslt	LCD_tmp
	addlw	0x07	; number is greater than 9 
	addlw	0x26
	addwf	LCD_tmp,W
	return
	
    end