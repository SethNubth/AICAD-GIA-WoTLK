-- Auxiliares\NodeSight\NodeSight.lua - FINAL v1.4 UNIFICADO - Lee solo pasar + NodeSight - WoTLK 30300
local ADDON_NAME, ns = ...
ns = ns or {}

-- DB
NodeSightDB = NodeSightDB or {}
NodeSightDB.nodes = NodeSightDB.nodes or {}
local db = NodeSightDB
db.enabled = db.enabled == nil and true or db.enabled
db.worldIcons = db.worldIcons == nil and true or db.worldIcons
db.iconSize = db.iconSize or 16
db.shape = db.shape or 1

-- Frames pool
ns.miniFrames = ns.miniFrames or {}
ns.worldFrames = ns.worldFrames or {}
ns.miniCount = 0
ns.worldCount = 0

function ns.GetMiniFrame()
  ns.miniCount = ns.miniCount + 1
  if not ns.miniFrames[ns.miniCount] then
    local f = CreateFrame("Button", "NodeSightMini"..ns.miniCount, Minimap)
    f:SetWidth(16) f:SetHeight(16)
    f:SetFrameLevel(10)
    f.tex = f:CreateTexture(nil, "OVERLAY")
    f.tex:SetAllPoints(f)
    f.border = f:CreateTexture(nil, "OVERLAY")
    f.border:SetTexture("Interface\\Minimap\\MiniMap-TrackingBorder")
    f.border:SetAllPoints(f)
    f.border:Hide()
    f:Hide()
    ns.miniFrames[ns.miniCount] = f
  end
  return ns.miniFrames[ns.miniCount]
end

function ns.GetWorldFrame()
  ns.worldCount = ns.worldCount + 1
  if not ns.worldFrames[ns.worldCount] then
    local parent = WorldMapDetailFrame or WorldMapButton or WorldMapFrame
    local f = CreateFrame("Button", "NodeSightWorld"..ns.worldCount, parent)
    f:SetWidth(18) f:SetHeight(18)
    f:SetFrameLevel(5000) f:SetFrameStrata("FULLSCREEN")
    f.tex = f:CreateTexture(nil, "OVERLAY")
    f.tex:SetAllPoints(f)
    f:Hide()
    ns.worldFrames[ns.worldCount] = f
  end
  return ns.worldFrames[ns.worldCount]
end

function ns.ClearAll()
  for i=1, #ns.miniFrames do if ns.miniFrames[i] then ns.miniFrames[i]:Hide() end end
  for i=1, #ns.worldFrames do if ns.worldFrames[i] then ns.worldFrames[i]:Hide() end end
  ns.miniCount = 0
  ns.worldCount = 0
end

function ns.NodeIcon(name)
  if not name then return "Interface\\Icons\\INV_Misc_Herb_02" end
  if AICAD_MEDIA and AICAD_MEDIA[name] then return AICAD_MEDIA[name] end
  local n = string.lower(name)
  if n:find("titan") then return "Interface\\Icons\\inv_ore_titanium_01" end
  if n:find("saron") then return "Interface\\Icons\\inv_ore_saronite_01" end
  if n:find("cobalto") then return "Interface\\Icons\\inv_ore_cobalt_01" end
  return "Interface\\Icons\\INV_Misc_Herb_02"
end

