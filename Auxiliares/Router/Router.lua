-- AICAD Router v5 - RUTA CERRADA CIRCULAR - Inicio en punto más cercano - Por Profesión
-- Rasganorte >>> Corona de Hielo - Minería / Herboristería

AICAD_Router = {}
AICAD_Router.route = {}
AICAD_Router.lines = {}
AICAD_Router.prof = "MINING" -- default

-- RUTAS BASE PREDEFINIDAS POR PROFESION (extraídas de tu foto blanca)
local ROUTES = {
  MINING = { -- Titanio / Saronita / Cobalto
    {x=0.32, y=0.30, n="Saronita"}, {x=0.38, y=0.26, n="Titanio"}, {x=0.45, y=0.24, n="Saronita"},
    {x=0.51, y=0.27, n="Titanio"}, {x=0.56, y=0.33, n="Saronita"}, {x=0.60, y=0.41, n="Saronita"},
    {x=0.60, y=0.51, n="Titanio"}, {x=0.54, y=0.60, n="Saronita"}, {x=0.46, y=0.64, n="Saronita"},
    {x=0.37, y=0.61, n="Titanio"}, {x=0.31, y=0.52, n="Saronita"}, {x=0.28, y=0.42, n="Saronita"},
    {x=0.28, y=0.35, n="Titanio"},
  },
  HERB = { -- Loto / Lirios / Albahaca
    {x=0.30, y=0.32, n="Lirios"}, {x=0.37, y=0.28, n="Albahaca"}, {x=0.44, y=0.25, n="Loto"},
    {x=0.52, y=0.28, n="Lirios"}, {x=0.57, y=0.34, n="Albahaca"}, {x=0.60, y=0.45, n="Loto"},
    {x=0.58, y=0.54, n="Lirios"}, {x=0.51, y=0.62, n="Albahaca"}, {x=0.43, y=0.65, n="Loto"},
    {x=0.35, y=0.60, n="Lirios"}, {x=0.30, y=0.50, n="Albahaca"}, {x=0.27, y=0.40, n="Lirios"},
  },
  BOTH = {} -- se llena combinando
}
for _,v in ipairs(ROUTES.MINING) do table.insert(ROUTES.BOTH, v) end
for _,v in ipairs(ROUTES.HERB) do table.insert(ROUTES.BOTH, v) end

local function DetectProfession()
  -- Detecta profesión real
  for i=1,2 do
    local _,_,_,_,_,_,skillLine = GetProfessionInfo(i)
    if skillLine then
      if skillLine==182 or skillLine==186 then AICAD_Router.prof="MINING" end
      if skillLine==171 then AICAD_Router.prof="HERB" end
    end
  end
  if IsSpellKnown(2575) then AICAD_Router.prof="MINING" end
  if IsSpellKnown(2366) then AICAD_Router.prof="HERB" end
  if IsSpellKnown(2575) and IsSpellKnown(2366) then AICAD_Router.prof="BOTH" end
  
  -- Si tienes nodos personales de Titanio, prioriza mineria
  if AICAD_WORLDMAP_DB and AICAD_WORLDMAP_DB.personal[118] then
    AICAD_Router.prof="MINING"
  end
  return AICAD_Router.prof
end

local function Dist(a,b) return math.sqrt((a.x-b.x)^2 + (a.y-b.y)^2) end

