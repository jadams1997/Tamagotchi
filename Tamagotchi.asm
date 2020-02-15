#include p18f87k22.inc

    extern LCD_Setup, LCD_Send_Byte_D,LCD_shift, LCD_clear, Keyboard_Setup, GHOST, Keyboard, FOOD, LEARN, DANCE, SLEEPY, BALL_GAME
	
acs0                             udata_acs
counter_happiness                res 1 
counter_happiness_decrement      res 1
life_mode                        res 1
counter_life                     res 1
counter_output	                 res 1   
delay_count_1                    res 1
delay_count_2                    res 1
delay_count_3                    res 1
tables	                         udata 0x400    
myArray                          res 0x80 
Key_Pressed                      res 0x40
 
pdata code
Line_0          data "PRESS A TO HATCH"
	        variable Line_Bytes_0= .16

tamagotchi code
 
	org     0x0
	goto	setup
	org     0x100
 
setup	bcf	EECON1, CFGS	; point to Flash program memory  
	bsf	EECON1, EEPGD 	; access Flash program memory
	call	LCD_Setup	; setup LCD
	call    Keyboard_Setup  ; setup keyboard 
	goto    main
	
MAIN 
	nop
	nop
	nop
	call    output_PRESS_A_TO_HATCH   ;output "PRESS_A_TO_HATCH"
PRESS_A_TO_HATCH
	movlw   0x00
	movwf   Key_Pressed   ;Reset the key pressed variable
        call    Keyboard      ;call keyboard for an input
	movwf   Key_Pressed   ;waits for input
	movlw   0x41          
	cpfseq  Key_Pressed   ;is the key pressed A?
	bra     MAIN          ;if not, got back to start
	call    output_starting_screen   ;if A is pressed, output starting screen 
	call    output_hatching_sequence ;carry out hatching sequence 
	movlw   0xFF
	movwf   counter_happiness_decrement ;set the counter_happiness_decrement to 255
	movlw   0x64
	movwf   counter_happiness  ;counter_happiness to 100
	movlw   0x03          
	movwf   counter_life ;counter_life to 3
GAME_MODE
	movlw   0x00
	movwf   Key_Pressed    ;reset Key_Pressed variable 
	call    Keyboard     ;wait for keyboard input 
	movwf   KeyPressed 
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
CHECK_C_PRESSED
	movlw   0x43
	cpfseq  Key_Pressed 
	bra     CHECK_D_PRESSED 
	movf    life_mode, W
	call    SLEEPY
CHECK_D_PRESSED
	movlw   0x44
	cpfseq  Key_Pressed 
	bra     CHECK_E_PRESSED
	movf    life_mode, W
	call    DANCE
CHECK_E_PRESSED
	movlw   0x45
	cpfseq  Key_Pressed 
	bra     CHECK_F_PRESSED
	movf    life_mode, W
	call    LEARN	
CHECK_F_PRESSED 
	movlw   0x46
	cpfseq  Key_Pressed 
	bra     dch     ;if no key is pressed, decrement the happiness counter
	bra     fm      ; if F is pressed, go to FOOD
fm	movf    life_mode, W
	call    FOOD
dch	decfsz  counter_happiness_decrement
	bra     GAME_MODE
	movlw   0x01   ;If counter_happiness_decrement is zero, subtract counter happiness by 1
	subwf   counter_happiness
	call    HAPPINESS  ;call happiness, to update smiley, keep track of happiness, lives and death 
	
	
	
	
	
HAPPINESS	
	movlw   0x00
	cpfsgt  counter_happiness
	bra     LIFE  ;if counter_happiness is zero, go to decrease a life 
	movlw   b'11000000'
	call    LCD_shift   ;shifting where the LCD writes to ammend happiness character
	movlw   0x32
        cpfslt  counter_happiness 
	bra     HAPPY
	movlw   0x19
	cpfslt  counter_happiness
	bra     NEUTRAL
	bra     SAD
HAPPY   ;update the happiness marker 
	movlw   0x05    ;happy face location
	call    LCD_Send_Byte_D
NEUTRAL
	movlw   0x06    ;neutral face location
	call    LCD_Send_Byte_D
SAD 
	movlw   0x07    ;sad face location 
	call    LCD_Send_Byte_D
	return 
	
	
