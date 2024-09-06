@echo off
:menu
cls
echo ========================
echo          ARCADE
echo	      EQUIPO 404
echo ========================
echo 1. TIC TAC TOE
echo 2. Piedra, Papel o Tijera
echo 3. Ruleta Rusa
echo 4. Adivinanza
echo 5. Salir
echo ========================
echo.
set /p option= Selecciona una opcion: 

if "%option%"=="1" goto :option1
if "%option%"=="2" goto :option2
if "%option%"=="3" goto :option3
if "%option%"=="4" goto :option4
if "%option%"=="5" goto :exit
echo Opción no válida. Inténtalo de nuevo.
pause
goto :menu

:option1
echo Has seleccionado la Opción 1.
@echo off
setLocal EnableDelayedExpansion
:newgame
cls
echo ===============================
echo 	Equipo 404
echo 	TIC-TAC-TOE
echo ===============================
echo 	Controles:
echo		 7^| 8 ^| 9
echo 	--+---+--
echo		 4^| 5 ^| 6
echo 	--+---+--
echo		 1^| 2 ^| 3
echo ===============================
echo 1. Maquina
echo 2. 1 jugador
echo 3. 2 jugadores
echo 4. Salir
echo ===============================
echo.
set /a X=1
set /a O=2
set /a winner=0

:numberofplayers
set /p players= "Opcion: "
if %players% LSS 4 (
 call :validplayernumber
) else if %players% == 4 goto :menu
echo Opcion invalida.
echo.
goto :newgame

:validplayernumber
set /a human=0
if %players% == 1 goto :humanset
set /p human="Elige X o O: "
if "%human%" == "X" set /a human=%X%
if "%human%" == "x" set /a human=%X%
if "%human%" == "O" set /a human=%O%
if "%human%" == "o" set /a human=%O%
if %human% == %X% goto :humanset
if %human% == %O% goto :humanset
echo Entrada desconocida.
echo|set /p="Escogiendo jugador inicial al azar: "
set /a human=%random% %% 2 + 1
call :drawsquare %human%
echo.

:humanset
echo|set /p="Escogiendo jugador inicial al azar: "
set /a player=%random% %% 2 + 1
call :drawsquare %player%
echo.
echo.
if %player% == %X% goto :firstset
if %player% == %O% goto :firstset
echo.

:firstset
rem Clearing the board
for /l %%i in (1, 1, 9) do set /a BOARD%%i=0

:mainloop
set /a move=0
if %players% == 3 goto :callhumanmove
if %players% == 2 if %human% == %player% goto :callhumanmove
call :computermove %player%
goto :donemoving
:callhumanmove
call :humanmove %player%
:donemoving

call :checkstalemate
call :checkwinner 1
call :checkwinner 2
if not %winner% == 0 goto :youwon
if %move% == 0 (
 echo Gracias por jugar.
 pause
 goto :eof
)
if %player% == %X% (set /a player=%O%) else set /a player=%X%
goto :mainloop

:youwon
call :drawboard
if %winner% == -1 (
echo EMPATE.
) else (
echo|set /p="Ganador: "
call :drawsquare %winner%
echo.
)
pause
goto :option1



:checkwinner
 if not %BOARD1% == %1 goto :checkwinner1done
 if %BOARD2% == %1 if %BOARD3% == %1 (
  set /a winner=%1
  goto :eof
 )
 if %BOARD5% == %1 if %BOARD9% == %1 (
  set /a winner=%1
  goto :eof
 )
 if %BOARD4% == %1 if %BOARD7% == %1 (
  set /a winner=%1
  goto :eof
 )
:checkwinner1done
 if not %BOARD5% == %1 goto :checkwinner5done
 if %BOARD4% == %1 if %BOARD6% == %1 (
  set /a winner=%1
  goto :eof
 )
 if %BOARD2% == %1 if %BOARD8% == %1 (
  set /a winner=%1
  goto :eof
 )
 if %BOARD3% == %1 if %BOARD7% == %1 (
  set /a winner=%1
  goto :eof
 )
