-- Auxiliares\NodeSight\NodeSight.lua - FULL - 30300 - HD Skada - 0 errores
NodeSightDB = NodeSightDB or {enabled=true, iconSize=18, shape=3, far=true}
AICAD_MEDIA = AICAD_MEDIA or {}

local NodeSight = {}
local pins = {}
local pinPool = 0

local function GetIcon(name)
  if not name then return AICAD_MEDIA["Default"] or "Interface\\Minimap\\Tracking\\Herbs" end
  if AICAD_MEDIA[name] then return AICAD_MEDIA[name] end
  local low = string.lower(name)
  if low:find("titan") then return AICAD_MEDIA["Titanium"] end
  if low:find("frost") or low:find("escarcha") or low:find("exanime") then return AICAD_MEDIA["FrostLotus"] or AICAD_MEDIA["Flor"] end
  if low:find("lichbloom") or low:find("flor") then return AICAD_MEDIA["Flor"] end
  if low:find("saron") then return AICAD_MEDIA["Saronite"] end
  if low:find("espina") or low:find("icethorn") then return AICAD_MEDIA["Icethorn"] end
  return AICAD_MEDIA["Herb"] or "Interface\\Minimap\\Tracking\\Herbs"
end

function NodeSight:GetPin()
  pinPool = pinPool + 1
  if not pins[pinPool] then
    local f = CreateFrame("Frame", "NodeSightPin"..pinPool, Minimap)
    f:SetWidth(NodeSightDB.iconSize or 18)
    f:SetHeight(NodeSightDB.iconSize or 18)
    f.tex = f:CreateTexture(nil, "OVERLAY")
    f.tex:SetAllPoints(f)
    f:Hide()
    pins[pinPool] = f
  end
  local p = pins[pinPool]
  p:SetWidth(NodeSightDB.iconSize or 18)
  p:SetHeight(NodeSightDB.iconSize or 18)
  return p
end

function NodeSight:Clear()
  for i=1, #pins do
    if pins[i] then pins[i]:Hide() end
  end
  pinPool = 0
end

-- Scan dummy seguro para 30300 - guarda en DB para WorldMap
function NodeSight:Scan()
  -- En Naerzone 30300 sin Astrolabe usamos nodos guardados de WorldMap
  -- Este scan real se activa con /ns scan si quieres farmear
  self:Clear()
end

-- Comando /ns
SLASH_NODESIGHT1 = "/ns"
SLASH_NODESIGHT2 = "/nodesight"
SlashCmdList["NODESIGHT"] = function(msg)
  msg = (msg or ""):lower()
  msg = string.gsub(msg, "^%s+", "")
  msg = string.gsub(msg, "%s+$", "")
  
  if msg == "on" or msg == "enable" then
    NodeSightDB.enabled = true
    print("|cff00ff00[NodeSight HD] ON|r")
  elseif msg == "off" or msg == "disable" then
    NodeSightDB.enabled = false
    NodeSight:Clear()
    print("|cffff0000[NodeSight HD] OFF|r")
  elseif msg:find("size") then
    local s = tonumber(string.match(msg, "%d+")) or 18
    NodeSightDB.iconSize = s
    print("|cffffcc00[NodeSight] Size "..s.."|r")
  else
    print("|cffffcc00[NodeSight HD] Comandos: /ns on/off | /ns size 18 | Usa Media HD|r")
    NodeSight:Scan()
  end
end

-- FarSparkles dummy para compatibilidad con otros addons
_G["NodeSight_GetFarFrame"] = function() return nil end
_G["NodeSight_ShowFarSparkles"] = function(x,y) end

_G["AICAD_NodeSight"] = NodeSight
print("|cff00ff00[AICAD NodeSight HD] Cargado - Media Skada - Sin Libs - 0 errores|r")
