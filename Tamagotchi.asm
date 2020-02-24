#include p18f87k22.inc

    extern LCD_Setup, LCD_Send_Byte_D, LCD_shift, LCD_clear, output_HEAT_TO_HATCH
    extern FOOD, LEARN, DANCE, SLEEPY, BALL_GAME, output_starting_screen
    extern output_hatching_sequence, output_PRESS_A_TO_START, FOOD_Setup
    extern BABY, GHOST, ADC_Setup, TEMPERATURE, Temperature_hex_1, Temperature_hex_2
	
acs0                             udata_acs
counter_happiness                res 1
counter_happiness_decrement      res 1
counter_happiness_decrement_2    res 1
counter_happiness_decrement_3    res 1
life_mode                        res 1
counter_life                     res 1
delay_count_1                    res 1
delay_count_2                    res 1
delay_count_3                    res 1
tables	                         udata 0x400    
myArray                          res 0x80 		  
counter_row	                 res 1
counter_column	                 res 1
Key_Pressed                      res 0x40
sound_buuzz                      res 1
 

tamagotchi code
 
	org     0x0
	goto	setup
	org     0x100
 
setup	bcf	EECON1, CFGS	; point to Flash program memory  
	bsf	EECON1, EEPGD 	; access Flash program memory
	call	LCD_Setup	; setup LCD
	call    Keyboard_Setup  ; setup keyboard 
	call    FOOD_Setup 
	call    ADC_Setup
	goto    MAIN
	
MAIN 
	nop
	nop
	nop
	call    output_PRESS_A_TO_START   ;output "PRESS_A_TO_HATCH"
PRESS_A_TO_START
	movlw   0xFF
	movwf	counter_happiness_decrement
	movlw   0x00
	movwf   Key_Pressed   ;Reset the key pressed variable
        call    Keyboard      ;call keyboard for an input
	movwf   Key_Pressed   ;waits for input
	movlw   0x41          
	cpfseq  Key_Pressed   ;is the key pressed A?
	bra     PRESS_A_TO_START         ;if not, got back to start
	call	output_HEAT_TO_HATCH
	call	delay
	call    output_starting_screen   ;if A is pressed, output starting screen 
hatch_temp
	call	delay
	call    TEMPERATURE 
	movlw   0xDC
	cpfsgt  Temperature_hex_1
	bra     coldh
	bra	hoth
coldh	movlw   b'11000010'
	call    LCD_shift 
	movlw   0x2A
	call    LCD_Send_Byte_D	
	bra     hatch_temp
hoth	movlw   b'11000010'
	call    LCD_shift 
	movlw   0xD7
	call    LCD_Send_Byte_D
	call    output_hatching_sequence ;carry out hatching sequence 	
	movlw   0xFE
	movwf   counter_happiness_decrement ;set the counter_happiness_decrement to 255
	movlw   0xFE
	movwf	counter_happiness_decrement_2
	movlw   0x01
	movwf   counter_happiness_decrement_3
	movlw   0xF4
	movwf   counter_happiness  ;counter_happiness to 100
	movlw   0x03          
	movwf   counter_life ;counter_life to 3
	movlw	0x0
	movwf   life_mode ;initialise the life mode at 0 for baby rabbit
	call    BABY
	call	GHOST
GAME_MODE
	movlw   0x00
	movwf   Key_Pressed    ;reset Key_Pressed variable 
	call    Keyboard     ;wait for keyboard input 
	movwf   Key_Pressed 
CHECK_A_PRESSED
	movlw   0x41      ;is the key pressed A?
	cpfseq  Key_Pressed 
	bra     CHECK_B_PRESSED   
	bra     GAME_MODE
CHECK_B_PRESSED
	movlw   0x42       ;is the key pressed B?
	cpfseq  Key_Pressed 
	bra     CHECK_C_PRESSED
	movf    life_mode, W    ;save the life_mode for the game to use
	call    BALL_GAME
	movlw	0xf4
	movwf	counter_happiness
	call	HAPPINESS
	bra     GAME_MODE
CHECK_C_PRESSED
	movlw   0x43
	cpfseq  Key_Pressed 
	bra     CHECK_D_PRESSED 
	movf    life_mode, W
	call    SLEEPY
	movlw	0xf4
	movwf	counter_happiness
	call	HAPPINESS
	bra     GAME_MODE
CHECK_D_PRESSED
	movlw   0x44
	cpfseq  Key_Pressed 
	bra     CHECK_E_PRESSED
	movf    life_mode, W
	call    DANCE
	movlw	0xf4
	movwf	counter_happiness
	call	HAPPINESS
	bra     GAME_MODE
CHECK_E_PRESSED
	movlw   0x45
	cpfseq  Key_Pressed 
	bra     CHECK_F_PRESSED
	movf    life_mode, W
	call    LEARN
	movlw	0xf4
	movwf	counter_happiness
	call	HAPPINESS
	bra     GAME_MODE
