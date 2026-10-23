-- Auxiliares\Router\Router.lua - FINAL - Usa WorldMap de Blizzard - 30300
-- Comandos: /route personal /route gathermate /route gold /route level /route tomtom on/off

AICAD_ROUTER_DB = AICAD_ROUTER_DB or {
  activeDB="personal", -- personal o gathermate
  useTomTom=true,
  mode="gold", -- gold o level
}
AICAD_WORLDMAP_DB = AICAD_WORLDMAP_DB or {personal={}, imported={}}

-- MODO ORO: Solo lo más útil por zona
local GOLD_USEFUL = {
  [485] = {"Lichbloom", "Icethorn", "Frost Lotus", "Titanium"}, -- Cumbres Tormentosas = Flor Exanime
  [492] = {"Titanium", "Saronite", "Frost Lotus"}, -- Corona Hielo
  [486] = {"Titanium", "Saronite"}, -- Cuenca Sholazar
  [0] = {"Frost Lotus", "Titanium", "Lichbloom"},
}

local Router = {}

function Router:GetNodes(mapID, dbType)
  local all={}
  local wdb=AICAD_WORLDMAP_DB
  if not mapID then mapID=GetCurrentMapAreaID() or 485 end
  if dbType=="personal" then
    if wdb.personal[mapID] then for _,n in ipairs(wdb.personal[mapID]) do table.insert(all,n) end end
  elseif dbType=="gathermate" then
    if wdb.imported[mapID] then for _,n in ipairs(wdb.imported[mapID]) do table.insert(all,n) end end
    if AICAD_GIA_WORLDMAP_NODES and AICAD_GIA_WORLDMAP_NODES[mapID] then
      for _,n in ipairs(AICAD_GIA_WORLDMAP_NODES[mapID]) do table.insert(all,n) end
    end
  end
  return all
end

function Router:Build(mode)
  local mapID=GetCurrentMapAreaID() or 485
  local zone=GetZoneText() or "Desconocida"
  local dbType=AICAD_ROUTER_DB.activeDB
  local nodes=self:GetNodes(mapID, dbType)
  
  if #nodes==0 then
    print("|cffff0000[Router] No hay nodos en "..string.upper(dbType).." en "..zone.." - Farmea primero.|r")
    return
  end

  local route={}
  if mode=="gold" then
    local useful=GOLD_USEFUL[mapID] or GOLD_USEFUL[0]
    for _,node in ipairs(nodes) do
      if node.name then
        for _,need in ipairs(useful) do
          if node.name:lower():find(need:lower()) then table.insert(route,node) break end
        end
      end
    end
    if #route==0 then route=nodes end
    print("|cffffcc00[Router ORO] DB: "..string.upper(dbType).." | "..zone.." | Flor Exanime útil | "..#route.." nodos|r")
  else
    route=nodes -- MODO LEVEL 1-450: Todo por igual
    print("|cff00ff00[Router LEVEL 1-450] DB: "..string.upper(dbType).." | "..zone.." | Todo por igual | "..#route.." nodos|r")
  end

  -- Pinta en mapa de Blizzard + TomTom si está ON
  if AICAD_ROUTER_DB.useTomTom and TomTom then
    TomTom:ClearAllWaypoints()
    for _,n in ipairs(route) do
      local x=n.x or 0.5
      local y=n.y or 0.5
      if x>1 then x=x/100 end
      if y>1 then y=y/100 end
      TomTom:AddZWaypoint(mapID, 0, x*100, y*100, n.name or "Nodo", false, true)
    end
  end
end

function Router:ActualizarDB(tipo)
  AICAD_ROUTER_DB.activeDB=tipo
  print("|cffffcc00[Router] Actualizado a >> Base Datos "..string.upper(tipo).."|r")
  self:Build(AICAD_ROUTER_DB.mode)
end

-- Slash Commands Finales
SLASH_ROUTE1="/route"
SLASH_ROUTE2="/rt"
SlashCmdList["ROUTE"]=function(msg)
  msg=(msg or ""):lower():trim()
  if msg=="personal" then Router:ActualizarDB("personal")
  elseif msg=="gathermate" or msg=="gather" or msg=="gm" then Router:ActualizarDB("gathermate")
  elseif msg=="gold" or msg=="oro" then AICAD_ROUTER_DB.mode="gold"; Router:Build("gold")
  elseif msg=="level" or msg=="1-450" or msg=="profesion" then AICAD_ROUTER_DB.mode="level"; Router:Build("level")
  elseif msg=="tomtom on" then AICAD_ROUTER_DB.useTomTom=true; print("|cff00ff00TomTom ON|r")
  elseif msg=="tomtom off" then AICAD_ROUTER_DB.useTomTom=false; if TomTom then TomTom:ClearAllWaypoints() end; print("|cffff0000TomTom OFF - Solo mapa Blizzard (M)|r")
  elseif msg=="clear" or msg=="limpiar" then if TomTom then TomTom:ClearAllWaypoints() end; print("Ruta limpiada")
  else Router:Build(AICAD_ROUTER_DB.mode) end
end

_G["AICAD_Router"]=Router
print("|cff00ff00AICAD Router AI cargado - Mapa Blizzard|r")
