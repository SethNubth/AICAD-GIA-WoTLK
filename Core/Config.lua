-- Core\Config.lua - Config DB Naerzone 30300 - AICAD-GIA-WoTLK v1.0 - Safe - FIX
AICAD_GIA = AICAD_GIA or {}

AICAD_GIA.DefaultDB = {
  mapBase = 3, -- 1=Personal, 2=GatherMate2, 3=WEB Altertime .TGA (futuro)
  useNodeLists = true,
  useNodeSight = true,
  routeMode = "GOLD", -- GOLD | LEVELING_1_450
  useRouterAI = true,
  useTomTom = false, -- OFF por defecto - solo Blizzard Map
  useGatherMate = false, -- OFF por defecto
  useSkadaMedia = true,
  useMiniMapHD = true,
  debug = false,
}

AICAD_GIA.DefaultCharDB = {
  personalRoutes = {},
  lastZone = nil,
}

function AICAD_GIA:InitDB()
  if not _G["AICAD_GIA_DB"] then _G["AICAD_GIA_DB"] = {} end
  if not _G["AICAD_GIA_CHAR_DB"] then _G["AICAD_GIA_CHAR_DB"] = {} end
  -- Compat con tu WorldMap/Router que usan otros nombres
  if not _G["AICAD_WORLDMAP_DB"] then _G["AICAD_WORLDMAP_DB"] = {personal={}, imported={}} end
  if not _G["AICAD_ROUTER_DB"] then _G["AICAD_ROUTER_DB"] = {activeDB="personal", useTomTom=false, mode="gold"} end
  if not _G["NodeSightDB"] then _G["NodeSightDB"] = {enabled=true, iconSize=18} end

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

function AICAD_GIA:GetMapBase() 
  return (_G["AICAD_GIA_DB"] and _G["AICAD_GIA_DB"].mapBase) or 3 
end

function AICAD_GIA:GetRouteMode() 
  return (_G["AICAD_GIA_DB"] and _G["AICAD_GIA_DB"].routeMode) or "GOLD" 
end

function AICAD_GIA:SetMapBase(base)
  if base == 1 or base == 2 or base == 3 then
    _G["AICAD_GIA_DB"].mapBase = base
    print("|cffffcc00[AICAD GIA] Base: "..base.." (1=Personal 2=Gathermate 3=WEB)|r")
    if self.WorldMap and self.WorldMap.RefreshMap then
      self.WorldMap:RefreshMap()
    end
  end
end

-- FIX: Tu addon se llama AicadGia en el .toc, no AICAD_GIA
local f = CreateFrame("Frame")
f:RegisterEvent("ADDON_LOADED")
f:SetScript("OnEvent", function(self, event, addon)
  local low = string.lower(addon or "")
  if low == "aicadgia" or low == "aicad_gia" or addon == "AICAD_GIA" then
    AICAD_GIA:InitDB()
    if AICAD_GIA_DB.debug then
      print("|cffffcc00[AICAD GIA] DB Init OK - mapBase="..AICAD_GIA:GetMapBase().." routeMode="..AICAD_GIA:GetRouteMode().."|r")
    end
    self:UnregisterEvent("ADDON_LOADED")
  end
end)
