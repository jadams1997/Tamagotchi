#include p18f87k22.inc
	
    extern LCD_Send_Byte_D,LCD_shift, LCD_clear
    global LEARN
 
acs3	udata_acs 
counter_row	    res 1
counter_column	    res 1
delay_count_l1      res 1
delay_count_l2      res 1
delay_count_l3      res 1
Number_pressed_1_int   res 1
Number_pressed_2_int   res 1
Number_pressed_1_string   res 1
Number_pressed_2_string   res 1
integer                res 1
string	                res 1
result                 res 1 
output_1                res 1
output_2                res 1
count        res 1

learn code
    
    
LEARN
    movlw   b'10001000'
    call    LCD_shift 
    movlw   0x3F
    call    LCD_Send_Byte_D
    movlw   0x2B
    call    LCD_Send_Byte_D
    movlw   0x3F
    call    LCD_Send_Byte_D
    movlw   0x3D
    call    LCD_Send_Byte_D
    movlw   0x3F
    call    LCD_Send_Byte_D
learn
    movlw   0x00
    movwf   result 
    movlw   0x00
    movwf   Number_pressed_1_int
    movlw   0x00
    movwf   Number_pressed_2_int
    movlw   ' '
    movwf   Number_pressed_1_string
    movlw   ' '
    movwf   Number_pressed_2_string
    movlw   0x0F
    movwf   integer 
    movlw   ' '
    movwf   output_2
    call    Numberpad 
    movff   integer, Number_pressed_1_int
    movff   string, Number_pressed_1_string
    call    learn_delay
    call    Numberpad 
    movff   integer,  Number_pressed_2_int
    movff   string, Number_pressed_2_string
    movlw   0x0F
    cpfseq  Number_pressed_1_int
    bra     c
    bra     learn 
c   movlw   0X0F
    cpfseq  Number_pressed_2_int
    bra     calculate
    bra     learn 
calculate
    movlw   b'10001000'
    call    LCD_shift 
    movf    Number_pressed_1_string, w
    call    LCD_Send_Byte_D
    movlw   b'10001010'
    call    LCD_shift 
    movf    Number_pressed_2_string, w 
    call    LCD_Send_Byte_D 
    call    learn_delay 
    call    learn_delay 
    movf    Number_pressed_1_int, w
    addwf   result, 1
    movf    Number_pressed_2_int, w
    addwf   result, 1
    movlw   0x00
checked
    cpfseq  result 
    bra     c_1
    movlw   '0'
    movwf   output_1
    bra     output 
c_1 movlw   0x01
    cpfseq  result 
    bra     c_2
    movlw   '1'
    movwf   output_1
    bra     output 
c_2 movlw   0x02
    cpfseq  result 
    bra     c_3
    movlw   '2'
    movwf   output_1
    bra     output 
c_3 movlw   0x03
    cpfseq  result 
    bra     c_4
    movlw   '3'
    movwf   output_1
    bra     output 
c_4 movlw   0x04
    cpfseq  result 
    bra     c_5
    movlw   '4'
    movwf   output_1
    bra     output 
c_5 movlw   0x05
    cpfseq  result 
    bra     c_6
    movlw   '5'
    movwf   output_1
    bra     output 
c_6 movlw   0x06
    cpfseq  result 
    bra     c_7
    movlw   '6'
    movwf   output_1
    bra     output 
c_7 movlw   0x07
    cpfseq  result 
    bra     c_8
    movlw   '7'
    movwf   output_1
    bra     output 
c_8 movlw   0x08
    cpfseq  result 
    bra     c_9
    movlw   '8'
    movwf   output_1
    bra     output 
c_9 movlw   0x09
    cpfseq  result 
    bra     c_10
    movlw   '9'
    movwf   output_1
    bra     output 
c_10
    movlw   0x0A
    cpfseq  result 
    bra     c_11
    movlw   '1'
    movwf   output_1
    movlw   '0'
    movwf   output_2
    bra     output 
c_11 movlw   0x0B
    cpfseq  result 
    bra     c_12
    movlw   '1'
    movwf   output_1
    movlw   '1'
    movwf   output_2
    bra     output 
c_12
    movlw   0x0C
    cpfseq  result 
    bra     c_13
    movlw   '1'
    movwf   output_1
    movlw   '2'
    movwf   output_2
    bra     output 
