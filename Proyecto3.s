/*Andres Emilio Quinto, Luis Pedro Garcia*/
/*Proyecto 3 juego Go*/
.data
.align 2
        turno_2:
                .asciz "              Es el turno del jugador numero 2                          "
        encerrado:
                .asciz " Lo encerraron, por lo tanto pierde la posicion "
        turno_1:
                .asciz "              Es el turno del jugador numero 1                          "
        posicionAnterior:
                .asciz "El valor de la posicion anterior es: %d\n"
        posicionNueva:
                .asciz "El valor de la nueva posicion es: %d\n"
        punteoTxt:
                .asciz "Puntos: %d\n"
        puntos_1:
                .word 0
        puntos_2:
                .word 0
        numeroFormato:
                .asciz "%d"
        exito:
                .asciz "Jugada realizada\n"
        numero:
                .word 0
        numeroTxt:
                .asciz "El numero es: %d\n"
        fila:
                .asciz "Ingrese que fila desea posicionarse "
        columna:
                .asciz "Ingrese la columna que desea posicionarse "
        mensaje:
                .asciz "------El Juego comienza------\n"
        contador:
                .word 0
        fil_1:
                .word 0,0,0,0,0
        fil_2:
                .word 0,0,0,0,0
        fil_3:
                .word 0,0,0,0,0
        fil_4:
                .word 0,0,0,0,0
        ganadorFormato:
                .asciz " El ganador es: %d\n"
        fil_5:
                .word 0,0,0,0,0
        Error:
                .asciz "La posicion escogida ya esta ocupada!! siguiente turno!\n"
		empate1:
				.asciz "Es un empate"
        menu_p:
                .asciz " 1.Reglas\n 2.Jugar\n 3.Salir\n\nOpcion: "
        cadena:
                .asciz "%s"
        op:
                .word 0
        Error_no_opcion:
                .asciz "Error!!!! La opcion no es valida"
        reglas_n:
                .asciz "Se juega entre dos jugadores.  El objetivo del juego es convertir todas las fichas de un jugador a fichas del otro jugador.En un tablero de 5x5 cada jugador coloca una ficha por turno.\nSi un jugador coloca las fichas del otro entre dos fichas suyas, todas las fichas atrapadas se convierten a fichas del jugador.Esto se pude hacer de forma vertical u horizontal.\n"
/*#################################  Main  #############################################*/
.text
.align 2
.global main
.type main, %function
main:
        @@ grabar registro de enlace en la pila
        stmfd   sp!, {lr}

menu:
        /* muestra el menu */
        ldr r1,=menu_p @@ direccion de menu
        ldr r0,=cadena
        bl printf

        /* leer el dato ingresado */
        bl getchar

        /* condicionales del menu */
        cmp r0,#'1'
                beq reglas
        cmpne r0,#'2'
                beq juego
        cmpne r0,#'3'
                beq salir
        bne error

reglas:
        @@muestra las reglas con puts
        ldr r0,=reglas_n
        bl puts
        b juego /*Luego de esto se inicia el juego*/

juego:

/* Mostrar mensaje de bienvenida */
        ldr r0,=mensaje
        bl puts
        /* for del juego hasta no tener mas posiciones disponibles */
/*      ldr r2,=contador
        ldr r3,[r2]
        */
        ciclo:
                /* codigo del ciclo */
                /* primer jugador */
                ldr r0, =turno_1
                bl puts
                bl posicion

                        ldreq r1, =contador
                        ldreq r8, [r1]
                        addeq r6, r8, #1
                        streq r6, [r1]
                        ldreq r1,=contador
                        ldreq r1, [r1]

                /* segundo jugador */
                ldr r0, =turno_2
                bl puts
                bl posicion_2

                        ldreq r1, =contador
                        ldreq r8, [r1]
                        addeq r6, r8, #1
                        streq r6, [r1]
                        ldreq r1,=contador
                        ldreq r1, [r1]

                cmp r1, #25
                beq ganador
                bne ciclo

error:
        ldr r0,=Error_no_opcion
        bl puts
        b salir
