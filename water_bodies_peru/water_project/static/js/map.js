// Variables globales
let map;
let allMarkers = [];
let contaminationFilters = {0: true, 1: true, 2: true};
let mineFilters = {true: true, false: true};
let currentLayer;

const statsDiv = document.getElementById("stats");
const loadingDiv = document.getElementById("loading");
const infoPanel = document.getElementById("infoPanel");

// Definir las capas de mapa
const mapLayers = {
    street: L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
        attribution: '© OpenStreetMap contributors',
        maxZoom: 19
    }),
    satellite: L.tileLayer('https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}', {
        attribution: 'Tiles © Esri',
        maxZoom: 19
    }),
    topographic: L.tileLayer('https://{s}.tile.opentopomap.org/{z}/{x}/{y}.png', {
        attribution: 'Map data: © OpenStreetMap contributors, SRTM | Map style: © OpenTopoMap',
        maxZoom: 17
    })
};

// Inicializar mapa
initMap();

function initMap() {
    // Centrar en Perú
    map = L.map('map').setView([-9.19, -75.015], 6);

    // Capa de mapa base (por defecto: calles)
    currentLayer = mapLayers.street;
    currentLayer.addTo(map);

    // Cargar datos
    loadCSV();
}

function changeMapType(type) {
    // Remover la capa actual
    if (currentLayer) {
        map.removeLayer(currentLayer);
    }
    
    // Agregar la nueva capa
    currentLayer = mapLayers[type];
    currentLayer.addTo(map);
}

function loadCSV() {
    // Cargar el archivo CSV desde la ruta estática de Django
    const csvPath = '/static/data/data.csv';
    
    Papa.parse(csvPath, {
        download: true,
        header: true,
        skipEmptyLines: true,
        complete: function(results) {
            console.log("Datos cargados:", results.data.length, "registros");
            console.log("Campos:", results.meta.fields);
            processData(results.data);
            loadingDiv.style.display = 'none';
        },
        error: function(error) {
            console.error("Error al cargar CSV:", error);
            loadingDiv.innerHTML = "Error: No se pudo cargar el archivo data.csv";
        }
    });
}

function getMarkerColor(contamination, hasMines) {
    // Lógica de colores según especificaciones:
    // - Azul (#1E90FF): Sin contaminación, sin minas
    // - Naranja (#FF8C00): Sin contaminación, con minas
    // - Café (#8B4513): Contaminado (nivel 1), sin minas
    // - Negro (#000000): Muy contaminado (nivel 2), sin minas
    // - Rosa (#FF1493): Cualquier contaminación + minas
    
    if (contamination > 0 && hasMines) {
        return '#FF1493'; // Rosa: contaminado + minas
    }
    
    if (contamination === 2) {
        return '#000000'; // Negro: muy contaminado
    }
    
    if (contamination === 1) {
        return '#8B4513'; // Café: contaminado
    }
    
    if (hasMines) {
        return '#FF8C00'; // Naranja: minas cercanas sin contaminación
    }
    
    return '#1E90FF'; // Azul: sin problemas
}

function processData(data) {
    let stats = {
        total: 0,
        withMines: 0,
        noContamination: 0,
        contaminated: 0,
        veryContaminated: 0
    };

    data.forEach((row, index) => {
        // Extraer latitud y longitud
        let lat = parseFloat(row.lat);
        let lon = parseFloat(row.lon);

        // Validar coordenadas
        if (isNaN(lat) || isNaN(lon)) {
            return;
        }

        // Extraer datos
        let region = row.Region || '';
        let nombre = row.Nombre || 'Sin nombre';
        let tipo = row.Tipo || '';
        let densidadPoblacional = row['Densidad poblacional'] || '';
        let tipoSuelo = row['Tipo de suelo'] || '';
        let usoSuelo = row['uso de suelo'] || '';
        
        // Determinar si tiene minas cerca
        let minasCercaValue = row['Minas Cerca?'] || '';
        let hasMines = minasCercaValue.toString().trim() === '1';
        
        // Contar cantidad de minas (columna "Cantidad")
        let cantidadMinas = row.Cantidad || '';
        
        // Determinar nivel de contaminación
        let contaminacionValue = row['Contaminación'] || '';
        let contamination = 0;
        if (contaminacionValue.toString().trim() === '1') {
            contamination = 1;
        } else if (contaminacionValue.toString().trim() === '2') {
            contamination = 2;
        }
        
        // Tipo de contaminación
        let tipoContaminacion = row['Tipo de contaminación'] || '';

        // Actualizar estadísticas
        stats.total++;
        if (hasMines) stats.withMines++;
        if (contamination === 0) stats.noContamination++;
        if (contamination === 1) stats.contaminated++;
        if (contamination === 2) stats.veryContaminated++;

        // Determinar color del marcador
        let markerColor = getMarkerColor(contamination, hasMines);

        // Crear popup con información
        let popupContent = `
            <b>${nombre}</b><br>
            <b>Región:</b> ${region}<br>
            <b>Lat:</b> ${lat.toFixed(6)}<br>
            <b>Lon:</b> ${lon.toFixed(6)}<br>
            <b>Tipo:</b> ${tipo}<br>
            <b>Densidad poblacional:</b> ${densidadPoblacional}<br>
            <b>Tipo de suelo:</b> ${tipoSuelo}<br>
            <b>Uso de suelo:</b> ${usoSuelo}
        `;

        // Agregar información de minas si corresponde
        if (hasMines) {
            popupContent += `<br><b>Cantidad de minas cercanas:</b> ${cantidadMinas || 'No especificado'}`;
        }

        // Agregar información de contaminación si corresponde
        if (contamination > 0) {
            popupContent += `<br><b>Tipo de Contaminación:</b> ${tipoContaminacion || 'No especificado'}`;
        }

        // Crear marcador
        let marker = L.circleMarker([lat, lon], {
            radius: 6,
            fillColor: markerColor,
            color: '#FFFFFF',
            weight: 1.5,
            fillOpacity: 0.8
        }).bindPopup(popupContent);

        // Guardar propiedades para filtros
        marker.contamination = contamination;
        marker.hasMines = hasMines;

        // Agregar al mapa
        marker.addTo(map);
        allMarkers.push(marker);
    });

    // Mostrar estadísticas
    updateStats(stats);
}

function updateStats(stats) {
    statsDiv.innerHTML = `
        <b>Estadísticas Generales</b><br>
        Total de cuerpos: ${stats.total}<br>
        Con minas cercanas: ${stats.withMines}<br>
        <br>
        <b>Por contaminación:</b><br>
        Sin contaminación: ${stats.noContamination}<br>
        Contaminados: ${stats.contaminated}<br>
        Muy contaminados: ${stats.veryContaminated}
    `;
}

function toggleContamination(level) {
    contaminationFilters[level] = !contaminationFilters[level];
    applyFilters();
}

function toggleMines(hasMines) {
    mineFilters[hasMines] = !mineFilters[hasMines];
    applyFilters();
}

function applyFilters() {
    allMarkers.forEach(marker => {
        let show = true;

        // Filtrar por contaminación
        if (!contaminationFilters[marker.contamination]) {
            show = false;
        }

        // Filtrar por minas
        if (!mineFilters[marker.hasMines]) {
            show = false;
        }

        // Mostrar u ocultar marcador
        if (show) {
            if (!map.hasLayer(marker)) {
                marker.addTo(map);
            }
        } else {
            map.removeLayer(marker);
        }
    });
}

function togglePanel() {
    if (infoPanel.style.display === 'none') {
        infoPanel.style.display = 'block';
    } else {
        infoPanel.style.display = 'none';
    }
}
