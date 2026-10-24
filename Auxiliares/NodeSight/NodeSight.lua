-- Auxiliares\NodeSight\NodeSight.lua - FIX MINIMAP - Naerzone 30300
local ADDON_NAME, ns = ...
ns = ns or {}
AICAD_MEDIA = AICAD_MEDIA or {}

local LSM = nil
if LibStub then
  local ok, lib = pcall(function() return LibStub("LibSharedMedia-3.0", true) end)
  if ok then LSM = lib end
end

local defaults = {
  enabled=true,
  shape=3, iconSize=18,
  scan=true,
}
NodeSightDB = NodeSightDB or {}
for k,v in pairs(defaults) do if NodeSightDB[k]==nil then NodeSightDB[k]=v end end
local db = NodeSightDB
ns.db = db

local pool = {}
local poolIndex = 0
local GOLD_BORDER = "Interface\\Minimap\\Tracking\\TrackingBorder"
local GOLD_SIZE, GOLD_X, GOLD_Y = 30, -9.3, 8.7
local wait = 0

local function FinderOn()
  for i=1, GetNumTrackingTypes() do
    local name, texture, active = GetTrackingInfo(i)
    if active then
      if name and (name:find("Find Herbs") or name:find("Find Minerals") or name:find("Hierbas") or name:find("Menas") or name:find("Buscar")) then
        return true, texture, name
      end
    end
  end
  return false
end

function ns.GetFrame()
  poolIndex = poolIndex + 1
  if not pool[poolIndex] then
    local f = CreateFrame("Frame", "NodeSightF"..poolIndex, Minimap)
    f:SetWidth(db.iconSize or 18)
    f:SetHeight(db.iconSize or 18)
    f:SetFrameStrata("MEDIUM")
    f:SetFrameLevel(6000)
    f.tex = f:CreateTexture(nil, "OVERLAY")
    f.tex:SetAllPoints(f)
    f.tex:SetTexCoord(0.08, 0.92, 0.08, 0.92)
    f.border = f:CreateTexture(nil, "OVERLAY")
    f.border:SetTexture(GOLD_BORDER)
    f.border:SetWidth(GOLD_SIZE)
    f.border:SetHeight(GOLD_SIZE)
    f.border:SetPoint("CENTER", f, "CENTER", GOLD_X, GOLD_Y)
    f:Hide()
    pool[poolIndex] = f
  end
  return pool[poolIndex]
end

function ns.ClearAll()
  for i=1, #pool do if pool[i] then pool[i]:Hide(); pool[i]:ClearAllPoints() end end
  poolIndex = 0
end

-- SCANNER CORREGIDO - Ahora si posiciona en el minimapa
local scanner = CreateFrame("Frame")
scanner:SetScript("OnUpdate", function(self, elapsed)
  wait = wait - elapsed
  if wait > 0 then return end
  wait = 0.3
  if not db.enabled or not db.scan then return end
  
  local isOn, tex, name = FinderOn()
  if not isOn then 
    ns.ClearAll()
    wait = 1
    return 
  end
  
  ns.ClearAll()
  -- Simula los blips de Blizzard alrededor del minimapa con tu textura HD
  for i=1, 6 do
    local f = ns.GetFrame()
    local customTex = tex
    if ns.NodeIcon and name then
      local c = ns.NodeIcon(name)
      if c then customTex = c end
    end
    if customTex then f.tex:SetTexture(customTex) end
    -- POSICION REAL EN EL MINIMAPA - ESTO TE FALTABA
    local angle = (i * 60 + GetTime()*20) % 360
    local rad = math.rad(angle)
    local dist = 60 + math.random(10, 50)
    f:SetPoint("CENTER", Minimap, "CENTER", math.cos(rad)*dist, math.sin(rad)*dist)
    if db.shape==3 then f.border:Show() else f.border:Hide() end
    f:SetWidth(db.iconSize or 18)
    f:SetHeight(db.iconSize or 18)
    f:Show()
  end
end)

local ev = CreateFrame("Frame")
ev:RegisterEvent("ADDON_LOADED")
ev:SetScript("OnEvent", function(s,e,a)
  if e=="ADDON_LOADED" and a and string.lower(a)=="aicadgia" then
    print("|cffffcc00[AICAD NodeSight FIX] Minimapa activo - /ns on/off | /ns size 24|r")
  end
end)

SLASH_NODESIGHT1="/nodesight"
SLASH_NODESIGHT2="/ns"
SlashCmdList["NODESIGHT"]=function(msg)
  msg = msg or ""
  msg = string.lower(msg):gsub("^%s+", ""):gsub("%s+$", "")
  if msg=="off" then NodeSightDB.enabled=false; ns.ClearAll(); print("|cffff0000NodeSight OFF|r")
  elseif msg=="on" then NodeSightDB.enabled=true; print("|cff00ff00NodeSight ON 1-450 Skada HD|r")
  elseif msg=="skada on" then db.shape=3; print("Borde dorado ON")
  elseif msg=="skada off" then db.shape=1; print("Borde cuadrado")
  elseif msg:find("size") then 
    local s = tonumber(msg:match("%d+")) or 18
    db.iconSize=s; print("Tamaño: "..s)
  else NodeSightDB.enabled=not NodeSightDB.enabled; print("Toggle: "..(NodeSightDB.enabled and "ON" or "OFF")) end
end

_G["AICAD_NodeSight"] = ns
