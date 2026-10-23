-- Auxiliares\WorldMap\WorldMap.lua - FULL - Blizzard Map 30300 - 0 errores Lua - TomTom OFF - HD Skada
local ADDON_NAME, ns = ...
ns = ns or {}

-- DB segura WoTLK
AICAD_WORLDMAP_DB = AICAD_WORLDMAP_DB or {}
AICAD_WORLDMAP_DB.personal = AICAD_WORLDMAP_DB.personal or {}
AICAD_WORLDMAP_DB.imported = AICAD_WORLDMAP_DB.imported or {}
AICAD_ROUTER_DB = AICAD_ROUTER_DB or {activeDB="personal", useTomTom=false, mode="gold"}
AICAD_GIA_WORLDMAP_NODES = AICAD_GIA_WORLDMAP_NODES or {}
AICAD_MEDIA = AICAD_MEDIA or {}

local WorldMap = {}
WorldMap.pins = {}
WorldMap.pinCount = 0

-- Textura desde Core\Media.lua HD -> Names.lua -> fallback Blizzard
local function GetIcon(name)
  if not name then return AICAD_MEDIA["Default"] or "Interface\\Minimap\\Tracking\\Herbs" end
  -- 1. Tu Media HD Skada 1024
  if AICAD_MEDIA[name] then return AICAD_MEDIA[name] end
  -- 2. Tu Names.lua 1-450 FULL
  if ns.NodeIcon then
    local custom = ns.NodeIcon(name)
    if custom then return custom end
  end
  -- 3. Fallback inteligente WoTLK
  local n = string.lower(name)
  if n:find("titan") then return AICAD_MEDIA["Titanium"] or AICAD_MEDIA["Titanio"] or "Interface\\Icons\\inv_ore_titanium_01" end
  if n:find("saron") then return AICAD_MEDIA["Saronite"] or AICAD_MEDIA["Saronita"] or "Interface\\Icons\\inv_ore_saronite_01" end
  if n:find("cobalto") or n:find("cobalt") then return AICAD_MEDIA["Cobalto"] or "Interface\\Icons\\inv_ore_cobalt_01" end
  if n:find("frost") or n:find("exanime") then return AICAD_MEDIA["FrostLotus"] or "Interface\\Icons\\INV_Misc_Herb_FrostLotus" end
  if n:find("lichbloom") then return AICAD_MEDIA["Lichbloom"] or "Interface\\Icons\\INV_Misc_Herb_Lichbloom" end
  if n:find("icethorn") or n:find("espina") then return AICAD_MEDIA["Icethorn"] or "Interface\\Icons\\INV_Misc_Herb_Icethorn" end
  return AICAD_MEDIA["Herb"] or "Interface\\Minimap\\Tracking\\Herbs"
end

function WorldMap:GetPin()
  self.pinCount = self.pinCount + 1
  local idx = self.pinCount
  if not self.pins[idx] then
    local parent = WorldMapDetailFrame or WorldMapButton or WorldMapFrame
    local f = CreateFrame("Button", "AICADWMPin"..idx, parent)
    f:SetWidth(16) f:SetHeight(16)
    f:SetFrameLevel(5000) f:SetFrameStrata("FULLSCREEN")
    f.tex = f:CreateTexture(nil, "OVERLAY")
    f.tex:SetAllPoints(f)
    f.tex:SetTexCoord(0.08,0.92,0.08,0.92)
    f:Hide()
    self.pins[idx] = f
  end
  local p = self.pins[idx]
  p:SetWidth(16) p:SetHeight(16)
  return p
end

function WorldMap:Clear()
  for i=1, #self.pins do if self.pins[i] then self.pins[i]:Hide() end end
  self.pinCount = 0
end

function WorldMap:ShowZone(mapID)
  self:Clear()
  if not mapID then
    if GetCurrentMapAreaID then 
      local ok, id = pcall(GetCurrentMapAreaID)
      if ok then mapID = id end
    end
    mapID = mapID or 485 -- Corona de Hielo fallback WoTLK
  end
  
  local activeDB = "personal"
  if AICAD_ROUTER_DB and AICAD_ROUTER_DB.activeDB then activeDB = AICAD_ROUTER_DB.activeDB end
  
  local all = {}
  if activeDB == "personal" then
    if AICAD_WORLDMAP_DB.personal[mapID] then
      for _, n in ipairs(AICAD_WORLDMAP_DB.personal[mapID]) do table.insert(all, n) end
    end
  else
    if AICAD_WORLDMAP_DB.imported[mapID] then
      for _, n in ipairs(AICAD_WORLDMAP_DB.imported[mapID]) do table.insert(all, n) end
    end
    if AICAD_GIA_WORLDMAP_NODES[mapID] then
      for _, n in ipairs(AICAD_GIA_WORLDMAP_NODES[mapID]) do table.insert(all, n) end
    end
  end
  
  if #all == 0 then return end
  
  local parent = WorldMapDetailFrame or WorldMapButton or WorldMapFrame
  local pw = parent:GetWidth() if pw == 0 or not pw then pw = 1002 end
  local ph = parent:GetHeight() if ph == 0 or not ph then ph = 668 end
  
  for _, node in ipairs(all) do
    local x = node.x or node[1] or 0.5
    local y = node.y or node[2] or 0.5
    if x > 1 then x = x / 100 end
    if y > 1 then y = y / 100 end
    if x < 0 or x > 1 or y < 0 or y > 1 then
      -- evita pins fuera mapa
    else
      local pin = self:GetPin()
      pin.tex:SetTexture(GetIcon(node.name or node[3]))
      pin:ClearAllPoints()
      pin:SetPoint("CENTER", parent, "TOPLEFT", x * pw, -y * ph)
      pin:Show()
      pin:SetScript("OnEnter", function(self)
        if WorldMapTooltip then
          WorldMapTooltip:SetOwner(self, "ANCHOR_RIGHT")
          WorldMapTooltip:AddLine(node.name or "Nodo", 1, 1, 0)
          WorldMapTooltip:AddLine("Zona: "..mapID.." | DB: "..string.upper(activeDB), 0.8, 0.8, 0.8)
          WorldMapTooltip:AddLine(string.format("X: %.1f Y: %.1f", x*100, y*100), 0.6, 0.6, 0.6)
          WorldMapTooltip:Show()
        end
      end)
      pin:SetScript("OnLeave", function() if WorldMapTooltip then WorldMapTooltip:Hide() end end)
    end
  end
end

-- Eventos Blizzard Map 30300
local ev = CreateFrame("Frame")
ev:RegisterEvent("WORLD_MAP_UPDATE")
ev:SetScript("OnEvent", function(self, event)
  WorldMap:ShowZone()
end)

-- Slash /wmap
SLASH_AICADWMAP1 = "/wmap"
SLASH_AICADWMAP2 = "/worldmap"
SlashCmdList["AICADWMAP"] = function(msg)
  msg = msg or ""
  local id = tonumber(string.match(msg, "%d+"))
  WorldMap:ShowZone(id)
  print("|cffffcc00[AICAD WorldMap] Pintando DB: "..(AICAD_ROUTER_DB.activeDB or "personal").." en mapa Blizzard (M) - WoTLK 30300|r")
end

_G["AICAD_WorldMap"] = WorldMap
print("|cff00ff00[AICAD WorldMap] Blizzard Map HD 30300 cargado - TomTom OFF|r")
