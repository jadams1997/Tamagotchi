#include p18f87k22.inc


    global Keyboard_Setup, Keyboard
 
 
acs0	udata_acs 
counter_row	    res 1
counter_column	    res 1

output  code
  
  
symbol  data '3'
        constant    myTable_l=.1

main code 
    
start 
 
 
Keyboard_Setup
    clrf LATE 
    movlw 0xFF
    movwf 0x20
    call delay
    
    
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
    call delay
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
    movwf 0x20
    call delay
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
    decfsz 0x20
    bra delay
    return 

decode
    movlw 0x00
    cpfseq counter_row
    bra row_1
    bra column_11
column_11
    movlw 0x04
    cpfseq counter_column
    bra column_12
    movlw '1'
column_12
    movlw 0x05
    cpfseq counter_column
    bra column_13
    movlw '2'
column_13
    movlw 0x06
    cpfseq counter_column
    bra column_14
    movlw '3'
column_14
    movlw 'F'
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
column_22
    movlw 0x05
    cpfseq counter_column
    bra column_23
    movlw '5'
column_23
    movlw 0x06
    cpfseq counter_column
    bra column_24
    movlw '6'
column_24
    movlw 'E'
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
column_32
    movlw 0x05
    cpfseq counter_column
    bra column_33
    movlw '8'
column_33
    movlw 0x06
    cpfseq counter_column
    bra column_34
    movlw '9'
column_34
    movlw 'D'
row_3
    bra column_41
column_41
    movlw 0x04
    cpfseq counter_column
    bra column_42
    movlw 'A'
column_42
    movlw 0x05
    cpfseq counter_column
    bra column_43
    movlw '0'
column_43
    movlw 0x06
    cpfseq counter_column
    bra column_44
    movlw 'B'
column_44
    movlw 'C'
    
    
    end
 