error_1:
        ldr r0,=Error
        bl puts
        b salir

/* ver al ganador */
ganador:
        ldr r5, =puntos_1
        ldr r5, [r5]
        ldr r6, =puntos_2
        ldr r6, [r6]
        cmp r5, r6
				beq empate
        movgt r1, #1
        movlt r1, #2
        ldr r0, =ganadorFormato
        bl printf
        b salir
empate:

		ldr r0, =empate1
		bl puts

salir:
        mov     r3, #0
        mov     r0, r3
        /* colocar registro de enlace para desactivar la pila y retorna al SO*/
        ldmfd   sp!, {lr}
        bx      lr

posicion:
        /* guardar el lr anterior a la pila */
        push {lr}
        /* pregunta la fila */
       /* ldr r1,=fila
        ldr r0,=cadena
        bl printf
        bl getchar*/
        /* leer el dato ingresado */
        ldr r0, = fila
        bl puts

        ldr r0,= numeroFormato
        ldr r1,= op
        bl scanf
        ldr r1, =op
        ldr r1, [r1]
        /* if */
        cmp r1, #1
                beq cambio_1
        cmpne r1, #2
                beq cambio_2
        cmpne r1, #3
                beq cambio_3
        cmpne r1, #4
                beq cambio_4
        cmpne r1, #5
                beq cambio_5
        /* si coloco una fila incorrecta */
        blne error
        /* salida de lr para seguir en el ciclo*/


        /* fil_1 */
        cambio_1:
                ldr r0, =columna
                bl puts

                ldr r0, =numeroFormato
                ldr r1, =numero
                bl scanf

                /* validar si el espacio esta vacio */
                mov r10, #4
                ldr r1, =numero
                ldr r1, [r1]
                mul r1, r1, r10
                ldr r4,=fil_1
                add r4, r4, r1
                ldr r5, [r4]
                /*imprimir el valor que esta en la posicion dada*/
                ldr r1, [r4]
                ldr r0, =posicionAnterior
                bl printf
                /* cambiar el valor si esta vacio */
                mov r1, r5
                cmp r1, #0
                blne error_1

                        moveq r7, #1
                        moveq r8, r4
                        streq r7, [r8]
                        /*imprimir el nuevo valor de la posicion */
                        moveq r1, r7
                        ldreq r0, =posicionNueva
                        bleq printf

                        /* le suma un punto */
                        ldreq r1, =puntos_1
                        ldreq r8, [r1]
                        addeq r6, r8, #1
                        streq r6, [r1]
                        /* imprime el punteo */
                        ldreq r1,=puntos_1
                        ldreq r1, [r1]
                        ldreq r0, =punteoTxt
                        bleq printf

                        /* verifica si tiene al oponente a la derecha */
                        moveq r1, #4
                        addeq r8, r4, r1
                        ldreq r3, [r8]
                        /*ldreq r5, [r1]*/

                        /* vefiricar si tiene al oponente a la izquierda */
                        moveq r1, #4
                        subeq r8, r4, r1
                        ldreq r2, [r8]
                        /*ldreq r6, [r1]*/

                        /* cambia de valor la posicion si esta encerrado horizontalmente */
                        encerrado_h:
                                cmp r3, #2
                                cmpeq r2, #2
                                ldreq r0, =encerrado
                                bleq puts
                                moveq r9, #2
                                streq r9, [r4]
                                /* resta un punto a su puntuacion */
                                ldreq r1, =puntos_1
                                ldreq r8, [r1]
                                subeq r6, r8, #1
                                streq r6, [r1]
                                /* imprime el punteo */
                                ldreq r1,=puntos_1
                                ldreq r1, [r1]
                                ldreq r0, =punteoTxt
                                bleq printf
                                ldrne r0, =exito
                                blne puts
                b d_pc
        /* fil_2 */
        cambio_2:
                ldr r0, =columna
                bl puts

                ldr r0, =numeroFormato
                ldr r1, =numero
                bl scanf

                /* validar si el espacio esta vacio */
                mov r10, #4
                ldr r1, =numero
                ldr r1, [r1]
                mul r1, r1, r10
                ldr r4,=fil_2
                add r4, r4, r1
                ldr r5, [r4]
                /*imprimir el valor que esta en la posicion dada*/
                ldr r1, [r4]
                ldr r0, =posicionAnterior
                bl printf
                /* cambiar el valor si esta vacio */
                mov r1, r5
                cmp r1, #0
                        moveq r7, #1
                        moveq r8, r4
                        streq r7, [r8]
                        /*imprimir el nuevo valor de la posicion */
                        moveq r1, r7
                        ldreq r0, =posicionNueva
                        bleq printf

                        /* le suma un punto */
                        ldreq r1, =puntos_1
                        ldreq r8, [r1]
                        addeq r6, r8, #1
                        streq r6, [r1]
                        /* imprime el punteo */
                        ldreq r1,=puntos_1
                        ldreq r1, [r1]
                        ldreq r0, =punteoTxt
                        bleq printf

                        /* verifica si tiene al oponente a la derecha */
                        moveq r1, #4
                        addeq r8, r4, r1
                        ldreq r3, [r8]
                        /*ldreq r5, [r1]*/

                        /* vefiricar si tiene al oponente a la izquierda */
                        moveq r1, #4
                        subeq r8, r4, r1
                        ldreq r2, [r8]
                        beq encerrado_h
                        /*ldreq r6, [r1]*/
        /* fil_3 */
        cambio_3:
                ldr r0, =columna
                bl puts

                ldr r0, =numeroFormato
                ldr r1, =numero
                bl scanf

                /* validar si el espacio esta vacio */
                mov r10, #4
                ldr r1, =numero
                ldr r1, [r1]
                mul r1, r1, r10
                ldr r4,=fil_3
                add r4, r4, r1
                ldr r5, [r4]
                /*imprimir el valor que esta en la posicion dada*/
                ldr r1, [r4]
                ldr r0, =posicionAnterior
                bl printf
                /* cambiar el valor si esta vacio */
                mov r1, r5
                cmp r1, #0
                        moveq r7, #1
                        moveq r8, r4
                        streq r7, [r8]
                        /*imprimir el nuevo valor de la posicion */
                        moveq r1, r7
                        ldreq r0, =posicionNueva
                        bleq printf

                        /* le suma un punto */
                        ldreq r1, =puntos_1
                        ldreq r8, [r1]
                        addeq r6, r8, #1
                        streq r6, [r1]
                        /* imprime el punteo */
                        ldreq r1,=puntos_1
                        ldreq r1, [r1]
                        ldreq r0, =punteoTxt
                        bleq printf

                        /* verifica si tiene al oponente a la derecha */
                        moveq r1, #4
                        addeq r8, r4, r1
                        ldreq r3, [r8]
                        /*ldreq r5, [r1]*/

                        /* vefiricar si tiene al oponente a la izquierda */
                        moveq r1, #4
                        subeq r8, r4, r1
                        ldreq r2, [r8]
                        beq encerrado_h
                        /*ldreq r6, [r1]*/
                /* fil_4 */
        cambio_4:
                ldr r0, =columna
                bl puts

                ldr r0, =numeroFormato
                ldr r1, =numero
                bl scanf

                /* validar si el espacio esta vacio */
                mov r10, #4
                ldr r1, =numero
                ldr r1, [r1]
                mul r1, r1, r10
                ldr r4,=fil_4
                add r4, r4, r1
                ldr r5, [r4]
                /*imprimir el valor que esta en la posicion dada*/
                ldr r1, [r4]
                ldr r0, =posicionAnterior
                bl printf
                /* cambiar el valor si esta vacio */
                mov r1, r5
                cmp r1, #0
                        moveq r7, #1
                        moveq r8, r4
                        streq r7, [r8]
                        /*imprimir el nuevo valor de la posicion */
                        moveq r1, r7
                        ldreq r0, =posicionNueva
                        bleq printf

                        /* le suma un punto */
                        ldreq r1, =puntos_1
                        ldreq r8, [r1]
                        addeq r6, r8, #1
                        streq r6, [r1]
                        /* imprime el punteo */
                        ldreq r1,=puntos_1
                        ldreq r1, [r1]
                        ldreq r0, =punteoTxt
                        bleq printf

                        /* verifica si tiene al oponente a la derecha */
                        moveq r1, #4
                        addeq r8, r4, r1
                        ldreq r3, [r8]
                        /*ldreq r5, [r1]*/

                        /* vefiricar si tiene al oponente a la izquierda */
                        moveq r1, #4
                        subeq r8, r4, r1
                        ldreq r2, [r8]
                        beq encerrado_h
                        /*ldreq r6, [r1]*/
                /* fil_5 */
        cambio_5:
                ldr r0, =columna
                bl puts

                ldr r0, =numeroFormato
                ldr r1, =numero
                bl scanf

                /* validar si el espacio esta vacio */
                mov r10, #4
                ldr r1, =numero
                ldr r1, [r1]
                mul r1, r1, r10
                ldr r4,=fil_5
                add r4, r4, r1
                ldr r5, [r4]
                /*imprimir el valor que esta en la posicion dada*/
                ldr r1, [r4]
                ldr r0, =posicionAnterior
                bl printf
                /* cambiar el valor si esta vacio */
                mov r1, r5
                cmp r1, #0
                        moveq r7, #1
                        moveq r8, r4
                        streq r7, [r8]
                        /*imprimir el nuevo valor de la posicion */
                        moveq r1, r7
                        ldreq r0, =posicionNueva
                        bleq printf

                        /* le suma un punto */
                        ldreq r1, =puntos_1
                        ldreq r8, [r1]
                        addeq r6, r8, #1
                        streq r6, [r1]
                        /* imprime el punteo */
                        ldreq r1,=puntos_1
                        ldreq r1, [r1]
                        ldreq r0, =punteoTxt
                        bleq printf

                        /* verifica si tiene al oponente a la derecha */
                        moveq r1, #4
                        addeq r8, r4, r1
                        ldreq r3, [r8]
                        /*ldreq r5, [r1]*/

                        /* vefiricar si tiene al oponente a la izquierda */
                        moveq r1, #4
                        subeq r8, r4, r1
                        ldreq r2, [r8]
                        beq encerrado_h
                        /*ldreq r6, [r1]*/
        d_pc:
                pop {pc}

