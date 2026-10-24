-- AICAD Router v6 FINAL - 45/120 DINAMICO - Semi-Circuito Inteligente Zona 118
AICAD_ROUTER = AICAD_ROUTER or {}
AICAD_ROUTER.route = {}
AICAD_ROUTER.active = false
AICAD_ROUTER.lastCount = 0

local function Dist(a,b) return math.sqrt((a.x-b.x)^2 + (a.y-b.y)^2) end

-- Encuentra el cluster mas denso de 45 nodos si hay 120+
local function GetBest45Nodes(allNodes, entry)
  if #allNodes <= 45 then return allNodes end
  
  -- Si tienes 120, busca el cluster de 45 mas cercano a tu entrada de Tundra
  local scored = {}
  for _,n in ipairs(allNodes) do
    local dEntry = Dist(n, entry)
    -- cuenta vecinos cerca
    local neighbors = 0
    for _,m in ipairs(allNodes) do
      if Dist(n,m) < 0.08 then neighbors=neighbors+1 end
    end
    table.insert(scored, {node=n, score=dEntry - neighbors*0.01})
  end
  table.sort(scored, function(a,b) return a.score < b.score end)
  
  local best = {}
  for i=1,45 do best[i]=scored[i].node end
  print(string.format("|cffFFD700[Router] Tienes %d menas, seleccionando las 45 mejores cerca de entrada Tundra (cluster denso)|r", #allNodes))
  return best
end

function AICAD_ROUTER:BuildSemiCircuit(zoneID, forceCount)
  zoneID = zoneID or 118
  local allNodes = AICAD_WORLDMAP:GetNodes(zoneID)
  
  if #allNodes == 0 then print("|cffff0000[Router] DB vacia, pica menas primero /aicadsave|r"); return {} end
  
  -- LOGICA 45/120
  local useCount = #allNodes
  if forceCount then
    useCount = forceCount
  else
    if #allNodes >= 120 then useCount = 45 -- Si tienes 120+, solo 45 optimas
    elseif #allNodes >= 45 then useCount = 45 -- Si tienes 45-119, 45
    else useCount = #allNodes -- Si tienes menos de 45, todas las que tengas
    end
  end
  
  local entry = AICAD_WORLDMAP.entryPoints[zoneID] or {x=0.50, y=0.85, name="Entrada Tundra Boreal"}
  local px, py = GetPlayerMapPosition("player")
  local startPoint = (px~=0 and py > 0.65) and {x=px, y=py} or entry
  
  local nodesToRoute = GetBest45Nodes(allNodes, entry)
  if #nodesToRoute > useCount then
    local trimmed = {}
    for i=1,useCount do trimmed[i]=nodesToRoute[i] end
    nodesToRoute = trimmed
  end
  
  -- NEAREST NEIGHBOR + 2-OPT para semi-circuito cerrado
  local route = {}
  local remaining = {}
  for _,n in ipairs(nodesToRoute) do table.insert(remaining, n) end
  
  local current = startPoint
  while #remaining > 0 do
    local bestIdx, bestDist = 1, 9999
    for i,n in ipairs(remaining) do
      local d = Dist(current, n)
      if d < bestDist then bestDist=d; bestIdx=i end
    end
    table.insert(route, remaining[bestIdx])
    current = remaining[bestIdx]
    table.remove(remaining, bestIdx)
  end
  
  self.route = route
  self.active = true
  self.lastCount = #route
  
  local totalDB = #allNodes
  print(string.format("|cff00FF00[Router] RUTA %d/%d CREADA | Zona %d | Inicio: %s | Semi-Circuito cerrado desde Tundra|r",
    #route, totalDB, zoneID, (px~=0 and "Tu pos" or "Entrada Tundra"), #route))
  
  return route
end

function AICAD_ROUTER:DrawRoute()
  if not self.route or #self.route==0 then return end
  if AICAD_WORLDMAP and AICAD_WORLDMAP.Refresh then AICAD_WORLDMAP:Refresh() end
end

function AICAD_ROUTER:OnNodeSaved(node)
  if self.active and #AICAD_WORLDMAP_DB.personal[node.zoneID] >= self.lastCount then
    -- No reconstruye automatico para no spamear, solo si escribes /router
  end
end

SLASH_AICADROUTER1="/router"
SLASH_AICADROUTER2="/ruta"
SlashCmdList["AICADROUTER"]=function(msg)
  msg = msg and string.lower(msg) or ""
  local force = nil
  if msg:find("45") then force=45
  elseif msg:find("120") then force=120
  elseif msg:find("all") or msg:find("todo") then force=999
  end
  AICAD_ROUTER:BuildSemiCircuit(118, force)
  AICAD_ROUTER:DrawRoute()
end

-- Info
SLASH_AICADROUTERINFO1="/rinfo"
SlashCmdList["AICADROUTERINFO"]=function()
  local all = AICAD_WORLDMAP_DB.personal[118] or {}
  print(string.format("|cffFFD700[Info] DB: %d menas en Corona | Ruta actual: %d | Modo: %s|r",
    #all, AICAD_ROUTER.lastCount or 0, #all>=120 and "45/120" or #all.."/"..#all))
end

print("|cff00FF00[AICAD Router v6 45/120 Cargado - /router, /router 45, /router 120, /rinfo|r")
