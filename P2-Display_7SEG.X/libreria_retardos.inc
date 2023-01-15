;----------------------------------------------------------------
;Autor: jorge carreño quino-----Fecha: 09/01/2023
;programa: MPLAB X IDE v6.00----compilador xc8
;-- Tarjeta: Curiosity Nano PIC18F57Q84-----------------------------    
;------permite calcular los siguientes retardos a una frecuencia de 4MHZ
;-------------------------------------------------------------------------
;-------------------------------------------------------------------------
PSECT udata_acs
contador1: ds 1
contador2: ds 1
    
PSECT code
;------ como trabaja con una frecuancia de 4MHZ entonces 1tcy= 1us-----
;------ t=(4k+6)us  ---------------------------------------------------
delay_10us:
    MOVLW 1
    MOVWF contador1,0
loop:
    nop
    DECFSZ contador1,1,0
    GOTO loop
    RETURN   
;---------t=(3k+7)us---------------------------------------------------
delay_25us:;k-->6
    MOVLW 6
    MOVWF contador1,0
    nop 
loop1:
    DECFSZ contador1,1,0
    goto loop1
    RETURN 
;----  t= (3k+8)us   --------------------------------------------------
delay_50us:   
    MOVLW 14
    MOVWF contador1,0 
    NOP
    NOP
loop2:
    DECFSZ contador1,1,0
    GOTO loop2
    RETURN
;-------  t=(4k+8)us  -------------------------------------------------
delay_100us:
    MOVLW 23
    MOVWF contador1,0
    NOP
    NOP 
loop3:
    NOP
    DECFSZ contador1,1,0
    GOTO loop3
    RETURN
;----------   t=(3k+8)us--------------------------------------------
delay_200us:
    MOVLW 64
    MOVWF contador1,0
    NOP
    NOP
loop4:
    DECFSZ contador1,1,0
    GOTO loop4
    RETURN
;------ t= (4k+6)us   -----------------------------------------------
delay_250us:
    MOVLW 61
    MOVWF contador1,0
loop5:
    NOP
    DECFSZ contador1,1,0
    GOTO loop5
    RETURN
;--------  t= (4k+8)  ------------------------------------------------
delay_500us:
    MOVLW 123
    MOVWF contador1,0
    NOP
    NOP
loop6:
    NOP
    DECFSZ contador1,1,0
    GOTO loop6
    RETURN
;---------------------------------------------------------------------

delay_1ms:
    MOVLW 1
    MOVWF contador2,0
loop_exter:
    MOVLW 249
    MOVWF contador1,0
loop_inter:
    NOP
    DECFSZ contador1,1,0
    GOTO loop_inter
    DECFSZ contador2,1,0
    GOTO loop_exter
    RETURN
;-------------------------------------------------------------------
delay_5ms:
    MOVLW 5
    MOVWF contador2,0
loop_exter1:
    MOVLW 249
    MOVWF contador1,0
loop_inter1:
    NOP
    DECFSZ contador1,1,0
    GOTO loop_inter1
    DECFSZ contador2,1,0
    GOTO loop_exter1
    RETURN   
;----------------------------------------------------------------------
delay_10ms:
    MOVLW 10
    MOVWF contador2,0
loop_exter2:
    MOVLW 249
    MOVWF contador1,0
loop_inter2:
    NOP
    DECFSZ contador1,1,0
    GOTO loop_inter2
    DECFSZ contador2,1,0
    GOTO loop_exter2
    RETURN
;----------------------------------------------------------------------
delay_25ms:
    MOVLW 25
    MOVWF contador2,0
loop_exter3:
    MOVLW 249
    MOVWF contador1,0
loop_inter3:
    NOP
    DECFSZ contador1,1,0
    GOTO loop_inter3
    DECFSZ contador2,1,0
    GOTO loop_exter3
    RETURN
;-----------------------------------------------------------------------
delay_50ms:
    MOVLW 50
    MOVWF contador2,0
loop_exter4:
    MOVLW 249
    MOVWF contador1,0
loop_inter4:
    NOP
    DECFSZ contador1,1,0
    GOTO loop_inter4
    DECFSZ contador2,1,0
    GOTO loop_exter4
    RETURN
;----------------------------------------------------------------------
delay_100ms:
    MOVLW 100
    MOVWF contador2,0
loop_exter5:
    MOVLW 249
    MOVWF contador1,0
loop_inter5:
    NOP
    DECFSZ contador1,1,0
    GOTO loop_inter5
    DECFSZ contador2,1,0
    GOTO loop_exter5
    RETURN
;-------------------------------------------------------------------------
delay_200ms:
    MOVLW 200
    MOVWF contador2,0
loop_exter6:
    MOVLW 249
    MOVWF contador1,0
loop_inter6:
    NOP
    DECFSZ contador1,1,0
    GOTO loop_inter6
    DECFSZ contador2,1,0
    GOTO loop_exter6
    RETURN
;-------------------------------------------------------------------
delay_250ms:
    MOVLW 250
    MOVWF contador2,0
loop_exter7:
    MOVLW 249
    MOVWF contador1,0
loop_inter7:
    NOP
    DECFSZ contador1,1,0
    GOTO loop_inter7
    DECFSZ contador2,1,0
    GOTO loop_exter7
    RETURN    
;-----------------------------------------------------   
delay_240ms:
    MOVLW 240
    MOVWF contador2,0
loop_exterx:
    MOVLW 249
    MOVWF contador1,0
loop_interx:
    NOP
    DECFSZ contador1,1,0
    GOTO loop_interx
    DECFSZ contador2,1,0
    GOTO loop_exterx
    RETURN
;------------------------------


