-- Core\Main.lua - FINAL v1.3 - AUTO SOLO PASAR - Naerzone 30300
AICAD_GIA = AICAD_GIA or {}

function AICAD_GIA:InitDB()
  AICAD_GIA_DB = AICAD_GIA_DB or {}
  AICAD_GIA_DB.autoScan = true
  AICAD_GIA_DB.personal = AICAD_GIA_DB.personal or {}
  AICAD_GIA_DB.routeMode = AICAD_GIA_DB.routeMode or "GOLD"
  _G["AICAD_WORLDMAP_DB"] = _G["AICAD_WORLDMAP_DB"] or {personal={}}
  _G["AICAD_WORLDMAP_DB"].personal = _G["AICAD_WORLDMAP_DB"].personal or {}
  NodeSightDB = NodeSightDB or {}
  NodeSightDB.nodes = NodeSightDB.nodes or {}
  print("|cff00ff00[AICAD] DB Iniciada - Auto Solo Pasar ON|r")
end

function AICAD_GIA:OnInitialize()
  if not AICAD_GIA_DB then self:InitDB() end
  if AICAD_GIA_DB.autoScan == nil then AICAD_GIA_DB.autoScan = true end
  
  print("|cffffcc00[AICAD GIA v1.0 - Naerzone 3.3.5a] Cargado - /aicad para opciones|r")
  print("|cffffcc00Base: "..(self:GetMapBase() or 3).." | Modo: "..(self:GetRouteMode() or "GOLD").." | /aicad 1 para guardar|r")

  SLASH_AICAD1 = "/aicad"
  SlashCmdList["AICAD"] = function(msg)
    msg = (msg or ""):lower():gsub("^%s+",""):gsub("%s+$","")
    if msg == "1" then AICAD_GIA:SetMapBase(1)
    elseif msg == "2" then AICAD_GIA:SetMapBase(2)
    elseif msg == "3" then AICAD_GIA:SetMapBase(3)
    elseif msg == "gold" then AICAD_GIA_DB.routeMode = "GOLD"
    elseif msg == "level" then AICAD_GIA_DB.routeMode = "LEVELING_1_450"
    elseif msg == "clear" then
      local mapID = GetCurrentMapAreaID and GetCurrentMapAreaID() or 0
      if _G["AICAD_WORLDMAP_DB"] and _G["AICAD_WORLDMAP_DB"].personal then
        _G["AICAD_WORLDMAP_DB"].personal[mapID] = {}
        print("|cffff0000[AICAD] Base 1 limpiada mapa: "..mapID.." | WEB no tocada|r")
      end
    elseif msg == "scan on" then AICAD_GIA_DB.autoScan = true; print("|cff00ff00[AICAD] Scanner Solo Pasar ON|r")
    elseif msg == "scan off" then AICAD_GIA_DB.autoScan = false; print("|cffff0000[AICAD] Scanner OFF|r")
    else
      InterfaceOptionsFrame_OpenToCategory("AICAD GIA")
      InterfaceOptionsFrame_OpenToCategory("AICAD GIA")
      print("|cffffcc00Comandos: /aicad 1=Personal(Escribe) 3=WEB(Solo muestra) | scan on/off|r")
    end
  end
end

-- === UNIFICADO: Guarda en las 2 DB a la vez ===
function AICAD_GIA:SavePersonalNode(mapID, x, y, name)
  if not mapID or not x or not y or x == 0 then return end
  if not AICAD_GIA_DB or AICAD_GIA_DB.autoScan == false then return end
  if self:GetMapBase() == 3 then return end
  
  _G["AICAD_WORLDMAP_DB"] = _G["AICAD_WORLDMAP_DB"] or {personal={}}
  _G["AICAD_WORLDMAP_DB"].personal = _G["AICAD_WORLDMAP_DB"].personal or {}
  _G["AICAD_WORLDMAP_DB"].personal[mapID] = _G["AICAD_WORLDMAP_DB"].personal[mapID] or {}
  
  for _, n in ipairs(_G["AICAD_WORLDMAP_DB"].personal[mapID]) do
    if math.abs(n.x - x) < 0.008 and math.abs(n.y - y) < 0.008 then return end
  end
  
  table.insert(_G["AICAD_WORLDMAP_DB"].personal[mapID], {x=x, y=y, name=name, time=time()})
  
  NodeSightDB = NodeSightDB or {}; NodeSightDB.nodes = NodeSightDB.nodes or {}
  local zone = GetRealZoneText() or GetZoneText()
  NodeSightDB.nodes[zone] = NodeSightDB.nodes[zone] or {}
  local icon = "Interface\\Icons\\INV_Misc_Herb_02"
  if name and string.lower(name):find("veta") then icon="Interface\\Icons\\INV_Ore_Copper_01" end
  table.insert(NodeSightDB.nodes[zone], {x=x, y=y, mx=true, icon=icon})
  
  print("|cff00ff00[AICAD] + Auto: "..(name or "Nodo").." | "..string.format("%.1f, %.1f", x*100, y*100).."|r")
  if _G["AICAD_NodeSight"] and _G["AICAD_NodeSight"].DrawSaved then _G["AICAD_NodeSight"].DrawSaved() end
end

local f = CreateFrame("Frame")
f:RegisterEvent("PLAYER_LOGIN")
f:SetScript("OnEvent", function(self, event)
  AICAD_GIA:OnInitialize()
  self:UnregisterEvent("PLAYER_LOGIN")
end)

-- === SCANNER SOLO PASAR 0.3s ===
local scanFrame = CreateFrame("Frame")
scanFrame.lastScan = 0; scanFrame.lastNode = ""
scanFrame:SetScript("OnUpdate", function(self, elapsed)
  if not AICAD_GIA_DB or not AICAD_GIA_DB.autoScan then return end
  if AICAD_GIA:GetMapBase() == 3 then return end
  self.lastScan = self.lastScan + elapsed
  if self.lastScan < 0.3 then return end; self.lastScan = 0
  local mapID = GetCurrentMapAreaID and GetCurrentMapAreaID() or nil
  if not mapID or mapID == 0 then return end
  local x, y = GetPlayerMapPosition("player")
  if not x or x == 0 then return end
  local tooltipText = nil
  if GameTooltip and GameTooltip:IsShown() then
    local gtt = _G["GameTooltipTextLeft1"]
    if gtt then tooltipText = gtt:GetText() end
  end
  if tooltipText and tooltipText ~= self.lastNode then
    local lname = string.lower(tooltipText)
    if string.find(lname, "veta") or string.find(lname, "filón") or string.find(lname, "hierba") or string.find(lname, "flor") or string.find(lname, "espina") or string.find(lname, "cobre") or string.find(lname, "estaño") or string.find(lname, "oro") or string.find(lname, "adamantita") or string.find(lname, "khorium") then
      self.lastNode = tooltipText
      AICAD_GIA:SavePersonalNode(mapID, x, y, tooltipText)
    end
  end
end)

local moveFrame = CreateFrame("Frame")
moveFrame.lastX, moveFrame.lastY = 0,0
moveFrame:SetScript("OnUpdate", function(self, el)
  local x,y = GetPlayerMapPosition("player")
  if x and x~=0 then
    if math.abs(x-self.lastX) > 0.01 or math.abs(y-self.lastY) > 0.01 then
      scanFrame.lastNode = ""
      self.lastX, self.lastY = x,y
    end
  end
end)
