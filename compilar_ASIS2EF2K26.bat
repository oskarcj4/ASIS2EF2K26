@echo off
REM ==================================================================
REM Area : ASIS2EF2K26
REM Autor : Oskar Cermeno
REM Carne : 0901-23-15379
REM Fecha : 24/11/2026
REM ==================================================================
REM Proposito :
REM  Compila Contabilidad (Modelo, Controlador y Vista) y el ejecutable
REM  Ejecucion_ASIS2EF2K26 (x64) usando las DLL de la carpeta dll.
REM Reglas especificas:
REM  Se detiene en el primer proyecto que falle.
REM ==================================================================
setlocal EnableExtensions

set "RAIZ=%~dp0"
set "RAIZ=%RAIZ:~0,-1%"
set "CO=%RAIZ%\codigo\modulos\contabilidad\Bibliotecas de Contabilidad\Contabilidad"
set "CONFIG=Debug"
if not "%~1"=="" set "CONFIG=%~1"

set "MSB="
set "VSWHERE=%ProgramFiles(x86)%\Microsoft Visual Studio\Installer\vswhere.exe"
if exist "%VSWHERE%" (
    for /f "usebackq delims=" %%P in (`"%VSWHERE%" -latest -products * -requires Microsoft.Component.MSBuild -find MSBuild\**\Bin\MSBuild.exe`) do set "MSB=%%P"
)
if not defined MSB (
    for %%E in (Enterprise Professional Community BuildTools) do (
        if exist "%ProgramFiles%\Microsoft Visual Studio\2022\%%E\MSBuild\Current\Bin\MSBuild.exe" set "MSB=%ProgramFiles%\Microsoft Visual Studio\2022\%%E\MSBuild\Current\Bin\MSBuild.exe"
    )
)
if not defined MSB (
    echo No se encontro MSBuild de Visual Studio 2022.
    exit /b 1
)
echo MSBuild: %MSB%
echo Configuracion: %CONFIG%
echo.

call :compilar "%CO%\CapaModelo_Contabilidad\CapaModelo_Contabilidad.csproj" || goto :fallo
call :compilar "%CO%\CapaControlador_Contabilidad\CapaControlador_Contabilidad.csproj" || goto :fallo
call :compilar "%CO%\CapaVista_Contabilidad\CapaVista_Contabilidad.csproj" || goto :fallo
call :compilar "%RAIZ%\Ejecucion_ASIS2EF2K26\Ejecucion_ASIS2EF2K26\Ejecucion_ASIS2EF2K26.csproj" || goto :fallo

echo.
echo ===== Compilacion terminada sin errores =====
echo Ejecutable: %RAIZ%\Ejecucion_ASIS2EF2K26\Ejecucion_ASIS2EF2K26\bin\%CONFIG%\Ejecucion_ASIS2EF2K26.exe
exit /b 0

:compilar
echo Compilando %~nx1
"%MSB%" "%~1" -t:Build -p:Configuration=%CONFIG% -nologo -v:minimal
exit /b %ERRORLEVEL%

:fallo
echo.
echo ===== La compilacion fallo =====
exit /b 1
