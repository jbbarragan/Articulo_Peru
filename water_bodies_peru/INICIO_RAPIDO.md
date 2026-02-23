# 🚀 INICIO RÁPIDO - 3 PASOS

## Paso 1️⃣: Configurar API Key

```bash
# Crear archivo .env
echo "OPENAI_API_KEY=sk-tu-clave-aqui" > .env
```

**¿No tienes API key?** → https://platform.openai.com/api-keys

---

## Paso 2️⃣: Iniciar Todo

### Windows:
```cmd
start_all.bat
```

### Linux/Mac:
```bash
./start_all.sh
```

**Resultado:** Se abren 2 ventanas de terminal
- 🟢 Ventana 1: Django (puerto 8000)
- 🟢 Ventana 2: Chainlit (puerto 8001)

---

## Paso 3️⃣: ¡Usar!

1. Abre tu navegador en: **http://localhost:8000**
2. Verás el mapa interactivo 🗺️
3. Haz clic en el icono **DOT** (abajo a la izquierda) 🤖
4. ¡Chatea con el asistente! 💬

---

## 💬 Ejemplos de Preguntas

```
"¿Cuántos cuerpos de agua están contaminados?"
"Dame información sobre Cusco"
"¿Qué ríos tienen minas cercanas?"
"Muéstrame los más contaminados"
```

---

## ❌ ¿No Funciona?

### Chatbot vacío:
→ Verifica que ambas ventanas estén abiertas
→ Abre http://localhost:8001 para confirmar que Chainlit corre

### Error "API key not found":
→ Revisa tu archivo .env
→ Reinicia ambos servidores

### Puerto en uso:
→ Cierra otros procesos en puertos 8000/8001

---

## 📖 Más Ayuda

- `README_COMPLETO.md` → Guía completa
- `SOLUCION_CHATBOT.md` → Troubleshooting detallado

---

**¡Eso es todo! En 3 pasos tienes todo funcionando** 🎉