-- DIBUJA TODO LO GUARDADO - FIX HD UNIFICADO
function ns.DrawSaved()
  if not db.enabled then return end
  ns.ClearAll()
  
  local mapID = GetCurrentMapAreaID and GetCurrentMapAreaID() or 0
  local mapName = GetRealZoneText() or GetZoneText()
  local all = {}
  
  -- 1. Tu Base 1 solo pasar - Main.lua
  if AICAD_WORLDMAP_DB and AICAD_WORLDMAP_DB.personal and AICAD_WORLDMAP_DB.personal[mapID] then
    for _, n in ipairs(AICAD_WORLDMAP_DB.personal[mapID]) do
      table.insert(all, {x=n.x, y=n.y, icon=ns.NodeIcon(n.name), name=n.name})
    end
  end
  -- 2. NodeSight viejo
  if NodeSightDB.nodes[mapName] then
    for _, node in ipairs(NodeSightDB.nodes[mapName]) do
      table.insert(all, {x=node.x, y=node.y, icon=node.icon or ns.NodeIcon(node.name), name=node.name or "Nodo"})
    end
  end
  
  if #all == 0 then return end
  
  local px, py = GetPlayerMapPosition("player")
  if px==0 and py==0 then px=0.5; py=0.5 end
  
  for _, node in ipairs(all) do
    -- MINIMAPA cerca
    local dx = (node.x - px) * 800
    local dy = (node.y - py) * 800
    if math.abs(dx)<130 and math.abs(dy)<130 then
      local f = ns.GetMiniFrame()
      f.tex:SetTexture(node.icon)
      f:ClearAllPoints()
      f:SetPoint("CENTER", Minimap, "CENTER", dx, -dy)
      if db.shape==3 then f.border:Show() else f.border:Hide() end
      f:SetWidth(db.iconSize); f:SetHeight(db.iconSize)
      f:Show()
    end
    -- WORLD MAP en M
    if WorldMapFrame and WorldMapFrame:IsVisible() and db.worldIcons then
      local parent = WorldMapDetailFrame or WorldMapButton
      if parent then
        local wf = ns.GetWorldFrame()
        wf.tex:SetTexture(node.icon)
        wf:ClearAllPoints()
        wf:SetPoint("CENTER", parent, "TOPLEFT", node.x*parent:GetWidth(), -node.y*parent:GetHeight())
        wf:SetWidth(db.iconSize+4); wf:SetHeight(db.iconSize+4)
        wf:Show()
      end
    end
  end
end

-- Eventos
local ev = CreateFrame("Frame")
ev:RegisterEvent("WORLD_MAP_UPDATE")
ev:RegisterEvent("ZONE_CHANGED_NEW_AREA")
ev:SetScript("OnEvent", function(self, event)
  if C_Timer and C_Timer.After then
    C_Timer.After(0.2, function() ns.DrawSaved() end)
  else ns.DrawSaved() end
end)

-- Loot saver (cuando picas)
local lootFrame = CreateFrame("Frame")
lootFrame:RegisterEvent("CHAT_MSG_LOOT")
lootFrame:SetScript("OnEvent", function(self, event, msg)
  if not msg then return end
  local mapID = GetCurrentMapAreaID and GetCurrentMapAreaID() or 0
  local x,y = GetPlayerMapPosition("player")
  if not x or x==0 then return end
  if msg:find("Recibes botín") or msg:find("You receive loot") then
    local zone = GetRealZoneText() or GetZoneText()
    NodeSightDB.nodes[zone] = NodeSightDB.nodes[zone] or {}
    table.insert(NodeSightDB.nodes[zone], {x=x, y=y, icon="Interface\\Icons\\INV_Misc_Herb_02", mx=true})
    if AICAD_GIA and AICAD_GIA.SavePersonalNode then
      AICAD_GIA:SavePersonalNode(mapID, x, y, "Loot: "..msg)
    end
    ns.DrawSaved()
    if _G["AICAD_Router"] and _G["AICAD_Router"].Recalc then _G["AICAD_Router"].Recalc() end
  end
end)

-- Slash /ns
SLASH_NODESIGHT1 = "/ns"
SlashCmdList["NODESIGHT"] = function(msg)
  msg = (msg or ""):lower()
  if msg == "on" then db.enabled=true; print("|cff00ff00[NodeSight] ON|r"); ns.DrawSaved()
  elseif msg == "off" then db.enabled=false; ns.ClearAll(); print("|cffff0000[NodeSight] OFF|r")
  elseif msg == "clear" then 
    local mapName = GetRealZoneText() or GetZoneText()
    NodeSightDB.nodes[mapName] = {}
    if AICAD_WORLDMAP_DB and AICAD_WORLDMAP_DB.personal then
      local mapID = GetCurrentMapAreaID and GetCurrentMapAreaID() or 0
      AICAD_WORLDMAP_DB.personal[mapID] = {}
    end
    ns.ClearAll()
    print("|cffff0000[NodeSight] Todo limpiado|r")
  else ns.DrawSaved() print("|cffffcc00[NodeSight] /ns on/off/clear - WoTLK 30300|r") end
end

_G["AICAD_NodeSight"] = ns
print("|cff00ff00[AICAD NodeSight] UNIFICADO cargado - Lee solo pasar + loot - 30300|r")
