;----------------------------------------------------------------
;Autor: jorge carreño quino-----Fecha: 15/01/2023
;programa: MPLAB X IDE v6.00----compilador xc8
;-- Tarjeta: Curiosity Nano PIC18F57Q84-----------------------------    
;-este programa me hara un corrimiento de led, inicia el----------
;-corrimiento cuando presionas el boton , y se detiene cuando presionas----
;-el boton(cuando se halla detenido y presionas otra vez,continua el corrimiento--
;--en el led donde se quedo)---------------------------------------------
processor 18F57Q84
#include "bit_config.inc"// config statements should precede project file includes.
#include <xc.inc>
#include "libreria_retardos.inc"
PSECT resetvect,class=CODE,reloc=2
resetvect:
    GOTO main
PSECT CODE  
main:
    CALL config_osc,1;configuro el oscilador interno a 4 MHZ
    CALL config_port,1; configuro los puertos a utilizar 
    
corrimiento:  
    BTFSC PORTA,3,0
    GOTO corrimiento  
    ;comienza el corrimiento impar  
LED_1:
    BCF LATE,1,1;desactiva el led de corrimiento par 
    BSF LATE,0,1;me activa el led de corrimiento impar 
    BCF LATC,7,1
    BSF LATC,0,1; activa el primer led 
    CALL delay_250ms; tiempo que dura el led en el corrimiento par 
    BTFSC PORTA,3,0; evalua si esta presionado el pulsador
    GOTO LED_2
estop_1:
    ;  se detiene en prendido el led donde se presiona el pulsador
    CALL delay_250ms
    BTFSC PORTA,3,0;si presionas el boton continuara con el corrimiento donde se quedo
    GOTO estop_1
LED_2: 
    BCF LATC,0,1; apagamos el led 1 
    BSF LATC,1,1; prendemos el led 2
    CALL delay_250ms
    BTFSC PORTA,3,0; evalua si esta presionado el pulsador
    GOTO LED_3
estop_2:
    ; se detiene el led 2 y vuele a correr el programa cuando se pulsa otra vez
    CALL delay_250ms
    BTFSC PORTA,3,0;si presionas el boton continuara con el corrimiento donde se quedo
    GOTO estop_2
LED_3:
    BCF LATC,1,1; apaga el led 2
    BSF LATC,2,1; prende el led 3 
    CALL delay_250ms,1
    BTFSC PORTA,3,0; evalua si esta presionado el pulsador 
    GOTO LED_4
estop_3:
    ;se detiene en el led 3
    CALL delay_250ms,1
    BTFSC PORTA,3,0;si presionas el boton continuara con el corrimiento donde se quedo
    GOTO estop_3
LED_4:
    BCF LATC,2,1; apaga  el led 3 
    BSF LATC,3,1; prende el led 4 
    CALL delay_250ms
    BTFSC PORTA,3,0;evalua si mi boton esta presionado
    GOTO LED_5
estop_4:
    ;Se detiene en el led
    CALL delay_250ms
    BTFSC PORTA,3,0;si presionas el boton continuara con el corrimiento donde se quedo
    GOTO estop_4   
LED_5:
    ;se apaga el led 4 y se prende el led 5
    BCF LATC,3,1
    BSF LATC,4,1
    CALL delay_250ms
    BTFSC PORTA,3,0; evalua si el pulsador esta presionado 
    GOTO LED_6
estop_5:
    ;se queda en el led 5
    CALL delay_250ms
    BTFSC PORTA,3,0;si presionas el boton continuara con el corrimiento donde se quedo
    GOTO estop_5
LED_6:
    ;se apaga el led 5 y se prende el led 6
    BCF LATC,4,1
    BSF LATC,5,1
    CALL delay_250ms
    BTFSC PORTA,3,0;evalua si el pulsador esta prendido .
    GOTO LED_7
estop_6:
    ;se queda prendodp en el led 6
    CALL delay_250ms
    BTFSC PORTA,3,0;si presionas el boton continuara con el corrimiento donde se quedo
    GOTO estop_6
LED_7:
    ; se apaga el led 6 y se prende el led 7
    BCF LATC,5,1
    BSF LATC,6,1
    CALL delay_250ms
    BTFSC PORTA,3,0;evalua si mi boton esta presionado
    GOTO LED_8
estop_7:
    ; el corrimiento queda en el led 7
    CALL delay_250ms
    BTFSC PORTA,3,0;si presionas el boton continuara con el corrimiento donde se quedo
    GOTO estop_7
LED_8:
    ;se apaga el led 7 y se prende el led 8 
    BCF LATC,6,1
    BSF LATC,7,1
    CALL delay_250ms
    BTFSC PORTA,3,0;evalua si mi boton esta presionado
    GOTO LED1
estop_8:
    ;el corrmiento queda en el led 8
    CALL delay_250ms
    BTFSC PORTA,3,0;si presionas el boton continuara con el corrimiento donde se quedo
    GOTO estop_8   
;comienza el corrimiento par 
LED1:
    BCF LATE,0,1;desactiva el led de corrimiento impar
    BSF LATE,1,1;activa el led de corrimiento par
    BCF LATC,7,1;apagas el led 8 
    BSF LATC,0,1;activas el primer led 
    CALL delay_250ms
    BTFSC PORTA,3,0; evalua si esta presionado el boton
    GOTO LED2
