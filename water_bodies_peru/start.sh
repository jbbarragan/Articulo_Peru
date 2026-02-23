#!/bin/bash

# Script para iniciar ambos servidores (Django y Chainlit)

echo "🚀 Iniciando Sistema de Cuerpos de Agua del Perú con DOT"
echo "=================================================="
echo ""

# Verificar que estamos en el directorio correcto
if [ ! -f "manage.py" ]; then
    echo "❌ Error: Este script debe ejecutarse desde el directorio raíz del proyecto"
    exit 1
fi

# Verificar imagen DOT
if [ ! -f "water_project/static/images/DOT.jpg" ]; then
    echo "⚠️  Advertencia: No se encontró la imagen DOT.jpg"
    echo "   Por favor, coloca tu imagen en: water_project/static/images/DOT.jpg"
    echo ""
fi

# Verificar .env
if [ ! -f ".env" ]; then
    echo "❌ Error: Archivo .env no encontrado"
    echo "   Por favor, configura tu archivo .env con OPENAI_API_KEY"
    exit 1
fi

# Iniciar Django en segundo plano
echo "🌐 Iniciando servidor Django en puerto 8000..."
python manage.py runserver 0.0.0.0:8000 &
DJANGO_PID=$!
sleep 3

# Iniciar Chainlit en segundo plano
echo "🤖 Iniciando chatbot Chainlit en puerto 8001..."
cd chainlit_app
chainlit run app.py --host 0.0.0.0 --port 8001 &
CHAINLIT_PID=$!
cd ..

echo ""
echo "✅ Sistema iniciado correctamente!"
echo "=================================================="
echo "📍 Mapa interactivo: http://localhost:8000"
echo "🤖 Chatbot DOT: Integrado en el mapa (botón inferior derecho)"
echo ""
echo "Para detener los servidores, presiona Ctrl+C"
echo "=================================================="
echo ""

# Función para limpiar al salir
cleanup() {
    echo ""
    echo "🛑 Deteniendo servidores..."
    kill $DJANGO_PID 2>/dev/null
    kill $CHAINLIT_PID 2>/dev/null
    echo "✅ Servidores detenidos"
    exit 0
}

# Capturar Ctrl+C
trap cleanup INT TERM

# Esperar indefinidamente
wait
