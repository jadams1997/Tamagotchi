#include p18f87k22.inc

extern LCD_Setup, LCD_output 
	
global myTable
    
acs0 udata_acs
counter_row res 1
counter_column res 1
counter_happiness res 1 
counter_happiness_decrement res 1
counter_food res 1 
counter_life res 1
 
;STARTING SCREEN/ BEFORE HATCH.
pdata	code    
myTable data	    "Hello World!\n"	; message, plus carriage return
	constant    myTable_l=.13	; length of data

 
tamagotchi code 
 
main
    call LCD_Setup 
    call LCD_output  
  
    
 end