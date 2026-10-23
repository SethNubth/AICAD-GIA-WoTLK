Aquí tienes GOD el `README.md` final completo para `AICAD-GIA-WoTLK`.

Cópialo tal cual:
AICAD-GIA-WoTLK - v1.0 Forever - Naerzone 3.3.5a (30300)

> **AICAD GIA - Gather Information Addon**
> Addon Standalone para Naerzone - Rutas Minería / Herboristería 1-450 + Router AI + NodeSight HD

![Version](https://img.shields.io/badge/Version-1.0%20💵%20Naerzone-ffff00)
![Interface](https://img.shields.io/badge/Interface-30300%20WotLK-0078D4)
![Server](https://img.shields.io/badge/Server-Naerzone%20EsMX%2FptBR-red)

🗺️ Que se está usando

1. Map de Blizzard (Base)
- **WorldMapDetailFrame** - Frame original de Blizzard WotLK 3.3.5a para dibujar rutas
- **Minimap** - MinimapFrame Blizzard para nodos HD + glow
- **WorldMapButton + Detail Tiles** - Texturas base del mapa de Blizzard (no se reemplazan)
- **Overlay propio** - `Media\Maps\*_1024.tga` encima del mapa Blizzard con SetTexture OVERLAY (0.85 alpha)

2. Librerías (Embebidas opcionales)
Libs\
├── LibStub - Cargador de librerías (required para LibSharedMedia)
└── LibSharedMedia-3.0 - Registro de texturas HD Skada Media
- **Sin dependencia Ace3** - Carga ligero en Naerzone
- Si no están, el addon carga igual en modo Standalone

3. Auxiliares (Si se desea usar - Opcionales)
| Auxiliar | Versión Naerzone | Función en AICAD GIA |
|----------|------------------|----------------------|
| **TomTom** | TomTom-r240-30300 (Cladhaire) | Auxiliar para waypoints flecha + /way. Si está OFF, RouterAI dibuja línea amarilla propia |
| **GatherMate2** | GatherMate2-30300 + GatherMate2_Data | Base de datos auxiliar para importar nodos. Se lee GatherMate2DB |
| **SharedMedia / Skada** | Skada Media | Fuente de texturas HD para iconos Herboristería / Minería |

> **IMPORTANTE:** AICAD-GIA-WoTLK es **STANDALONE** - No necesitas TomTom ni GatherMate2 para funcionar.

📦 Estructura - Infraestructura Final

AICAD-GIA-WoTLK\
├── AICAD_GIA.toc
├── Core\
│ ├── http://Main.lua - Init + Slash /aicad
│ ├── http://Config.lua - DB toggles useTomTom/useGatherMate/useNodeLists
│ ├── http://Locale.lua - esMX, ptBR, enUS Naerzone
│ └── http://Media.lua - Registro Skada Media 1024x1024
├── Data\
│ ├── http://NodeLists.lua - Listas Curse NodeSight HERB_ICONS/ORE_ICONS + menú activar/desactivar
│ ├── http://Zones.lua - IDs zonas: TundraBoreal=486, Sholazar= etc
│ └── http://Routes.lua - AI Max Factible 2 modos: Saronita/Titanio vs 1-450 formato TomTom r240 x,y 0-100
├── Modules\
│ ├── http://RouterAI.lua - DrawYellowRoute sobre map Blizzard, si TomTom ON → AddZWaypoint auxiliar
│ ├── http://NodeSight.lua - ShowNode/Clear toggleable
│ ├── http://Mineria.lua - Filtros 1-450 cobre → titanio
│ └── http://Herboristeria.lua - Filtros 1-450 Silverleaf → Lirio
├── UI\
│ ├── http://WorldMap.lua - 3 Bases: 1=Original Personal / 2=GatherMate / 3=WEB http://Altertime.TGA
│ ├── http://MiniMap.lua - Nodos HD + glow Skada en Minimap Blizzard
│ └── http://OptionsPanel.lua - ESC → Interface → AICAD GIA toggles
├── Media\ - Texturas WEB Altertime
│ ├── Herb\ - Herb_Silverleaf_HD.tga etc http://1024x1024.TGA alpha
│ ├── Ore\ - Ore_Saronite_HD.tga etc
│ ├── Maps\ - TundraBoreal_1024.tga, Sholazar_1024.tga, Altertime_Overlay_1024.tga
│ └── UI\ - Router_Yellow_Line.tga, Minimap_Glow.tga, NodeSight_Circle.tga
└── Libs\
    ├── LibStub\
    └── LibSharedMedia-3.0\[Oro][Leveling]

⚙️ Instalación Naerzone 3.3.5a

1. Descarga http://AICAD-GIA-WoTLK-v1.0-Forever-Naerzone-30300.zip
2. Extrae a Interface\AddOns\AICAD_GIA\
3. WoW Naerzone → AddOns → Activa AICAD GIA v1.0 Forever
4. Entra al juego

🎮 Comandos y Configuración

Slash Commands
- `/aicad` - Info + Panel
- `/aicadbase personal | gathermate | web` - Cambia base WorldMap
- `/aicad route gold` - Modo ORO (farmeo Saronita/Titanio)
- `/aicad route leveling` - Modo LEVELING 1-450 (subir profesión)
- `/aicad save` - Guarda ruta personal (Base Original Personal)

Panel Configuración
`ESC → Interface → AddOns → AICAD GIA`

- **WorldMap Base:** Dropdown 1=Original Personal / 2=GatherMate / 3=WEB Altertime .TGA
- **NodeSight:** ON/OFF
- **NodeLists:** Activar/Desactivar hierbas/vetas por lista Curse
- **RouterAI:** ON/OFF línea amarilla
- **RouteMode:** GOLD (Oro) vs LEVELING 1-450
- **TomTom:** ON/OFF auxiliar (si lo tienes)
- **GatherMate2:** ON/OFF auxiliar
- **Skada Media HD:** ON/OFF

🔧 WorldMap - 3 Bases Explicadas

| Base | Origen | Archivo | Uso |
|------|--------|---------|-----|
| **1. Original Personal** | Tus rutas guardadas | `AICAD_GIA_CHAR_DB.personalRoutes` | `/aicad save` guarda tus nodos actuales |
| **2. GatherMate2** | DB GatherMate2 | `GatherMate2DB` + `GatherMate2_Data` | Si tienes GatherMate2 instalado, importa sus nodos |
| **3. WEB Altertime** | WEB + .TGA 1024 | `Media\Maps\*_1024.tga` + `Data\Routes.lua` | Default - Texturas HD Altertime + rutas AI |

🚀 Modos Router AI

- **GOLD:** Ruta más rentable - Prioriza Saronita Rico, Titanio, Lirios de Tundra. Para nivel 80 farmeo oro Naerzone
- **LEVELING 1-450:** Ruta progresiva - Cobre 1-75 → Plata 75-125 → Saronita 400-450 etc. Para subir profesión

Formato: `x, y 0-100` compatible TomTom r240 Naerzone

📋 Requisitos

- **WoW:** 3.3.5a (12340) - Interface 30300 - Naerzone
- **Opcional:** TomTom-r240-30300, GatherMate2-30300, SharedMedia
- **Standalone:** Funciona sin ningún auxiliar

🏷️ Tags

`wow` `wotlk` `30300` `naerzone` `addon` `gathering` `mining` `herbalism` `routes` `tomtom` `gathermate` `blizzard-map` `skada-media` `altertime` `3.3.5a`

Credits

- **Author:** AICAD - GOD - Naerzone v1.0 Forever
- **Maps:** Blizzard WorldMapDetailFrame + Altertime WEB .TGA 1024x1024
- **Lists:** Curse NodeSight NodeLists
- **Libs:** LibStub, LibSharedMedia-3.0, Skada Media
- **Auxiliares:** TomTom r240 Cladhaire, GatherMate2

---
**AICAD-GIA-WoTLK v1.0 Forever - Naerzone 3.3.5a**
¿Lo subes así GOD o le agregamos badge de GitHub Release para `AICAD-GIA-WoTLK-v1.0-Forever-Naerzone-30300.zip`?