LIFE    ;evaluate the life counter and adjust hearts
	movlw   0x01
	subwf   counter_life 
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
ONE_LIFE_LEFT
	movlw   b'10000001'
	call    LCD_shift
	movlw   ' '
	call    LCD_Send_Byte_D
DEATH   ;for death, clear the LCD, send ghost 
	call    LCD_clear 
	movlw   b'11001000'
	call    LCD_shift 
	movlw   0x00   ;location of ghost
	call    LCD_Send_Byte_D
	call    delay 
	call    delay 
	call    delay 
	call    delay 
	bra     finished 
	
	
output_PRESS_A_TO_HATCH
	call    LCD_clear 
	movlw	upper(Line_0)	; address of data in PM
	movwf	TBLPTRU		; load upper bits to TBLPTRU
	movlw	high(Line_0)	; address of data in PM
	movwf	TBLPTRH		; load high byte to TBLPTRH
	movlw	low(Line_0)	; address of data in PM
	movwf	TBLPTRL		; load low byte to TBLPTRL
	movlw	Line_Bytes_0	; bytes to read
	movwf 	counter_output	; our counter register
loop 	tblrd*+			; one byte from PM to TABLAT, increment TBLPRT
	movf    TABLAT, w
        call    LCD_Send_Byte_D
	decfsz	counter_output	; count down to zero
	bra     loop
	return 
	
output_starting_screen
	call    LCD_clear
	movlw   0x01
	call    LCD_Send_Byte_D
	movlw   0x01
	call    LCD_Send_Byte_D
	movlw   0x01
	call    LCD_Send_Byte_D
	movlw   b'11000000'
	call    LCD_shift 
	movlw   0x06
	call    LCD_Send_Byte_D  ;display smiley face for starting happiness 
	movlw   0x41
	call    LCD_Send_Byte_D  ;display an A to show in hatching mode 
	movlw   b'11001000'
	call    LCD_shift 
	movlw   0x00   
	call    LCD_Send_Byte_D   ;output egg in middle of bottom line
	return 
output_hatching_sequence
	call    delay
	movlw   0x0F
	movwf   0x20  ; register to hold the number of times the egg will vibrate 
dynamic	movlw   b'11000111'     ;dynamic sequence shows the egg vibrating before it hatches 
	call    LCD_shift 
	movlw   0xDE   ;move bracket " to left of egg
	call    LCD_Send_Byte_D
	movlw   b'11001001'
	call    LCD_shift 
	movlw   0xDE   ;move bracket " to right of egg
	call    LCD_Send_Byte_D 
	call    delay 
	movlw   b'11000111'
	call    LCD_shift 
	movlw   ' ' 
	call    LCD_Send_Byte_D
	movlw   b'110010001'
	call    LCD_shift 
	movlw   ' '    ;make brackets disappear again
	call    LCD_Send_Byte_D 
	call    delay 
	decfsz  0x20  ;repeat blinking 0x020 times
	bra     dynamic 
	movlw   0x05
	movwf   0x20     ; register to hold the number of times the egg will blink in and out 
egg_blink
	movlw   b'11001000'
	call    LCD_shift 
	movlw   0x00   
	call    LCD_Send_Byte_D 
	call    delay
	movlw   b'11001000'
	call    LCD_shift 
	movlw   ' '
	call    LCD_Send_Byte_D 
	call    delay 
	decfsz  0x20
	bra     egg_blink 
crack   movlw   0xA1   
	call    LCD_Send_Byte_D   ;Output 
	movlw   b'11000111'
	call    LCD_shift 
	movlw   0x18  ;(
	call    LCD_Send_Byte_D
	movlw   b'11001001'
	call    LCD_shift 
	movlw   0x19  ;)
	call    LCD_Send_Byte_D 
	call    delay 
	call    delay 
	call    delay 
	movlw   b'11000111'
	call    LCD_shift 
	movlw   ' '
	call    LCD_Send_Byte_D
	movlw   b'11001001'
	call    LCD_shift 
	movlw   ' '
	call    LCD_Send_Byte_D 
	return 


delay
	movlw   0xFF
	movwf   delay_count_1
	movlw   0xFF
	movlw   0xFF
	movwf   delay_count_2
	movlw   0xFF
	movwf   delay_count_3
lb1     decfsz  delay_count_1
	bra     lb1
lb2     decfsz  delay_count_2
	bra     lb2
lb3     decfsz  delay_count_3
	bra     lb3
	return

	

finished
	
	end