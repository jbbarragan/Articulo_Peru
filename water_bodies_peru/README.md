# Sistema de Visualización de Cuerpos de Agua del Perú con Chatbot DOT

Sistema completo para visualizar y consultar información sobre cuerpos de agua en Perú, su contaminación y actividad minera cercana, con un asistente virtual inteligente (DOT) integrado.

## 🌟 Características

### Mapa Interactivo
- Visualización de cuerpos de agua en todo Perú
- Sistema de colores para identificar niveles de contaminación
- Filtros por contaminación y presencia de minas
- Tres tipos de mapas: Calles, Satélite y Topográfico
- Estadísticas en tiempo real

### Chatbot DOT
- Asistente virtual especializado en cuerpos de agua
- Integración con OpenAI GPT-4
- Consultas sobre regiones específicas
- Análisis de contaminación y actividad minera
- Interfaz oculta que se despliega al hacer clic

## 📋 Requisitos

- Python 3.9+
- Django 5.0.1
- Chainlit 1.0.200
- OpenAI API Key

## 🚀 Instalación

### 1. Clonar o descargar el proyecto

```bash
cd water_bodies_peru
```

### 2. Crear entorno virtual

```bash
python -m venv venv
source venv/bin/activate  # En Windows: venv\Scripts\activate
```

### 3. Instalar dependencias

```bash
pip install -r requirements.txt
```

### 4. Configurar variables de entorno

Edita el archivo `.env` y actualiza las siguientes variables:

```env
OPENAI_API_KEY=tu-api-key-aqui
DJANGO_SECRET_KEY=tu-secret-key-aqui
DEBUG=True
```

### 5. Agregar imagen DOT

Coloca tu imagen `DOT.jpg` en:
```
water_project/static/images/DOT.jpg
```

### 6. Migrar base de datos Django

```bash
python manage.py migrate
```

## 🎯 Uso

### Ejecutar el servidor Django

En una terminal:

```bash
python manage.py runserver
```

El mapa estará disponible en: `http://localhost:8000`

### Ejecutar el chatbot Chainlit

En otra terminal (mantén el servidor Django corriendo):

```bash
cd chainlit_app
chainlit run app.py --host 0.0.0.0 --port 8001
```

El chatbot estará integrado automáticamente en la interfaz del mapa.

## 📊 Estructura del Proyecto

```
water_bodies_peru/
├── water_project/              # Django project
│   ├── settings.py            # Configuración Django
│   ├── urls.py                # URLs principales
│   ├── wsgi.py                # WSGI config
│   ├── static/                # Archivos estáticos
│   │   ├── css/
│   │   ├── js/
│   │   │   ├── map.js        # Lógica del mapa
│   │   │   └── chatbot.js    # Control del chatbot
│   │   ├── images/
│   │   │   └── DOT.jpg       # Imagen del chatbot
│   │   └── data/
│   │       └── data.csv      # Datos de cuerpos de agua
│   ├── templates/             # Templates HTML
│   │   └── index.html        # Página principal
│   └── data/
│       └── data.csv          # Datos originales
├── chainlit_app/              # Aplicación Chainlit
│   ├── app.py                # Lógica del chatbot
│   ├── .chainlit             # Configuración Chainlit
│   └── public/               # Assets públicos
├── requirements.txt          # Dependencias Python
├── .env                      # Variables de entorno
├── manage.py                 # Django management
└── README.md                 # Este archivo
```

## 🎨 Código de Colores del Mapa

- 🔵 **Azul (#1E90FF)**: Sin contaminación, sin minas
- 🟠 **Naranja (#FF8C00)**: Sin contaminación, con minas cercanas
- 🟤 **Café (#8B4513)**: Contaminado (nivel 1)
- ⚫ **Negro (#000000)**: Muy contaminado (nivel 2)
- 🩷 **Rosa (#FF1493)**: Contaminado + minas cercanas

## 💬 Uso del Chatbot DOT

1. Haz clic en el botón circular con la imagen DOT en la esquina inferior derecha
2. El chatbot se desplegará en una ventana
3. Escribe tus preguntas sobre:
   - Cuerpos de agua específicos
   - Estadísticas regionales
   - Niveles de contaminación
   - Actividad minera
   - Cualquier consulta relacionada

### Ejemplos de preguntas:

- "¿Cuántos cuerpos de agua hay en la región Amazonas?"
- "Muéstrame los ríos más contaminados"
- "¿Qué cuerpos de agua tienen minas cercanas?"
- "Dame estadísticas de la región Ancash"

## 🔧 Configuración Avanzada

### Cambiar el modelo de OpenAI

En `chainlit_app/app.py`, línea ~195:

```python
stream = await client.chat.completions.create(
    model="gpt-4o-mini",  # Cambiar aquí: gpt-4, gpt-3.5-turbo, etc.
    messages=messages,
    stream=True,
    temperature=0.7,
    max_tokens=1000
)
```

### Personalizar el diseño del chatbot

Edita `water_project/templates/index.html` en la sección de estilos del chatbot (líneas 50-100).

### Modificar datos del mapa

Actualiza el archivo `water_project/data/data.csv` con nuevos datos de cuerpos de agua.

## 🐛 Solución de Problemas

### El chatbot no aparece
- Verifica que Chainlit esté corriendo en el puerto 8001
- Revisa la consola del navegador (F12) para errores

### El mapa no carga los datos
- Confirma que `data.csv` esté en `water_project/static/data/`
- Revisa la consola del navegador para errores de CORS

### Error de OpenAI API
- Verifica que tu API key sea válida
- Confirma que tienes créditos disponibles en tu cuenta de OpenAI

## 📝 Notas Importantes

1. **Imagen DOT.jpg**: Debes proporcionar tu propia imagen. El sistema espera encontrarla en `water_project/static/images/DOT.jpg`

2. **API Key de OpenAI**: La API key en `.env` debe ser válida. Obtén una en https://platform.openai.com/api-keys

3. **Puertos**: 
   - Django corre en puerto 8000
   - Chainlit corre en puerto 8001
   - Asegúrate de que ambos puertos estén disponibles

4. **Datos CSV**: El archivo debe mantener la estructura de columnas existente para que el sistema funcione correctamente.

## 🤝 Contribuciones

Este proyecto fue desarrollado para el análisis de cuerpos de agua en Perú y su relación con la actividad minera.

## 📄 Licencia

Este proyecto es de código abierto. Siéntete libre de usarlo y modificarlo según tus necesidades.

## 📧 Soporte

Para preguntas o problemas, consulta la documentación de:
- Django: https://docs.djangoproject.com/
- Chainlit: https://docs.chainlit.io/
- OpenAI: https://platform.openai.com/docs/

---

**Desarrollado con ❤️ para el análisis ambiental del Perú**
