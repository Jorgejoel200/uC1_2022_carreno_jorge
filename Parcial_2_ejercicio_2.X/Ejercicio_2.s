;-----------------------------------------------------------------------------
; Autor:     Jorge carreño quino     
; Fecha:     30/01/2023
; file:      Ejercicio_2.s
; programa:  MPLAB X IDE v6.00        compilador xc8
; Tarjeta: Curiosity Nano PIC18F57Q84 
; Grupo: 06
;----------------------------------------------------------------------------------------
;inicia prendiendo y apagando el led de la placa con un retardo de 500ms, al pulsar
;el boton de la placa te realiza una secuencia de leds , al pretar el boton del pin RB4 
;te detiene la secuencia y regresa al programa programa principal,y al pulsar el boton del 
;pin RF2 te reinicia la secuencia y apaga los leds
;-----------------------------------------------------------------------------------------
PROCESSOR 18F57Q84
#include "Bit_Config.inc"  
#include <xc.inc>
;#include "libreria_retardos.inc"
    
PSECT udata_acs
offset:	        DS 1
counter:        DS 1  
contador_5:     DS 1
detener_led:    DS 1 
contador1:      DS 1
contador2:      DS 1
cuenta_1:       DS 1
evalua_2:       DS 1
PSECT resetVect,class=CODE,reloc=2
resetVect:
    goto Main
    
PSECT ISRVectLowPriority,class=CODE,reloc=2
    
ISRVectLowPriority:
    BTFSS  PIR1,0,0	; ¿Se ha producido la INT0?
    GOTO    Exit1
interruccion_0:
    BCF	    PIR1,0,0	; limpiamos el flag de INT0
    GOTO    inicio
Exit1:
    RETFIE
    
PSECT ISRVectHighPriority,class=CODE,reloc=2
    
ISRVectHighPriority:
    BTFSC PIR6,0,0  ; ¿Se ha producido la INT1?
    GOTO detente    ; me lleva a dicha rutina 
INTER_2:
    BTFSC PIR10,0,0 ; ¿Se ha producido la INT2?
    BCF PIR10,0,0   ;limpiamos el flag de INT2
    CLRF LATC,1     ;me apagara todo los leds
    SETF evalua_2,0 ;al cargale 1, puedo utilizar mi variable para saber si INT2 se ah producido
Exit0:
    RETFIE
    
PSECT CODE    
Main:
    CALL    Config_OSC,1
    CALL    Config_Port,1
    CALL    Config_PPS,1
    CALL    Config_INT0_INT1,1
principal:
    BANKSEL LATF
    BCF	    LATF,3,1	 ;Led on
    CALL    delay_250ms
    CALL    delay_250ms
    BSF	    LATF,3,1	 ;Led off
    CALL    delay_250ms
    CALL    delay_250ms
    goto    principal
inicio:
    MOVLW   0x05         ;quiero que mi secuencia se ejecute 5 veces 
    MOVWF   contador_5,0 ;le cargo a mi varibale para luego decrementarla
    MOVLW   0x0
    ;mis variables estaran cargadas de cero , cuando no se aplique ninguna interrucion de alta 
    MOVWF   cuenta_1,0	
    MOVWF   evalua_2,0
    GOTO    reload
;implementando mi Computed_GOTO   
siguiente: 
    BANKSEL PCLATU
    MOVLW   low highword(TABLE)
    MOVWF   PCLATU,1
    MOVLW   high(TABLE)
    MOVWF   PCLATH,1
    RLNCF   offset,0,0
    CALL    TABLE 
    BTFSC   evalua_2,1,0  ;evaludo si antes se ah producido INT2
    GOTO    Exit1         ;despues de producir INT2, termino mi INT0 y asi vuelve al programa principal
    BTFSC   cuenta_1,1,0  ; evaludo si antes se ah producido INT1
    GOTO    Exit1         ;despues de producir INT1, termino mi INT0 Y asi vuelve al programa principal
    MOVWF   LATC,0        ;despues de ir a la tabla, muestro en mi puerto C
    MOVWF   detener_led,0 ;guardo el valor obtenido en la tabla en una variable 
    CALL    delay_250ms 
    DECFSZ  counter,1,0   ;decremento el numero de offset y evaluo si es cero 
    GOTO    Next_seq
    GOTO    Apagar   
Next_seq:
    INCF    offset,1,0  
    GOTO    siguiente  
Apagar:
    DECFSZ  contador_5,1,0 ; me decrementara hasta la secuencia llegue a 5 veces
    GOTO    reload
    GOTO    Exit1          ;luego que llegue 5 veces termina mi INT0
reload: 
    BSF	    LATF,3,1	   ;Led on
    MOVLW   10
    MOVWF   counter,0	   ;carga el contador con el numero de offset
    MOVLW   0x00
    MOVWF   offset,0	   ;definimos el valor del offset inicial
    GOTO    siguiente
;esta rutina se realiza cuando se activa INT1
detente:
    BCF PIR6,0,0          ; me limpia el flag de INT1
    MOVF detener_led,0,0  ; le paso a w el ultimo valor de la tabla antes que sucediera INT1
    MOVWF LATC,1          ;al mandarlo al pin RC , mostrare donde se detuvo la secuencia
    SETF cuenta_1,0       ;cargo de 1 para saber que se ah producido INT1
    GOTO Exit0
    
    
