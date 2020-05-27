/* AndresEmilioQuinto & LuisPedroGarcía */
/*18288 & 19344*/
/* Proyecto 3 temario GO*/
.data
.align 2
        turno_2:
                .asciz "              Es el turno del segundo jugador                           "
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
                .asciz "############################################# Comienzo del Juego ######################################################"
        contador:
                .word 0
        jeje:
                .asciz " sxdcfvgbh    "
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
                .asciz "La posicion esta llena!!!!!!\n"
        menu_p:
                .asciz " 1.Reglas\n 2.Jugar\n 3.Salir\n\nOpcion: "
        cadena:
                .asciz "%s"
        op:
                .word 0
        Error_no_opcion:
                .asciz "Error!!!! La opcion no es valida"
        reglas_n:
                .asciz "1.El tablero es de 5 filas por 5 columnas. Cada posicion del tablero de referira primero como el numero de fila y luego el numero de columna."
/*#################################  Main  ############################################*/
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
        b juego

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

                cmp r1, #10
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
