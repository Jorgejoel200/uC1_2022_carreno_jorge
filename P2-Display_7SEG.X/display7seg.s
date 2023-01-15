;----------------------------------------------------------------
;Autor: jorge carreño quino-----Fecha: 15/01/2023
;programa: MPLAB X IDE v6.00----compilador xc8
;-- Tarjeta: Curiosity Nano PIC18F57Q84-----------------------------    
;--este programa inicia contando de 0-9, pero si mantienes presionado el boton--
;--te cuenta de A-F, y si dejas de presionar te vuelve a contar de 0-9------
processor 18F57Q84
#include "bit_config.inc"// config statements should precede project file includes.
#include <xc.inc>
#include "libreria_retardos.inc"
PSECT resetvect,class=CODE,reloc=2
resetvect:
    GOTO main
PSECT CODE
main:
    CALL config_osc,1; configuro el oscilador interno 
    CALL config_port,1; configuro los puertos a trabajar 
    BTFSS PORTA,3,0;si el boton esta precionado cuenta de A-F
    GOTO CONTA; si no esta presionado el boton cuenta de 0-9
; para mi display anado , eh querido poner en orden la salida del pin RD0 para 
; el segmento a , la salida del pin RD1 para el segmento B  en ese orden
cuenta0:
    CALL delay_250ms
    CALL delay_250ms
    MOVLW 01000000B; carga mi registro de trabajo con tal valor 
    MOVWF LATD,1; carga el LATD con el valor de W , de tal manera que me muestra un 0 
    CALL delay_250ms
    CALL delay_250ms
    BTFSS PORTA,3,0;si el boton no esta presionado continua con el conteo de 0-9
    GOTO CONTA; en el caso que boton este presionado me comienza a contar de A-F
cuenta1:
    CALL delay_250ms
    CALL delay_250ms
    MOVLW 01111001B;carga mi registro de trabajo con tal valor 
    MOVWF LATD,1;carga el LATD con el valor de W , de tal manera que me muestra un 1
    CALL delay_250ms
    CALL delay_250ms
    BTFSS PORTA,3,0;si el boton no esta presionado continua con el conteo de 0-9
    GOTO CONTA;en el caso que boton este presionado me comienza a contar de A-F
cuenta2:
    CALL delay_250ms
    CALL delay_250ms
    MOVLW 00100100B;carga mi registro de trabajo con tal valor 
    MOVWF LATD,1;carga el LATD con el valor de W , de tal manera que me muestra un 2
    CALL delay_250ms
    CALL delay_250ms
    BTFSS PORTA,3,0;si el boton no esta presionado continua con el conteo de 0-9
    GOTO CONTA;en el caso que boton este presionado me comienza a contar de A-F
cuenta3:
    CALL delay_250ms
    CALL delay_250ms
    MOVLW 00110000B;carga mi registro de trabajo con tal valor 
    MOVWF LATD,1;carga el LATD con el valor de W , de tal manera que me muestra un 3
    CALL delay_250ms
    CALL delay_250ms
    BTFSS PORTA,3,0;si el boton no esta presionado continua con el conteo de 0-9
    GOTO CONTA
cuenta4:
    CALL delay_250ms
    CALL delay_250ms
    MOVLW 00011001B;carga mi registro de trabajo con tal valor 
    MOVWF LATD,1;carga el LATD con el valor de W , de tal manera que me muestra un 4
    CALL delay_250ms
    CALL delay_250ms
    BTFSS PORTA,3,0;si el boton no esta presionado continua con el conteo de 0-9
    GOTO CONTA
cuenta5:
    CALL delay_250ms
    CALL delay_250ms
    MOVLW 00010010B;carga mi registro de trabajo con tal valor 
    MOVWF LATD,1;carga el LATD con el valor de W , de tal manera que me muestra un 5
    CALL delay_250ms
    CALL delay_250ms
    BTFSS PORTA,3,0;si el boton no esta presionado continua con el conteo de 0-9
    GOTO CONTA
cuenta6:
    CALL delay_250ms
    CALL delay_250ms
    MOVlW 00000010B;carga mi registro de trabajo con tal valor 
    MOVWF LATD,1;carga el LATD con el valor de W , de tal manera que me muestra un 6
    CALL delay_250ms
    CALL delay_250ms
    BTFSS PORTA,3,0;si el boton no esta presionado continua con el conteo de 0-9
    GOTO CONTA
cuenta7:
    CALL delay_250ms
    CALL delay_250ms
    MOVLW 01111000B;carga mi registro de trabajo con tal valor 
    MOVWF LATD,1;carga el LATD con el valor de W , de tal manera que me muestra un 7
    CALL delay_250ms
    CALL delay_250ms
    BTFSS PORTA,3,0;si el boton no esta presionado continua con el conteo de 0-9
    GOTO CONTA
