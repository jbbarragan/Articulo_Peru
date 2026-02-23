@echo off
cls

echo ========================================================
echo   Sistema de Cuerpos de Agua - Inicio Rapido
echo ========================================================
echo.

REM Verificar que estamos en el lugar correcto
if not exist "manage.py" (
    echo ERROR: Ejecuta este script desde water_bodies_peru\
    pause
    exit /b 1
)

echo [1/4] Verificando Python...
python --version
if errorlevel 1 (
    echo ERROR: Python no encontrado
    pause
    exit /b 1
)
echo.

echo [2/4] Activando entorno virtual...
if exist "venv\Scripts\activate.bat" (
    call venv\Scripts\activate.bat
    echo OK - Entorno activado
) else (
    echo Creando entorno virtual...
    python -m venv venv
    call venv\Scripts\activate.bat
)
echo.

echo [3/4] Instalando Django si es necesario...
pip install -q django
echo.

echo [4/4] Iniciando Django en puerto 8000...
echo.
echo ========================================================
echo   Servidor iniciando...
echo   Abre tu navegador en: http://localhost:8000
echo ========================================================
echo.

timeout /t 2 /nobreak >nul
start http://localhost:8000

python manage.py runserver 8000