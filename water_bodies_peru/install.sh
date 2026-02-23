#!/bin/bash

# Script de instalación automática para el Sistema de Cuerpos de Agua del Perú

echo "=================================================="
echo "Instalación del Sistema de Cuerpos de Agua - Perú"
echo "con Chatbot DOT"
echo "=================================================="
echo ""

# Colores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Verificar Python
echo "🔍 Verificando Python..."
if ! command -v python3 &> /dev/null; then
    echo -e "${RED}❌ Python 3 no está instalado${NC}"
    echo "Por favor, instala Python 3.9 o superior desde https://www.python.org/"
    exit 1
fi

PYTHON_VERSION=$(python3 --version | cut -d' ' -f2 | cut -d'.' -f1,2)
echo -e "${GREEN}✅ Python $PYTHON_VERSION encontrado${NC}"
echo ""

# Crear entorno virtual
echo "📦 Creando entorno virtual..."
if [ -d "venv" ]; then
    echo -e "${YELLOW}⚠️  Entorno virtual ya existe, saltando...${NC}"
else
    python3 -m venv venv
    echo -e "${GREEN}✅ Entorno virtual creado${NC}"
fi
echo ""

# Activar entorno virtual
echo "🔌 Activando entorno virtual..."
source venv/bin/activate
echo -e "${GREEN}✅ Entorno virtual activado${NC}"
echo ""

# Instalar dependencias
echo "📚 Instalando dependencias..."
pip install --upgrade pip
pip install -r requirements.txt
echo -e "${GREEN}✅ Dependencias instaladas${NC}"
echo ""

# Verificar .env
echo "🔐 Verificando configuración..."
if [ ! -f ".env" ]; then
    echo -e "${YELLOW}⚠️  Archivo .env no encontrado${NC}"
    echo "📝 Creando archivo .env desde plantilla..."
    cp .env .env
    echo -e "${YELLOW}⚠️  Por favor, edita .env y agrega tu OPENAI_API_KEY${NC}"
else
    echo -e "${GREEN}✅ Archivo .env encontrado${NC}"
fi
echo ""

# Migrar base de datos
echo "🗄️  Configurando base de datos..."
python manage.py migrate --noinput
echo -e "${GREEN}✅ Base de datos configurada${NC}"
echo ""

# Verificar imagen DOT
echo "🖼️  Verificando imagen DOT..."
if [ ! -f "water_project/static/images/DOT.jpg" ]; then
    echo -e "${YELLOW}⚠️  Imagen DOT.jpg no encontrada${NC}"
    echo "   Por favor, coloca tu imagen en: water_project/static/images/DOT.jpg"
    echo "   Puedes usar DOT_placeholder.svg como referencia"
else
    echo -e "${GREEN}✅ Imagen DOT.jpg encontrada${NC}"
fi
echo ""

# Verificar CSV
echo "📊 Verificando datos CSV..."
if [ -f "water_project/static/data/data.csv" ]; then
    LINES=$(wc -l < water_project/static/data/data.csv)
    echo -e "${GREEN}✅ Archivo CSV encontrado con $LINES líneas${NC}"
else
    echo -e "${RED}❌ Archivo CSV no encontrado${NC}"
fi
echo ""

echo "=================================================="
echo -e "${GREEN}✅ Instalación completada!${NC}"
echo "=================================================="
echo ""
echo "📋 Siguientes pasos:"
echo ""
echo "1. Configura tu OPENAI_API_KEY en el archivo .env"
echo "2. Coloca tu imagen DOT.jpg en water_project/static/images/"
echo "3. Ejecuta: ./start.sh (Linux/Mac) o start.bat (Windows)"
echo ""
echo "O ejecuta manualmente:"
echo "  Terminal 1: python manage.py runserver"
echo "  Terminal 2: cd chainlit_app && chainlit run app.py --port 8001"
echo ""
echo "=================================================="
