#include p18f87k22.inc

    extern LCD_Send_Byte_D,LCD_shift, LCD_clear
    global BALL_GAME

ball_data code 
 
acs8  udata_acs
  
delay_count_b1 res 1 
delay_count_b2 res 1
delay_count_b3 res 1
timer_1       res 1
timer_2 res 1
timer_3  res 1
timer_1_remaining res 1
timer_2_remaining res 1
timer_3_remaining res 1
ball code
    
    
BALL_GAME
    movlw  0x10
    movwf  timer_1_remaining 
    movlw  0x10
    movwf  timer_2_remaining
    movlw  0x10
    movwf  timer_2_remaining 
    movlw  b'11001001'
    call   LCD_shift 
    movlw  ' '
    call   LCD_Send_Byte_D
    movlw  0x02
    call   LCD_Send_Byte_D
    call   ball_delay
    movlw  b'11001010'
    call   LCD_shift 
    movlw  ' '
    call   LCD_Send_Byte_D
    movlw  0x02
    call   LCD_Send_Byte_D
    call   ball_delay
    movlw  b'11001011'
    call   LCD_shift 
    movlw  ' '
    call   LCD_Send_Byte_D
    movlw  0x02
    call   LCD_Send_Byte_D
    call   ball_delay
    movlw  b'11001100'
    call   LCD_shift 
    movlw  ' '
    call   LCD_Send_Byte_D
    movlw  0x02
    call   LCD_Send_Byte_D
    call   ball_delay
    movlw  b'11001101'
    call   LCD_shift 
    movlw  ' '
    call   LCD_Send_Byte_D
    movlw  0x02
    call   LCD_Send_Byte_D
    call   ball_delay
    movlw  b'11001110'
    call   LCD_shift 
    movlw  ' '
    call   LCD_Send_Byte_D
    movlw  0x02
    call   LCD_Send_Byte_D
    ;move rabbit to the end of the screen 
    call   ball_delay
ball 
    movlw b'11000011'
    call  LCD_shift 
    movlw ' '
    call  LCD_Send_Byte_D
    movlw 0x00
    call  LCD_Send_Byte_D
    call   ball_delay
    movlw b'11000100'
    call  LCD_shift 
    movlw ' '
    call  LCD_Send_Byte_D
    movlw 0x00
    call  LCD_Send_Byte_D
    call   ball_delay
    movlw b'11000101'
    call  LCD_shift 
    movlw ' '
    call  LCD_Send_Byte_D
    movlw 0x00
    call  LCD_Send_Byte_D
    call   ball_delay
    movlw b'11000110'
    call  LCD_shift 
    movlw ' '
    call  LCD_Send_Byte_D
    movlw 0x00
    call  LCD_Send_Byte_D
    call   ball_delay
    movlw b'11000111'
    call  LCD_shift 
    movlw ' '
    call  LCD_Send_Byte_D
    movlw 0x00
    call  LCD_Send_Byte_D
    call   ball_delay
    movlw b'11001000'
    call  LCD_shift 
    movlw ' '
    call  LCD_Send_Byte_D
    movlw 0x00
    call  LCD_Send_Byte_D
    call   ball_delay
    movlw b'11001001'
    call  LCD_shift 
    movlw ' '
    call  LCD_Send_Byte_D
    movlw 0x00
    call  LCD_Send_Byte_D
    call   ball_delay
    movlw b'11001010'
    call  LCD_shift 
    movlw ' '
    call  LCD_Send_Byte_D
    movlw 0x00
    call  LCD_Send_Byte_D
    call   ball_delay
    movlw b'11001011'
    call  LCD_shift 
    movlw ' '
    call  LCD_Send_Byte_D
    movlw 0x00
    call  LCD_Send_Byte_D
    call   ball_delay
    movlw b'11001100'
    call  LCD_shift 
    movlw ' '
    call  LCD_Send_Byte_D
    movlw 0x00
    call  LCD_Send_Byte_D
    call   ball_delay
    movlw b'11001101'
    call  LCD_shift 
    movlw ' '
    call  LCD_Send_Byte_D
    movlw 0x00
    call  LCD_Send_Byte_D 
    call   ball_delay
    ;ball has gotten to the space before the pet 
    ;call keypad to see if pressed in correct time 
    bra  React 
jump
    movlw  b'11001111'
    call   LCD_shift 
    movlw  ' ' 
    call   LCD_Send_Byte_D
    movlw  b'10001111'
    call   LCD_shift 
    movlw  0x02
    call   LCD_Send_Byte_D  
    movff  timer_1_remaining, timer_1
t_1     decfsz  timer_1_remaining 
	bra     n_2
	bra     move_ghost 
