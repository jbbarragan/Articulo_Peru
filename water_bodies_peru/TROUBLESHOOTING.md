# 🔧 Guía de Solución de Problemas

## Problemas Comunes y Soluciones

### 🗺️ Problemas con el Mapa

#### El mapa no se carga
**Síntoma:** Página en blanco o sin mapa

**Soluciones:**
1. Verifica que Django esté corriendo:
   ```bash
   python manage.py runserver
   ```
2. Abre la consola del navegador (F12) y busca errores
3. Verifica que puedas acceder a http://localhost:8000

#### Los marcadores no aparecen
**Síntoma:** Mapa visible pero sin puntos

**Soluciones:**
1. Verifica que `data.csv` esté en `water_project/static/data/`
2. Abre consola del navegador (F12) y verifica errores de JavaScript
3. Verifica que el CSV tenga el formato correcto
4. Refresca la página (Ctrl + F5)

#### Error: "No se pudo cargar el archivo data.csv"
**Síntoma:** Mensaje de error en pantalla

**Soluciones:**
1. Verifica la ruta del archivo:
   ```bash
   ls -la water_project/static/data/data.csv
   ```
2. Asegúrate de que el archivo tiene permisos de lectura
3. Verifica que el servidor esté sirviendo archivos estáticos correctamente

---

### 🤖 Problemas con el Chatbot

#### El botón DOT no aparece
**Síntoma:** No hay botón circular en la esquina inferior derecha

**Soluciones:**
1. Verifica que `DOT.jpg` esté en `water_project/static/images/`
2. Revisa la consola del navegador (F12) para errores
3. Verifica que el archivo chatbot.js se cargue correctamente
4. Intenta con un nombre de imagen diferente y actualiza el HTML

#### El chatbot no se despliega al hacer clic
**Síntoma:** El botón está visible pero no pasa nada al hacer clic

**Soluciones:**
1. Verifica que Chainlit esté corriendo en puerto 8001:
   ```bash
   cd chainlit_app
   chainlit run app.py --port 8001
   ```
2. Abre consola del navegador y busca errores de CORS
3. Verifica que el iframe apunte a `http://localhost:8001/chainlit`

#### Error: "Failed to load resource" en el iframe
**Síntoma:** El chatbot se despliega pero muestra error

**Soluciones:**
1. Verifica que Chainlit esté corriendo
2. Accede directamente a http://localhost:8001 en otra pestaña
3. Revisa los logs de Chainlit en la terminal
4. Reinicia el servidor de Chainlit

---

### 🔑 Problemas con OpenAI API

#### Error: "Invalid API Key"
**Síntoma:** Chatbot responde con error de API key

**Soluciones:**
1. Verifica que `.env` tenga la key correcta:
   ```bash
   cat .env | grep OPENAI_API_KEY
   ```
2. Asegúrate de que no haya espacios extra
3. La key debe empezar con `sk-proj-` o `sk-`
4. Reinicia el servidor de Chainlit después de cambiar `.env`

#### Error: "Rate limit exceeded"
**Síntoma:** Mensaje de límite de uso excedido

**Soluciones:**
1. Espera 1 minuto y vuelve a intentar
2. Verifica tu tier en https://platform.openai.com/account/limits
3. Considera hacer upgrade si es necesario
4. Reduce la frecuencia de consultas

#### Error: "Insufficient credits"
**Síntoma:** Sin créditos disponibles

**Soluciones:**
1. Ve a https://platform.openai.com/account/billing
2. Añade créditos o método de pago
3. Verifica que no hayas excedido tu límite mensual

#### El chatbot tarda mucho en responder
**Síntoma:** Respuestas muy lentas

**Soluciones:**
1. Cambia a un modelo más rápido (GPT-4o Mini)
2. Reduce `max_tokens` en `app.py`
3. Verifica tu conexión a Internet
4. Revisa el estado de OpenAI: https://status.openai.com/

---

### 🐍 Problemas con Django

#### Error: "ModuleNotFoundError"
**Síntoma:** Falta un módulo de Python

**Soluciones:**
1. Activa el entorno virtual:
   ```bash
   source venv/bin/activate  # Linux/Mac
   venv\Scripts\activate     # Windows
   ```
2. Reinstala dependencias:
   ```bash
   pip install -r requirements.txt
   ```

#### Error: "Port already in use"
**Síntoma:** El puerto 8000 está ocupado

**Soluciones:**
1. Usa otro puerto:
   ```bash
   python manage.py runserver 8080
   ```
2. O mata el proceso:
   ```bash
   # Linux/Mac
   lsof -ti:8000 | xargs kill -9
   
   # Windows
   netstat -ano | findstr :8000
   taskkill /PID <PID> /F
   ```

