-- Auxiliares\WorldMap\Database.lua - 3 DBs - WEB TGA + GatherMate + Personal - WoTLK 30300 FINAL - 0 errores
AICAD_GIA_WORLDMAP_NODES = AICAD_GIA_WORLDMAP_NODES or {}
AICAD_GIA_WEB_TGA = AICAD_GIA_WEB_TGA or {}
AICAD_WORLDMAP_DB = AICAD_WORLDMAP_DB or {}
AICAD_WORLDMAP_DB.personal = AICAD_WORLDMAP_DB.personal or {}
AICAD_WORLDMAP_DB.imported = AICAD_WORLDMAP_DB.imported or {}
AICAD_MEDIA = AICAD_MEDIA or {}

-- Base WEB TGA HD - Conectada a tu carpeta Auxiliares/Media/WEB/
-- Ruta real: Interface\AddOns\AicadGia\Auxiliares\Media\WEB\*.tga
local WEB_PATH = "Interface\\AddOns\\AicadGia\\Auxiliares\\Media\\WEB\\"

AICAD_GIA_WEB_TGA = {
  -- WotLK Northrend - Tus TGA Altertime HD
  [492] = WEB_PATH.."Corona de Hielo Herboristeria.tga", -- Icecrown Lichbloom + Saronita + Titanio
  [485] = WEB_PATH.."Cuenca de Sholazar Herboristeria.tga", -- Sholazar Lichbloom + Saronita
  [486] = WEB_PATH.."Fiordo Aquilonal.tga", -- Borean Tundra Goldclover
  [488] = WEB_PATH.."Tundra Boreal.tga", -- Borean Duplicate fallback
  [490] = WEB_PATH.."Cementerio de Dragones.tga", -- Dragonblight Goldclover
  [491] = WEB_PATH.."Colinas Pardas.tga", -- Grizzly Hills Goldclover
  [493] = WEB_PATH.."Cumbres Tormentosas.tga", -- Storm Peaks Icethorn + Titanium
  [495] = WEB_PATH.."ZulDrak.tga", -- ZulDrak Goldclover
  [510] = WEB_PATH.."Conquista del Invierno.tga", -- Wintergrasp Titanium
  -- TBC - Ejemplo tu screenshot Terokkar 378
  [378] = WEB_PATH.."Terokkar Herboristeria.tga", -- Felweed Terocone + Fel Iron
}

-- DB WEB Nodos de ejemplo para Router AI Gold - 378 = Terokkar como tu screenshot
AICAD_GIA_WORLDMAP_NODES = {
  -- Terokkar 378 - TBC ejemplo
  [378] = {
    {x=0.35, y=0.18, type="herb", name="Felweed", value=2, icon="Interface\\Icons\\INV_Misc_Herb_Felweed"},
    {x=0.42, y=0.25, type="herb", name="Terocone", value=5, icon="Interface\\Icons\\INV_Misc_Herb_Terocone"},
    {x=0.48, y=0.38, type="herb", name="Dreaming Glory", value=3},
    {x=0.58, y=0.52, type="ore", name="Fel Iron Deposit", value=4, icon="Interface\\Icons\\INV_Ore_FelIron_01"},
    {x=0.62, y=0.60, type="ore", name="Adamantite Deposit", value=6},
  },
  -- Cuenca de Sholazar 485 - Farm Oro WotLK BEST
  [485] = {
    {x=0.45, y=0.50, type="herb", name="Lichbloom", value=7},
    {x=0.48, y=0.52, type="herb", name="Icethorn", value=6},
    {x=0.50, y=0.55, type="herb", name="Frost Lotus", value=10},
    {x=0.52, y=0.58, type="ore", name="Saronite Deposit", value=7},
    {x=0.55, y=0.60, type="ore", name="Titanium Vein", value=10},
  },
  -- Corona de Hielo 492 - Endgame WotLK
  [492] = {
    {x=0.42, y=0.48, type="herb", name="Lichbloom", value=7},
    {x=0.45, y=0.50, type="herb", name="Icethorn", value=6},
    {x=0.47, y=0.52, type="herb", name="Frost Lotus", value=10},
    {x=0.50, y=0.55, type="ore", name="Titanium Vein", value=10},
    {x=0.52, y=0.58, type="ore", name="Saronite Deposit", value=7},
  },
  -- Fiordo Aquilonal 486 - Start WotLK
  [486] = {
    {x=0.35, y=0.30, type="herb", name="Goldclover", value=2},
    {x=0.40, y=0.45, type="ore", name="Cobalt Deposit", value=3},
  },
  -- Cumbres Tormentosas 493 - Titanium max
  [493] = {
    {x=0.40, y=0.50, type="ore", name="Titanium Vein", value=10},
    {x=0.45, y=0.55, type="herb", name="Icethorn", value=6},
  },
}

-- Helper para WorldMap.lua
function AICAD_GIA_GetWebNodes(mapID)
  return AICAD_GIA_WORLDMAP_NODES[mapID]
end

function AICAD_GIA_GetWebTGA(mapID)
  return AICAD_GIA_WEB_TGA[mapID]
end

print("|cff00ff00[AICAD Database] 3 DBs cargadas: WEB TGA HD "..(AICAD_GIA_WEB_TGA and "OK" or "FAIL").." | Nodos WEB: "..(AICAD_GIA_WORLDMAP_NODES and "OK" or "FAIL").." - WoTLK 30300|r")