CHECK_F_PRESSED 
	movlw   0x46
	cpfseq  Key_Pressed 
	bra     GAME_MODE    ;if no key is pressed
	movf    life_mode, W
	call    FOOD; if F is pressed, go to FOOD.  Food returns new life_mode
	movwf   life_mode
	movlw	0xf4
	movwf	counter_happiness
	call	HAPPINESS
	bra     GAME_MODE
	
	
	
 
Keyboard_Setup
        clrf LATE 
        movlw 0xFF
        movwf 0x20
        call delay_k
        return 
    
    
Keyboard
        call setup_row
        bra read_row
column
        call setup_column
        bra read_column
    
    
setup_row 
        movlw 0xF0
        movwf TRISE, ACCESS  
        bsf PADCFG1, REPU, BANKED
        movlw 0x0F
        movwf PORTE, ACCESS
        movlw 0xFF
        movwf 0x20
        call delay_k
        return 
   
read_row   
	btfss PORTE, RE4
	bra check_1
	movlw 0x0
	movwf counter_row
	bra column
check_1
	btfss PORTE, RE5
	bra check_2
	movlw 0x01
	movwf counter_row
	bra column
check_2
	btfss PORTE, RE6
	bra check_3
	movlw 0x02
	movwf counter_row
	bra column
check_3
	btfss PORTE, RE7
	bra   dch
	movlw 0x03
	movwf counter_row
	bra column
    
setup_column
	movlw 0x0F
	movwf TRISE, ACCESS 
	bsf PADCFG1, REPU, BANKED
	movlw 0xF0
	movwf PORTE, ACCESS
	movlw 0xFF
	movwf 0x20
	call delay_k
	return 

read_column   
	btfss PORTE, RE0
	bra check_5
	movlw 0x04
	movwf counter_column
	bra decode
check_5
	btfss PORTE, RE1
	bra check_6
	movlw 0x05
	movwf counter_column
	bra decode
check_6
	btfss PORTE, RE2
	bra check_7
	movlw 0x06
	movwf counter_column
	bra decode
check_7
	btfss PORTE, RE3
	bra read_row
	movlw 0x07
	movwf counter_column
	bra decode

	
delay_k 
	decfsz 0x20
	bra delay_k
	return 

decode
	movlw 0x00
	cpfseq counter_row
	bra row_1
	bra column_11
	return 
column_11
	movlw 0x04
	cpfseq counter_column
	bra column_12
	movlw '1'
	return 
column_12
	movlw 0x05
	cpfseq counter_column
	bra column_13
	movlw '2'
	return 
column_13
	movlw 0x06
	cpfseq counter_column
	bra column_14
	movlw '3'
	return 
column_14
	movlw 'F'
	return 
row_1 
	movlw 0x01
	cpfseq counter_row
	bra row_2
	bra column_21
column_21
	movlw 0x04
	cpfseq counter_column
	bra column_22
	movlw '4'
	return 
column_22
	movlw 0x05
	cpfseq counter_column
	bra column_23
	movlw '5'
	return 
column_23
	movlw 0x06
	cpfseq counter_column
	bra column_24
	movlw '6'
	return 
column_24
	movlw 'E'
	return 
row_2
	movlw 0x02
	cpfseq counter_row
	bra row_3
	bra column_31
column_31
	movlw 0x04
	cpfseq counter_column
	bra column_32
	movlw '7'
	return 
column_32
	movlw 0x05
	cpfseq counter_column
	bra column_33
	movlw '8'
	return 
column_33
	movlw 0x06
	cpfseq counter_column
	bra column_34
	movlw '9'
	return 
column_34
	movlw 'D'
	return 
row_3
	bra column_41
column_41
	movlw 0x04
	cpfseq counter_column
	bra column_42
	movlw 'A'
	return 
column_42
	movlw 0x05
	cpfseq counter_column
	bra column_43
	movlw '0'
	return 
column_43
	movlw 0x06
	cpfseq counter_column
	bra column_44
	movlw 'B'
	return 
column_44
	movlw 'C'
	return 

	
dch	movlw   0xFF
	cpfseq  counter_happiness_decrement
	bra	dch1
	bra     read_row
dch1	decfsz  counter_happiness_decrement
	bra     read_row
	decfsz  counter_happiness_decrement_2
	bra	dch2
	bra     dch3
dch2    movlw	0xFE
	movwf	counter_happiness_decrement
	bra	read_row
dch3	decfsz  counter_happiness_decrement_3
	bra	dch4
	bra     dch5
dch4	movlw	0xFE
	movwf	counter_happiness_decrement_2
	bra	read_row	
dch5	movlw   0x01   ;If counter_happiness_decrement is zero, subtract counter happiness by 1
	subwf   counter_happiness, 1
	call    HAPPINESS  ;call happiness, to update smiley, keep track of happiness, lives and death 
	movlw   0x00
	cpfsgt  counter_happiness
	call    LIFE  ;if counter_happiness is zero, go to decrease a life 
	movlw   0xFE
	movwf	counter_happiness_decrement ;reset counter_happiness_decrement to 100
	movlw	0xFE
	movwf	counter_happiness_decrement_2
	movlw	0x01
	movwf	counter_happiness_decrement_3
	bra	read_row
	
    
	
