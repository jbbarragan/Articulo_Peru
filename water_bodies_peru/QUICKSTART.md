# 🚀 Guía de Inicio Rápido

## Instalación en 5 pasos

### 1️⃣ Instalar dependencias
```bash
pip install -r requirements.txt
```

### 2️⃣ Configurar API Key de OpenAI
Edita el archivo `.env`:
```
OPENAI_API_KEY=tu-api-key-aqui
```

### 3️⃣ Agregar imagen DOT.jpg
Coloca tu imagen en:
```
water_project/static/images/DOT.jpg
```

### 4️⃣ Migrar base de datos
```bash
python manage.py migrate
```

### 5️⃣ Iniciar el sistema

**Linux/Mac:**
```bash
./start.sh
```

**Windows:**
```bash
start.bat
```

**Manual (dos terminales):**

Terminal 1:
```bash
python manage.py runserver
```

Terminal 2:
```bash
cd chainlit_app
chainlit run app.py --port 8001
```

## 🌐 Acceso

- **Mapa:** http://localhost:8000
- **Chatbot:** Click en el botón DOT (inferior derecha)

## ❓ Preguntas frecuentes

**P: El chatbot no aparece**
R: Asegúrate de que Chainlit esté corriendo en el puerto 8001

**P: Error de OpenAI**
R: Verifica que tu API key sea válida y tenga créditos

**P: El mapa no carga los datos**
R: Confirma que data.csv esté en `water_project/static/data/`

**P: ¿Cómo cambio la imagen del chatbot?**
R: Reemplaza `water_project/static/images/DOT.jpg` con tu imagen

## 📊 Características principales

✅ Mapa interactivo de Perú
✅ 1200+ cuerpos de agua mapeados
✅ Sistema de filtros por contaminación
✅ Detección de actividad minera
✅ Chatbot AI con OpenAI GPT-4
✅ Estadísticas en tiempo real
✅ Interfaz responsive

## 🎯 Uso del Chatbot

Ejemplos de consultas:

- "¿Cuántos ríos contaminados hay en Amazonas?"
- "Muéstrame estadísticas de Ancash"
- "¿Qué cuerpos de agua tienen minas cercanas?"
- "Dame información sobre el Río Marañón"

---

Para más detalles, consulta el README.md completo
