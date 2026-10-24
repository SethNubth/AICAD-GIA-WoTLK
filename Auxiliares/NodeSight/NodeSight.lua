-- Auxiliares\NodeSight\NodeSight.lua - AUTOSAVE 1-450 - Naerzone 30300
local ADDON_NAME, ns = ...
ns = ns or {}

local defaults = { enabled=true, shape=3, iconSize=18, worldIcons=true }
NodeSightDB = NodeSightDB or {}
NodeSightDB.nodes = NodeSightDB.nodes or {} -- AQUI SE GUARDA TODO LO QUE PIQUES
for k,v in pairs(defaults) do if NodeSightDB[k]==nil then NodeSightDB[k]=v end end
local db = NodeSightDB
ns.db = db

local poolMinimap = {}
local poolWorld = {}
local mIndex, wIndex = 0,0
local GOLD_BORDER = "Interface\\Minimap\\Tracking\\TrackingBorder"

-- POOL MINIMAPA
function ns.GetMiniFrame()
  mIndex=mIndex+1
  if not poolMinimap[mIndex] then
    local f = CreateFrame("Frame", "NSMini"..mIndex, Minimap)
    f:SetWidth(db.iconSize); f:SetHeight(db.iconSize)
    f:SetFrameLevel(6000); f:SetFrameStrata("MEDIUM")
    f.tex=f:CreateTexture(nil,"OVERLAY"); f.tex:SetAllPoints(f)
    f.tex:SetTexCoord(0.08,0.92,0.08,0.92)
    f.border=f:CreateTexture(nil,"OVERLAY"); f.border:SetTexture(GOLD_BORDER)
    f.border:SetWidth(30); f.border:SetHeight(30)
    f.border:SetPoint("CENTER",f,"CENTER",-9.3,8.7)
    f:Hide(); poolMinimap[mIndex]=f
  end
  return poolMinimap[mIndex]
end

-- POOL WORLD MAP
function ns.GetWorldFrame()
  wIndex=wIndex+1
  if not poolWorld[wIndex] then
    local f = CreateFrame("Frame", "NSWorld"..wIndex, WorldMapDetailFrame)
    f:SetWidth(db.iconSize+6); f:SetHeight(db.iconSize+6)
    f:SetFrameLevel(6000); f:SetFrameStrata("MEDIUM")
    f.tex=f:CreateTexture(nil,"OVERLAY"); f.tex:SetAllPoints(f)
    f.tex:SetTexCoord(0.08,0.92,0.08,0.92)
    f:Hide(); poolWorld[wIndex]=f
  end
  return poolWorld[wIndex]
end

function ns.ClearAll()
  for i=1,#poolMinimap do if poolMinimap[i] then poolMinimap[i]:Hide(); poolMinimap[i]:ClearAllPoints() end end
  for i=1,#poolWorld do if poolWorld[i] then poolWorld[i]:Hide(); poolWorld[i]:ClearAllPoints() end end
  mIndex=0; wIndex=0
end

-- DIBUJA TODO LO GUARDADO EN MAPA Y MINIMAPA
function ns.DrawSaved()
  if not db.enabled then return end
  ns.ClearAll()
  local map = GetRealZoneText() or GetZoneText()
  if not NodeSightDB.nodes[map] then return end
  
  for _,node in ipairs(NodeSightDB.nodes[map]) do
    -- 1. En MINIMAPA (cerca de ti)
    if node.mx then
      local f = ns.GetMiniFrame()
      f.tex:SetTexture(node.icon)
      -- Convierte coordenadas de mundo a offset de minimapa
      local px, py = GetPlayerMapPosition("player")
      if px==0 and py==0 then px=0.5; py=0.5 end
      local dx = (node.x - px) * 1200
      local dy = (node.y - py) * 1200
      if math.abs(dx)<120 and math.abs(dy)<120 then
        f:SetPoint("CENTER", Minimap, "CENTER", dx, -dy)
        if db.shape==3 then f.border:Show() else f.border:Hide() end
        f:Show()
      end
    end
    -- 2. En WORLD MAP (cuando le das M)
    if WorldMapFrame:IsVisible() and db.worldIcons then
      local wf = ns.GetWorldFrame()
      wf.tex:SetTexture(node.icon)
      wf:SetPoint("CENTER", WorldMapDetailFrame, "TOPLEFT", node.x*WorldMapDetailFrame:GetWidth(), -node.y*WorldMapDetailFrame:GetHeight())
      wf:Show()
    end
  end
end

-- AUTOGUARDADO CUANDO PIQUES
local gatherFrame = CreateFrame("Frame")
gatherFrame:RegisterEvent("CHAT_MSG_LOOT")
gatherFrame:RegisterEvent("WORLD_MAP_UPDATE")
gatherFrame:SetScript("OnEvent", function(self, event, msg)
  if event=="CHAT_MSG_LOOT" then
    if not msg:find("Recibes bot") and not msg:find("Recibes") then return end
    local x,y = GetPlayerMapPosition("player")
    if x==0 and y==0 then return end
    local zone = GetRealZoneText() or GetZoneText()
    NodeSightDB.nodes[zone] = NodeSightDB.nodes[zone] or {}
    
    -- Detecta que picaste por el texto del loot
    local icon = "Interface\\Icons\\INV_Misc_Herb_02"
    if msg:find("Cobre") or msg:find("Esta") or msg:find("Mineral") then icon="Interface\\Icons\\INV_Ore_Copper_01" end
    if msg:find("Hierba") or msg:find("Flor") then icon="Interface\\Icons\\INV_Misc_Herb_02" end
    
    table.insert(NodeSightDB.nodes[zone], {x=x, y=y, mx=true, icon=icon, time=date("%H:%M")})
    print("|cff00ff00[NodeSight] Guardado en "..zone.." |r"..msg)
    ns.DrawSaved()
  elseif event=="WORLD_MAP_UPDATE" then
    ns.DrawSaved()
  end
end)

-- Refresco cada 0.5s
local upd=CreateFrame("Frame")
local t=0
upd:SetScript("OnUpdate", function(s,el)
  t=t+el; if t<0.5 then return end; t=0
  ns.DrawSaved()
end)

-- SLASH
SLASH_NODESIGHT1="/ns"
SLASH_NODESIGHT2="/nodesight"
SlashCmdList["NODESIGHT"]=function(msg)
  msg=msg:lower():gsub("^%s+",""):gsub("%s+$","")
  if msg=="clear" then NodeSightDB.nodes={}; ns.ClearAll(); print("|cffff0000NodeSight DB borrada|r")
  elseif msg=="off" then db.enabled=false; ns.ClearAll(); print("NodeSight OFF")
  elseif msg=="on" then db.enabled=true; print("NodeSight ON - AutoGuardado activo")
  else print("|cffffcc00NodeSight AutoSave: /ns on/off | /ns clear (borra mapa)|r") end
end

print("|cffffcc00[AICAD NodeSight] AutoSave cargado - Pica una mena y dale M para verla|r")
_G["AICAD_NodeSight"]=ns
