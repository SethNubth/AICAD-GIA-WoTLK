-- Auxiliares\NodeSight\NodeSight.lua - 1.4.1 Krelock -> 30300 Naerzone - Skada HD 1024 - 1-450 - FINAL 0 ERRORES
local ADDON_NAME, ns = ...
ns = ns or {}
AICAD_MEDIA = AICAD_MEDIA or {}

-- LIBS opcional - si no esta, usa Blizzard
local LSM = nil
if LibStub then
  local ok, lib = pcall(function() return LibStub("LibSharedMedia-3.0", true) end)
  if ok then LSM = lib end
end
local SkadaMediaPath = "Interface\\AddOns\\AicadGia\\Media\\SkadaHD1024.tga"

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
  local ok = pcall(function()
    for i=1, GetNumTrackingTypes() do
      local name, texture, active, category = GetTrackingInfo(i)
      if active and category then
        if category=="spell" or (name and (name:find("Find Herbs") or name:find("Find Minerals") or name:find("Hierbas") or name:find("Menas") or name:find("Buscar"))) then
          return true
        end
      end
    end
  end)
  return ok
end

function ns.GetFrame()
  poolIndex = poolIndex + 1
  if not pool[poolIndex] then
    local f = CreateFrame("Frame", "NodeSightF"..poolIndex, Minimap)
    f:SetWidth(db.iconSize or 18)
    f:SetHeight(db.iconSize or 18)
    f:SetFrameLevel(5000+poolIndex)
    f:SetFrameStrata("MEDIUM")
    f.tex = f:CreateTexture(nil, "OVERLAY")
    f.tex:SetAllPoints(f)
    f.tex:SetTexCoord(0.08, 0.92, 0.08, 0.92)
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
  for i=1, #pool do 
    if pool[i] then pool[i]:Hide() end
  end
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
  local ok = pcall(function()
    for i=1, GetNumTrackingTypes() do
      local name, texture, active, category = GetTrackingInfo(i)
      if active and texture then
        local f = ns.GetFrame()
        if not f then break end
        -- Icono HD de tu Media.lua
        if ns.NodeIcon and name then
          local custom = ns.NodeIcon(name)
          if custom then texture = custom end
        end
        if LSM and name then
          local ok2, t2 = pcall(function() return LSM:Fetch("icon", name) end)
          if ok2 and t2 then texture = t2 end
        end
        f.tex:SetTexture(texture)
        f.tex:SetTexCoord(0.08, 0.92, 0.08, 0.92)
        if db.shape==3 then f.border:Show() else f.border:Hide() end
        f:SetWidth(db.iconSize or 18)
        f:SetHeight(db.iconSize or 18)
        f:Show()
        c=c+1
        if c>=40 then break end
      end
    end
  end)
end)

local ev = CreateFrame("Frame")
ev:RegisterEvent("ADDON_LOADED")
ev:RegisterEvent("MINIMAP_UPDATE_TRACKING")
ev:SetScript("OnEvent", function(s,e,a)
  if e=="ADDON_LOADED" then
    if a and string.lower(a) == "aicadgia" then
      print("|cffffcc00[AICAD NodeSight 1-450] Skada HD 1024 cargado - /ns on/off | /ns skada|r")
    end
  end
  if e=="MINIMAP_UPDATE_TRACKING" then wait=0 end
end)

-- Slash FIX sin trim()
SLASH_NODESIGHT1="/nodesight"
SLASH_NODESIGHT2="/ns"
SlashCmdList["NODESIGHT"]=function(msg)
  msg = msg or ""
  msg = string.lower(msg)
  msg = string.gsub(msg, "^%s+", "")
  msg = string.gsub(msg, "%s+$", "")
  
  if msg=="off" then NodeSightDB.enabled=false; ns.ClearAll(); print("|cffff0000NodeSight OFF permanente - mapa limpio|r")
  elseif msg=="on" then NodeSightDB.enabled=true; print("|cff00ff00NodeSight ON 1-450 Skada HD|r")
  elseif msg=="skada on" then db.shape=3; print("Forma Skada redonda ON - HD 1024")
  elseif msg=="skada off" then db.shape=1; print("Forma cuadrada")
  elseif msg:find("size") then 
    local s = tonumber(string.match(msg, "%d+")) or db.iconSize
    db.iconSize = s
    print("Tamaño: "..s)
  else 
    NodeSightDB.enabled=not NodeSightDB.enabled
    print("NodeSight toggle: "..(NodeSightDB.enabled and "ON" or "OFF"))
  end
end

-- Compat FarSparkles
_G["NodeSight_GetFarFrame"] = function() return nil end
_G["NodeSight_ShowFarSparkles"] = function(x,y) end
_G["AICAD_NodeSight"] = ns

-- FarSparkles.lua ya no necesario
