-- AICAD WorldMap.lua v14 - FINAL LIMPIO: No muta, copia display, threshold config
AICAD_WORLDMAP_DB = AICAD_WORLDMAP_DB or {}
AICAD_WORLDMAP_DB.personal = AICAD_WORLDMAP_DB.personal or {}
AICAD_WORLDMAP_DB.shared = AICAD_WORLDMAP_DB.shared or {}
AICAD_WORLDMAP_DB.web = AICAD_WORLDMAP_DB.web or {}
AICAD_WORLDMAP_DB.config = AICAD_WORLDMAP_DB.config or {
  showPersonal=true, 
  showShared=false, 
  showWeb=true,
  dupThreshold=0.015, -- configurable: 0.015 = 25 yardas, 0.008 = 12 yardas si mapa mucha precision
}

local function EnsureList(base, zoneID)
  zoneID = zoneID or 118
  AICAD_WORLDMAP_DB[base] = AICAD_WORLDMAP_DB[base] or {}
  local list = AICAD_WORLDMAP_DB[base][zoneID] or {}
  AICAD_WORLDMAP_DB[base][zoneID] = list
  return list
end

function AICAD_WORLDMAP:SaveNode(x,y,name)
  -- SOLO BASE 1 PERSONAL
  local list = EnsureList("personal", 118)
  local threshold = AICAD_WORLDMAP_DB.config.dupThreshold or 0.015
  
  for _,n in ipairs(list) do
    if math.sqrt((n.x-x)^2 + (n.y-y)^2) < threshold then return end -- usa threshold config
  end
  
  table.insert(list, {x=x, y=y, name=name, zoneID=118, time=time()})
  print(string.format("|cff00FF00[BASE1] Guardado %d,%d | Threshold %.3f | Total %d|r", x*100, y*100, threshold, #list))
end

function AICAD_WORLDMAP:GetNodesForDisplay()
  -- COPIA TEMPORAL - nunca muta originales
  local all = {}
  local cfg = AICAD_WORLDMAP_DB.config
  
  if cfg.showPersonal then
    local list = AICAD_WORLDMAP_DB.personal[118] or {}
    for _,n in ipairs(list) do
      table.insert(all, {x=n.x, y=n.y, name=n.name, displayColor="YELLOW", displayBase="BASE1"})
    end
  end
  if cfg.showShared then
    local list = AICAD_WORLDMAP_DB.shared[118] or {}
    for _,n in ipairs(list) do
      table.insert(all, {x=n.x, y=n.y, name=n.name, displayColor="GREEN", displayBase="BASE2"})
    end
  end
  if cfg.showWeb then
    local list = AICAD_WORLDMAP_DB.web[118] or {}
    for _,n in ipairs(list) do
      table.insert(all, {x=n.x, y=n.y, name=n.name, displayColor="GRAY", displayBase="BASE3"})
    end
  end
  return all
end

-- Comando para ajustar threshold si mapa tiene mucha precision
SLASH_AICADTHRESH1="/aicadthresh"
SlashCmdList["AICADTHRESH"]=function(msg)
  local v = tonumber(msg)
  if v then
    AICAD_WORLDMAP_DB.config.dupThreshold = v
    print("|cffFFD700Threshold duplicados ajustado a "..v.." | 0.015=25yds 0.008=12yds 0.02=35yds|r")
  else
    print("|cffFFD700Threshold actual: "..(AICAD_WORLDMAP_DB.config.dupThreshold or 0.015).." | Usa /aicadthresh 0.008|r")
  end
end

EnsureList("personal",118)
EnsureList("shared",118)
EnsureList("web",118)

print("|cff00FF00[WorldMap v14 FINAL - No muta, copia display, threshold config]|r")
