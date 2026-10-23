-- Auxiliares\WorldMap\WorldMap.lua - FULL - Blizzard Map 30300 - 0 errores Lua - TomTom OFF
local ADDON_NAME = "AicadGia"

-- DB segura
AICAD_WORLDMAP_DB = AICAD_WORLDMAP_DB or {}
AICAD_WORLDMAP_DB.personal = AICAD_WORLDMAP_DB.personal or {}
AICAD_WORLDMAP_DB.imported = AICAD_WORLDMAP_DB.imported or {}
AICAD_ROUTER_DB = AICAD_ROUTER_DB or {activeDB="personal", useTomTom=false, mode="gold"}
AICAD_GIA_WORLDMAP_NODES = AICAD_GIA_WORLDMAP_NODES or {}

local WorldMap = {}
WorldMap.pins = {}
WorldMap.pinCount = 0

-- Textura desde Core\Media.lua o fallback Blizzard
local function GetIcon(name)
  if name and AICAD_MEDIA and AICAD_MEDIA[name] then
    return AICAD_MEDIA[name]
  end
  local n = string.lower(name or "")
  if n:find("frost") or n:find("exanime") then
    return "Interface\\Icons\\INV_Misc_Herb_FrostLotus"
  elseif n:find("lichbloom") or n:find("flor") then
    return "Interface\\Icons\\INV_Misc_Herb_Lichbloom"
  elseif n:find("titanium") or n:find("titanio") then
    return "Interface\\Icons\\inv_ore_titanium_01"
  elseif n:find("saronite") or n:find("saronita") then
    return "Interface\\Icons\\inv_ore_saronite_01"
  end
  return "Interface\\Minimap\\Tracking\\Herbs"
end

function WorldMap:GetPin()
  self.pinCount = self.pinCount + 1
  local idx = self.pinCount
  if not self.pins[idx] then
    local parent = WorldMapDetailFrame or WorldMapButton or WorldMapFrame
    local f = CreateFrame("Button", "AICADWMPin"..idx, parent)
    f:SetWidth(16)
    f:SetHeight(16)
    f:SetFrameLevel(5000)
    f:SetFrameStrata("FULLSCREEN")
    f.tex = f:CreateTexture(nil, "OVERLAY")
    f.tex:SetAllPoints(f)
    f:Hide()
    self.pins[idx] = f
  end
  return self.pins[idx]
end

function WorldMap:Clear()
  for i=1, #self.pins do
    if self.pins[i] then self.pins[i]:Hide() end
  end
  self.pinCount = 0
end

function WorldMap:ShowZone(mapID)
  self:Clear()
  
  -- MapID seguro 30300
  if not mapID then
    if GetCurrentMapAreaID then
      mapID = GetCurrentMapAreaID()
    else
      mapID = 485 -- Corona Hielo fallback
    end
  end
  
  local activeDB = "personal"
  if AICAD_ROUTER_DB and AICAD_ROUTER_DB.activeDB then
    activeDB = AICAD_ROUTER_DB.activeDB
  end
  
  local all = {}
  
  if activeDB == "personal" then
    if AICAD_WORLDMAP_DB.personal[mapID] then
      for _, n in ipairs(AICAD_WORLDMAP_DB.personal[mapID]) do
        table.insert(all, n)
      end
    end
  else
    if AICAD_WORLDMAP_DB.imported[mapID] then
      for _, n in ipairs(AICAD_WORLDMAP_DB.imported[mapID]) do
        table.insert(all, n)
      end
    end
    if AICAD_GIA_WORLDMAP_NODES[mapID] then
      for _, n in ipairs(AICAD_GIA_WORLDMAP_NODES[mapID]) do
        table.insert(all, n)
      end
    end
  end
  
  if #all == 0 then return end
  
  local parent = WorldMapDetailFrame or WorldMapButton or WorldMapFrame
  local pw = parent:GetWidth()
  local ph = parent:GetHeight()
  if pw == 0 then pw = 1002 end
  if ph == 0 then ph = 668 end
  
  for _, node in ipairs(all) do
    local x = node.x or node[1] or 0.5
    local y = node.y or node[2] or 0.5
    if x > 1 then x = x / 100 end
    if y > 1 then y = y / 100 end
    
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
    pin:SetScript("OnLeave", function()
      if WorldMapTooltip then WorldMapTooltip:Hide() end
    end)
  end
end

-- Eventos Blizzard Map
local ev = CreateFrame("Frame")
ev:RegisterEvent("WORLD_MAP_UPDATE")
ev:RegisterEvent("WORLD_MAP_CHANGED")
ev:SetScript("OnEvent", function(self, event)
  WorldMap:ShowZone()
end)

-- Slash /wmap
SLASH_AICADWMAP1 = "/wmap"
SLASH_AICADWMAP2 = "/worldmap"
SlashCmdList["AICADWMAP"] = function(msg)
  local id = tonumber(msg)
  WorldMap:ShowZone(id)
  print("|cffffcc00[AICAD WorldMap] Pintando DB: "..(AICAD_ROUTER_DB.activeDB or "personal").." en mapa Blizzard (M)|r")
end

_G["AICAD_WorldMap"] = WorldMap