#### Error: "CSRF verification failed"
**Síntoma:** Errores de CSRF en formularios

**Soluciones:**
1. Verifica que `django.middleware.csrf.CsrfViewMiddleware` esté en MIDDLEWARE
2. Agrega `{% csrf_token %}` en formularios (si los hay)
3. En desarrollo, puedes desactivar temporalmente en settings.py

---

### 📦 Problemas de Instalación

#### pip install falla
**Síntoma:** Error al instalar dependencias

**Soluciones:**
1. Actualiza pip:
   ```bash
   pip install --upgrade pip
   ```
2. Instala paquetes uno por uno para identificar el problema
3. Verifica tu versión de Python (debe ser 3.9+)

#### Error: "Python not found"
**Síntoma:** Python no reconocido

**Soluciones:**
1. Verifica la instalación:
   ```bash
   python --version
   python3 --version
   ```
2. Añade Python al PATH (Windows)
3. Reinstala Python desde https://python.org

---

### 🌐 Problemas de Red

#### CORS errors en la consola
**Síntoma:** Errores de Cross-Origin en el navegador

**Soluciones:**
1. Asegúrate de que ambos servidores estén en localhost
2. Verifica la configuración de `allow_origins` en `.chainlit`
3. Usa el mismo protocolo (http) para ambos

#### No se puede acceder desde otra máquina
**Síntoma:** Solo funciona en localhost

**Soluciones:**
1. Inicia Django con:
   ```bash
   python manage.py runserver 0.0.0.0:8000
   ```
2. Inicia Chainlit con:
   ```bash
   chainlit run app.py --host 0.0.0.0 --port 8001
   ```
3. Configura el firewall para permitir los puertos 8000 y 8001

---

### 📊 Problemas con Datos

#### Error al procesar CSV
**Síntoma:** Errores al cargar datos del CSV

**Soluciones:**
1. Verifica el encoding del CSV (debe ser UTF-8)
2. Asegúrate de que tiene todas las columnas necesarias:
   - Region, Nombre, lat, lon, Tipo, Minas Cerca?, Cantidad, etc.
3. Verifica que no haya filas vacías
4. Revisa que las coordenadas sean números válidos

#### Coordenadas incorrectas
**Síntoma:** Marcadores en ubicaciones erróneas

**Soluciones:**
1. Verifica el formato de lat/lon (decimal, no grados-minutos)
2. Asegúrate de que lat esté entre -90 y 90
3. Asegúrate de que lon esté entre -180 y 180
4. Para Perú: lat debe ser negativa (~-18 a -0), lon debe ser negativa (~-81 a -68)

---

## 🛠️ Herramientas de Diagnóstico

### Verificar que todo esté corriendo:

```bash
# Verificar Django
curl http://localhost:8000

# Verificar Chainlit
curl http://localhost:8001

# Ver procesos Python
ps aux | grep python

# Ver puertos en uso
netstat -tulpn | grep LISTEN  # Linux
netstat -an | findstr LISTEN  # Windows
```

### Logs importantes:

**Django:**
- Terminal donde corrió `python manage.py runserver`
- Busca errores 500, 404, etc.

**Chainlit:**
- Terminal donde corrió `chainlit run app.py`
- Busca errores de OpenAI, conexión, etc.

**Navegador:**
- Consola (F12 → Console)
- Network tab para ver requests fallidas

---

## 📝 Checklist de Diagnóstico

Cuando algo no funcione, verifica en orden:

- [ ] Python 3.9+ instalado
- [ ] Dependencias instaladas (`pip list`)
- [ ] Archivo `.env` existe y tiene API key
- [ ] Imagen `DOT.jpg` en `water_project/static/images/`
- [ ] CSV en `water_project/static/data/data.csv`
- [ ] Django corriendo en puerto 8000
- [ ] Chainlit corriendo en puerto 8001
- [ ] Sin errores en consola del navegador (F12)
- [ ] OpenAI API key válida
- [ ] Créditos disponibles en OpenAI

---

## 🆘 Obtener Ayuda

Si nada funciona:

1. **Revisa los logs** en las terminales de Django y Chainlit
2. **Copia el error exacto** que ves
3. **Revisa la consola del navegador** (F12)
4. **Busca el error** en Google/Stack Overflow
5. **Verifica versiones** de paquetes instalados

### Comandos útiles para reportar problemas:

```bash
# Versión de Python
python --version

# Paquetes instalados
pip list

# Estructura del proyecto
tree -L 2  # Linux/Mac
dir /s /b  # Windows

# Verificar CSV
head -5 water_project/static/data/data.csv
```

---

¿Aún tienes problemas? Revisa:
- README.md para instrucciones generales
- QUICKSTART.md para inicio rápido
- OPENAI_SETUP.md para configuración de OpenAI
