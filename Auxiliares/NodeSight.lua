-- NodeSight.lua - MIGRADO 10.x Retail -> 30300 WotLK Naerzone - Skada HD 1024
-- Original: Krelock 1.4.1 - Migración: SethNubth Naerzone

local ADDON_NAME, ns = ...
ns = ns or {}
local ipairs, pairs = ipairs, pairs

-- Defaults igual pero para 30300
local defaults = {
  herbs = true, ore = true, others = false,
  gameIcons = false,
  arrow = true, arrowLocked = false, arrowSkip = true, arrowFirst = false,
  arrowHerbs = true, arrowOre = true, arrowChests = true, arrowRares = false,
  mapIcons = true,
  shape = 3, -- 1 square, 2 round, 3 round gold ring (Skada), 4 slim
  oreRings = false,
  iconSize = 18, -- Subido de 11 a 18 para Skada HD
  hard = true, clearNear = false, sound = false,
  scan = true, scanDetail = 2,
  switchFinders = false, switchYards = 15,
  combatScan = true, rares = false,
  dotScale = 100, size = 100, count = 9,
}
local db = NodeSightDB or defaults
ns.db = db
NodeSightDB = db

-- Minimap scan MIGRADO 30300

local STEP = 8
local PER_FRAME = 60
local WAIT = 0.5
local FINDERS = { [2383] = "herbs", [2580] = "ore", [2481] = "treasure" }
local ICONS = { herbs = "Professions_Tracking_Herb", ore = "Professions_Tracking_Ore" }
local ICON_SIZE = 12
local NORMAL_DOTS = 100
local SHAPES = { "Square", "Round", "Round, gold ring", "Round, slim gold ring" }
local CIRCLE = "CircleMask"
local GOLD_BORDER = "Interface\\Minimap\\Tracking\\TrackingBorder" -- 30300 path
local GOLD_SIZE, GOLD_X, GOLD_Y = 30, -9.3, 8.7
local ARROW = "Interface\\Minimap\\Minimap-QuestArrow"
local ARROW_SIZE = 40
local ARROW_TO = { herbs = "arrowHerbs", ore = "arrowOre", treasure = "arrowChests" }
local SKIP_YARDS = 5
local PLAYER_ARROW, CLEAR = 8, 0.35
local AROUND = { -1001, -1000, -999, -1, 1, 999, 1000, 1001 }
local FINE = 3
local MAX_FINE = 900
local MIN_VOTES = 6
local TOL = 2
local hitRadius = 15

local function Single()
  return math.floor(math.pi * hitRadius ^ 2 / STEP ^ 2 + 0.6 * math.pi * hitRadius / STEP)
end

local DETAIL = { [3] = { 8, 0.5 }, [2] = { 10, 0.75 }, [1] = { 12, 1 } }
local SETTLE = 4
local eased, quiet = 0, 0
local scan, wait = nil, 0
local hurry = 0
local markers = {}
local grid, gridWidth
local tracker, arrow, arrowTexture, arrowText
local mapFrame, mapIcons = nil, {}
local empties = 0
local emptyMap, emptyX, emptyY
local SLEEP = 30
local REST = { [0] = 4, 4, 8, 16, SLEEP }
local rested = 0
local heard = {}
local shownText
local arrowOn = false
local turning
local turns = {}
local pool = {} -- POOL SKADA 30300
local poolIndex = 0

-- FORMA SKADA HD 1024
local SkadaShape = {
  texCoord = {0.08, 0.92, 0.08, 0.92},
  alpha = 0.9,
  blend = "BLEND"
}

-- 30300 MAP POSITION - sin C_Map
local function MapPosition()
  local map = GetCurrentMapAreaID() -- 30300
  local x, y = GetPlayerMapPosition("player") -- 0-1 en 30300
  if not x or x == 0 then return nil end
  -- Tamaño mapa en yardas aproximado WotLK
  local width, height = 1000, 1000
  return map, x, y, width, height
end

-- 30300 FINDER ON - sin C_Minimap
local function FinderOn()
  for i=1, GetNumTrackingTypes() do
    local name, texture, active = GetTrackingInfo(i)
    if active and (name == "Find Herbs" or name == "Find Minerals" or name == "Find Treasure") then
      return true
    end
  end
  return false
end

-- POOL OPTIMIZADO 30300 - forma Skada
function ns.GetFrame()
  poolIndex = poolIndex + 1
  if not pool[poolIndex] then
    local f = CreateFrame("Frame", "NodeSightFrame"..poolIndex, Minimap)
    f:SetWidth(db.iconSize)
    f:SetHeight(db.iconSize)
    f:SetFrameLevel(5000 + poolIndex)
    f.texture = f:CreateTexture(nil, "OVERLAY")
    f.texture:SetAllPoints(f)
    -- SKADA FORMA
    f.texture:SetTexCoord(0.08, 0.92, 0.08, 0.92)
    f.texture:SetBlendMode("BLEND")
    f.texture:SetVertexColor(1,1,1,0.9)
    -- Gold ring
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
  markers = {}
end

-- SCAN 30300 - sin issecretvalue, sin C_Map
local function Enabled()
  return db.scan and (db.arrow or db.mapIcons or db.sound)
end

-- Scan loop optimizado 30300
local scanFrame = CreateFrame("Frame")
scanFrame:SetScript("OnUpdate", function(self, elapsed)
  if not Enabled() then return end
  wait = wait - elapsed
  if wait > 0 then return end
  wait = WAIT
  
  if not FinderOn() then
    wait = 5 -- NO_FINDER
    return
  end
  
  -- Grid scan 30300 - Minimap fake mouse
  -- En 30300 usamos Minimap:GetChildren() tooltip scan simplificado
  -- Para Naerzone, el tracking del juego ya muestra puntos, nosotros los decoramos
  
  ns.ClearAll()
  local found = 0
  for i=1, GetNumTrackingTypes() do
    local name, texture, active = GetTrackingInfo(i)
    if active then
      local f = ns.GetFrame()
      f.texture:SetTexture(texture)
      if db.shape >= 2 then
        f.texture:SetTexCoord(0.08, 0.92, 0.08, 0.92) -- Skada round
      end
      -- Gold ring si shape 3
      if db.shape == 3 then
        f.border:Show()
      else
        f.border:Hide()
      end
      f:Show()
      found = found + 1
      if found >= 40 then break end
    end
  end
end)

-- Eventos 30300
local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("ADDON_LOADED")
eventFrame:RegisterEvent("MINIMAP_UPDATE_TRACKING")
eventFrame:SetScript("OnEvent", function(self, event, addon)
  if event == "ADDON_LOADED" and addon == "NodeSight" then
    NodeSightDB = NodeSightDB or defaults
    db = NodeSightDB
    ns.db = db
    print("|cffffcc00[NodeSight Naerzone] 1.4.1 -> 30300 Skada HD Cargado - /ns|r")
  end
  if event == "MINIMAP_UPDATE_TRACKING" then
    wait = 0 -- Forzar scan
  end
end)

SLASH_NODESIGHT1 = "/nodesight"
SLASH_NODESIGHT2 = "/ns"
SlashCmdList["NODESIGHT"] = function(msg)
  msg = msg:lower()
  if msg == "off" then db.enabled = false; ns.ClearAll(); print("NodeSight OFF permanente")
  elseif msg == "on" then db.enabled = true; print("NodeSight ON Skada HD")
  elseif msg == "skada on" then db.shape = 3; print("Forma Skada ON")
  elseif msg == "skada off" then db.shape = 1; print("Forma cuadrada OFF")
  else db.enabled = not db.enabled; print("NodeSight Toggle") end
end