cuenta8:
    CALL delay_250ms
    CALL delay_250ms
    MOVLW 00000000B;carga mi registro de trabajo con tal valor 
    MOVWF LATD,1;carga el LATD con el valor de W , de tal manera que me muestra un 8
    CALL delay_250ms
    CALL delay_250ms
    BTFSS PORTA,3,0;si el boton no esta presionado continua con el conteo de 0-9
    GOTO CONTA
cuenta9:
    CALL delay_250ms
    CALL delay_250ms
    MOVLW 00011000B;carga mi registro de trabajo con tal valor 
    MOVWF LATD,1;carga el LATD con el valor de W , de tal manera que me muestra un 9
    CALL delay_250ms
    CALL delay_250ms
    BTFSS PORTA,3,0;si el boton no esta presionado continua con el conteo de 0-9
    GOTO CONTA
    GOTO cuenta0
CONTA:
    CALL delay_250ms
    CALL delay_250ms
    MOVLW 00100000B;carga mi registro de trabajo con tal valor 
    MOVWF LATD,1;carga el LATD con el valor de W , de tal manera que me muestra un A
    CALL delay_250ms
    CALL delay_250ms
    BTFSC PORTA,3,0;si el boton esta presionado continua con el conteo de A-F
    GOTO cuenta0;si el boton lo dejas de presionar te regresa al conteo de 0-9
cuentaB:
    CALL delay_250ms
    CALL delay_250ms
    MOVLW 3;carga mi registro de trabajo con tal valor 
    MOVWF LATD,1;carga el LATD con el valor de W , de tal manera que me muestra un B
    CALL delay_250ms
    CALL delay_250ms
    BTFSC PORTA,3,0;si el boton esta presionado continua con el conteo de A-F
    GOTO cuenta0;si el boton lo dejas de presionado continua con el conteo de 0-9
cuentaC:
    CALL delay_250ms
    CALL delay_250ms
    MOVLW 01000110B;carga mi registro de trabajo con tal valor 
    MOVWF LATD,1;carga el LATD con el valor de W , de tal manera que me muestra un C
    CALL delay_250ms
    CALL delay_250ms
    BTFSC PORTA,3,0;si el boton esta presionado continua con el conteo de A-F
    GOTO cuenta0;si el boton lo dejas de presionar te regresa al conteo de 0-9
cuentad:
    CALL delay_250ms
    CALL delay_250ms
    MOVLW 00100001B;carga mi registro de trabajo con tal valor 
    MOVWF LATD,1;carga el LATD con el valor de W , de tal manera que me muestra un D
    CALL delay_250ms
    CALL delay_250ms
    BTFSC PORTA,3,0;si el boton esta presionado continua con el conteo de A-F
    GOTO cuenta0;si el boton lo dejas de presionar te regresa al conteo de 0-9
cuentae:
    CALL delay_250ms
    CALL delay_250ms
    MOVLW 00000100B;carga mi registro de trabajo con tal valor 
    MOVWF LATD,1;carga el LATD con el valor de W , de tal manera que me muestra un e
    CALL delay_250ms
    CALL delay_250ms
    BTFSC PORTA,3,0;si el boton esta presionado continua con el conteo de A-F
    GOTO cuenta0;si el boton lo dejas de presionar te regresa al conteo de 0-9
cuentaf:
    CALL delay_250ms
    CALL delay_250ms
    MOVLW 14;carga mi registro de trabajo con tal valor 
    MOVWF LATD,1;carga el LATD con el valor de W , de tal manera que me muestra un f
    CALL delay_250ms
    CALL delay_250ms
    BTFSC PORTA,3,0;si el boton esta presionado continua con el conteo de A-F
    GOTO cuenta0;si el boton lo dejas de presionar te regresa al conteo de 0-9
    goto CONTA
config_osc:
    BANKSEL OSCCON1
    MOVLW 0X60 ;selecionamos el bloque del oscilador interno con una div=1
    MOVWF OSCCON1,1
    BANKSEL OSCFRQ
    MOVLW 0x02;seleciono una frecuencia de 4MHZ
    MOVWF OSCFRQ,1
    RETURN
config_port:
    ;configuro mi puerto D donde obtendre las salidas para mi display anado
    BANKSEL PORTD
    CLRF PORTD,1; como estoy trabajando con un anado, es activo en bajo 
    SETF LATD,1 ; todas mis salidas =1 , asi mi anodo comun inicia apagado 
    CLRF ANSELD,1; mis puertos seran digitales 
    CLRF TRISD,1 ; me interesa que todos mis pines sean salidas 
    
    ;configuro el boton 
    BANKSEL PORTA 
    CLRF PORTA,1 
    CLRF ANSELA,1    
    BSF TRISA,3,1    
    BSF WPUA,3,1    
    RETURN
END resetvect


