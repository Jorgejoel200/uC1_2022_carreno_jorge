PROCESSOR 18F57Q84
#include "Bit_Config.inc"   /*config statements should precede project file includes.*/
#include <xc.inc>
;#include "Retardos.inc"
    
PSECT resetVect,class=CODE,reloc=2
resetVect:
    goto Main
    
PSECT ISRVectLowPriority,class=CODE,reloc=2
ISRVect:
    BTFSS   PIR1,0,0	; ¿Se ha producido la INT0?
    GOTO    Exit
Toggle_Led:
    BCF	    PIR1,0,0	; limpiamos el flag de INT0
    BTG	    LATF,3,0	; toggle Led
Exit:
    RETFIE

PSECT udata_acs
contador1:  DS 1	    
contador2:  DS 1
offset:	    DS 1
counter:    DS 1
    
PSECT CODE    
Main:
    CALL    Config_OSC,1
    CALL    Config_Port,1
    CALL    Config_PPS,1
    CALL    Config_INT0,1
    GOTO    Reload
Loop:
    BANKSEL PCLATU
    MOVLW   low highword(Table)
    MOVWF   PCLATU,1
    MOVLW   high(Table)
    MOVWF   PCLATH,1
    RLNCF   offset,0,0
    CALL    Table
    MOVWF   LATC,0
    CALL    Delay_250ms,1
    DECFSZ  counter,1,0
    GOTO    Next_Seq
    GOTO    Reload
Next_Seq:
    INCF    offset,1,0
    GOTO    Loop
Reload:
    MOVLW   0x05	
    MOVWF   counter,0	; carga del contador con el numero de offsets
    MOVLW   0x00	
    MOVWF   offset,0	; definimos el valor del offset inicial
    GOTO    Loop
    
Config_OSC:
    ;Configuracion del Oscilador Interno a una frecuencia de 4MHz
    BANKSEL OSCCON1
    MOVLW   0x60    ;seleccionamos el bloque del osc interno(HFINTOSC) con DIV=1
    MOVWF   OSCCON1,1 
    MOVLW   0x02    ;seleccionamos una frecuencia de Clock = 4MHz
    MOVWF   OSCFRQ,1
    RETURN
    
Config_Port:	
    ;Config Led
    BANKSEL PORTF
    CLRF    PORTF,1	
    BSF	    LATF,3,1	
    CLRF    ANSELF,1	
    BCF	    TRISF,3,1	
    
    ;Config Button
    BANKSEL PORTA
    CLRF    PORTA,1	
    CLRF    ANSELA,1	
    BSF	    TRISA,3,1	
    BSF	    WPUA,3,1	 
    
    ;Config PORTC
    BANKSEL PORTC
    SETF    PORTC,1	
    SETF    LATC,1	
    CLRF    ANSELC,1	
    CLRF    TRISC,1
    RETURN
    
Config_PPS:
    BANKSEL INT0PPS
    MOVLW   0x03
    MOVWF   INT0PPS,1	; INT0 --> RA3
    RETURN
    
;   Secuencia para configurar interrupcion:
;    1. Definir prioridades
;    2. Configurar interrupcion
;    3. Limpiar el flag
;    4. Habilitar la interrupcion
;    5. Habilitar las interrupciones globales
Config_INT0:
    BCF	INTCON0,5,0 ; INTCON0<IPEN> = 0 -- Deshabilitar prioridades
    BCF	INTCON0,0,0 ; INTCON0<INT0EDG> = 0 -- INT0 por flanco de bajada
    BCF	PIR1,0,0    ; PIR1<INT0IF> = 0 -- limpiamos el flag de interrupcion
    BSF	PIE1,0,0    ; PIE1<INT0IE> = 1 -- habilitamos la interrupcion ext
    BSF	INTCON0,7,0 ; INTCON0<GIE/GIEH> = 1 -- habilitamos las interrupciones de forma global
    RETURN

Table:
    ADDWF   PCL,1,0
    RETLW   11111111B	; offset: 0
    RETLW   11111110B	; offset: 1
    RETLW   11111101B	; offset: 2
    RETLW   11111011B	; offset: 3
    RETLW   11110111B	; offset: 4
    
Delay_250ms:		    ; 2Tcy -- Call
    MOVLW   250		    ; 1Tcy -- k2
    MOVWF   contador2,0	    ; 1Tcy
; T = (6 + 4k)us	    1Tcy = 1us
Ext_Loop:		    
    MOVLW   249		    ; 1Tcy -- k1
    MOVWF   contador1,0	    ; 1Tcy
Int_Loop:
    NOP			    ; k1*Tcy
    DECFSZ  contador1,1,0   ; (k1-1)+ 3Tcy
    GOTO    Int_Loop	    ; (k1-1)*2Tcy
    DECFSZ  contador2,1,0
    GOTO    Ext_Loop
    RETURN		    ; 2Tcy
    
End resetVect


