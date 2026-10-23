-- Auxiliares\WorldMap\WorldMap.lua - 3 DBs Elegibles + Router AI + Skada HD 1-450 - 30300
AICAD_WORLDMAP_DB = AICAD_WORLDMAP_DB or {enabled=true, personal={}, imported={}, layer1=true, layer2=true, layer3=false}
AICAD_ROUTER_DB = AICAD_ROUTER_DB or {usePersonal=true, useGatherMate=true, useWeb=false, modeGold=true, modeLevel=false, maxNodes=40}

local db = AICAD_WORLDMAP_DB
local rdb = AICAD_ROUTER_DB
local pool, poolIdx = {}, 0
local GOLD_BORDER = "Interface\\Minimap\\Tracking\\TrackingBorder"

local function GetFrame()
  poolIdx = poolIdx + 1
  if not pool[poolIdx] then
    local f = CreateFrame("Frame", "AICADWM"..poolIdx, WorldMapDetailFrame)
    f:SetWidth(14) f:SetHeight(14) f:SetFrameLevel(6000)
    f.tex = f:CreateTexture(nil, "OVERLAY") f.tex:SetAllPoints(f)
    f.tex:SetTexCoord(0.08, 0.92, 0.08, 0.92)
    f.border = f:CreateTexture(nil, "OVERLAY") f.border:SetTexture(GOLD_BORDER)
    f.border:SetWidth(26) f.border:SetHeight(26) f.border:SetPoint("CENTER", f, "CENTER", -9.3, 8.7) f.border:Hide()
    f:Hide() pool[poolIdx]=f
  end return pool[poolIdx]
end
local function Clear() for i=1,#pool do pool[i]:Hide() end poolIdx=0 end

local function GetSelectedNodes(mapID)
  local all={}
  if rdb.usePersonal and db.personal[mapID] then for _,n in ipairs(db.personal[mapID]) do table.insert(all,n) end end
  if rdb.useGatherMate and db.imported[mapID] then for _,n in ipairs(db.imported[mapID]) do table.insert(all,n) end end
  if rdb.useWeb and AICAD_GIA_WORLDMAP_NODES and AICAD_GIA_WORLDMAP_NODES[mapID] then for _,n in ipairs(AICAD_GIA_WORLDMAP_NODES[mapID]) do table.insert(all,n) end end
  return all
end

local function DrawWorldMap()
  if not db.enabled then Clear() return end
  Clear()
  local mapID = GetCurrentMapAreaID and GetCurrentMapAreaID() or 378
  local nodes = GetSelectedNodes(mapID)
  for _, n in ipairs(nodes) do
    local f=GetFrame()
    f.tex:SetTexture(n.icon or "Interface\\Icons\\INV_Misc_Herb_01")
    f.tex:SetTexCoord(0.08, 0.92, 0.08, 0.92) f.border:Show()
    f:ClearAllPoints() f:SetPoint("CENTER", WorldMapDetailFrame, "TOPLEFT", n.x*WorldMapDetailFrame:GetWidth(), -n.y*WorldMapDetailFrame:GetHeight()) f:Show()
  end
end

local function SavePersonal(mapID, x, y, icon, name)
  db.personal[mapID]=db.personal[mapID] or {}
  for _,n in ipairs(db.personal[mapID]) do if math.abs(n.x-x)<0.02 and math.abs(n.y-y)<0.02 then return end end
  table.insert(db.personal[mapID], {x=x,y=y,icon=icon,name=name,value=5})
  if #db.personal[mapID]>300 then table.remove(db.personal[mapID],1) end
end

local ev=CreateFrame("Frame")
ev:RegisterEvent("WORLD_MAP_UPDATE") ev:RegisterEvent("MINIMAP_UPDATE_TRACKING") ev:RegisterEvent("ADDON_LOADED")
ev:SetScript("OnEvent", function(self, event, arg1)
  if event=="WORLD_MAP_UPDATE" then DrawWorldMap()
  elseif event=="MINIMAP_UPDATE_TRACKING" then
    local mapID=GetCurrentMapAreaID and GetCurrentMapAreaID() or 0
    if mapID==0 then return end
    local x,y=GetPlayerMapPosition("player")
    if x==0 and y==0 then return end
    for i=1,GetNumTrackingTypes() do
      local name, texture, active=GetTrackingInfo(i)
      if active and texture then SavePersonal(mapID,x,y,texture,name) end
    end
  elseif event=="ADDON_LOADED" and arg1=="AICAD_GIA_WorldMap" then
    print("|cffffcc00[AICAD WorldMap] 3 DBs - /wm on/off - /aicad|r")
  end
end)

SLASH_WORLDMAP1="/wm" SLASH_WORLDMAP2="/worldmap"
SlashCmdList["WORLDMAP"]=function(msg)
  msg=(msg or ""):lower()
  if msg=="off" then db.enabled=false; Clear(); print("WorldMap OFF")
  elseif msg=="on" then db.enabled=true; DrawWorldMap(); print("WorldMap ON")
  elseif msg=="clear" then db.personal={}; Clear(); print("Personal DB borrada")
  else DrawWorldMap() end
end