estop1:
    ;se queda el corrimiento en el led 1
    CALL delay_250ms
    BTFSC PORTA,3,0; si presionas el boton continuara con el corrimiento donde se quedo 
    GOTO estop1
LED2: 
    ;se apaga el led 1 y se prende el led 2 
    CALL delay_250ms
    BCF LATC,0,1
    BSF LATC,1,1
    CALL delay_250ms
    BTFSC PORTA,3,0;evalua si esta presionado el boton 
    GOTO LED3
estop2:
    ;se queda el corrimiento en el led 2
    CALL delay_250ms
    BTFSC PORTA,3,0; si presionas el boton continuara con el corrimiento donde se quedo 
    GOTO estop2
LED3:
    ;se apaga el led 2 y se prende el led 3
    CALL delay_250ms
    BCF LATC,1,1
    BSF LATC,2,1
    CALL delay_250ms
    BTFSC PORTA,3,0;evalua si mi boton esta presionado
    GOTO LED4
estop3:
    ;se queda el corrimiento en el led 3
    CALL delay_250ms
    BTFSC PORTA,3,0; si presionas el boton continuara con el corrimiento donde se quedo 
    GOTO estop3
LED4:
    ;se apaga el led 3 y prende el led 4
    CALL delay_250ms
    BCF LATC,2,1
    BSF LATC,3,1
    CALL delay_250ms
    BTFSC PORTA,3,0; evalua si mi boton esta presionado 
    GOTO LED5
estop4:
    ; queda el corrim1ento en el led 4
    CALL delay_250ms
    BTFSC PORTA,3,0;si presionas el boton continuara con el corrimiento donde se quedo 
    GOTO estop4   
LED5:
    ; se apaga el led 4 y se prende el led 5
    CALL delay_250ms
    BCF LATC,3,1
    BSF LATC,4,1
    CALL delay_250ms
    BTFSC PORTA,3,0;evalua si mi boton esta presionado
    GOTO LED6
estop5:
    ;el corrimientto queda en el led 5
    CALL delay_250ms
    BTFSC PORTA,3,0;si presionas el boton continuara con el corrimiento donde se quedo 
    GOTO estop5
LED6:
    ;se apaga el led 5 y se prende el led 6
    CALL delay_250ms
    BCF LATC,4,1
    BSF LATC,5,1
    CALL delay_250ms 
    BTFSC PORTA,3,0;evalua si mi boton esta presionado
    CALL delay_250ms
    GOTO LED7
estop6:
    ;el corrimiento queda en el led 6
    CALL delay_250ms
    BTFSC PORTA,3,0;si presionas el boton continuara con el corrimiento donde se quedo 
    GOTO estop6
LED7:
    ;se apaga el led 6 y se prende el led 7
    CALL delay_250ms
    BCF LATC,5,1
    BSF LATC,6,1
    CALL delay_250ms
    BTFSC PORTA,3,0
    GOTO LED8
estop7:
    ;el corrimiento en el led 7
    CALL delay_250ms
    BTFSC PORTA,3,0;si presionas el boton continuara con el corrimiento donde se quedo 
    GOTO estop7
LED8:
    ;se apaga el led 7 y se prende el led 8 
    CALL delay_250ms
    BCF LATC,6,1
    BSF LATC,7,1
    CALL delay_250ms
    BTFSC PORTA,3,0
    GOTO LED_1
estop8:
    ;se queda el corrimiento en el led 8
    CALL delay_250ms
    BTFSC PORTA,3,0;si presionas el boton continuara con el corrimiento donde se quedo 
    GOTO estop8
    GOTO LED_1; vuelve a corrimiento impar y sigue con par otra vez 
config_osc:
    BANKSEL OSCCON1
    MOVLW 0X60h ;SELECIONAMOS EL BLOQUE DEL OSCILADOR INTERNO CON UN DIV:1
    MOVWF OSCCON1,1
    BANKSEL OSCFRQ
    MOVLW 0x02h;SELECIONAMOS UNA FRECUENCIA DE 4MHZ
    MOVWF OSCFRQ,1
    RETURN
config_port:
    ;configuro el puerto donde iran los led que me mostraran corrimiento impar y par 
    BANKSEL PORTE
    SETF PORTE,1
    CLRF LATE,1
    CLRF ANSELE,1
    CLRF TRISE,1
    ;configuro el puerto c donde tendre salidas para hacer mi corrimiento con 
    ;8 leds 
    BANKSEL PORTC
    SETF PORTC,1
    CLRF LATC,1; mis led inician apagados 
    CLRF ANSELC,1; todos mispuertos seran digitales
    CLRF TRISC,1 ; RC3=salidas 
;configurando boton 
    BANKSEL PORTA 
    CLRF PORTA,1     ;
    CLRF ANSELA,1    ;PORTA DIGITAL 
    BSF TRISA,3,1    ;RA3 COMO ENTRADA
    BSF WPUA,3,1     ;ACTIVAMOS LA RESISTENCIA PULL-UP DEL PIN RA3
    RETURN

END resetvect 

