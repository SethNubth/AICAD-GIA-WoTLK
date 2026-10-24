-- Core\Config.lua - Config DB Naerzone 30300 - v1.2 FINAL - WEB solo mostrar
AICAD_GIA = AICAD_GIA or {}

AICAD_GIA.DefaultDB = {
  mapBase = 3, -- 1=Personal, 2=GatherMate2, 3=WEB .TGA solo mostrar (Altertime) - RESPETADO
  useNodeLists = true,
  useNodeSight = true,
  routeMode = "GOLD",
  useRouterAI = true, -- Solo afecta Base 1 y 2, nunca Base 3 WEB
  useTomTom = false,
  useGatherMate = false,
  useSkadaMedia = true,
  useMiniMapHD = true,
  autoScan = true,
  scanRange = 80,
  iconSize = 16,
  debug = false,
}

AICAD_GIA.DefaultCharDB = {
  personalRoutes = {},
  lastZone = nil,
}

function AICAD_GIA:InitDB()
  if not _G["AICAD_GIA_DB"] then _G["AICAD_GIA_DB"] = {} end
  if not _G["AICAD_GIA_CHAR_DB"] then _G["AICAD_GIA_CHAR_DB"] = {} end
  if not _G["AICAD_WORLDMAP_DB"] then _G["AICAD_WORLDMAP_DB"] = {personal={}, imported={}} end
  if not _G["AICAD_ROUTER_DB"] then _G["AICAD_ROUTER_DB"] = {activeDB="personal", useTomTom=false, mode="gold"} end
  if not _G["NodeSightDB"] then _G["NodeSightDB"] = {enabled=true, iconSize=18} end
  if not _G["AICAD_GIA_WORLDMAP_NODES"] then _G["AICAD_GIA_WORLDMAP_NODES"] = {} end -- WEB solo lectura

  if not _G["AICAD_WORLDMAP_DB"].personal then _G["AICAD_WORLDMAP_DB"].personal = {} end

  for k, v in pairs(self.DefaultDB) do
    if _G["AICAD_GIA_DB"][k] == nil then
      _G["AICAD_GIA_DB"][k] = v
    end
  end
  for k, v in pairs(self.DefaultCharDB) do
    if _G["AICAD_GIA_CHAR_DB"][k] == nil then
      _G["AICAD_GIA_CHAR_DB"][k] = v
    end
  end
end

function AICAD_GIA:GetMapBase() return (_G["AICAD_GIA_DB"] and _G["AICAD_GIA_DB"].mapBase) or 3 end
function AICAD_GIA:GetRouteMode() return (_G["AICAD_GIA_DB"] and _G["AICAD_GIA_DB"].routeMode) or "GOLD" end

function AICAD_GIA:SetMapBase(base)
  if base == 1 or base == 2 or base == 3 then
    _G["AICAD_GIA_DB"].mapBase = base
    local msg = base == 1 and "Personal (Router AI escribe)" or base == 2 and "GatherMate2 (Solo lectura)" or "WEB .TGA (Solo mostrar, ayuda visual, no escribe)"
    print("|cffffcc00[AICAD GIA] Base: "..base.." - "..msg.."|r")
    if self.WorldMap and self.WorldMap.RefreshMap then self.WorldMap:RefreshMap() end
  end
end

local f = CreateFrame("Frame")
f:RegisterEvent("ADDON_LOADED")
f:SetScript("OnEvent", function(self, event, addon)
  local low = string.lower(addon or "")
  if low == "aicadgia" or low == "aicad_gia" or addon == "AICAD_GIA" then
    AICAD_GIA:InitDB()
    if AICAD_GIA_DB.debug then
      print("|cffffcc00[AICAD GIA] DB Init OK - Base WEB solo mostrar respetada|r")
    end
    self:UnregisterEvent("ADDON_LOADED")
  end
end)
