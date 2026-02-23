#!/bin/bash

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

clear
echo "========================================================"
echo "  Sistema de Cuerpos de Agua - Inicio Completo"
echo "========================================================"
echo ""
echo "Este script iniciará:"
echo "  1. Servidor Django (Frontend) en puerto 8000"
echo "  2. Servidor Chainlit (Chatbot) en puerto 8001"
echo ""
echo "========================================================"
echo ""

# Verificar Python
echo -e "${BLUE}[1/5] Verificando Python...${NC}"
if ! command -v python3 &> /dev/null; then
    echo -e "${RED}❌ ERROR: Python 3 no está instalado${NC}"
    echo "Por favor instala Python 3.8 o superior"
    exit 1
fi
python3 --version
echo ""

# Activar entorno virtual
echo -e "${BLUE}[2/5] Configurando entorno virtual...${NC}"
if [ -d "venv" ]; then
    source venv/bin/activate
    echo -e "${GREEN}✅ Entorno virtual activado${NC}"
else
    echo "Creando entorno virtual..."
    python3 -m venv venv
    source venv/bin/activate
    echo -e "${GREEN}✅ Entorno virtual creado y activado${NC}"
fi
echo ""

# Instalar dependencias
echo -e "${BLUE}[3/5] Verificando dependencias...${NC}"
if ! pip show django &> /dev/null; then
    echo "Instalando dependencias..."
    pip install -r requirements.txt
else
    echo -e "${GREEN}✅ Dependencias ya instaladas${NC}"
fi
echo ""

# Verificar archivo .env
echo -e "${BLUE}[4/5] Verificando configuración...${NC}"
if [ ! -f ".env" ]; then
    echo -e "${YELLOW}⚠️  ADVERTENCIA: No se encontró archivo .env${NC}"
    echo "El chatbot necesita una API key de OpenAI para funcionar."
    echo ""
    echo "Por favor crea un archivo .env con:"
    echo "OPENAI_API_KEY=tu-api-key-aqui"
    echo ""
    echo "Puedes obtener tu API key en: https://platform.openai.com/api-keys"
    echo ""
    read -p "¿Deseas continuar de todas formas? (s/n): " continue
    if [ "$continue" != "s" ] && [ "$continue" != "S" ]; then
        echo ""
        echo "Saliendo..."
        exit 1
    fi
else
    echo -e "${GREEN}✅ Archivo .env encontrado${NC}"
fi
echo ""

# Función para limpiar procesos al salir
cleanup() {
    echo ""
    echo -e "${YELLOW}Deteniendo servidores...${NC}"
    kill $DJANGO_PID 2>/dev/null
    kill $CHAINLIT_PID 2>/dev/null
    echo -e "${GREEN}✅ Servidores detenidos${NC}"
    exit 0
}

trap cleanup SIGINT SIGTERM

# Iniciar servidores
echo -e "${BLUE}[5/5] Iniciando servidores...${NC}"
echo "========================================================"
echo ""

# Iniciar Django en background
echo -e "${GREEN}Iniciando Django en puerto 8000...${NC}"
python manage.py runserver 8000 > /tmp/django.log 2>&1 &
DJANGO_PID=$!

# Esperar 3 segundos
sleep 3

# Iniciar Chainlit en background
echo -e "${GREEN}Iniciando Chainlit en puerto 8001...${NC}"
cd chainlit_app
chainlit run app.py --port 8001 > /tmp/chainlit.log 2>&1 &
CHAINLIT_PID=$!
cd ..

sleep 2

echo ""
echo "========================================================"
echo -e "${GREEN}  ✅ Servidores iniciados correctamente${NC}"
echo "========================================================"
echo ""
echo "  Django (Frontend):  http://localhost:8000"
echo "  Chainlit (Chatbot): http://localhost:8001"
echo ""
echo "  El chatbot está disponible en el icono inferior izquierdo"
echo ""
echo -e "${YELLOW}  Presiona Ctrl+C para detener ambos servidores${NC}"
echo "========================================================"
echo ""

# Abrir navegador automáticamente (opcional)
if command -v xdg-open &> /dev/null; then
    sleep 2
    xdg-open http://localhost:8000 &
elif command -v open &> /dev/null; then
    sleep 2
    open http://localhost:8000 &
fi

# Mostrar logs en tiempo real
echo "Mostrando logs (presiona Ctrl+C para salir):"
echo ""
tail -f /tmp/django.log /tmp/chainlit.log 2>/dev/null &
TAIL_PID=$!

# Esperar indefinidamente
wait $DJANGO_PID $CHAINLIT_PID
