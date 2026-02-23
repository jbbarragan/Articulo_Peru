# 🤖 Guía de Configuración de OpenAI API

## Obtener tu API Key

### 1. Crear cuenta en OpenAI
1. Ve a https://platform.openai.com/signup
2. Regístrate con tu email
3. Verifica tu cuenta

### 2. Obtener API Key
1. Inicia sesión en https://platform.openai.com/
2. Ve a "API keys" en el menú lateral
3. Click en "Create new secret key"
4. Copia la key (solo se muestra una vez)
5. Guárdala en un lugar seguro

### 3. Configurar en el proyecto
Edita el archivo `.env`:
```env
OPENAI_API_KEY=sk-proj-tu-key-completa-aqui
```

## Modelos Disponibles

El proyecto usa por defecto `gpt-4o-mini` (más económico).

Puedes cambiarlo en `chainlit_app/app.py`:

### Modelos recomendados:

**GPT-4o Mini** (por defecto)
- Modelo: `gpt-4o-mini`
- Costo: Más económico
- Velocidad: Rápida
- Calidad: Buena para la mayoría de casos

**GPT-4o**
- Modelo: `gpt-4o`
- Costo: Medio
- Velocidad: Rápida
- Calidad: Excelente

**GPT-4 Turbo**
- Modelo: `gpt-4-turbo-preview`
- Costo: Más alto
- Velocidad: Media
- Calidad: Máxima

**GPT-3.5 Turbo**
- Modelo: `gpt-3.5-turbo`
- Costo: Muy económico
- Velocidad: Muy rápida
- Calidad: Buena para consultas simples

### Cómo cambiar el modelo:

En `chainlit_app/app.py`, línea ~195:

```python
stream = await client.chat.completions.create(
    model="gpt-4o-mini",  # ← CAMBIAR AQUÍ
    messages=messages,
    stream=True,
    temperature=0.7,
    max_tokens=1000
)
```

## Costos Estimados

### Por 1000 consultas promedio:

| Modelo | Entrada | Salida | Total aproximado |
|--------|---------|--------|------------------|
| GPT-4o Mini | $0.15 | $0.60 | $0.75 |
| GPT-4o | $2.50 | $10.00 | $12.50 |
| GPT-4 Turbo | $10.00 | $30.00 | $40.00 |
| GPT-3.5 Turbo | $0.50 | $1.50 | $2.00 |

*Precios aproximados, consultar https://openai.com/pricing*

## Límites de Uso

### Free Tier
- Límite: $5 de crédito gratis (nuevos usuarios)
- Válido por: 3 meses
- Suficiente para: ~6,600 consultas con GPT-4o Mini

### Tier 1 (Pago inicial)
- Límite: 200 requests/min
- Requiere: Añadir método de pago
- Precio: Pay-as-you-go

## Configuración de Seguridad

### 1. Nunca compartas tu API Key
- No la subas a GitHub
- No la compartas en mensajes
- Úsala solo en archivos `.env`

### 2. Monitorea tu uso
- Dashboard: https://platform.openai.com/usage
- Configura alertas de gasto
- Revisa el uso regularmente

### 3. Configura límites
En el dashboard de OpenAI:
1. Ve a "Settings" > "Limits"
2. Configura límite mensual
3. Activa notificaciones

## Solución de Problemas

### Error: "Invalid API Key"
✅ Verifica que la key esté correcta en `.env`
✅ Asegúrate de no tener espacios extra
✅ La key debe empezar con "sk-"

### Error: "Rate limit exceeded"
✅ Espera unos minutos
✅ Verifica tu tier en OpenAI
✅ Considera upgrade si es necesario

### Error: "Insufficient credits"
✅ Añade créditos en https://platform.openai.com/account/billing
✅ Verifica tu método de pago

### Error: "Model not found"
✅ Verifica el nombre del modelo
✅ Algunos modelos requieren acceso especial
✅ Usa `gpt-4o-mini` para empezar

## Optimización de Costos

### 1. Usa el modelo apropiado
- Consultas simples → GPT-4o Mini
- Análisis complejos → GPT-4o
- No uses GPT-4 Turbo sin necesidad

### 2. Optimiza los prompts
- Sé específico y conciso
- Evita repeticiones
- Usa el contexto CSV eficientemente

### 3. Implementa caché
El proyecto ya implementa:
- Historial de conversación
- Contexto de datos CSV local
- Procesamiento previo de consultas

## Recursos Adicionales

- 📚 Documentación: https://platform.openai.com/docs
- 💰 Precios: https://openai.com/pricing
- 🔧 API Reference: https://platform.openai.com/docs/api-reference
- 💬 Comunidad: https://community.openai.com/

## Alternativas Gratuitas

Si no quieres usar OpenAI, considera:

1. **Ollama** (local, gratis)
   - Modelos: Llama, Mistral, etc.
   - Requiere modificar `chainlit_app/app.py`

2. **Hugging Face API** (con límites gratuitos)
   - Varios modelos disponibles
   - Requiere adaptación del código

3. **Google Gemini** (free tier generoso)
   - API similar a OpenAI
   - Requiere modificar el cliente

---

**¿Necesitas ayuda?** Consulta la documentación de OpenAI o abre un issue en GitHub.
