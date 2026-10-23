-- Core\Config.lua - Config DB Naerzone 30300 - AICAD-GIA-WoTLK v1.0 - Safe

AICAD_GIA = AICAD_GIA or {}

AICAD_GIA.DefaultDB = {
  mapBase = 3, -- 1=Original Personal, 2=GatherMate2, 3=WEB Altertime .TGA
  useNodeLists = true,
  useNodeSight = true,
  routeMode = "GOLD", -- GOLD | LEVELING_1_450
  useRouterAI = true,
  useTomTom = false, -- auxiliar opcional
  useGatherMate = false, -- auxiliar opcional
  useSkadaMedia = true,
  useMiniMapHD = true,
  debug = false,
}

AICAD_GIA.DefaultCharDB = {
  personalRoutes = {},
  lastZone = nil,
}

function AICAD_GIA:InitDB()
  if not AICAD_GIA_DB then AICAD_GIA_DB = {} end
  for k, v in pairs(self.DefaultDB) do
    if AICAD_GIA_DB[k] == nil then AICAD_GIA_DB[k] = v end
  end
  if not AICAD_GIA_CHAR_DB then AICAD_GIA_CHAR_DB = {} end
  for k, v in pairs(self.DefaultCharDB) do
    if AICAD_GIA_CHAR_DB[k] == nil then AICAD_GIA_CHAR_DB[k] = v end
  end
end

function AICAD_GIA:GetMapBase() return AICAD_GIA_DB.mapBase or 3 end
function AICAD_GIA:GetRouteMode() return AICAD_GIA_DB.routeMode or "GOLD" end

function AICAD_GIA:SetMapBase(base)
  if base == 1 or base == 2 or base == 3 then
    AICAD_GIA_DB.mapBase = base
    print("|cffffcc00[AICAD GIA] Base: "..base.."|r")
    if self.WorldMap then self.WorldMap:RefreshMap() end
  end
end

local f = CreateFrame("Frame")
f:RegisterEvent("ADDON_LOADED")
f:SetScript("OnEvent", function(self, event, addon)
  if addon == "AICAD_GIA" then
    AICAD_GIA:InitDB()
    self:UnregisterEvent("ADDON_LOADED")
  end
end)
