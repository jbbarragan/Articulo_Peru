'''
ESTA VERSION JALA CON OPENAI PERO NO TENGO CREDITOS
import os
import chainlit as cl
from openai import AsyncOpenAI
import pandas as pd
from pathlib import Path
from dotenv import load_dotenv

# Cargar variables de entorno
load_dotenv()

# Configurar OpenAI con AsyncOpenAI (API moderna)
client = AsyncOpenAI(api_key=os.getenv("OPENAI_API_KEY"))

# Cargar datos CSV
BASE_DIR = Path(__file__).resolve().parent.parent
CSV_PATH = BASE_DIR / "water_project" / "data" / "data.csv"

# Cargar datos globales
water_data = None

def load_water_data():
    """Carga los datos de cuerpos de agua del CSV"""
    global water_data
    try:
        water_data = pd.read_csv(CSV_PATH)
        print(f"Datos cargados: {len(water_data)} registros")
        return True
    except Exception as e:
        print(f" Error al cargar datos: {e}")
        return False

# Cargar datos al inicio
load_water_data()

def get_data_summary():
    """Obtiene un resumen de los datos disponibles"""
    if water_data is None:
        return "No hay datos disponibles."
    
    total = len(water_data)
    contaminated = len(water_data[water_data['Contaminación'].astype(str) == '1'])
    very_contaminated = len(water_data[water_data['Contaminación'].astype(str) == '2'])
    with_mines = len(water_data[water_data['Minas Cerca?'].astype(str) == '1'])
    
    # Manejar columna Region con BOM
    region_col = 'Region' if 'Region' in water_data.columns else 'ï»¿Region'
    regions = water_data[region_col].unique()
    
    return f"""
Base de datos de Cuerpos de Agua del Perú:
- Total de cuerpos de agua: {total}
- Cuerpos contaminados (nivel 1): {contaminated}
- Cuerpos muy contaminados (nivel 2): {very_contaminated}
- Cuerpos con minas cercanas: {with_mines}
- Regiones cubiertas: {len(regions)} ({', '.join(list(regions)[:5])}...)

Tipos de información disponible:
- Ubicación geográfica (latitud, longitud)
- Tipo de cuerpo de agua (río, quebrada, lago, etc.)
- Nivel de contaminación
- Presencia de minas cercanas
- Densidad poblacional
- Tipo de suelo
- Uso de suelo
"""

def search_water_bodies(query, region=None, contamination_level=None, has_mines=None):
    """Busca cuerpos de agua según criterios"""
    if water_data is None:
        return "No hay datos disponibles."
    
    df = water_data.copy()
    
    # Manejar columna Region con BOM
    region_col = 'Region' if 'Region' in df.columns else 'ï»¿Region'
    
    # Filtrar por región
    if region:
        df = df[df[region_col].str.contains(region, case=False, na=False)]
    
    # Filtrar por contaminación
    if contamination_level is not None:
        df = df[df['Contaminación'].astype(str) == str(contamination_level)]
    
    # Filtrar por minas
    if has_mines is not None:
        df = df[df['Minas Cerca?'].astype(str) == ('1' if has_mines else '0')]
    
    if len(df) == 0:
        return "No se encontraron cuerpos de agua con esos criterios."
    
    # Retornar resumen
    result = f"Se encontraron {len(df)} cuerpos de agua:\n\n"
    for idx, row in df.head(10).iterrows():
        result += f"- {row['Nombre']} ({row['Tipo']}) en {row[region_col]}\n"
        if str(row.get('Contaminación', '')) in ['1', '2']:
            result += f"  Contaminación: Nivel {row['Contaminación']}\n"
        if str(row.get('Minas Cerca?', '')) == '1':
            result += f"  Minas cercanas: {row.get('Cantidad', 'No especificado')}\n"
    
    if len(df) > 10:
        result += f"\n... y {len(df) - 10} más."
    
    return result

def get_region_stats(region):
    """Obtiene estadísticas de una región específica"""
    if water_data is None:
        return "No hay datos disponibles."
    
    region_col = 'Region' if 'Region' in water_data.columns else 'ï»¿Region'
    df = water_data[water_data[region_col].str.contains(region, case=False, na=False)]
    
    if len(df) == 0:
        return f"No se encontraron datos para la región {region}."
    
    total = len(df)
    contaminated = len(df[df['Contaminación'].astype(str) == '1'])
    very_contaminated = len(df[df['Contaminación'].astype(str) == '2'])
    with_mines = len(df[df['Minas Cerca?'].astype(str) == '1'])
    
    return f"""
Estadísticas de {region}:
- Total de cuerpos de agua: {total}
- Contaminados (nivel 1): {contaminated}
- Muy contaminados (nivel 2): {very_contaminated}
- Con minas cercanas: {with_mines}
- Porcentaje con algún nivel de contaminación: {((contaminated + very_contaminated) / total * 100):.1f}%
"""

# Sistema de mensajes para el contexto
SYSTEM_MESSAGE = """Eres DOT, un asistente virtual experto en cuerpos de agua del Perú y su contaminación relacionada con la actividad minera.

Tu propósito es ayudar a los usuarios a:
1. Consultar información sobre cuerpos de agua específicos
2. Analizar niveles de contaminación
3. Identificar áreas con actividad minera cercana
4. Proporcionar estadísticas regionales
5. Responder preguntas sobre la calidad del agua en Perú

Tienes acceso a una base de datos completa con información sobre:
- Ubicación geográfica de cada cuerpo de agua
- Niveles de contaminación (0: sin contaminación, 1: contaminado, 2: muy contaminado)
- Presencia de minas cercanas
- Tipo de cuerpo de agua (río, quebrada, lago, etc.)
- Densidad poblacional del área
- Tipo y uso de suelo

Responde de manera clara, concisa y profesional. Cuando proporciones datos específicos, cita la fuente (base de datos de cuerpos de agua del Perú).

Si el usuario pregunta sobre algo que no está en tu base de datos, indícalo claramente y ofrece ayuda con la información que sí tienes disponible.
"""

@cl.on_chat_start
async def start():
    """Se ejecuta cuando inicia una nueva conversación"""
    await cl.Message(
        content="""¡Hola! 👋 Soy **DOT**, tu asistente para consultar información sobre los cuerpos de agua del Perú.

Puedo ayudarte con:
- 🗺️ Información sobre cuerpos de agua específicos
- 🏭 Análisis de contaminación y actividad minera
- 📊 Estadísticas regionales
- 🔍 Búsquedas por región, tipo o nivel de contaminación

¿En qué puedo ayudarte hoy?"""
    ).send()
    
    # Inicializar el historial de mensajes en la sesión del usuario
    cl.user_session.set("messages", [
        {"role": "system", "content": SYSTEM_MESSAGE},
        {"role": "system", "content": get_data_summary()}
    ])

@cl.on_message
async def main(message: cl.Message):
    """Maneja los mensajes del usuario"""
    
    # Obtener historial de mensajes
    messages = cl.user_session.get("messages")
    
    # Analizar si el usuario está buscando información específica
    user_content = message.content.lower()
    
    # Agregar contexto adicional si es necesario
    additional_context = ""
    
    # Manejar columna Region con BOM
    region_col = 'Region' if 'Region' in water_data.columns else 'ï»¿Region'
    
    if any(word in user_content for word in ["región", "region", "departamento"]):
        # Extraer nombre de región (simplificado)
        for region in water_data[region_col].unique():
            if region.lower() in user_content:
                additional_context = get_region_stats(region)
                break
    
    if any(word in user_content for word in ["contaminado", "contaminación", "contamination"]):
        if "muy" in user_content or "nivel 2" in user_content:
            additional_context += "\n\n" + search_water_bodies("", contamination_level=2)
        elif "nivel 1" in user_content:
            additional_context += "\n\n" + search_water_bodies("", contamination_level=1)
    
    if any(word in user_content for word in ["mina", "minería", "minera", "mining"]):
        additional_context += "\n\n" + search_water_bodies("", has_mines=True)
    
    # Agregar mensaje del usuario
    user_message = message.content
    if additional_context:
        user_message += f"\n\nContexto adicional de la base de datos:\n{additional_context}"
    
    messages.append({"role": "user", "content": user_message})
    
    # Crear mensaje de respuesta con streaming
    msg = cl.Message(content="")
    await msg.send()
    
    # Llamar a OpenAI API con streaming
    try:
        stream = await client.chat.completions.create(
            model="gpt-4o-mini",
            messages=messages,
            stream=True,
            temperature=0.7,
            max_tokens=1000
        )
        
        full_response = ""
        async for part in stream:
            if part.choices[0].delta.content:
                token = part.choices[0].delta.content
                full_response += token
                await msg.stream_token(token)
        
        # Actualizar historial
        messages.append({"role": "assistant", "content": full_response})
        cl.user_session.set("messages", messages)
        
        await msg.update()
        
    except Exception as e:
        await msg.update()
        await cl.Message(
            content=f"Error al procesar tu mensaje: {str(e)}\n\nVerifica que tu API key de OpenAI esté configurada correctamente en el archivo .env"
        ).send()

@cl.on_chat_end
async def end():
    """Se ejecuta cuando termina la conversación"""
    print("Conversación finalizada")'''


