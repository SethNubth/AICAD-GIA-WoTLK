-- Auxiliares\Router\Router.lua - FINAL FIX AI TSP - Blizzard Map 30300 - 0 errores
AICAD_ROUTER_DB = AICAD_ROUTER_DB or {
  activeDB="personal",
  useTomTom=false,
  mode="gold",
}
AICAD_WORLDMAP_DB = AICAD_WORLDMAP_DB or {personal={}, imported={}}

local GOLD_USEFUL = {
  [485] = {"Lichbloom", "Icethorn", "Frost Lotus", "Titanium", "Flor Exanime", "Loto"},
  [492] = {"Titanium", "Saronite", "Frost Lotus"},
  [486] = {"Titanium", "Saronite"},
  [0] = {"Frost Lotus", "Titanium", "Lichbloom", "Flor Exanime"},
}

local Router = {}

local function SafeMapID()
  if GetCurrentMapAreaID then
    local ok, id = pcall(GetCurrentMapAreaID)
    if ok and id then return id end
  end
  if GetCurrentMapZone then return GetCurrentMapZone() end
  return 485
end

local function GetXY(node)
  local x = node.x or node[1] or 0.5
  local y = node.y or node[2] or 0.5
  if x > 1 then x = x/100 end
  if y > 1 then y = y/100 end
  return x, y
end

local function Dist(ax,ay,bx,by)
  local dx=ax-bx; local dy=ay-by
  return math.sqrt(dx*dx+dy*dy)
end

-- TSP Nearest Neighbor - Router AI real
local function TSP_Optimal(nodes)
  if #nodes <= 2 then return nodes end
  local unvisited={}
  for i=1,#nodes do unvisited[i]=nodes[i] end
  local route={}
  local current=table.remove(unvisited,1)
  table.insert(route, current)
  while #unvisited > 0 do
    local cx,cy=GetXY(current)
    local bestIdx=1
    local bestDist=9999
    for i,n in ipairs(unvisited) do
      local nx,ny=GetXY(n)
      local d=Dist(cx,cy,nx,ny)
      if d < bestDist then bestDist=d; bestIdx=i end
    end
    current=table.remove(unvisited, bestIdx)
    table.insert(route, current)
  end
  return route
end

function Router:GetNodes(mapID, dbType)
  local all={}
  local wdb=AICAD_WORLDMAP_DB
  mapID = mapID or SafeMapID()
  dbType = dbType or AICAD_ROUTER_DB.activeDB or "personal"
  if dbType=="personal" then
    if wdb.personal and wdb.personal[mapID] then 
      for _,n in ipairs(wdb.personal[mapID]) do table.insert(all,n) end 
    end
  elseif dbType=="gathermate" then
    if wdb.imported and wdb.imported[mapID] then 
      for _,n in ipairs(wdb.imported[mapID]) do table.insert(all,n) end 
    end
    if _G["AICAD_GIA_WORLDMAP_NODES"] and _G["AICAD_GIA_WORLDMAP_NODES"][mapID] then
      for _,n in ipairs(_G["AICAD_GIA_WORLDMAP_NODES"][mapID]) do table.insert(all,n) end
    end
  end
  return all
end

function Router:Build(mode)
  local mapID=SafeMapID()
  local zone=GetZoneText() or "Desconocida"
  local dbType=AICAD_ROUTER_DB.activeDB or "personal"
  mode = mode or AICAD_ROUTER_DB.mode or "gold"
  local nodes=self:GetNodes(mapID, dbType)
  if #nodes==0 then
    print("|cffff0000[Router] No hay nodos en "..string.upper(dbType).." en "..zone.." - Farmea primero.|r")
    return
  end
  local route={}
  if mode=="gold" then
    local useful=GOLD_USEFUL[mapID] or GOLD_USEFUL[0]
    for _,node in ipairs(nodes) do
      if node.name and useful then
        local nLow = string.lower(node.name or "")
        for _,need in ipairs(useful) do
          if nLow:find(string.lower(need)) then table.insert(route,node) break end
        end
      end
    end
    if #route==0 then route=nodes end
    route = TSP_Optimal(route)
    print("|cffffcc00[Router AI ORO] DB: "..string.upper(dbType).." | "..zone.." | "..#route.." nodos TSP|r")
  else
    route = TSP_Optimal(nodes)
    print("|cff00ff00[Router AI LEVEL 1-450] DB: "..string.upper(dbType).." | "..zone.." | "..#route.." nodos TSP|r")
  end
  if _G["AICAD_WorldMap"] and _G["AICAD_WorldMap"].ShowZone then
    pcall(function() _G["AICAD_WorldMap"]:ShowZone(mapID) end)
  end
  if AICAD_ROUTER_DB.useTomTom and TomTom then
    pcall(function()
      TomTom:ClearAllWaypoints()
      for _,n in ipairs(route) do
        local x,y=GetXY(n)
        TomTom:AddZWaypoint(mapID, 0, x*100, y*100, n.name or "Nodo", false, true)
      end
    end)
  end
  _G["AICAD_LAST_ROUTE"]=route
end

function Router:ActualizarDB(tipo)
  AICAD_ROUTER_DB.activeDB=tipo
  print("|cffffcc00[Router] Base >> "..string.upper(tipo).."|r")
  self:Build(AICAD_ROUTER_DB.mode)
end

SLASH_ROUTE1="/route"
SLASH_ROUTE2="/rt"
SlashCmdList["ROUTE"]=function(msg)
  msg = msg or ""
  msg = string.lower(msg)
  msg = string.gsub(msg, "^%s+", "")
  msg = string.gsub(msg, "%s+$", "")
  if msg=="personal" then Router:ActualizarDB("personal")
  elseif msg=="gathermate" or msg=="gather" or msg=="gm" then Router:ActualizarDB("gathermate")
  elseif msg=="gold" or msg=="oro" then AICAD_ROUTER_DB.mode="gold"; Router:Build("gold")
  elseif msg=="level" or msg=="1-450" or msg=="profesion" then AICAD_ROUTER_DB.mode="level"; Router:Build("level")
  elseif msg=="tomtom on" then AICAD_ROUTER_DB.useTomTom=true; print("|cff00ff00TomTom ON|r")
  elseif msg=="tomtom off" then AICAD_ROUTER_DB.useTomTom=false; if TomTom then pcall(function() TomTom:ClearAllWaypoints() end) end; print("|cffff0000TomTom OFF - Solo mapa Blizzard (M)|r")
  elseif msg=="clear" or msg=="limpiar" then if TomTom then pcall(function() TomTom:ClearAllWaypoints() end) end; print("Ruta limpiada")
  else Router:Build(AICAD_ROUTER_DB.mode) end
end

_G["AICAD_Router"]=Router