n_2     movff   timer_2_remaining, timer_2
t_2	decfsz  timer_2
	bra     n_3
	bra     t_1
n_3      movff  timer_3_remaining, timer_3
t_3	decfsz  timer_3
	bra     t_3
	bra     t_2
move_ghost
    movlw b'11001110'
    call  LCD_shift 
    movlw ' '
    call  LCD_Send_Byte_D
    movlw 0x00
    call  LCD_Send_Byte_D 
    call  ball_delay
    call  ball_delay
    call  ball_delay
    movlw b'11001111'
    call  LCD_shift 
    movlw ' '
    call  LCD_Send_Byte_D
    movlw b'10001111'
    call  LCD_shift
    movlw ' '
    call  LCD_Send_Byte_D
    movlw b'11001111'
    call  LCD_shift 
    movlw 0x02
    call  LCD_Send_Byte_D 
    bra   ball
die 
    movlw b'11001110'
    call  LCD_shift 
    movlw ' '
    call  LCD_Send_Byte_D
    movlw 0x00
    call  LCD_Send_Byte_D 
    call  ball_delay
    movlw b'11001111'
    call  LCD_shift 
    movlw ' '
    call  LCD_Send_Byte_D
    call  ball_delay 
    call  ball_delay 
    movlw b'11001111'
    call  LCD_shift 
    movlw 0x02 
    call  LCD_Send_Byte_D
    call  ball_delay 
    movlw b'11001111'
    call  LCD_shift  
    movlw ' '
    call  LCD_Send_Byte_D
    movlw b'11001110'
    call  LCD_shift 
    movlw 0x02 
    call  LCD_Send_Byte_D
    call  ball_delay 
    movlw b'11001110'
    call  LCD_shift  
    movlw ' '
    call  LCD_Send_Byte_D
    movlw b'11001101'
    call  LCD_shift 
    movlw 0x02 
    call  LCD_Send_Byte_D
    call  ball_delay 
    movlw b'11001101'
    call  LCD_shift  
    movlw ' '
    call  LCD_Send_Byte_D
    movlw b'11001100'
    call  LCD_shift 
    movlw 0x02 
    call  LCD_Send_Byte_D
    call  ball_delay 
    movlw b'11001100'
    call  LCD_shift  
    movlw ' '
    call  LCD_Send_Byte_D
    movlw b'11001011'
    call  LCD_shift 
    movlw 0x02 
    call  LCD_Send_Byte_D
    call  ball_delay 
    movlw b'11001011'
    call  LCD_shift  
    movlw ' '
    call  LCD_Send_Byte_D
    movlw b'11001010'
    call  LCD_shift 
    movlw 0x02 
    call  LCD_Send_Byte_D
    call  ball_delay 
    movlw b'11001010'
    call  LCD_shift  
    movlw ' '
    call  LCD_Send_Byte_D
    movlw b'11001001'
    call  LCD_shift 
    movlw 0x02 
    call  LCD_Send_Byte_D
    call  ball_delay 
    return 

  
React
        call setup_row
        bra  timer 
    
    
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
   
	
timer
        movlw   0x40
	movwf   timer_1
t1       
	decfsz  timer_1
	bra     n2
	bra     die 
	
n2      movlw   0x01
	subwf   timer_1_remaining, 1
	movlw   0x35
	movwf   timer_2
t2	decfsz  timer_2
	bra     n3
	bra     t1

n3      movlw   0x01
	subwf   timer_2_remaining, 1
	movlw   0x30
	movwf   timer_3
t3
	movlw   0x01
	subwf   timer_3_remaining, 1
	bra     read_row
no_press
	decfsz  timer_3
	bra     t3
	bra     t2
	
	
	
	
read_row   
	btfss PORTE, RE4
	bra check_1
	bra jump
check_1
	btfss PORTE, RE5
	bra check_2
	bra jump
check_2
	btfss PORTE, RE6
	bra check_3
	bra  jump
check_3
	btfss PORTE, RE7
	bra   no_press
	bra   jump
	

delay_k 
	decfsz 0x20
	bra delay_k
	return 

  
    
ball_delay
	movlw   0x90
	movwf   delay_count_b1
delay_1       
	decfsz  delay_count_b1
	bra     nested_2
	return
	
nested_2
	movlw   0x90
	movwf   delay_count_b2
delay_2	decfsz  delay_count_b2
	bra     nested_3
	bra     delay_1

nested_3
	movlw   0x90
	movwf   delay_count_b3
delay_3
	decfsz  delay_count_b3
	bra     delay_3
	bra     delay_2

    
    
    
    end 