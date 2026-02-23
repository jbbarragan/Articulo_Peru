# 🔧 SOLUCIÓN: Chatbot No Se Ve

## 📋 Diagnóstico del Problema

### ¿Qué estaba mal?

1. **Django corriendo solo en puerto 8000** ✅
2. **Chainlit NO estaba corriendo** ❌
3. **El iframe del chatbot apuntaba a puerto 8001** pero no había nada ahí ❌

### Por qué no veías nada en el chatbot:

Cuando hacías clic en el icono del chatbot, se abría un iframe que intentaba cargar `http://localhost:8001`, pero como Chainlit no estaba corriendo, el iframe quedaba vacío/en blanco.

## ✅ Solución Implementada

### Cambios realizados:

#### 1. **Icono del chatbot movido a la izquierda** ✅
   - Antes: esquina inferior derecha
   - Ahora: esquina inferior izquierda
   - Archivo modificado: `water_project/templates/index.html`

#### 2. **Scripts de inicio mejorados** ✅
   - `start_all.bat` (Windows) - Inicia Django Y Chainlit
   - `start_all.sh` (Linux/Mac) - Inicia Django Y Chainlit
   - Ambos scripts abren DOS ventanas/terminales separadas

#### 3. **README completo** ✅
   - Instrucciones paso a paso
   - Solución de problemas comunes
   - Ejemplos de uso del chatbot

## 🚀 Cómo Usar el Proyecto Corregido

### Opción 1: Script Automático (RECOMENDADO)

**Windows:**
```cmd
start_all.bat
```

**Linux/macOS:**
```bash
chmod +x start_all.sh
./start_all.sh
```

### Opción 2: Manual (dos terminales)

**Terminal 1 - Django:**
```cmd
venv\Scripts\activate   # Windows
# o
source venv/bin/activate  # Linux/Mac

python manage.py runserver 8000
```

**Terminal 2 - Chainlit:**
```cmd
venv\Scripts\activate   # Windows
# o
source venv/bin/activate  # Linux/Mac

cd chainlit_app
chainlit run app.py --port 8001
```

## ⚙️ Configuración Necesaria

### 1. Archivo .env (IMPORTANTE)

El chatbot necesita una API key de OpenAI. Crear archivo `.env` en la raíz:

```
OPENAI_API_KEY=sk-tu-api-key-aqui
```

**¿Dónde obtenerla?**
- https://platform.openai.com/api-keys
- OpenAI ofrece créditos gratuitos para nuevos usuarios
- El chatbot usa `gpt-4o-mini` (modelo económico)

### 2. Dependencias

Todas las dependencias están en `requirements.txt`:
```
Django==5.0.1
chainlit
openai
pandas
python-dotenv
```

El script automático las instala, pero si usas el método manual:
```bash
pip install -r requirements.txt
```

## 🧪 Verificar que Todo Funciona

### Checklist:

1. **Django corriendo** ✓
   - Abrir: http://localhost:8000
   - Deberías ver el mapa

2. **Chainlit corriendo** ✓
   - Abrir: http://localhost:8001
   - Deberías ver la interfaz del chatbot

3. **Chatbot integrado** ✓
   - En http://localhost:8000
   - Clic en el icono inferior izquierdo (DOT)
   - Se abre el chatbot en un iframe

4. **Chatbot funcional** ✓
   - Escribir: "Hola DOT"
   - Debería responder

## 🐛 Problemas Comunes y Soluciones

### Problema 1: Chatbot vacío/en blanco

**Causa:** Chainlit no está corriendo en puerto 8001

**Solución:**
1. Abrir http://localhost:8001 en el navegador
2. Si no carga, iniciar Chainlit manualmente:
   ```bash
   cd chainlit_app
   chainlit run app.py --port 8001
   ```

### Problema 2: Error "OpenAI API key not found"

**Causa:** Falta el archivo .env o la API key

**Solución:**
1. Crear archivo `.env` en la raíz del proyecto
2. Agregar: `OPENAI_API_KEY=tu-clave-aqui`
3. Reiniciar Chainlit

### Problema 3: "Puerto ya en uso"

**Causa:** Otro proceso está usando el puerto 8000 o 8001

**Solución Windows:**
```cmd
# Ver qué usa el puerto
netstat -ano | findstr :8000
netstat -ano | findstr :8001

# Matar el proceso (reemplazar PID con el número que veas)
taskkill /PID <numero> /F
```

**Solución Linux/Mac:**
```bash
# Ver y matar proceso en puerto 8000
lsof -ti:8000 | xargs kill -9

# Ver y matar proceso en puerto 8001
lsof -ti:8001 | xargs kill -9
```

### Problema 4: "ModuleNotFoundError: No module named 'chainlit'"

**Causa:** Dependencias no instaladas

**Solución:**
```bash
pip install -r requirements.txt
```

## 📝 Resumen de Cambios

| Aspecto | Antes | Ahora |
|---------|-------|-------|
| **Chatbot visible** | ❌ No | ✅ Sí |
| **Posición icono** | Derecha | Izquierda |
| **Scripts de inicio** | Solo Django | Django + Chainlit |
| **Documentación** | Básica | Completa con troubleshooting |

## 🎯 Resultado Esperado

Cuando ejecutes `start_all.bat` (o `.sh`):

1. Se abren **2 ventanas de terminal**:
   - Ventana 1: Django en puerto 8000
   - Ventana 2: Chainlit en puerto 8001

2. Tu navegador abre http://localhost:8000

3. Ves el **mapa interactivo** con todos los cuerpos de agua

4. En la **esquina inferior izquierda** está el icono de DOT

5. Al hacer **clic en DOT**, se abre el chatbot funcionando

6. Puedes **chatear** y hacer consultas sobre los cuerpos de agua

## 💡 Tip Pro

Para verificar rápidamente que todo está bien:

```bash
# Abrir 3 pestañas del navegador:
http://localhost:8000      # El mapa principal
http://localhost:8001      # Chainlit directo
http://localhost:8000      # Y probar el chatbot integrado
```

## 📞 ¿Todavía no funciona?

Si después de seguir esta guía el chatbot sigue sin funcionar:

1. Revisa los logs en ambas terminales
2. Verifica que las 2 ventanas están abiertas
3. Comprueba el archivo .env
4. Asegúrate de tener créditos en tu cuenta de OpenAI
5. Revisa la consola del navegador (F12) para errores JavaScript

---

**¡Ahora sí debería funcionar todo correctamente!** 🎉
