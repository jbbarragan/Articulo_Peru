# Sistema de Cuerpos de Agua del Perú

Sistema web interactivo para visualizar y analizar cuerpos de agua del Perú, con información sobre contaminación y actividad minera cercana. Incluye un chatbot inteligente (DOT) para consultas en lenguaje natural.

## 🌟 Características

### Frontend (Django + Leaflet)
- **Mapa interactivo** con clustering de marcadores para optimizar rendimiento
- **Filtros dinámicos** por nivel de contaminación y presencia de minas
- **Múltiples capas de mapa**: Calles, Satélite, Topográfico
- **Panel de estadísticas** en tiempo real
- **Visualización codificada por colores**:
  - 🔵 Azul: Sin contaminación, sin minas
  - 🟠 Naranja: Sin contaminación, con minas cercanas
  - 🟤 Café: Contaminado (nivel 1)
  - ⚫ Negro: Muy contaminado (nivel 2)
  - 🩷 Rosa: Contaminado con minas cercanas

### Chatbot DOT (Chainlit + OpenAI)
- **Consultas en lenguaje natural** sobre cuerpos de agua
- **Análisis regional** de contaminación
- **Búsquedas específicas** por región, tipo o nivel de contaminación
- **Estadísticas detalladas** bajo demanda
- **Interfaz conversacional** moderna y amigable

## 📋 Requisitos

- **Python 3.8+**
- **Cuenta de OpenAI** con API key (para el chatbot)
- **Navegador web moderno** (Chrome, Firefox, Safari, Edge)

## 🚀 Instalación Rápida

### Windows

1. **Descargar el proyecto** (si aún no lo tienes)
2. **Configurar API Key de OpenAI**:
   - Crear archivo `.env` en la raíz del proyecto
   - Agregar: `OPENAI_API_KEY=tu-api-key-aqui`
   - Obtén tu API key en: https://platform.openai.com/api-keys

3. **Ejecutar el script de inicio**:
   ```cmd
   start_all.bat
   ```

El script automáticamente:
- ✅ Verificará Python
- ✅ Creará el entorno virtual (si no existe)
- ✅ Instalará todas las dependencias
- ✅ Iniciará Django (puerto 8000)
- ✅ Iniciará Chainlit (puerto 8001)

### Linux / macOS

1. **Descargar el proyecto**
2. **Configurar API Key de OpenAI**:
   ```bash
   echo "OPENAI_API_KEY=tu-api-key-aqui" > .env
   ```

3. **Ejecutar el script de inicio**:
   ```bash
   chmod +x start_all.sh
   ./start_all.sh
   ```

## 🔧 Instalación Manual

Si prefieres controlar cada paso:

### 1. Crear entorno virtual

**Windows:**
```cmd
python -m venv venv
venv\Scripts\activate
```

**Linux/macOS:**
```bash
python3 -m venv venv
source venv/bin/activate
```

### 2. Instalar dependencias

```bash
pip install -r requirements.txt
```

### 3. Configurar variables de entorno

Crear archivo `.env` con:
```
OPENAI_API_KEY=tu-api-key-aqui
```

### 4. Iniciar Django (Terminal 1)

```bash
python manage.py runserver 8000
```

### 5. Iniciar Chainlit (Terminal 2)

```bash
cd chainlit_app
chainlit run app.py --port 8001
```

## 🌐 Uso

1. **Abrir el navegador** en: http://localhost:8000
2. El **mapa interactivo** se mostrará con todos los cuerpos de agua
3. Usar el **panel de filtros** (☰) para filtrar por contaminación o minas
4. Hacer **clic en el icono del chatbot** (esquina inferior izquierda) para abrir DOT
5. **Chatear con DOT** para obtener información específica

## 💬 Ejemplos de consultas al chatbot

- "¿Cuántos cuerpos de agua están contaminados en Perú?"
- "Dame información sobre la región de Cusco"
- "¿Qué ríos tienen minas cercanas?"
- "Muéstrame los cuerpos de agua muy contaminados"
- "¿Cuál es el estado del agua en Puno?"

## 📁 Estructura del Proyecto