c_13 movlw   0x0D
    cpfseq  result 
    bra     c_14
    movlw   '1'
    movwf   output_1
    movlw   '3'
    movwf   output_2
    bra     output 
c_14 movlw   0x0E
    cpfseq  result 
    bra     c_15
    movlw   '1'
    movwf   output_1
    movlw   '4'
    movwf   output_2
    bra     output 
c_15 movlw   0x0F
    cpfseq  result 
    bra     c_16
    movlw   '1'
    movwf   output_1
    movlw   '5'
    movwf   output_2
    bra     output 
c_16 movlw   0x10
    cpfseq  result 
    bra     c_17
    movlw   '1'
    movwf   output_1
    movlw   '6'
    movwf   output_2
    bra     output 
c_17 movlw   0x11
    cpfseq  result 
    bra     c_18
    movlw   '1'
    movwf   output_1
    movlw   '7'
    movwf   output_2
    bra     output 
c_18 
    movlw   '1'
    movwf   output_1
    movlw   '8'
    movwf   output_2
    bra     output 
output 
    movlw   b'10001100'
    call    LCD_shift 
    movf    output_1, w
    call    LCD_Send_Byte_D 
    movf    output_2, w
    call    LCD_Send_Byte_D
    call    learn_delay 
    call    learn_delay
    movlw   b'10001000'
    call    LCD_shift 
    movlw   ' '
    call    LCD_Send_Byte_D
    movlw   ' '
    call    LCD_Send_Byte_D
    movlw   ' '
    call    LCD_Send_Byte_D
    movlw   ' '
    call    LCD_Send_Byte_D
    movlw   ' '
    call    LCD_Send_Byte_D
    movlw   ' '
    call    LCD_Send_Byte_D
    return
    
 
    
Numberpad
    movlw 0xFF
    movwf  count
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
    movwf  count
    call   delay
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
    bra read_row
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
    movwf  count
    call   delay
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
  
delay 
    decfsz count
    bra delay
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
    movlw  0x01
    movwf integer 
    movlw  '1'
    movwf string 
    return 
column_12
    movlw 0x05
    cpfseq counter_column
    bra column_13
    movlw  0x02
    movwf integer 
    movlw  '2'
    movwf string 
    return 
column_13
    movlw 0x06
    cpfseq counter_column
    bra column_14
    movlw  0x03
    movwf integer 
    movlw  '3'
    movwf string 
column_14
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
    movlw  0x04
    movwf integer 
    movlw  '4'
    movwf string 
    return 
column_22
    movlw 0x05
    cpfseq counter_column
    bra column_23
    movlw  0x05
    movwf integer
    movlw  '5'
    movwf string 
    return 
column_23
    movlw 0x06
    cpfseq counter_column
    bra column_24
    movlw  0x06
    movwf integer
    movlw  '6'
    movwf string 
    return 
column_24
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
    movlw  0x07
    movwf integer
    movlw  '7'
    movwf string 
    return 
column_32
    movlw 0x05
    cpfseq counter_column
    bra column_33 
    movlw  0x08
    movwf integer
    movlw  '8'
    movwf string 
    return 
column_33
    movlw 0x06
    cpfseq counter_column
    bra column_34
    movlw  0x09
    movwf integer
    movlw  '9'
    movwf string 
    return 
column_34
    return 
row_3
    bra column_41
column_41
    movlw 0x04
    cpfseq counter_column
    bra column_42
    return 
column_42
    movlw 0x05
    cpfseq counter_column
    bra column_43
    movlw  0x0
    movwf integer
    movlw  '0'
    movwf string 
    return 
column_43
    movlw 0x06
    cpfseq counter_column
    bra column_44
    return 
column_44
    return 
    
    
    

learn_delay
	movlw   0x90
	movwf   delay_count_l1
delay_1       
	decfsz  delay_count_l1
	bra     nested_2
	return
	
nested_2
	movlw   0x90
	movwf   delay_count_l2
delay_2	decfsz  delay_count_l2
	bra     nested_3
	bra     delay_1

nested_3
	movlw   0x90
	movwf   delay_count_l3
delay_3
	decfsz  delay_count_l3
	bra     delay_3
	bra     delay_2
    end
 