posicion_2:
  /* guardar el lr anterior a la pila */
        push {lr}
        /* pregunta la fila */
       /* ldr r1,=fila
        ldr r0,=cadena
        bl printf
        bl getchar*/
        /* leer el dato ingresado */
        ldr r0, = fila
        bl puts

        ldr r0,= numeroFormato
        ldr r1,= op
        bl scanf
        ldr r1, =op
        ldr r1, [r1]
        /* if */
        cmp r1, #1
                beq cambio_1_2
        cmpne r1, #2
                beq cambio_2_2
        cmpne r1, #3
                beq cambio_3_2
        cmpne r1, #4
                beq cambio_4_2
        cmpne r1, #5
                beq cambio_5_2
        /* si coloco una fila incorrecta */
        blne error
        /* salida de lr para seguir en el ciclo*/


        /* fil_1 */
        cambio_1_2:
                ldr r0, =columna
                bl puts

                ldr r0, =numeroFormato
                ldr r1, =numero
                bl scanf

                /* validar si el espacio esta vacio */
                mov r10, #4
                ldr r1, =numero
                ldr r1, [r1]
                mul r1, r1, r10
                ldr r4,=fil_1
                add r4, r4, r1
                ldr r5, [r4]
                /*imprimir el valor que esta en la posicion dada*/
                ldr r1, [r4]
                ldr r0, =posicionAnterior
                bl printf
                /* cambiar el valor si esta vacio */
                mov r1, r5
                cmp r1, #0
                blne error_1

                        moveq r7, #2
                        moveq r8, r4
                        streq r7, [r8]
                        /*imprimir el nuevo valor de la posicion */
                        moveq r1, r7
                        ldreq r0, =posicionNueva
                        bleq printf

                        /* le suma un punto */
                        ldreq r1, =puntos_2
                        ldreq r8, [r1]
                        addeq r6, r8, #1
                        streq r6, [r1]
                        /* imprime el punteo */
                        ldreq r1,=puntos_2
                        ldreq r1, [r1]
                        ldreq r0, =punteoTxt
                        bleq printf

                        /* verifica si tiene al oponente a la derecha */
                        moveq r1, #4
                        addeq r8, r4, r1
                        ldreq r3, [r8]
                        /*ldreq r5, [r1]*/

                        /* vefiricar si tiene al oponente a la izquierda */
                        moveq r1, #4
                        subeq r8, r4, r1
                        ldreq r2, [r8]
                        /*ldreq r6, [r1]*/

                        /* cambia de valor la posicion si esta encerrado horizontalmente */
                        encerrado_h_2:
                                cmp r3, #1
                                cmpeq r2, #1
                                ldreq r0, =encerrado
                                bleq puts
                                moveq r9, #1
                                streq r9, [r4]
                                /* resta un punto a su puntuacion */
                                ldreq r1, =puntos_2
                                ldreq r8, [r1]
                                subeq r6, r8, #1
                                streq r6, [r1]
                                /* imprime el punteo */
                                ldreq r1,=puntos_2
                                ldreq r1, [r1]
                                ldreq r0, =punteoTxt
                                bleq printf
                                ldrne r0, =exito
                                blne puts
                b d_pc_2
        /* fil_2 */
        cambio_2_2:
                ldr r0, =columna
                bl puts

                ldr r0, =numeroFormato
                ldr r1, =numero
                bl scanf

                /* validar si el espacio esta vacio */
                mov r10, #4
                ldr r1, =numero
                ldr r1, [r1]
                mul r1, r1, r10
                ldr r4,=fil_2
                add r4, r4, r1
                ldr r5, [r4]
                /*imprimir el valor que esta en la posicion dada*/
                ldr r1, [r4]
                ldr r0, =posicionAnterior
                bl printf
                /* cambiar el valor si esta vacio */
                mov r1, r5
                cmp r1, #0
                        moveq r7, #2
                        moveq r8, r4
                        streq r7, [r8]
                        /*imprimir el nuevo valor de la posicion */
                        moveq r1, r7
                        ldreq r0, =posicionNueva
                        bleq printf

                        /* le suma un punto */
                        ldreq r1, =puntos_2
                        ldreq r8, [r1]
                        addeq r6, r8, #1
                        streq r6, [r1]
                        /* imprime el punteo */
                        ldreq r1,=puntos_2
                        ldreq r1, [r1]
                        ldreq r0, =punteoTxt
                        bleq printf

                        /* verifica si tiene al oponente a la derecha */
                        moveq r1, #4
                        addeq r8, r4, r1
                        ldreq r3, [r8]
                        /*ldreq r5, [r1]*/

                        /* vefiricar si tiene al oponente a la izquierda */
                        moveq r1, #4
                        subeq r8, r4, r1
                        ldreq r2, [r8]
                        beq encerrado_h_2
        cambio_3_2:
                ldr r0, =columna
                bl puts

                ldr r0, =numeroFormato
                ldr r1, =numero
                bl scanf

                /* validar si el espacio esta vacio */
                mov r10, #4
                ldr r1, =numero
                ldr r1, [r1]
                mul r1, r1, r10
                ldr r4,=fil_3
                add r4, r4, r1
                ldr r5, [r4]
                /*imprimir el valor que esta en la posicion dada*/
                ldr r1, [r4]
                ldr r0, =posicionAnterior
                bl printf
                /* cambiar el valor si esta vacio */
                mov r1, r5
                cmp r1, #0
                        moveq r7, #2
                        moveq r8, r4
                        streq r7, [r8]
                        /*imprimir el nuevo valor de la posicion */
                        moveq r1, r7
                        ldreq r0, =posicionNueva
                        bleq printf

                        /* le suma un punto */
                        ldreq r1, =puntos_2
                        ldreq r8, [r1]
                        addeq r6, r8, #1
                        streq r6, [r1]
                        /* imprime el punteo */
                        ldreq r1,=puntos_2
                        ldreq r1, [r1]
                        ldreq r0, =punteoTxt
                        bleq printf

                        /* verifica si tiene al oponente a la derecha */
                        moveq r1, #4
                        addeq r8, r4, r1
                        ldreq r3, [r8]
                        /*ldreq r5, [r1]*/

                        /* vefiricar si tiene al oponente a la izquierda */
                        moveq r1, #4
                        subeq r8, r4, r1
                        ldreq r2, [r8]
                        beq encerrado_h_2
                        /*ldreq r6, [r1]*/
                        /*ldreq r6, [r1]*/
        cambio_4_2:
                ldr r0, =columna
                bl puts

                ldr r0, =numeroFormato
                ldr r1, =numero
                bl scanf

                /* validar si el espacio esta vacio */
                mov r10, #4
                ldr r1, =numero
                ldr r1, [r1]
                mul r1, r1, r10
                ldr r4,=fil_4
                add r4, r4, r1
                ldr r5, [r4]
                /*imprimir el valor que esta en la posicion dada*/
                ldr r1, [r4]
                ldr r0, =posicionAnterior
                bl printf
                /* cambiar el valor si esta vacio */
                mov r1, r5
                cmp r1, #0
                        moveq r7, #2
                        moveq r8, r4
                        streq r7, [r8]
                        /*imprimir el nuevo valor de la posicion */
                        moveq r1, r7
                        ldreq r0, =posicionNueva
                        bleq printf

                        /* le suma un punto */
                        ldreq r1, =puntos_2
                        ldreq r8, [r1]
                        addeq r6, r8, #1
                        streq r6, [r1]
                        /* imprime el punteo */
                        ldreq r1,=puntos_2
                        ldreq r1, [r1]
                        ldreq r0, =punteoTxt
                        bleq printf

                        /* verifica si tiene al oponente a la derecha */
                        moveq r1, #4
                        addeq r8, r4, r1
                        ldreq r3, [r8]
                        /*ldreq r5, [r1]*/

                        /* vefiricar si tiene al oponente a la izquierda */
                        moveq r1, #4
                        subeq r8, r4, r1
                        ldreq r2, [r8]
                        beq encerrado_h_2
                        /*ldreq r6, [r1]*/
        cambio_5_2:
                ldr r0, =columna
                bl puts

                ldr r0, =numeroFormato
                ldr r1, =numero
                bl scanf

                /* validar si el espacio esta vacio */
                mov r10, #4
                ldr r1, =numero
                ldr r1, [r1]
                mul r1, r1, r10
                ldr r4,=fil_5
                add r4, r4, r1
                ldr r5, [r4]
                /*imprimir el valor que esta en la posicion dada*/
                ldr r1, [r4]
                ldr r0, =posicionAnterior
                bl printf
                /* cambiar el valor si esta vacio */
                mov r1, r5
                cmp r1, #0
                        moveq r7, #2
                        moveq r8, r4
                        streq r7, [r8]
                        /*imprimir el nuevo valor de la posicion */
                        moveq r1, r7
                        ldreq r0, =posicionNueva
                        bleq printf

                        /* le suma un punto */
                        ldreq r1, =puntos_2
                        ldreq r8, [r1]
                        addeq r6, r8, #1
                        streq r6, [r1]
                        /* imprime el punteo */
                        ldreq r1,=puntos_2
                        ldreq r1, [r1]
                        ldreq r0, =punteoTxt
                        bleq printf

                        /* verifica si tiene al oponente a la derecha */
                        moveq r1, #4
                        addeq r8, r4, r1
                        ldreq r3, [r8]
                        /*ldreq r5, [r1]*/

                        /* vefiricar si tiene al oponente a la izquierda */
                        moveq r1, #4
                        subeq r8, r4, r1
                        ldreq r2, [r8]
                        beq encerrado_h_2
                        /*ldreq r6, [r1]*/

        d_pc_2:
                pop {pc}
				
			