```
proyecto_corregido/
├── chainlit_app/          # Aplicación del chatbot
│   ├── app.py            # Lógica del chatbot con OpenAI
│   └── public/           # Assets del chatbot
├── water_project/         # Aplicación Django
│   ├── data/             # Archivo CSV con datos
│   ├── static/           # Archivos estáticos (imágenes)
│   ├── templates/        # Templates HTML
│   └── settings.py       # Configuración Django
├── .env                   # Variables de entorno (API keys)
├── requirements.txt       # Dependencias Python
├── start_all.bat         # Script de inicio para Windows
├── start_all.sh          # Script de inicio para Linux/macOS
└── README.md             # Este archivo
```

## 🔑 Obtener API Key de OpenAI

1. Ir a https://platform.openai.com/
2. Crear una cuenta o iniciar sesión
3. Ir a **API Keys**: https://platform.openai.com/api-keys
4. Crear una **nueva API key**
5. Copiar la key y agregarla al archivo `.env`

**Nota:** OpenAI ofrece créditos gratuitos para nuevos usuarios. El chatbot usa el modelo `gpt-4o-mini` que es económico y eficiente.

## 🐛 Solución de Problemas

### El chatbot no aparece o no funciona

**Problema:** El iframe del chatbot está vacío o muestra error.

**Solución:**
1. Verificar que el servidor Chainlit esté corriendo en el puerto 8001
2. Abrir http://localhost:8001 en una pestaña separada para confirmar
3. Verificar que el archivo `.env` tiene la API key correcta
4. Revisar la consola de Chainlit para errores

### Error: "OpenAI API key not found"

**Solución:**
1. Crear archivo `.env` en la raíz del proyecto
2. Agregar: `OPENAI_API_KEY=tu-api-key-aqui`
3. Reiniciar ambos servidores

### El mapa no carga

**Solución:**
1. Verificar que `water_project/data/data.csv` existe
2. Abrir la consola del navegador (F12) para ver errores
3. Verificar conexión a internet (se requiere para tiles del mapa)

### Puerto 8000 o 8001 ya está en uso

**Solución:**
1. Detener otros servicios que usen esos puertos
2. O modificar los puertos en los scripts de inicio:
   - Django: `python manage.py runserver 8080`
   - Chainlit: `chainlit run app.py --port 8081`
   - Actualizar el iframe en `templates/index.html` línea 264

## 🎨 Personalización

### Cambiar posición del chatbot

El chatbot ahora está en la **esquina inferior izquierda**. Para cambiarlo de nuevo:

En `templates/index.html`, buscar `.chatbot-container` y cambiar:
```css
.chatbot-container {
    left: 20px;  /* Cambiar a 'right: 20px;' para moverlo a la derecha */
}
```

### Cambiar colores del mapa

En `templates/index.html`, función `getMarkerColor()`, modificar los códigos de color.

### Modificar personalidad del chatbot

En `chainlit_app/app.py`, editar la variable `SYSTEM_MESSAGE` con las instrucciones que quieras dar al chatbot.

## 📊 Datos

El archivo `water_project/data/data.csv` contiene información de cuerpos de agua con las siguientes columnas:

- **Region**: Departamento/región del Perú
- **Nombre**: Nombre del cuerpo de agua
- **Tipo**: Tipo (río, quebrada, lago, etc.)
- **lat, lon**: Coordenadas geográficas
- **Contaminación**: Nivel (0: sin, 1: contaminado, 2: muy contaminado)
- **Minas Cerca?**: Presencia de minas (0 o 1)
- **Cantidad**: Número de minas cercanas
- **Tipo de contaminación**: Descripción del tipo
- **Densidad poblacional**: Nivel de población
- **Tipo de suelo**: Clasificación del suelo
- **uso de suelo**: Uso principal del terreno

## 🤝 Contribuir

Si encuentras bugs o tienes sugerencias:
1. Documenta el problema claramente
2. Incluye pasos para reproducirlo
3. Si es posible, sugiere una solución

## 📄 Licencia

Este proyecto es de código abierto para fines educativos y de investigación.

## 🙋 Soporte

Para dudas o problemas:
- Revisar la sección de **Solución de Problemas**
- Consultar los logs en las terminales de Django y Chainlit
- Verificar la consola del navegador (F12)

---

**¡Explora los cuerpos de agua del Perú y consulta con DOT!** 🌊🤖