import chainlit as cl
import pandas as pd
from pathlib import Path

# =========================
# CARGA DE DATOS
# =========================

BASE_DIR = Path(__file__).resolve().parent.parent
CSV_PATH = BASE_DIR / "water_project" / "data" / "data.csv"

water_data = None


def load_water_data():
    global water_data
    try:
        water_data = pd.read_csv(CSV_PATH)
        print(f"Datos cargados: {len(water_data)} registros")
    except Exception as e:
        print(f"Error al cargar CSV: {e}")


load_water_data()


def region_column(df):
    return "Region" if "Region" in df.columns else "ï»¿Region"


# =========================
# FUNCIONES DE CONSULTA
# =========================

def data_summary():
    total = len(water_data)
    contaminated = len(water_data[water_data["Contaminación"].astype(str) == "1"])
    very_contaminated = len(water_data[water_data["Contaminación"].astype(str) == "2"])
    with_mines = len(water_data[water_data["Minas Cerca?"].astype(str) == "1"])

    regions = water_data[region_column(water_data)].unique()

    return (
        f"**Base de Datos de Cuerpos de Agua del Perú**\n\n"
        f"- Total: {total}\n"
        f"- Contaminados (nivel 1): {contaminated}\n"
        f"- Muy contaminados (nivel 2): {very_contaminated}\n"
        f"- Con minas cercanas: {with_mines}\n"
        f"- Regiones cubiertas: {len(regions)}\n"
    )


