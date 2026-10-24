-- AICAD Router v9 ULTIMATE - Entre las 2, mejor de lo esperado
AICAD_ROUTER = AICAD_ROUTER or {}
AICAD_ROUTER.route = {}

local function Dist(a,b) return math.sqrt((a.x-b.x)^2 + (a.y-b.y)^2) end

local function GetSemiCircleNodes(allNodes, center, radius, direction)
  direction = direction or 1
  local arc={}
  for _,n in ipairs(allNodes) do
    local dx=n.x-center.x; local dy=n.y-center.y; local d=math.sqrt(dx*dx+dy*dy)
    if d>0.001 and d<=radius then table.insert(arc,{node=n, angle=math.atan2(dy,dx), dist=d}) end
  end
  if #arc==0 then return {} end
  table.sort(arc, function(a,b) return direction==1 and a.angle<b.angle or a.angle>b.angle end)
  local r={}; for _,v in ipairs(arc) do table.insert(r, v.node) end; return r
end

function AICAD_ROUTER:BuildUltimate()
  local base1 = AICAD_WORLDMAP_DB.personal[118] or {}
  local base3 = AICAD_WORLDMAP_DB.web[118] or {}
  if #base1==0 then print("|cffff0000[Ultimate] Pica primero /aicadsave|r"); return {} end

  local px,py = GetPlayerMapPosition("player")
  local entry = {x=0.50, y=0.85} -- Tundra Boreal
  local center = (px~=0) and {x=px,y=py} or entry

  -- MEJOR DE LO ESPERADO 1: Direccion auto segun entrada
  local direction = 1
  if px~=0 then
    if px < 0.4 then direction=-1 -- vienes del oeste (Fiordo) -> antihorario
    else direction=1 end -- vienes del sur (Tundra) -> horario
  end

  -- MEJOR DE LO ESPERADO 2: Radio adaptativo por densidad 45/120
  local useCount = #base1 >= 45 and 45 or #base1
  if #base1 >= 120 then useCount=45 end
  local radius = 0.18
  if #base1 >= 80 then radius=0.14 elseif #base1 <= 15 then radius=0.35 end

  local personalRoute = GetSemiCircleNodes(base1, center, radius, direction)
  if #personalRoute==0 then personalRoute=base1 end
  if #personalRoute>useCount then local t={}; for i=1,useCount do t[i]=personalRoute[i] end; personalRoute=t end

  -- MEJOR DE LO ESPERADO 3: Cierre + Copia display sin mutar
  local finalRoute={}
  for _,n in ipairs(personalRoute) do
    table.insert(finalRoute, {x=n.x, y=n.y, name=n.name, displayColor="YELLOW", base="BASE1", isPersonal=true})
  end
  if #finalRoute>1 then
    table.insert(finalRoute, {x=finalRoute[1].x, y=finalRoute[1].y, name="CIERRE", displayColor="YELLOW", base="BASE1"})
  end

  -- MEJOR DE LO ESPERADO 4: Entre las 2 - Añade BASE3 gris de fondo solo referencia
  if AICAD_WORLDMAP_DB.config.showWeb and #base3>0 then
    local guide = GetSemiCircleNodes(base3, center, radius+0.05, -direction) -- direccion opuesta
    for _,n in ipairs(guide) do
      if #finalRoute < 60 then -- max 60 en pantalla para no saturar
        table.insert(finalRoute, {x=n.x, y=n.y, name=n.name, displayColor="GRAY", base="BASE3", isPersonal=false})
      end
    end
  end

  self.route=finalRoute
  self.active=true

  print(string.format("|cff00FF00[ULTIMATE] %d/%d Personal YELLOW + %d Guia GRAY | Centro %.0f,%.0f | %s | Radio %.2f | Cierre Si|r",
    useCount, #base1, #finalRoute-useCount, center.x*100, center.y*100, direction==1 and "Horario Tundra" or "Antihorario Fiordo", radius))
  return finalRoute
end

SLASH_AICADULTIMATE1="/router"
SLASH_AICADULTIMATE2="/ultimate"
SlashCmdList["AICADULTIMATE"]=function() AICAD_ROUTER:BuildUltimate(); if AICAD_WORLDMAP.Refresh then AICAD_WORLDMAP:Refresh() end end

print("|cff00FF00[Router v9 ULTIMATE - Entre las 2, mejor de lo esperado - /router]|r")