:checkwinner5done
 if not %BOARD9% == %1 goto :eof
 if %BOARD7% == %1 if %BOARD8% == %1 (
  set /a winner=%1
  goto :eof
 )
 if %BOARD3% == %1 if %BOARD6% == %1 (
  set /a winner=%1
  goto :eof
 )
 goto :eof



:checkstalemate
 for /l %%i in (0, 1, 9) do (
  if !BOARD%%i! == 0 goto :eof
 )
 set /a winner=-1
 goto :eof



:drawboard
 call :drawsquare %BOARD7%
 echo|set /p="| "
 call :drawsquare %BOARD8%
 echo|set /p="| "
 call :drawsquare %BOARD9%
 echo.
 echo --+---+--
 call :drawsquare %BOARD4%
 echo|set /p="| "
 call :drawsquare %BOARD5%
 echo|set /p="| "
 call :drawsquare %BOARD6%
 echo.
 echo --+---+--
 call :drawsquare %BOARD1%
 echo|set /p="| "
 call :drawsquare %BOARD2%
 echo|set /p="| "
 call :drawsquare %BOARD3%
 echo.
 goto :eof



:drawsquare
 if %1 == %X% (
  echo|set /p="X "
 ) else if %1 == %O% (
  echo|set /p="O "
 ) else (
  echo|set /p=". "
 )
 goto :eof



:humanmove
 echo.
 call :drawboard
 echo|set /p="Jugador "
 call :drawsquare %1
 set /P move="- Posicion a escoger (1-9): "
 if %move% == 0 goto :eof
 for /l %%i in (0, 1, 9) do (
  if %move% == %%i if !BOARD%%i! == 0 goto :validhumanmove
 )
 echo Movimiento invalido.
 echo.
 goto :humanmove
:validhumanmove
 set /a BOARD%move%=%1
 goto :eof



:checkalmost
 set /a almost=0 
 set /a almostwho = %1
 if not %BOARD1% == %1 goto :checkalmost1done
 if %BOARD2% == %1 if %BOARD3% == 0 (
  set /a almost=3
  goto :eof
 )
 if %BOARD3% == %1 if %BOARD2% == 0 (
  set /a almost=2
  goto :eof
 )
 if %BOARD5% == %1 if %BOARD9% == 0 (
  set /a almost=9
  goto :eof
 )
 if %BOARD9% == %1 if %BOARD5% == 0 (
  set /a almost=5
  goto :eof
 )
 if %BOARD4% == %1 if %BOARD7% == 0 (
  set /a almost=7
  goto :eof
 )
 if %BOARD7% == %1 if %BOARD4% == 0 (
  set /a almost=4
  goto :eof
 )

:checkalmost1done
 if not %BOARD1% == 0 goto :checkalmostnot1done
 if %BOARD2% == %1 if %BOARD3% == %1 (
 set /a almost=1
 goto :eof
 )
 if %BOARD4% == %1 if %BOARD7% == %1 (
 set /a almost=1
 goto :eof
 )
 if %BOARD5% == %1 if %BOARD9% == %1 (
 set /a almost=1
 goto :eof
 )

:checkalmostnot1done
 if not %BOARD5% == %1 goto :checkalmost5done
 if %BOARD4% == %1 if %BOARD6% == 0 (
  set /a almost=6
  goto :eof
 )
 if %BOARD6% == %1 if %BOARD4% == 0 (
  set /a almost=4
  goto :eof
 )
 if %BOARD2% == %1 if %BOARD8% == 0 (
  set /a almost=8
  goto :eof
 )
 if %BOARD8% == %1 if %BOARD2% == 0 (
  set /a almost=2
  goto :eof
 )
 if %BOARD3% == %1 if %BOARD7% == 0 (
  set /a almost=7
  goto :eof
 )
 if %BOARD7% == %1 if %BOARD3% == 0 (
  set /a almost=3
  goto :eof
 )

