-- AICAD Router v6 FIX - SIN ICONO ENCIMA + RUTA CERRADA DESDE MAS CERCANO
-- Rasganorte >>> Corona de Hielo - Minería / Herboristería

AICAD_Router = {}
AICAD_Router.route = {}
AICAD_Router.lines = {}
AICAD_Router.prof = "MINING"

local ROUTES = {
  MINING = {
    {x=0.32, y=0.30, n="Saronita"}, {x=0.38, y=0.26, n="Titanio"}, {x=0.45, y=0.24, n="Saronita"},
    {x=0.51, y=0.27, n="Titanio"}, {x=0.56, y=0.33, n="Saronita"}, {x=0.60, y=0.41, n="Saronita"},
    {x=0.60, y=0.51, n="Titanio"}, {x=0.54, y=0.60, n="Saronita"}, {x=0.46, y=0.64, n="Saronita"},
    {x=0.37, y=0.61, n="Titanio"}, {x=0.31, y=0.52, n="Saronita"}, {x=0.28, y=0.42, n="Saronita"},
    {x=0.28, y=0.35, n="Titanio"},
  },
  HERB = {
    {x=0.30, y=0.32, n="Lirios"}, {x=0.37, y=0.28, n="Albahaca"}, {x=0.44, y=0.25, n="Loto"},
    {x=0.52, y=0.28, n="Lirios"}, {x=0.57, y=0.34, n="Albahaca"}, {x=0.60, y=0.45, n="Loto"},
    {x=0.58, y=0.54, n="Lirios"}, {x=0.51, y=0.62, n="Albahaca"}, {x=0.43, y=0.65, n="Loto"},
  },
  BOTH = {}
}
for _,v in ipairs(ROUTES.MINING) do table.insert(ROUTES.BOTH, v) end
for _,v in ipairs(ROUTES.HERB) do table.insert(ROUTES.BOTH, v) end

local function Dist(a,b) return math.sqrt((a.x-b.x)^2 + (a.y-b.y)^2) end

function AICAD_Router:BuildRouteFromNearest()
  local px, py = GetPlayerMapPosition("player")
  if px==0 then px=0.45; py=0.45 end
  local playerPos = {x=px, y=py}
  
  -- Usa base, no tus 24 nodos personales para que no se te pegue encima
  local pool = ROUTES.MINING
  if self.prof=="HERB" then pool=ROUTES.HERB end
  if self.prof=="BOTH" then pool=ROUTES.BOTH end

  -- FIX 1: FILTRA NODOS QUE ESTAN ENCIMA DE TI (menos de 40 yardas)
  local filtered = {}
  for _, n in ipairs(pool) do
    if Dist(playerPos, n) > 0.025 then -- quita el que está encima del PJ
      table.insert(filtered, n)
    end
  end
  if #filtered < 2 then filtered = pool end
  pool = filtered

  -- Encuentra el más cercano
  local nearestIdx=1; local nearestDist=999
  for i, node in ipairs(pool) do
    local d=Dist(playerPos, node)
    if d < nearestDist then nearestDist=d; nearestIdx=i end
  end
  
  -- Reordena desde el más cercano en círculo cerrado (no sales de zona)
  local route={}
  for i=0,#pool-1 do
    local idx=((nearestIdx-1+i)%#pool)+1
    table.insert(route, pool[idx])
  end
  table.insert(route, route[1]) -- cierra el círculo
  
  self.route=route
  self.nearest=nearestIdx
  
  print("|cff00FF00[AICAD Router v6] Inicio en punto "..nearestIdx.." a "..math.floor(nearestDist*100).."y | Ruta cerrada Corona sin salir | Prof: "..self.prof.."|r")
  self:DrawRoute()
end

function AICAD_Router:ClearLines()
  for _,f in ipairs(self.lines) do if f.Hide then f:Hide() end end
  self.lines={}
end

function AICAD_Router:DrawRoute()
  self:ClearLines()
  if not self.route or #self.route<2 then return end
  local parent=WorldMapDetailFrame; if not parent then return end
  local W,H=parent:GetWidth(), parent:GetHeight()
  
  for i=1,#self.route-1 do
    local n1,n2=self.route[i],self.route[i+1]
    for s=0,35 do
      local t=s/35
      local x=n1.x+(n2.x-n1.x)*t
      local y=n1.y+(n2.y-n1.y)*t
      local dot=parent:CreateTexture(nil,"OVERLAY")
      dot:SetTexture("Interface\\Buttons\\WHITE8x8")
      if i==1 then dot:SetVertexColor(0,1,0,1) else dot:SetVertexColor(1,1,1,0.9) end
      dot:SetWidth(3); dot:SetHeight(3)
      dot:SetPoint("CENTER",parent,"TOPLEFT",x*W,-y*H)
      dot:Show()
      table.insert(self.lines,dot)
    end
    local txt=parent:CreateFontString(nil,"OVERLAY","GameFontNormalSmall")
    txt:SetFont("Fonts\\FRIZQT__.TTF",12,"OUTLINE")
    if i==1 then txt:SetText("INICIO->"..i); txt:SetTextColor(0,1,0)
    else txt:SetText(i); txt:SetTextColor(1,1,0) end
    txt:SetPoint("CENTER",parent,"TOPLEFT",n1.x*W,-n1.y*H-10)
    txt:Show()
    table.insert(self.lines,txt)
  end
end

-- FIX 2: AUTO-BORRA EL ICONO FANTASMA ENCIMA AL PICAR
local function DeleteGhostNode()
  if not AICAD_WORLDMAP_DB or not AICAD_WORLDMAP_DB.personal then return end
  local px,py=GetPlayerMapPosition("player")
  if px==0 then return end
  for mapID,list in pairs(AICAD_WORLDMAP_DB.personal) do
    for i=#list,1,-1 do
      local n=list[i]
      if math.sqrt((n.x-px)^2+(n.y-py)^2) < 0.015 then
        table.remove(list, i)
      end
    end
  end
end

local f=CreateFrame("Frame")
f:RegisterEvent("CHAT_MSG_LOOT")
f:SetScript("OnEvent", function(_,_,msg)
  if msg and (msg:find("Recibes botín") or msg:find("Mena de") or msg:find("Loto") or msg:find("Lirios")) then
    DeleteGhostNode()
  end
end)

SLASH_AICADROUTER1="/router"
SlashCmdList["AICADROUTER"]=function(msg)
  msg=msg and msg:lower() or ""
  if msg=="mine" then AICAD_Router.prof="MINING"; AICAD_Router:BuildRouteFromNearest()
  elseif msg=="herb" then AICAD_Router.prof="HERB"; AICAD_Router:BuildRouteFromNearest()
  elseif msg=="both" then AICAD_Router.prof="BOTH"; AICAD_Router:BuildRouteFromNearest()
  elseif msg=="clear" then AICAD_Router:ClearLines()
  else AICAD_Router:BuildRouteFromNearest() end
end

print("|cffFFD700[AICAD Router v6 FIX] Sin icono encima - /router|r")
