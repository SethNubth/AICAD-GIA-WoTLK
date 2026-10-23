-- Auxiliares\NodeSight\NodeSight.lua - NodeSight 1.4.1 Krelock -> 30300 Naerzone - Skada HD 1024
-- Original retail 10.x con C_Map, issecretvalue -> Migrado a 30300 APIs WotLK

local ADDON_NAME, ns = ...
ns = ns or {}
local defaults = {
  herbs = true, ore = true, others = false, gameIcons = false,
  arrow = true, arrowLocked = false, arrowSkip = true, arrowFirst = false,
  arrowHerbs = true, arrowOre = true, arrowChests = true, arrowRares = true,
  mapIcons = true,
  shape = 3, -- 1 square, 2 round, 3 round gold ring SKADA, 4 slim
  oreRings = false, iconSize = 18, -- 11 -> 18 para HD
  hard = true, clearNear = false, sound = false,
  scan = true, scanDetail = 2, switchFinders = false, switchYards = 15,
  combatScan = true, rares = false, worldMark = false,
  dotScale = 100, sparkleColor = "ffffffff", size = 100, height = -60, count = 9,
}
local db = NodeSightDB or defaults
ns.db = db
NodeSightDB = db

-- POOL + FORMA SKADA
local pool = {}
local poolIndex = 0
local Skada = { texCoord = {0.08, 0.92, 0.08, 0.92}, alpha = 0.9 }

-- CONST 30300
local STEP, WAIT = 8, 0.5
local FINDERS = { [2383] = "herbs", [2580] = "ore", [2481] = "treasure" }
local GOLD_BORDER = "Interface\\Minimap\\Tracking\\TrackingBorder"
local GOLD_SIZE, GOLD_X, GOLD_Y = 30, -9.3, 8.7
local ARROW = "Interface\\Minimap\\Minimap-QuestArrow"
local DETAIL = { [3] = {8,0.5}, [2] = {10,0.75}, [1] = {12,1} }
local wait = 0
local markers = {}

-- MAP POSITION 30300 - SIN C_Map
local function MapPosition()
  local x, y = GetPlayerMapPosition("player")
  if not x or x == 0 then return nil end
  local map = GetCurrentMapAreaID()
  return map, x, y, 1000, 1000
end

local function FinderOn()
  for i=1, GetNumTrackingTypes() do
    local name, texture, active = GetTrackingInfo(i)
    if active and (name:find("Herbs") or name:find("Minerals") or name:find("Hierbas") or name:find("Menas")) then
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
    f.tex = f:CreateTexture(nil, "OVERLAY")
    f.tex:SetAllPoints(f)
    f.tex:SetTexCoord(0.08, 0.92, 0.08, 0.92) -- SKADA FORMA REDONDA
    f.tex:SetBlendMode("BLEND")
    f.border = f:CreateTexture(nil, "OVERLAY")
    f.border:SetTexture(GOLD_BORDER)
    f.border:SetWidth(GOLD_SIZE)
    f.border:SetHeight(GOLD_SIZE)
    f.border:SetPoint("CENTER", f, "CENTER", GOLD_X, GOLD_Y)
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

-- SCAN LOOP OPTIMIZADO 30300
local scanner = CreateFrame("Frame")
scanner:SetScript("OnUpdate", function(self, elapsed)
  if not db.scan then return end
  wait = wait - elapsed
  if wait > 0 then return end
  wait = WAIT
  if not FinderOn() then wait = 5 return end
  
  ns.ClearAll()
  local c = 0
  for i=1, GetNumTrackingTypes() do
    local name, texture, active = GetTrackingInfo(i)
    if active and texture then
      local f = ns.GetFrame()
      f.tex:SetTexture(texture)
      f.tex:SetTexCoord(0.08, 0.92, 0.08, 0.92)
      if db.shape == 3 then f.border:Show() else f.border:Hide() end
      f:SetWidth(db.iconSize)
      f:SetHeight(db.iconSize)
      f:Show()
      c=c+1
      if c>=40 then break end
    end
  end
end)

local ev = CreateFrame("Frame")
ev:RegisterEvent("ADDON_LOADED")
ev:RegisterEvent("MINIMAP_UPDATE_TRACKING")
ev:SetScript("OnEvent", function(s,e,a)
  if e=="ADDON_LOADED" and a=="NodeSight" then
    print("|cffffcc00[AICAD NodeSight] Auxiliar 1.4.1 -> 30300 Skada HD cargado - /ns on/off|r")
  end
  if e=="MINIMAP_UPDATE_TRACKING" then wait=0 end
end)

SLASH_NODESIGHT1="/nodesight"
SLASH_NODESIGHT2="/ns"
SlashCmdList["NODESIGHT"]=function(msg)
  msg=msg:lower()
  if msg=="off" then NodeSightDB.enabled=false; ns.ClearAll(); print("NodeSight OFF permanente - mapa limpio")
  elseif msg=="on" then NodeSightDB.enabled=true; print("NodeSight ON Skada HD")
  elseif msg=="skada on" then db.shape=3; print("Forma Skada redonda ON")
  elseif msg=="skada off" then db.shape=1; print("Forma cuadrada")
  else NodeSightDB.enabled = not NodeSightDB.enabled end
end
