-- Auxiliares\NodeSight\NodeSight.lua - 1.4.1 Krelock -> 30300 Naerzone - Skada HD 1024 - 1-450 - FINAL LIBS
local ADDON_NAME, ns = ...
ns = ns or {}

-- LIBS - Textura plantas/minería
local LSM = LibStub and LibStub("LibSharedMedia-3.0", true)
local SkadaMedia = "Interface\\AddOns\\AicadGia\\Media\\SkadaHD1024.tga"
if LSM then
  SkadaMedia = LSM:Fetch("statusbar", "Skada HD") or SkadaMedia
end

local defaults = {
  enabled=true,
  herbs=true, ore=true, others=false, gameIcons=false,
  arrow=true, arrowLocked=false, arrowSkip=true, arrowFirst=false,
  arrowHerbs=true, arrowOre=true, arrowChests=true, arrowRares=true,
  mapIcons=true, sparkles=true, worldMark=false,
  shape=3, oreRings=false, iconSize=18,
  hard=true, clearNear=false, sound=false,
  scan=true, scanDetail=2, switchFinders=false, switchYards=15,
  combatScan=true, rares=false,
  dotScale=100, sparkleColor="ffffffff", size=100, height=-60, count=9,
}

-- Clona DB bien sin pisar SavedVariables
NodeSightDB = NodeSightDB or {}
for k,v in pairs(defaults) do if NodeSightDB[k]==nil then NodeSightDB[k]=v end end
local db = NodeSightDB
ns.db = db

local pool = {}
local poolIndex = 0
local STEP, WAIT = 8, 0.5
local GOLD_BORDER = "Interface\\Minimap\\Tracking\\TrackingBorder"
local GOLD_SIZE, GOLD_X, GOLD_Y = 30, -9.3, 8.7
local wait = 0

local function FinderOn()
  for i=1, GetNumTrackingTypes() do
    local name, texture, active, category = GetTrackingInfo(i)
    if active and category and (category=="spell" or name:find("Find Herbs") or name:find("Find Minerals") or name:find("Hierbas") or name:find("Menas") or name:find("Buscar")) then
      return true
    end
  end
  return false
end

function ns.GetFrame()
  poolIndex = poolIndex + 1
  if not pool[poolIndex] then
    local f = CreateFrame("Frame", "NodeSightF"..poolIndex, Minimap)
    f:SetWidth(db.iconSize)
    f:SetHeight(db.iconSize)
    f:SetFrameLevel(5000+poolIndex)
    f:SetFrameStrata("MEDIUM")
    f.tex = f:CreateTexture(nil, "OVERLAY")
    f.tex:SetAllPoints(f)
    f.tex:SetTexCoord(0.08, 0.92, 0.08, 0.92)
    f.tex:SetBlendMode("BLEND")
    -- Skada HD 1024 Border
    f.border = f:CreateTexture(nil, "OVERLAY")
    f.border:SetTexture(GOLD_BORDER)
    f.border:SetWidth(GOLD_SIZE)
    f.border:SetHeight(GOLD_SIZE)
    f.border:SetPoint("CENTER", f, "CENTER", GOLD_X, GOLD_Y)
    if LSM then f.border:SetTexture(SkadaMedia) end
    f.border:Hide()
    f:Hide()
    pool[poolIndex] = f
  end
  return pool[poolIndex]
end

function ns.ClearAll()
  for i=1, #pool do pool[i]:Hide() end
  poolIndex = 0
end

local scanner = CreateFrame("Frame")
scanner:SetScript("OnUpdate", function(self, elapsed)
  if not db.enabled then return end
  if not db.scan then return end
  wait = wait - elapsed
  if wait > 0 then return end
  wait = WAIT
  if not FinderOn() then wait=2 return end
  ns.ClearAll()
  local c=0
  for i=1, GetNumTrackingTypes() do
    local name, texture, active, category = GetTrackingInfo(i)
    if active and texture then
      local f = ns.GetFrame()
      f.tex:SetTexture(texture)
      if LSM and (name:find("Herb") or name:find("Mineral")) then
        -- Usa textura HD de Libs para plantas/minería
        f.tex:SetTexture(LSM:Fetch("icon", name) or texture)
      end
      f.tex:SetTexCoord(0.08, 0.92, 0.08, 0.92)
      if db.shape==3 then f.border:Show() else f.border:Hide() end
      f:SetWidth(db.iconSize)
      f:SetHeight(db.iconSize)
      f:Show()
      c=c+1
      if c>=50 then break end
    end
  end
end)

local ev = CreateFrame("Frame")
ev:RegisterEvent("ADDON_LOADED")
ev:RegisterEvent("MINIMAP_UPDATE_TRACKING")
ev:SetScript("OnEvent", function(s,e,a)
  if e=="ADDON_LOADED" and (a=="AicadGia" or a=="AICAD_GIA_NodeSight" or a:lower():find("aicadgia")) then
    NodeSightDB.enabled = NodeSightDB.enabled==nil and true or NodeSightDB.enabled
    print("|cffffcc00[AICAD NodeSight 1-450] Skada HD 1024 + Libs cargado - /ns on/off | /ns skada|r")
  end
  if e=="MINIMAP_UPDATE_TRACKING" then wait=0 end
end)

SLASH_NODESIGHT1="/nodesight"
SLASH_NODESIGHT2="/ns"
SlashCmdList["NODESIGHT"]=function(msg)
  msg=(msg or ""):lower():trim()
  if msg=="off" then NodeSightDB.enabled=false; ns.ClearAll(); print("|cffff0000NodeSight OFF permanente - mapa limpio|r")
  elseif msg=="on" then NodeSightDB.enabled=true; print("|cff00ff00NodeSight ON 1-450 Skada HD|r")
  elseif msg=="skada on" then db.shape=3; print("Forma Skada redonda ON - HD 1024")
  elseif msg=="skada off" then db.shape=1; print("Forma cuadrada")
  elseif msg=="size" then print("Tamaño actual: "..db.iconSize)
  else NodeSightDB.enabled=not NodeSightDB.enabled; print("NodeSight toggle: "..(NodeSightDB.enabled and "ON" or "OFF")) end
end
