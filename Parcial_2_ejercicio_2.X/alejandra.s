PROCESSOR 18F57Q84
#include "Bit_config.inc"    ;/config statements should precede project file includes./
#include <xc.inc>
;#include "RETARDOS.inc"
;------------------------------------------------------------------------------------------------------
;Autor: RAMOS PALACIOS, JUAN ALEJANDRO -----
;Fecha:_30/01/2023
;Programa: MPLAB X IDE v6.00----compilador xc8
;Placa: PIC18F57Q84
;Función: Cuando se presiona el Boton RA3 comienza el programa, y empienza el programa cuando se encienden los
;lados extremos (RC0 y RC7), luego RC1 y RC6 y así consecutivamente hasta que se encuenden RC3 y RC4 y se apagan
;todos los leds y empienza el programa de manera inversa.
;La secuencia se detiene cuando se presione otro pulsador externo conectado en el pin RB4 o hasta que el número de
;repeticiones sea. El retardo entre el encendido y apagado de los leds será de 250 ms.
;Otro pulsador externo conectado al RF2 reinicia toda la secuencia y apaga los leds.;Mientras no se active ninguna interrupción, el programa principal, realice un toggle del led de la placa cada 500 ms.

PSECT udata_acs		    ;PSECT para utilizar el Access RAM
offset: DS	1	    ;Reserva (DS) un byte en Access RAM
counter: DS	1	    ;Reserva (DS) un byte en Accsess RAM
rep_5: DS	1
stop1_int1: DS	1
Reset2_int2: DS	1
Muestreo_Led: DS 1
Contador1: DS 1
Contador2: DS 1
    
PSECT resetVect,class=CODE,reloc=2  
resetVect:
    GOTO Main  
;---------------------------------------------------------------------------------------------------------------------------------------------------------------------------   
PSECT ISRVectLowPriority,class=CODE,reloc=2    ;Codigo de INT0 -->Prioridad baja
ISRVectLowPriority:
    MOVLW   0x00
    MOVWF   stop1_int1,0
    MOVWF   Reset2_int2,0
    MOVLW   0x05
    MOVWF   rep_5,0
    BTFSS   PIR1,0,0	    ;Consulta si se produce la INT0
    GOTO    Exit
    GOTO    Reload       
Exit:    
    RETFIE		    ;Retorno de interrupcion 
        
PSECT ISRVectHighPriority,class=CODE,reloc=2  ;Codigo INT1, INT2 --> Alta prioridad
ISRVectHighPriority:
    BTFSC   PIR6,0,0	    ;Consulta si se produce la INT1
    GOTO    Parar_leds
Borrar_leds:
    BTFSC   PIR10,0,0
    BCF	    PIR10,0,0
    CLRF    LATC,1
    SETF    Reset2_int2,0
Exit_Int12:
    RETFIE  

;--------------------------------------------------------------------------------------------------------------------------------------------------------   
PSECT CODE  
Main:
    ;Salto a Subrutinas
    CAll    Config_OSC,1
    CALL    Config_PORT,1
    CALL    Config_PPS,1
    CALL    Config_INTX,1

Led_uc:
    ;Programa principal
    CALL    delay_250ms
    CALL    delay_250ms
    BSF	    LATF,3,0 
    CALL    delay_250ms
    CALL    delay_250ms
    BCF	    LATF,3,0
    GOTO    Led_uc

;----------------------------------------------------------------------------------------------------------------------------------------------
Reload:
    BCF	    PIR1,0,0	    ;Limpiamos el falg
    MOVLW   0x0A	    ;Definimos el offset
    MOVWF   counter,0	    ;El numero de offset -> Es decir el corrimientos de leds seran 9
    MOVLW   0x00
    MOVWF   offset,0	    ;Valor inicial del offset es cero
    GOTO    Loop
    
Loop:   
    BANKSEL PCLATU
    MOVLW   low highword(Table)
    MOVWF   PCLATU,1
    MOVLW   high(Table)
    MOVWF   PCLATH,1
    RLNCF   offset,0,0	    ;(offset) = 3 x 2 = 6 , el w significa que se guarde en el acumulador
    CALL    Table
    BTFSC   Reset2_int2,1,0
    GOTO    Exit
    BTFSC   stop1_int1,1,0
    GOTO    Exit
    MOVWF   LATC,0
    MOVWF   Muestreo_Led,0
    CALL    delay_250ms
    DECFSZ  counter,1,0
    GOTO    Nex_seq
    GOTO    SEC_5   

SEC_5:
    DECFSZ  rep_5,1,0
    GOTO    Reload
    GOTO    Exit
    
    
Nex_seq:
    INCF    offset,1,0
    GOTO    Loop   

   
Table:
    ;Tabla de corrimiento de leds
    ADDWF   PCL,1,0	    ;(w) + PCL  = (offset) + PCL
    RETLW   10000001B	    ;offset: 0
    RETLW   01000010B	    ;offset: 1
    RETLW   00100100B	    ;offset: 2
    RETLW   00011000B	    ;offset: 3
    RETLW   00000000B	    ;offset: 4
    RETLW   00011000B	    ;offset: 5
    RETLW   00100100B	    ;offset: 6
    RETLW   01000010B	    ;offset: 7
    RETLW   10000001B	    ;offset: 8
    RETLW   00000000B	    ;offset: 9
    RETURN  
    
;---------------------------------------------------------------------------------------------------------------------------------------------------
Parar_leds:
    BCF	    PIR6,0,0	    ;Limpiamos el falg
    MOVF    Muestreo_Led,0,0
    MOVWF   LATC,1
    SETF    stop1_int1,0
    GOTO    Exit_Int12