TEMP
	call    TEMPERATURE 
	movlw   0xDB
	cpfsgt  Temperature_hex_1
	bra     cold_check 
	bra     hot 
cold_check
	movlw   0xC8
	cpfslt	Temperature_hex_1
	bra	normal_temp
	bra	snowflake
snowflake 
	movlw   b'11000010'
	call    LCD_shift 
	movlw   0x2A
	call    LCD_Send_Byte_D
	return 
hot 
	movlw   b'11000010'
	call    LCD_shift 
	movlw   0xD7
	call    LCD_Send_Byte_D
	return 
normal_temp
	movlw   b'11000010'
	call    LCD_shift 
	movlw   ' '
	call    LCD_Send_Byte_D
	return 
	
HAPPINESS	
	call    TEMP 
	movlw   b'11000000'
	call    LCD_shift   ;shifting where the LCD writes to ammend happiness character
	movlw   0x96
        cpfslt  counter_happiness 
	bra     HAPPY
	movlw   0x32
	cpfslt  counter_happiness
	bra     NEUTRAL
	bra     SAD
	
HAPPY   ;update the happiness marker 
	movlw   b'11000000'
	call    LCD_shift 
	movlw   0x05    ;happy face location
	call    LCD_Send_Byte_D
	return 
NEUTRAL
	movlw   b'11000000'
	call    LCD_shift 
	movlw   0x06    ;neutral face location
	call    LCD_Send_Byte_D
	return 
SAD 
	movlw   b'11000000'
	call    LCD_shift 
	movlw   0x07    ;sad face location 
	call    LCD_Send_Byte_D
	return 
	
	
LIFE    ;evaluate the life counter and adjust hearts
	movlw   0x01
	subwf   counter_life, 1
	movlw   0x02
	cpfseq  counter_life 
	bra     CHECK_LAST_LIFE
	bra     TWO_LIVES_LEFT
CHECK_LAST_LIFE    
	movlw   0x01 
	cpfseq  counter_life
	bra     DEATH
	bra     ONE_LIFE_LEFT
TWO_LIVES_LEFT
	movlw   b'10000010'
	call    LCD_shift
	movlw   ' '
	call    LCD_Send_Byte_D
	movlw   0xF4
	movwf   counter_happiness
	movlw   b'11000000'
	call    LCD_shift
	movlw   0x05
	call    LCD_Send_Byte_D
	return 
ONE_LIFE_LEFT
	movlw   b'10000001'
	call    LCD_shift
	movlw   ' '
	call    LCD_Send_Byte_D
	movlw   0xF4
	movwf   counter_happiness
	movlw   b'11000000'
	call    LCD_shift
	movlw   0x05
	call    LCD_Send_Byte_D
	return 
DEATH   ;for death, clear the LCD, send ghost 
	call    LCD_clear
	movlw   b'11001001'
	call    LCD_shift 
	movlw   0x00   ; DDRAM location of ghost
	call    LCD_Send_Byte_D
	call    delay 
	call    delay 
	call    delay 
	call    delay
	movlw   b'11001001'  ;45
	call    LCD_shift 
	movlw   ' '
	call    LCD_Send_Byte_D
	movlw   0x00
	call    LCD_Send_Byte_D
	call    delay 
	movlw   b'11001010'
	call    LCD_shift 
	movlw   ' '
	call    LCD_Send_Byte_D
	movlw   0x00
	call    LCD_Send_Byte_D
	call    delay 
	movlw   b'11001011'
	call    LCD_shift 
	movlw   ' '
	call    LCD_Send_Byte_D
	movlw   0x00
	call    LCD_Send_Byte_D
	call    delay 
	movlw   b'11001100'
	call    LCD_shift 
	movlw   ' '
	call    LCD_Send_Byte_D
	movlw   0x00
	call    LCD_Send_Byte_D
	call	delay
	movlw   b'11001101'  ;45
	call    LCD_shift 
	movlw   ' '
	call    LCD_Send_Byte_D
	movlw   0x00
	call    LCD_Send_Byte_D
	call    delay 
	movlw   b'11001110'
	call    LCD_shift 
	movlw   ' '
	call    LCD_Send_Byte_D
	movlw   0x00
	call    LCD_Send_Byte_D
	call    delay 
	movlw   b'11001111'
	call    LCD_shift 
	movlw   ' '
	call    LCD_Send_Byte_D
	bra     setup



delay
	movlw   0xff
	movwf   delay_count_1
delay_1       
	decfsz  delay_count_1
	bra     nested_2
	return
	
nested_2
	movlw   0xff
	movwf   delay_count_2
delay_2	decfsz  delay_count_2
	bra     nested_3
	bra     delay_1

nested_3
	movlw   0xff
	movwf   delay_count_3
delay_3
	decfsz  delay_count_3
	bra     delay_3
	bra     delay_2

finished
	
	end