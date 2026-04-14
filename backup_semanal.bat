@echo off
title BACKUP SEMANAL - G:\BCK para D:\
color 0A

set DATA=%DATE:/=%
set HORA=%TIME::=%
set HORA=%HORA:.=%
set LOGFILE=C:\BCK_LOGs\backup_%DATA%_%HORA%.log

echo ================================================
echo         BACKUP INCREMENTAL SEMANAL
echo ================================================
echo Data:    %DATE% %TIME%
echo Origem:  G:\BCK
echo Destino: D:
echo Log:     %LOGFILE%
echo ================================================
echo.

REM Cria pasta de logs se não existir
if not exist "C:\BCK_LOGs" mkdir "C:\BCK_LOGs"

REM Verifica se o disco G: está disponível
if not exist "G:\BCK" (
    echo ERRO: Disco G:\BCK não encontrado!
    echo Backup cancelado.
    echo %DATE% %TIME% - ERRO: Disco G: nao encontrado >> %LOGFILE%
    pause
    exit /b 1
)

echo Iniciando backup...
echo.

robocopy "G:\BCK" "D:" ^
    /E ^
    /XO ^
    /MT:16 ^
    /FFT ^
    /R:3 ^
    /W:5 ^
    /NP ^
    /LOG+:%LOGFILE% ^
    /COPY:DAT ^
    /DCOPY:T ^
    /J

echo.
echo ================================================
echo Backup finalizado em %DATE% %TIME%
echo ================================================

REM Mantém apenas os últimos 30 logs (opcional)
forfiles /p "C:\BCK_LOGs" /s /m *.log /d -30 /c "cmd /c del @path" 2>nul

exit /b 0