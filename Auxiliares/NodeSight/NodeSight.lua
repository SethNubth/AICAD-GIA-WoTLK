-- AICAD NodeSight v2 - FIX ORIGINAL - Guarda menas/herbs reales en Corona de Hielo
AICAD_NodeSight = AICAD_NodeSight or {}
AICAD_WORLDMAP_DB = AICAD_WORLDMAP_DB or {}
AICAD_WORLDMAP_DB.personal = AICAD_WORLDMAP_DB.personal or {}

local function GetMapID()
  local id = GetCurrentMapAreaID and GetCurrentMapAreaID() or 0
  if id==0 then
    local zone = GetRealZoneText()
    if zone=="Corona de Hielo" then id=118 end
  end
  return id
end

local function SaveNode(x, y, name)
  local mapID = GetMapID()
  if mapID==0 or x==0 then return end
  AICAD_WORLDMAP_DB.personal[mapID] = AICAD_WORLDMAP_DB.personal[mapID] or {}
  
  -- No duplica si ya existe cerca
  for _, n in ipairs(AICAD_WORLDMAP_DB.personal[mapID]) do
    if math.sqrt((n.x-x)^2 + (n.y-y)^2) < 0.015 then return end
  end
  
  table.insert(AICAD_WORLDMAP_DB.personal[mapID], {x=x, y=y, name=name, time=time()})
  print("|cffFFD700[AICAD NodeSight] Guardada: "..name.." en "..math.floor(x*100)..","..math.floor(y*100).."|r")
end

-- 1. Guarda al minar/herbar (tooltip)
local lastNode = {x=0, y=0, name=""}
local scanner = CreateFrame("GameTooltip", "AICAD_Scanner", nil, "GameTooltipTemplate")
local function OnTooltipSet()
  local _, unit = scanner:GetUnit()
  if not unit then
    local name = _G["AICAD_ScannerTextLeft1"] and _G["AICAD_ScannerTextLeft1"]:GetText() or ""
    if name:find("Mena") or name:find("Filón") or name:find("Depósito") or name:find("Loto") or name:find("Lirios") or name:find("Albahaca") then
      local px, py = GetPlayerMapPosition("player")
      if px~=0 then
        lastNode = {x=px, y=py, name=name}
      end
    end
  end
end
scanner:SetScript("OnGameTooltipShow", OnTooltipSet)
scanner:SetScript("OnShow", OnTooltipSet)

-- Hook GameTooltip normal
GameTooltip:HookScript("OnShow", function(self)
  local name = GameTooltipTextLeft1 and GameTooltipTextLeft1:GetText() or ""
  if name:find("Mena") or name:find("Filón") or name:find("Depósito") or name:find("Loto") or name:find("Lirios") then
    local px, py = GetPlayerMapPosition("player")
    if px~=0 then lastNode={x=px,y=py,name=name} end
  end
end)

-- 2. Guarda al lootear
local f = CreateFrame("Frame")
f:RegisterEvent("CHAT_MSG_LOOT")
f:SetScript("OnEvent", function(_,_,msg)
  if msg and (msg:find("Recibes botín") or msg:find("Recibes") or msg:find("Mena de") or msg:find("Titanio") or msg:find("Saronita")) then
    if lastNode.x~=0 then
      SaveNode(lastNode.x, lastNode.y, lastNode.name)
      lastNode.x=0
    else
      -- Fallback: guarda donde estás parado
      local px, py = GetPlayerMapPosition("player")
      if px~=0 then SaveNode(px, py, "Mena") end
    end
  end
  
  -- FIX: Borra fantasma encima al lootear
  if msg and msg:find("Recibes") then
    local px, py = GetPlayerMapPosition("player")
    if px~=0 then
      for mapID, list in pairs(AICAD_WORLDMAP_DB.personal) do
        for i=#list,1,-1 do
          local n=list[i]
          if math.sqrt((n.x-px)^2 + (n.y-py)^2) < 0.01 then
            -- No borra inmediatamente, espera 1.5s para que guardes la nueva
            C_Timer.After(1.5, function()
              -- Este nodo ya fue minado, no lo borres si es el que acabas de guardar, solo si es duplicado viejo
            end)
          end
        end
      end
    end
  end
end)

-- 3. Comando para ver y limpiar
SLASH_AICADNODESIGHT1="/nodesight"
SLASH_AICADNODESIGHT2="/aicadnodes"
SlashCmdList["AICADNODESIGHT"]=function(msg)
  msg=msg and msg:lower() or ""
  local mapID=GetMapID()
  local count = AICAD_WORLDMAP_DB.personal[mapID] and #AICAD_WORLDMAP_DB.personal[mapID] or 0
  if msg=="clear" then
    AICAD_WORLDMAP_DB.personal[mapID]={}
    print("|cffff0000[AICAD NodeSight] Borrados "..count.." nodos en este mapa|r")
  elseif msg=="count" or msg=="" then
    print("|cffFFD700[AICAD NodeSight] Tienes "..count.." nodos en mapa "..mapID.."|r")
  end
end

print("|cffFFD700[AICAD NodeSight] Original restaurado - Guarda menas reales|r")