def region_stats(region):
    col = region_column(water_data)
    df = water_data[water_data[col].str.contains(region, case=False, na=False)]

    if df.empty:
        return f"No se encontraron datos para la región **{region}**."

    total = len(df)
    contaminated = len(df[df["Contaminación"].astype(str) == "1"])
    very_contaminated = len(df[df["Contaminación"].astype(str) == "2"])
    with_mines = len(df[df["Minas Cerca?"].astype(str) == "1"])

    return (
        f"📍 **Región: {region}**\n\n"
        f"- Total de cuerpos de agua: {total}\n"
        f"- Contaminados (nivel 1): {contaminated}\n"
        f"- Muy contaminados (nivel 2): {very_contaminated}\n"
        f"- Con minas cercanas: {with_mines}\n"
        f"- % con contaminación: {((contaminated + very_contaminated)/total)*100:.1f}%"
    )


def list_water_bodies(df, title):
    if df.empty:
        return "No se encontraron registros."

    msg = f"🔍 **{title}**\n\n"
    for _, row in df.head(10).iterrows():
        msg += f"- **{row['Nombre']}** ({row['Tipo']}) – {row[region_column(df)]}\n"

    if len(df) > 10:
        msg += f"\n… y {len(df) - 10} más."

    return msg


# =========================
# CHAINLIT
# =========================

@cl.on_chat_start
async def start():
    await cl.Message(
        content=(
            "👋 Hola, soy **DOT**.\n\n"
            "Trabajo **solo con la base de datos local** de cuerpos de agua del Perú.\n\n"
            "Puedes preguntar:\n"
            "- 📊 Resumen general\n"
            "- 📍 Estadísticas por región (ej. *Cusco*)\n"
            "- 🏭 Cuerpos con minas cercanas\n"
            "- ⚠️ Cuerpos contaminados\n"
        )
    ).send()


@cl.on_message
async def main(message: cl.Message):
    user = message.content.lower()
    col = region_column(water_data)

    # Resumen general
    if any(k in user for k in ["resumen", "general", "base de datos"]):
        await cl.Message(content=data_summary()).send()
        return

    # Región
    for region in water_data[col].unique():
        if region.lower() in user:
            await cl.Message(content=region_stats(region)).send()
            return

    # Contaminados
    if "muy contaminado" in user or "nivel 2" in user:
        df = water_data[water_data["Contaminación"].astype(str) == "2"]
        await cl.Message(content=list_water_bodies(df, "Cuerpos muy contaminados")).send()
        return

    if "contaminado" in user:
        df = water_data[water_data["Contaminación"].astype(str) == "1"]
        await cl.Message(content=list_water_bodies(df, "Cuerpos contaminados")).send()
        return

    # Minas
    if any(k in user for k in ["mina", "minería", "minas"]):
        df = water_data[water_data["Minas Cerca?"].astype(str) == "1"]
        await cl.Message(content=list_water_bodies(df, "Cuerpos con minas cercanas")).send()
        return

    # Fallback
    await cl.Message(
        content="🤔 No entendí la consulta. Intenta con una región, *contaminados*, *minas* o *resumen*."
    ).send()


@cl.on_chat_end
async def end():
    print("Conversación finalizada")