TABLE:
    ADDWF   PCL,1,0
    RETLW   10000001B	; offset: 0
    RETLW   01000010B	; offset: 1
    RETLW   00100100B	; offset: 2
    RETLW   00011000B	; offset: 3
    RETLW   00000000B	; offset: 4
    RETLW   00011000B	; offset: 5
    RETLW   00100100B	; offset: 6
    RETLW   01000010B	; offset: 7
    RETLW   10000001B	; offset: 8
    RETLW   00000000B	; offset: 9
    
Config_OSC:
    ;Configuracion del Oscilador Interno a una frecuencia de 4MHz
    BANKSEL OSCCON1
    MOVLW   0x60     ;seleccionamos el bloque del osc interno(HFINTOSC) con DIV=1
    MOVWF   OSCCON1,1 
    MOVLW   0x02     ;seleccionamos una frecuencia de Clock = 4MHz
    MOVWF   OSCFRQ,1
    RETURN
    
Config_Port:	
    ;Configuro el led de la placa y un boton exterior(de alta prioridad)
    BANKSEL PORTF
    CLRF    PORTF,1	
    BSF	    LATF,3,1
    CLRF    ANSELF,1
    CLRF    ANSELF,1
    BCF	    TRISF,3,1
    BSF     TRISF,2,1
    BSF	    WPUF,2,1
    ;configuro mi puerto C( estaran colocados mi leds)
    BANKSEL PORTC   
    CLRF    PORTC,1	;PORTC = 0
    CLRF    LATC,1	;LATC = 0 -- Leds apagado
    CLRF    ANSELC,1	;ANSELC = 0 -- Digital
    CLRF    TRISC,1
    ; coniguro el boton de la placa
    BANKSEL PORTA
    CLRF    PORTA,1	
    CLRF    ANSELA,1	
    BSF	    TRISA,3,1	
    BSF	    WPUA,3,1
    
    ;configuro mi otro boton exterior 
    BANKSEL PORTB
    BCF    PORTB,4,1
    BCF    ANSELB,4,1
    BSF     TRISB,4,1     ; Puerto Entrada 
    BSF	    WPUB,4,1
    RETURN 
Config_PPS:
    ;Config INT0
    BANKSEL INT0PPS
    MOVLW   0x03
    MOVWF   INT0PPS,1	  ; INT0 --> RA3
    
    ;Config INT1
    BANKSEL INT1PPS
    MOVLW   0x0C
    MOVWF   INT1PPS,1	  ; INT1 --> RB4
    ;config INT2
    BANKSEL INT2PPS
    MOVLW   0x2A
    MOVWF   INT2PPS,1
    RETURN
    
;   Secuencia para configurar interrupcion:
;    1. Definir prioridades
;    2. Configurar interrupcion
;    3. Limpiar el flag
;    4. Habilitar la interrupcion
;    5. Habilitar las interrupciones globales
Config_INT0_INT1:
    ;Configuracion de prioridades
    BSF	INTCON0,5,0 ; INTCON0<IPEN> = 1 -- Habilitamos las prioridades
    BANKSEL IPR1
    BCF	IPR1,0,1    ; IPR1<INT0IP> = 0 -- INT0 de baja prioridad
    BSF	IPR6,0,1    ; IPR6<INT1IP> = 1 -- INT1 de alta prioridad
    BSF IPR10,0,1   ;IPR6<INT1IP> = 1 -- INT1 de alta prioridad
    ;Config INT0
    BCF	INTCON0,0,0 ; INTCON0<INT0EDG> = 0 -- INT0 por flanco de bajada
    BCF	PIR1,0,0    ; PIR1<INT0IF> = 0 -- limpiamos el flag de interrupcion
    BSF	PIE1,0,0    ; PIE1<INT0IE> = 1 -- habilitamos la interrupcion ext0
    
    ;Config INT1
    BCF	INTCON0,1,0 ; INTCON0<INT1EDG> = 0 -- INT1 por flanco de bajada
    BCF	PIR6,0,0    ; PIR6<INT0IF> = 0 -- limpiamos el flag de interrupcion
    BSF	PIE6,0,0    ; PIE6<INT0IE> = 1 -- habilitamos la interrupcion ext1
    
    ;Config INT2
    BCF	INTCON0,2,0 ; INTCON0<INT1EDG> = 0 -- INT1 por flanco de bajada
    BCF	PIR10,0,0    ; PIR6<INT0IF> = 0 -- limpiamos el flag de interrupcion
    BSF	PIE10,0,0    ; PIE6<INT0IE> = 1 -- habilitamos la interrupcion ext2
    
    ;Habilitacion de interrupciones
    BSF	INTCON0,7,0 ; INTCON0<GIE/GIEH> = 1 -- habilitamos las interrupciones de forma global y de alta prioridad
    BSF	INTCON0,6,0 ; INTCON0<GIEL> = 1 -- habilitamos las interrupciones de baja prioridad
    RETURN
   
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

END resetVect