:checkalmost5done
 if not %BOARD5% == 0 goto :checkalmostnot5done
 if %BOARD4% == %1 if %BOARD6% == %1 (
  set /a almost=5
  goto :eof
 )
 if %BOARD2% == %1 if %BOARD8% == %1 (
  set /a almost=5
  goto :eof
 )
 if %BOARD3% == %1 if %BOARD7% == %1 (
  set /a almost=5
  goto :eof
 )

:checkalmostnot5done
 if not %BOARD9% == %1 goto :checkalmost9done
 if %BOARD7% == %1 if %BOARD8% == 0 (
  set /a almost=8
  goto :eof
 )
 if %BOARD8% == %1 if %BOARD7% == 0 (
  set /a almost=7
  goto :eof
 )
 if %BOARD3% == %1 if %BOARD6% == 0 (
  set /a almost=6
  goto :eof
 )
 if %BOARD6% == %1 if %BOARD3% == 0 (
  set /a almost=3
  goto :eof
 )
:checkalmost9done
 if not %BOARD9% == 0 goto :eof
 if %BOARD7% == %1 if %BOARD8% == %1 (
  set /a almost=9
  goto :eof
 )
 if %BOARD3% == %1 if %BOARD6% == %1 (
  set /a almost=9
  goto :eof
 )
 goto :eof



:computermove
 echo.
 call :drawboard
 echo|set /p="Turno de Maquina "
 call :drawsquare %1
 echo|set /p=""
 echo.
 pause
 set /a move=0
 
 if %1 == 2 goto :computercheckalmost2
 call :checkalmost 1
 call :movealmost %1
 if not %move% == 0 goto :eof
 call :checkalmost 2
 call :movealmost %1
 if not %move% == 0 goto :eof
 goto :computercheckalmost2done

:computercheckalmost2
 call :checkalmost 2
 call :movealmost %1
 if not %move% == 0 goto :eof
 call :checkalmost 1
 call :movealmost %1
 if not %move% == 0 goto :eof
:computercheckalmost2done

 if not %BOARD5% == 0 goto :computernotmoving5
 set /a move=5
 set /a BOARD%move%=%1
 goto :eof

:computernotmoving5
 set /a blanks=0
 for /l %%i in (1, 1, 9) do (
  if !BOARD%%i! == 0 set /a blanks=blanks + 1
 )
 set /a blank=%random% %% %blanks%
 set /a countup=0
:randomloop
 set /a countup=countup + 1
 if !BOARD%countup%! == 0 (
  set /a blank=blank - 1
  if %blank% == 0 (
   set /a move=%countup%
   goto :randomloopover
  )
 )
 goto :randomloop
:randomloopover
 set /a BOARD%move%=%1
 goto :eof

:movealmost
 if %almost% == 0 goto :eof
 set /a move=almost
 set /a BOARD%move%=%1
 goto :eof

pause
goto :menu

:option2
cls
echo ===============================
echo 	Equipo 404
echo   Piedra, Papel o Tijeras!
echo ===============================
echo 1. Piedra
echo 2. Papel
echo 3. Tijeras
echo 4. Instrucciones
echo 5. Salir
echo ===============================
echo.
echo Opcion: 

set /p opcion=

set num=3

set /a rival=%random% %% 3 + 1

if %opcion% LSS 4 (
call :eleccion %opcion%
echo.
call :eleccion %rival%
) else if %opcion% == 4 (
call :instrucciones
) else if %opcion% == 5 (
goto :menu
) else if %opcion% GTR 5 (
echo Opcion invalida
)

if %rival% == %opcion% (
	echo EMPATE
) else if %opcion% == 1 (
    if %rival% equ 2 (
	echo PIERDES :C
        echo Papel cubre Piedra
    ) else (
	echo GANAS!!!
        echo Piedra rompe Tijeras
    )
) else if %opcion% == 2 (
    if %rival% equ 3 (
	echo PIERDES :C
        echo Tijeras cortan Papel
    ) else (
	echo GANAS!!!
        echo Papel cubre Piedra
    )
) else if %opcion% == 3 (
    if %rival% equ 1 (
	echo PIERDES :C
        echo Piedra rompe Tijeras
    ) else (
	echo GANAS!!!
        echo Tijeras cortan Papel
    )
)
pause
goto :option2