function AICAD_Router:BuildRouteFromNearest()
  local prof = DetectProfession()
  local base = ROUTES[prof] or ROUTES.MINING
  
  -- Junta con tus nodos personales
  local personal = {}
  if AICAD_WORLDMAP_DB and AICAD_WORLDMAP_DB.personal[118] then
    for _,n in ipairs(AICAD_WORLDMAP_DB.personal[118]) do table.insert(personal,{x=n.x,y=n.y,n="Mena personal"}) end
  end
  if AICAD_WORLDMAP_DB and AICAD_WORLDMAP_DB.personal[493] then
    for _,n in ipairs(AICAD_WORLDMAP_DB.personal[493]) do table.insert(personal,{x=n.x,y=n.y,n="Mena personal"}) end
  end
  
  local pool = {}
  if #personal >= 15 then pool = personal else pool = base end
  if #pool < 2 then pool = base end

  -- 1. ENCONTRAR PUNTO MAS CERCANO A TI
  local px, py = GetPlayerMapPosition("player")
  if px==0 then px=0.45; py=0.45 end
  local playerPos = {x=px, y=py}
  
  local nearestIdx = 1
  local nearestDist = 999
  for i, node in ipairs(pool) do
    local d = Dist(playerPos, node)
    if d < nearestDist then nearestDist = d; nearestIdx = i end
  end
  
  -- 2. REORDENAR RUTA EMPEZANDO DESDE EL MAS CERCANO Y SIGUIENDO CIRCULAR (sin salir)
  local route = {}
  for i=0, #pool-1 do
    local idx = ((nearestIdx-1 + i) % #pool) + 1
    table.insert(route, pool[idx])
  end
  -- Cierra el círculo volviendo al inicio
  table.insert(route, route[1])
  
  self.route = route
  self.nearest = nearestIdx
  
  print("|cff"..(prof=="HERB" and "00FF00" or "FFD700").."[AICAD Router] Prof: "..prof.." | Inicio: punto "..nearestIdx.." (el mas cercano a ti) | Ruta cerrada de "..#route.." puntos - Corona de Hielo no sales de la zona|r")
  self:DrawRoute()
end

function AICAD_Router:ClearLines()
  for _,f in ipairs(self.lines) do if f.Hide then f:Hide() end end
  self.lines={}
end

function AICAD_Router:DrawRoute()
  self:ClearLines()
  if not self.route or #self.route<2 then return end
  local parent = WorldMapDetailFrame
  if not parent then return end
  local W,H = parent:GetWidth(), parent:GetHeight()
  
  for i=1,#self.route-1 do
    local n1,n2=self.route[i],self.route[i+1]
    -- Línea blanca continua cerrada
    for s=0,35 do
      local t=s/35
      local x=n1.x+(n2.x-n1.x)*t
      local y=n1.y+(n2.y-n1.y)*t
      local dot=parent:CreateTexture(nil,"OVERLAY")
      dot:SetTexture("Interface\\Buttons\\WHITE8x8")
      if i==1 then dot:SetVertexColor(0,1,0,1) -- primer tramo VERDE = inicio
      else dot:SetVertexColor(1,1,1,0.9) end
      dot:SetWidth(3); dot:SetHeight(3)
      dot:SetPoint("CENTER",parent,"TOPLEFT",x*W,-y*H)
      dot:Show()
      table.insert(self.lines,dot)
    end
    
    -- Número y nombre
    local txt=parent:CreateFontString(nil,"OVERLAY","GameFontNormalSmall")
    txt:SetFont("Fonts\\FRIZQT__.TTF",12,"OUTLINE")
    if i==1 then txt:SetText("INICIO->"..i); txt:SetTextColor(0,1,0)
    else txt:SetText(i); txt:SetTextColor(1,1,0) end
    txt:SetPoint("CENTER",parent,"TOPLEFT",n1.x*W,-n1.y*H-10)
    txt:Show()
    table.insert(self.lines,txt)
  end
end

-- SLASH
SLASH_AICADROUTER1="/router"
SLASH_AICADROUTER2="/aicadrouter"
SlashCmdList["AICADROUTER"]=function(msg)
  msg=msg and msg:lower() or ""
  if msg=="recalc" or msg=="" then AICAD_Router:BuildRouteFromNearest()
  elseif msg=="mine" then ROUTES.BOTH=ROUTES.MINING; AICAD_Router.prof="MINING"; AICAD_Router:BuildRouteFromNearest()
  elseif msg=="herb" then AICAD_Router.prof="HERB"; AICAD_Router:BuildRouteFromNearest()
  elseif msg=="both" then AICAD_Router.prof="BOTH"; AICAD_Router:BuildRouteFromNearest()
  elseif msg=="clear" then AICAD_Router:ClearLines()
  else AICAD_Router:BuildRouteFromNearest() end
end

print("|cffFFD700[AICAD Router v5] Cargado - Rasganorte>>>Corona de Hielo | /router = ruta desde tu punto mas cercano|r")
