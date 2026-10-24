-- Auxiliares\Router\Router.lua - ROUTER GOLD TSP - Lee nodos solo pasar - WoTLK 30300 - TomTom OFF
local ADDON_NAME, ns = ...
ns = ns or {}

AICAD_ROUTER_DB = AICAD_ROUTER_DB or {activeDB="personal", useTomTom=false, mode="GOLD", lastRoute={}}
local Router = {}
Router.lines = {}
Router.lineCount = 0
Router.route = {}

function Router:GetAllNodes(mapID)
  if not mapID then
    if GetCurrentMapAreaID then local ok,id = pcall(GetCurrentMapAreaID) if ok then mapID=id end end
    mapID = mapID or 121 -- Sholazar default
  end
  local all = {}
  -- 1. Tu Base 1 personal - solo pasar
  if AICAD_WORLDMAP_DB and AICAD_WORLDMAP_DB.personal and AICAD_WORLDMAP_DB.personal[mapID] then
    for _, n in ipairs(AICAD_WORLDMAP_DB.personal[mapID]) do
      table.insert(all, {x=n.x, y=n.y, name=n.name or "Nodo"})
    end
  end
  -- 2. NodeSight por si acaso
  if NodeSightDB and NodeSightDB.nodes then
    local zoneName = GetRealZoneText() or GetZoneText()
    if NodeSightDB.nodes[zoneName] then
      for _, n in ipairs(NodeSightDB.nodes[zoneName]) do
        table.insert(all, {x=n.x, y=n.y, name="NodeSight"})
      end
    end
  end
  return all, mapID
end

-- TSP Nearest Neighbor - mejor ruta corta
function Router:CalculateTSP(nodes)
  if #nodes == 0 then return {} end
  local px, py = GetPlayerMapPosition("player")
  if not px or px==0 then px,py = nodes[1].x, nodes[1].y end
  
  local unvisited = {}
  for i,v in ipairs(nodes) do unvisited[i]=v end
  local route = {}
  local cx, cy = px, py
  
  while #unvisited > 0 do
    local bestIdx, bestDist = nil, 9999
    for i, n in ipairs(unvisited) do
      local dx = (n.x - cx); local dy = (n.y - cy)
      local dist = dx*dx + dy*dy
      if dist < bestDist then bestDist = dist; bestIdx = i end
    end
    if bestIdx then
      local nextNode = table.remove(unvisited, bestIdx)
      table.insert(route, nextNode)
      cx, cy = nextNode.x, nextNode.y
    else break end
  end
  return route
end

function Router:GetLine()
  self.lineCount = self.lineCount + 1
  local idx = self.lineCount
  if not self.lines[idx] then
    local parent = WorldMapDetailFrame or WorldMapButton or WorldMapFrame
    local f = CreateFrame("Frame", "AICADRouterLine"..idx, parent)
    f:SetFrameLevel(4999) f:SetFrameStrata("FULLSCREEN")
    f.tex = f:CreateTexture(nil, "OVERLAY")
    f.tex:SetTexture(1,1,0,0.7) -- amarillo oro
    f:Hide()
    self.lines[idx] = f
  end
  return self.lines[idx]
end

function Router:ClearRoute()
  for i=1,#self.lines do if self.lines[i] then self.lines[i]:Hide() end end
  self.lineCount = 0
  self.route = {}
end

function Router:DrawRoute(route, mapID)
  self:ClearRoute()
  if #route < 2 then return end
  local parent = WorldMapDetailFrame or WorldMapButton or WorldMapFrame
  local pw = parent:GetWidth() if pw==0 or not pw then pw=1002 end
  local ph = parent:GetHeight() if ph==0 or not ph then ph=668 end
  
  for i=1, #route-1 do
    local n1 = route[i]; local n2 = route[i+1]
    local x1, y1 = n1.x, n1.y; local x2, y2 = n2.x, n2.y
    if x1>1 then x1=x1/100 end; if y1>1 then y1=y1/100 end
    if x2>1 then x2=x2/100 end; if y2>1 then y2=y2/100 end
    
    local line = self:GetLine()
    local dx = (x2 - x1) * pw
    local dy = (y2 - y1) * ph
    local dist = math.sqrt(dx*dx + dy*dy)
    local angle = math.atan2(dy, dx)
    
    line:ClearAllPoints()
    line:SetPoint("TOPLEFT", parent, "TOPLEFT", x1*pw, -y1*ph)
    line:SetWidth(dist)
    line:SetHeight(2)
    line.tex:ClearAllPoints()
    line.tex:SetAllPoints(line)
    -- rotar textura no funciona en 3.3.5a simple, usamos linea recta con SetRotation si existe
    if line.tex.SetRotation then line.tex:SetRotation(angle) end
    line:Show()
  end
  print("|cff00ff00[AICAD Router] Ruta GOLD con "..#route.." nodos dibujada en mapa "..mapID.."|r")
end

function Router:Recalc()
  local nodes, mapID = self:GetAllNodes()
  if #nodes == 0 then print("|cffff0000[AICAD Router] No hay nodos en Base 1. Pasa por algunas menas primero. /aicad 1|r") return end
  local mode = AICAD_GIA_DB and AICAD_GIA_DB.routeMode or "GOLD"
  if mode == "GOLD" then
    -- en modo GOLD prioriza titanio, saronita
    table.sort(nodes, function(a,b) return (a.name or "") < (b.name or "") end)
  end
  self.route = self:CalculateTSP(nodes)
  self:DrawRoute(self.route, mapID)
  -- también repinta WorldMap pins
  if _G["AICAD_WorldMap"] and _G["AICAD_WorldMap"].ShowZone then
    _G["AICAD_WorldMap"]:ShowZone(mapID)
  end
end

-- Slash /router
SLASH_AICADROUTER1 = "/router"
SLASH_AICADROUTER2 = "/aicadroute"
SlashCmdList["AICADROUTER"] = function(msg)
  msg = (msg or ""):lower()
  if msg:find("recalc") or msg:find("calc") or msg == "" then Router:Recalc()
  elseif msg:find("clear") then Router:ClearRoute() print("|cffff0000[AICAD Router] Ruta limpiada|r")
  elseif msg:find("gold") then AICAD_GIA_DB.routeMode="GOLD"; print("|cffffcc00[AICAD] Modo GOLD|r"); Router:Recalc()
  elseif msg:find("level") then AICAD_GIA_DB.routeMode="LEVELING_1_450"; print("|cffffcc00[AICAD] Modo LEVEL 1-450|r"); Router:Recalc()
  else Router:Recalc() end
end

_G["AICAD_Router"] = Router
print("|cff00ff00[AICAD Router] TSP GOLD cargado - /router recalc - TomTom OFF - 30300|r")