:option3
:: Inicializar el array de números disponibles
set nums=1 2 3 4 5 6

cls
echo ===============================
echo 	Equipo 404
echo        	Ruleta Rusa
echo ===============================
echo 1. Jugar
echo 2. Salir
echo ===============================
echo.

set /p opcion= "Opcion: "

if %opcion% == 2 goto :menu

:: Generar un número aleatorio del 1 al 6
set /a randnum=%random% %% 6 + 1

:inicio

call :jugador

:: Turno de la maquina
echo Turno de la maquina...
for %%n in (%nums%) do (
    set computernum=%%n
    call :maquina_turno
    goto :inicio
)

:: Volver al inicio si nadie ha perdido
goto :option3

:option4
cls
echo ===============================
echo 	Equipo 404
echo        	Adivinanza
echo ===============================
echo 1. Jugar
echo 2. Salir
echo ===============================
echo.

set /p opcion= "Opcion: "

if %opcion% == 2 goto :menu

echo.
echo Bienvenido al juego de adivinanza!
echo Estoy pensando en un numero entre 1 y 100.
echo Adivina cual es el numero.
echo.

set /a target=%random% %% 100 + 1
call :guess 

pause
goto :option4


::Funciones del juego "Piedra, papel o tijeras"
:eleccion
if %1 == 1 (
echo. 
echo     ___
echo   /     \
echo  ^|       ^|
echo  ^|       ^|
echo   \ ___ /
echo.
) else if %1 == 2 (
echo. 
echo   ______
echo  ^|      ^|
echo  ^|      ^|
echo  ^|      ^|
echo  ^|______^|
echo. 
) else (
echo. 
echo    \  /
echo     \/
echo     /\
echo   _/  \_
echo  ^|_^|  ^|_^|
echo.
)
goto :eof

:instrucciones
echo. 
echo Elige un objeto de la lista
echo 1. Piedra
echo 2. Papel
echo 3. Tijeras
echo.
echo Una vez que hayas elegido, se escogera un objeto de la lista.
echo Y dependiendo del objeto que se escoga pierdes, ganas o empatas.
echo -Piedra rompe Tijeras
echo -Papel cubre Piedra
echo -Tijeras rompe papel
echo.
goto :eof


::Funciones del juego "Ruleta Rusa"
:jugador
:: Entrada del jugador
echo.
echo Numeros disponibles: %nums%
set /p playernum= Tu turno, elige un numero: 
echo.

:: Validar que el número está disponible
if "!nums:%playernum%=!"=="%nums%" (
    echo Numero invalido, elige otro numero.
    goto :inicio
)

:: Eliminar el número elegido por el jugador de la lista
set nums=!nums:%playernum%=!

:: Verificar si el jugador eligió el número aleatorio
if %playernum%==%randnum% (
    echo Oh no!
    echo Elegiste el numero secreto %randnum%
    echo Has perdido!
    pause
    goto option3
)
goto :eof

:maquina_turno
:: Eliminar el número elegido por la máquina de la lista
set nums=!nums:%computernum%=!
echo La maquina eligio: %computernum%

:: Verificar si la máquina eligió el número aleatorio
if %computernum%==%randnum% (
    echo.
    echo La maquina eligio el numero secreto %randnum%
    echo Has ganado!
    pause
    goto :option3
)
goto :eof


::Funciones del juego "Adivinanza"
:guess
set /p guess="Introduce un numero: "

if "%guess%" == "" goto guess
if "%guess%" == "%target%" (
    echo.
    echo Felicidades! Has adivinado el numero.
) else if %guess% lss %target% (
    echo.
    echo El numero es mayor. Intentalo de nuevo.
    goto guess
) else if %guess% gtr %target% (
    echo.
    echo El numero es menor. Intentalo de nuevo.
    goto guess
)
goto :eof