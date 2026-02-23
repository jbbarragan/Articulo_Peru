@echo off
cls
echo ========================================================
echo   Sistema de Cuerpos de Agua - Inicio Completo
echo ========================================================
echo.
echo Este script iniciara:
echo   1. Servidor Django (Frontend) en puerto 8000
echo   2. Servidor Chainlit (Chatbot) en puerto 8001
echo.
echo ========================================================

REM Verificar Python
echo [1/5] Verificando Python...
python --version > nul 2>&1
if errorlevel 1 (
    echo ERROR: Python no esta instalado o no esta en PATH
    echo Por favor instala Python 3.8 o superior desde python.org
    pause
    exit /b 1
)
python --version
echo.

REM Activar entorno virtual
echo [2/5] Activando entorno virtual...
if exist "venv\Scripts\activate.bat" (
    call venv\Scripts\activate.bat
    echo OK - Entorno virtual activado
) else (
    echo No se encontro entorno virtual, creando uno nuevo...
    python -m venv venv
    call venv\Scripts\activate.bat
    echo OK - Entorno virtual creado y activado
)
echo.

REM Instalar dependencias si es necesario
echo [3/5] Verificando dependencias...
pip show django > nul 2>&1
if errorlevel 1 (
    echo Instalando dependencias...
    pip install -r requirements.txt
) else (
    echo OK - Dependencias ya instaladas
)
echo.

REM Verificar archivo .env
echo [4/5] Verificando configuracion...
if not exist ".env" (
    echo ADVERTENCIA: No se encontro archivo .env
    echo El chatbot necesita una API key de OpenAI para funcionar.
    echo.
    echo Por favor crea un archivo .env con:
    echo OPENAI_API_KEY=tu-api-key-aqui
    echo.
    echo Puedes obtener tu API key en: https://platform.openai.com/api-keys
    echo.
    set /p continue="Deseas continuar de todas formas? (s/n): "
    if /i not "%continue%"=="s" (
        echo.
        echo Saliendo...
        pause
        exit /b 1
    )
) else (
    echo OK - Archivo .env encontrado
)
echo.

REM Iniciar servidores
echo [5/5] Iniciando servidores...
echo ========================================================
echo   IMPORTANTE: Se abriran dos ventanas de terminal
echo   - Ventana 1: Django (Frontend)
echo   - Ventana 2: Chainlit (Chatbot)
echo.
echo   NO CIERRES NINGUNA DE LAS VENTANAS
echo ========================================================
echo.

REM Iniciar Django en una nueva ventana
start "Django Frontend - Puerto 8000" cmd /k "call venv\Scripts\activate.bat && echo ========================================================== && echo   DJANGO FRONTEND - Puerto 8000 && echo ========================================================== && echo. && python manage.py runserver 8000"

REM Esperar 3 segundos
timeout /t 3 /nobreak > nul

REM Iniciar Chainlit en una nueva ventana
start "Chainlit Chatbot - Puerto 8001" cmd /k "call venv\Scripts\activate.bat && echo ========================================================== && echo   CHAINLIT CHATBOT - Puerto 8001 && echo ========================================================== && echo. && cd chainlit_app && chainlit run app.py --port 8001"

echo.
echo ========================================================
echo   Servidores iniciandose...
echo ========================================================
echo.
echo   Espera unos segundos y luego abre tu navegador en:
echo   http://localhost:8000
echo.
echo   El chatbot estara disponible en el icono inferior izquierdo
echo.
echo   Para detener los servidores:
echo   - Cierra ambas ventanas de terminal
echo   O presiona Ctrl+C en cada una
echo ========================================================
echo.
pause