;delay_250ms:                ; 
;    MOVLW   250             ; 
;   MOVWF   Contador2,0     ; 
;;T=(6+4k)us              ; 
;Ext_Loop:
;   MOVLW   249             ;
;  MOVWF   Contador1,0     ;
;Int_Loop:
;   NOP                     ; 
;  DECFSZ Contador1,1,0    ; 
; GOTO Int_Loop           ; 
;DECFSZ  Contador2,1,0
;GOTO  Ext_Loop
;RETURN		    ;

    
;-----------------------------------------------------------------------------------------------------------------------------------------------------------
     
    
;Subrutinas
Config_OSC:
    BANKSEL OSCCON1
    MOVLW   0x60
    MOVWF   OSCCON1,1
    MOVLW   0x02
    MOVWF   OSCFRQ,1
    RETURN
    
Config_PORT:
    BANKSEL PORTF	;Configuracion de led de uC
    BCF	    PORTF,3,1
    BSF	    LATF,3,1
    CLRF    ANSELF,1 
    BCF	    TRISF,3,1
    
    ;Configuracion de button RF2
    BCF	    PORTF,2,1
    BSF	    TRISF,2,1
    BSF	    WPUF,2,1

    ;Configuracion de button RB4
    BANKSEL PORTB
    BCF    PORTB,4,1
    BCF    ANSELB,4,1
    BSF     TRISB,4,1     ; Puerto Entrada 
    BSF	    WPUB,4,1
       
    BANKSEL PORTA	;Configuracion de button del uC
    BCF	    PORTA,3,1
    CLRF    ANSELA,1 
    BSF	    TRISA,3,1
    BSF	    WPUA,3,1
    
    BANKSEL PORTC	;Configuracion del puerto C
    SETF    PORTC,1
    CLRF    LATC,1
    CLRF    ANSELC,1
    CLRF    TRISC,1
    RETURN
       
Config_PPS:
    BANKSEL INT0PPS
    MOVLW   0x03
    MOVWF   INT0PPS,1	;INT0 --> RA3
    
    BANKSEL INT1PPS
    MOVLW   0x0C
    MOVWF   INT1PPS,1	;INT1 --> RB4
    
    BANKSEL INT2PPS
    MOVLW   0x2A
    MOVWF   INT2PPS,1	;INT2 --> RF2
    RETURN
    
    
Config_INTX:
;   Secuencia para configurar interrupcion:
;    1. Definir prioridades
;    2. Configurar interrupcion
;    3. Limpiar el flag
;    4. Habilitar la interrupcion
;    5. Habilitar las interrupciones globales
    
    BSF	    INTCON0,5,0 ;INTCON0<IPEN> = 1 --> Habilitar prioridades
    BANKSEL IPR1
    BCF	    IPR1,0,1    ;IPR1<INT0IP> = 0 --> INT0 de baja prioridad
    BSF	    IPR6,0,1    ;IPR6<INT1IP> = 1 --> INT1 de alta prioridad
    BSF	    IPR10,0,1   ;IPR10<INT2IP> = 1 --> INT2 de alta prioridad
    
   ;Config. INT0
    BCF	INTCON0,0,0 ; INTCON0<INT0EDG> = 0 --> INT0 por flanco de bajada
    BCF	PIR1,0,0    ; PIR1<INT0IF> = 0 -- limpiamos el flag de interrupcion
    BSF	PIE1,0,0    ; PIE1<INT0IE> = 1 -- habilitamos la interrupcion ext0
    
    
   ;Config. INT1
    BCF	INTCON0,1,0 ; INTCON0<INT1EDG> = 0 --> INT0 por flanco de bajada
    BCF	PIR6,0,0    ; PIR6<INT1IF> = 0 -- limpiamos el flag de interrupcion
    BSF	PIE6,0,0    ; PIE6<INT1IE> = 1 -- habilitamos la interrupcion ext1
   
   
   
   ;Config. INT2
    BCF	INTCON0,2,0 ; INTCON0<INT2EDG> = 0 --> INT0 por flanco de bajada
    BCF	PIR10,0,0    ; PIR10<INT2IF> = 0 -- limpiamos el flag de interrupcion
    BSF	PIE10,0,0    ; PIE10<INT2IE> = 1 -- habilitamos la interrupcion ext2
    
   ;Config. GLOBAL
    BSF	INTCON0,7,0 ; INTCON0<GIE/GIEH> = 1 -- habilitamos las interrupciones de forma global
    BSF	INTCON0,6,0 ; INTCON0<GIEL> = 1 -- habilitamos las interrupciones de baja prioridad
    RETURN
    
delay_250ms:  
    MOVLW   250		    ;(W) = 250
    MOVWF   Contador2,0	    ;(Contador2) = 200 = K2
ext_250ms_a:		
    MOVLW   249		    ;(W) = 249
    MOVWF   Contador1,0	    ;(Contador1) = 249 = K1
ext_250ms_b:
    NOP			   
    DECFSZ  Contador1,1,0   ;(K1) - 1 --> (d), salta si el resultado del decremento es cero
    GOTO    ext_250ms_b	    ;salto a etiqueta    
    DECFSZ  Contador2,1,0   ;(K2) - 1 --> (d), salta si el resultado del decremento es cero
    GOTO    ext_250ms_a	    ;salto a etiqueta 
    RETURN		    		      


    
END resetVect


