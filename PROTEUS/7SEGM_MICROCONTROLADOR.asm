;**********************************************************
;     CONTADOR DE DOS DIGITOS MULTIPLEXADO CON DISPLAY DE 
;     SIETE SEGMENTOS USANDO EL TMR0 COMO BASE DE TIEMPO 
;         DE 10ms  (10x100) PARA INCREMENTAR SU VALOR CADA 
;         		SEGUNDO DE 00-99
;**********************************************************
;			DESCRIPCION: 
;Se trata de incrementar un contador cada segundo y mostrar 
;su valor en dos displays colocados en el puerto B usando la
;técnica de multiplexación. Uno para unidades y otro para
;decenas. Los displays se refrescan cada 20ms. El tmr0 se 
;programa para que genere una interrupción cada 0.01 seg.
; (10 mS) que se repetirá 100 veces con el objeto de activar 
;el conteo cada 1000 mS. Use un reloj de 4MHz.
;**********************************************************
;DIRECTIVAS

	LIST		p=16F887	;Tipo de microcontrolador
	INCLUDE 	P16F887.INC	;Define los SFRs y bits del 
					;P16F887

	__CONFIG _CONFIG1, _CP_OFF&_WDT_OFF&_INTOSCIO&_LVP_OFF	
					;Setea parámetros de 
					;configuración

	errorlevel	 -302		;Deshabilita mensajes de 						;advertencia por cambio bancos			
	CBLOCK	0X020	
	contador			;Cuenta 100 interrupciones
	unidades	
	uni_cod		
	decenas	
	dec_cod		
	sel		
	ENDC
;**********************************************************
;PROGRAMA
	ORG	0x00		;Vector de RESET
	GOTO	MAIN
	ORG	0x04		;Vector de interrupción
	GOTO	Interrupcion	;Va a rutina de interrupción

;DURANTE LA INTERRUPCION SE CUENTAN 100 INTERRUPCIONES
;PARA COMPLETAR 10x100=1000ms. 			
Interrupcion  
	movf	sel,w		;Se mueve a si mismo para afectar bandera
	btfss	STATUS,2	;sel=0 refresca dig1; sel=1 refresca dig2
	goto	dig2
dig1	 	
	movf	unidades,w  
	call	tabla
	movwf	uni_cod
	movf 	uni_cod,w
	bsf	PORTA,0
	bsf	PORTA,1
	movwf	PORTB
	bcf	PORTA,0
	comf	sel,f
	goto 	dec
dig2	
	movf	decenas,w  
	call		tabla
	movwf	dec_cod
	movf 	dec_cod,w
	bsf	PORTA,0
	bsf	PORTA,1
	movwf	PORTB
	bcf	PORTA,1
	comf	sel,f	
dec
						
	decfsz 	contador,f		;cuenta espacios de 10ms
	goto	Seguir			;Aún, no son 100 interrupciones
	INCF 	unidades,f		;Ahora sí 10x100=1000ms=1seg
	movlw	.10
	subwf	unidades,w
	btfss	STATUS,2
	goto	cont
	clrf	unidades
	incf	decenas
	movlw	.10
	subwf	decenas,w
	btfss	STATUS,2
	goto	cont
	clrf	decenas

cont
 	movlw 	.100		
       	movwf 	contador   		;Carga contador con 100




Seguir   
	bcf	INTCON,T0IF		;Repone flag del TMR0 
	movlw 	~.39
       	movwf 	TMR0      		;Repone el TMR0 con ~.39
       	retfie				;Retorno de interrupción

MAIN
;SETEO DE PUERTOS 
	BANKSEL	ANSEL		;Selecciona el Bank3
	CLRF		ANSEL
	CLRF		ANSELH
	BANKSEL 	TRISA		;Selecciona el Bank1
	CLRF		TRISA		;PORTA configurado como salida
	CLRF		TRISB		;PORTB configurado como salida

;INICIALIZACION	      
	BANKSEL 	PORTA		;Selecciona el Bank0		
	CLRF		PORTA		;Borra latch de salida de PORTB
	CLRF		PORTB		;Borra latch de salida de PORTC
	clrf		unidades
	clrf		decenas
	clrf		sel			                                                                         

;PROGRAMACION DEL TMR0
	banksel		OPTION_REG  	;Selecciona el Bank1
	movlw		b'00000111'	;TMR0 como temporizador
	movwf		OPTION_REG  	;con preescaler de 256 
	BANKSEL	TMR0		;Selecciona el Bank0
	movlw		.217		;Valor decimal 217	
	movwf		TMR0		;Carga el TMR0 con 217
	
;PROGRAMACION DE INTERRUPCION
	movlw	b'10100000'
	movwf	INTCON			;Activa la interrupción del TMR0
	movlw	.100			;Cantidad de interrupciones a contar
	movwf	contador		;Nº de veces a repetir la interrupción

Loop			
	nop
	goto 	Loop

; TABLA DE CONVERSION---------------------------------------------------------

tabla
        	ADDWF   PCL,F       	; PCL + W -> PCL
					; El PCL se incrementa con el 
					; valor de W proporcionando un 
					; salto
       	RETLW   0x3F     	; Retorna con el código del 0
		RETLW	0x06		; Retorna con el código del 1
		RETLW	0x5B		; Retorna con el código del 2
		RETLW	0x4F		; Retorna con el código del 3
		RETLW	0x66		; Retorna con el código del 4
		RETLW	0x6D		; Retorna con el código del 5
		RETLW	0x7D		; Retorna con el código del 6
		RETLW	0x07		; Retorna con el código del 7
		RETLW	0x7F		; Retorna con el código del 8
		RETLW	0x67		; Retorna con el código del 9
	END			; Fin del programa fuente



