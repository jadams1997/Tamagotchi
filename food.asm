#include p18f87k22.inc

    extern LCD_Send_Byte_D, LCD_shift, LCD_clear
`   global FOOD, GROWTH

code
   
lifemode_food	    res 1
delay_counter_f1    res 1
delay_counter_f2    res 1
delay_counter_f3    res 1
	
Food code
    
FOOD 
    
GROWTH
	movwf lifemode_food
	movlw 0x49
	call  LCD_shift 
	movlw 0x2A
	call  LCD_Send_Byte_D
	call  food_delay
	call  food_delay
	call  food delay
	movlw 0x4A
	call  LCD_shift 
	movlw 0x2A
	call  LCD_Send_Byte_D
	movlw 0x19
	call  LCD_shift 
	movlw 0x2A
	call  LCD_Send_Byte_D
	movlw 0x48
	call  LCD_shift 
	movlw 0x2A
	call  LCD_Send_Byte_D
	call  food_delay
	call  food_delay
	call  food delay
	movlw 0x4B
	call  LCD_shift 
	movlw 0x2A
	call  LCD_Send_Byte_D
	movlw 0x1A
	call  LCD_shift 
	movlw 0x2A
	call  LCD_Send_Byte_D
	movlw 0x18
	call  LCD_shift 
	movlw 0x2A
	call  LCD_Send_Byte_D
	movlw 0x47
	call  LCD_shift 
	movlw 0x2A
	call  LCD_Send_Byte_D
	call  food_delay
	call  food_delay
	call  food delay
	movlw 0x4C
	call  LCD_shift 
	movlw 0x2A
	call  LCD_Send_Byte_D
	movlw 0x1B
	call  LCD_shift 
	movlw 0x2A
	call  LCD_Send_Byte_D
	movlw 0x17
	call  LCD_shift 
	movlw 0x2A
	call  LCD_Send_Byte_D
	movlw 0x46
	call  LCD_shift 
	movlw 0x2A
	call  LCD_Send_Byte_D
	call  food_delay
	call  food_delay
	call  food delay
	movlw 0x4D
	call  LCD_shift 
	movlw 0x2A
	call  LCD_Send_Byte_D
	movlw 0x1C
	call  LCD_shift 
	movlw 0x2A
	call  LCD_Send_Byte_D
	movlw 0x16
	call  LCD_shift 
	movlw 0x2A
	call  LCD_Send_Byte_D
	movlw 0x45
	call  LCD_shift 
	movlw 0x2A
	call  LCD_Send_Byte_D
	call  food_delay
	call  food_delay
	call  food delay
	movlw 0x4E
	call  LCD_shift 
	movlw 0x2A
	call  LCD_Send_Byte_D
	movlw 0x1D
	call  LCD_shift 
	movlw 0x2A
	call  LCD_Send_Byte_D
	movlw 0x15
	call  LCD_shift 
	movlw 0x2A
	call  LCD_Send_Byte_D
	movlw 0x44
	call  LCD_shift 
	movlw 0x2A
	call  LCD_Send_Byte_D
	call  food_delay
	call  food_delay
	call  food delay
	movlw 0x4F
	call  LCD_shift 
	movlw 0x2A
	call  LCD_Send_Byte_D
	movlw 0x1E
	call  LCD_shift 
	movlw 0x2A
	call  LCD_Send_Byte_D
	movlw 0x14
	call  LCD_shift 
	movlw 0x2A
	call  LCD_Send_Byte_D
	movlw 0x43
	call  LCD_shift 
	movlw 0x2A
	call  LCD_Send_Byte_D
	call  food_delay
	call  food_delay
	call  food delay
	movlw 0x1F
	call  LCD_shift 
	movlw 0x2A
	call  LCD_Send_Byte_D
	movlw 0x13
	call  LCD_shift 
	movlw 0x2A
	call  LCD_Send_Byte_D
	
	;alternate flashes to go here followed by change of rabbit character
	
   
   
   return
    
food_delay
	movlw   0xFF
	movwf   delay_counter_f1
	movlw   0xFF
	movwf   delay_counter_f2
	movlw   0xFF
	movwf   delay_counter_f3
lb1f    decfsz  delay_counter_f1
	bra     lb1f
lb2f    decfsz  delay_counter_f2
	bra     lb2f
lb3f    decfsz  delay_counter_f3
	bra     lb3f
	return
     
    
end 