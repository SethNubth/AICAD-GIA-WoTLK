-- AICAD NodeSight v7 FIX MAPA WotLK - USA WorldMapButton
AICAD_WORLDMAP_DB = AICAD_WORLDMAP_DB or {}
AICAD_WORLDMAP_DB.personal = AICAD_WORLDMAP_DB.personal or {}
AICAD_WORLDMAP_DB.personal[118] = AICAD_WORLDMAP_DB.personal[118] or {}

local mapIcons = {}

local function ClearMapIcons()
  for _,f in ipairs(mapIcons) do 
    if f.Hide then f:Hide() end
    if f.SetText then f:SetText("") end
  end
  mapIcons = {}
end

local function GetMapParent()
  if WorldMapButton then return WorldMapButton end
  if WorldMapDetailFrame then return WorldMapDetailFrame end
  return nil
end

local function DrawNodesOnMap()
  ClearMapIcons()
  local parent = GetMapParent()
  if not parent then print("|cffff0000No encuentro WorldMapButton|r"); return end
  
  local list = AICAD_WORLDMAP_DB.personal[118] or {}
  if #list==0 then print("|cffffff00No hay nodos para dibujar, pica una mena primero|r"); return end
  
  local W = parent:GetWidth()
  local H = parent:GetHeight()
  if W==0 then W=1002; H=668 end -- tamaño fijo WotLK
  
  for i,n in ipairs(list) do
    -- CUADRITO AMARILLO GRANDE PARA QUE LO VEAS
    local icon = parent:CreateTexture(nil, "OVERLAY")
    icon:SetTexture("Interface\\Buttons\\WHITE8x8")
    icon:SetVertexColor(1, 1, 0, 1) -- amarillo puro
    icon:SetWidth(12)
    icon:SetHeight(12)
    icon:SetPoint("CENTER", parent, "TOPLEFT", n.x*W, -n.y*H)
    icon:Show()
    table.insert(mapIcons, icon)
    
    local txt = parent:CreateFontString(nil, "OVERLAY", "GameFontNormalHuge")
    txt:SetFont("Fonts\\FRIZQT__.TTF", 12, "OUTLINE")
    txt:SetText(i)
    txt:SetTextColor(1,0,0)
    txt:SetPoint("CENTER", parent, "TOPLEFT", n.x*W, -n.y*H-10)
    txt:Show()
    table.insert(mapIcons, txt)
  end
  print("|cff00FF00[AICAD] Dibujados "..#list.." cuadritos amarillos en mapa M|r")
end

local function SaveCurrentPos()
  local x,y = GetPlayerMapPosition("player")
  if x==0 then x=0.43; y=0.39 end -- tu pos de la foto
  local list = AICAD_WORLDMAP_DB.personal[118]
  for _,n in ipairs(list) do
    if math.sqrt((n.x-x)^2 + (n.y-y)^2) < 0.02 then return end
  end
  table.insert(list, {x=x, y=y, name="Saronita"})
  print("|cff00FF00[AICAD GUARDADO] "..math.floor(x*100)..","..math.floor(y*100).." TOTAL: "..#list.."|r")
  DrawNodesOnMap()
end

local f = CreateFrame("Frame")
f:RegisterEvent("CHAT_MSG_LOOT")
f:RegisterEvent("WORLD_MAP_UPDATE")
f:SetScript("OnEvent", function(self, event, msg)
  if event=="CHAT_MSG_LOOT" and msg and (msg:find("Recibes") or msg:find("Saronita") or msg:find("cristalizada")) then
    SaveCurrentPos()
  elseif event=="WORLD_MAP_UPDATE" then
    DrawNodesOnMap()
  end
end)

if WorldMapFrame then
  WorldMapFrame:HookScript("OnShow", function() 
    C_Timer.After(0.2, DrawNodesOnMap) 
  end)
end

SLASH_AICADSAVE1="/aicadsave"
SlashCmdList["AICADSAVE"]=function() SaveCurrentPos() DrawNodesOnMap() end

SLASH_AICADNODESIGHT1="/nodesight"
SLASH_AICADNODESIGHT2="/showmap"
SlashCmdList["AICADNODESIGHT"]=function(msg)
  if msg=="clear" then AICAD_WORLDMAP_DB.personal[118]={}; ClearMapIcons(); print("Borrados")
  else DrawNodesOnMap() end
end

-- COMANDO DE EMERGENCIA PARA VER SI EL MAPA FUNCIONA
SLASH_AICADTESTMAP1="/testmap"
SlashCmdList["AICADTESTMAP"]=function()
  -- Crea 5 cuadritos de prueba en Corona para ver si dibuja
  AICAD_WORLDMAP_DB.personal[118] = {
    {x=0.43, y=0.39}, {x=0.45, y=0.40}, {x=0.50, y=0.45}, {x=0.55, y=0.50}, {x=0.40, y=0.60}
  }
  print("|cff00FF00Creando 5 cuadritos de prueba... abre M|r")
  DrawNodesOnMap()
end

print("|cff00FF00[AICAD v7 MAPA WotLK Cargado - Escribe /testmap y abre M|r")
