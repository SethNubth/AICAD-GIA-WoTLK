-- AICAD WorldMap.lua v12 - 3 BASES SEPARADAS
AICAD_WORLDMAP_DB = AICAD_WORLDMAP_DB or {}
AICAD_WORLDMAP_DB.personal = AICAD_WORLDMAP_DB.personal or {} -- BASE 1: Personal
AICAD_WORLDMAP_DB.personal[118] = AICAD_WORLDMAP_DB.personal[118] or {}

AICAD_WORLDMAP_DB.shared = AICAD_WORLDMAP_DB.shared or {} -- BASE 2: Compartida / GatherMate
AICAD_WORLDMAP_DB.shared[118] = AICAD_WORLDMAP_DB.shared[118] or {}

AICAD_WORLDMAP_DB.web = AICAD_WORLDMAP_DB.web or {} -- BASE 3: Web Dibujo - SOLO VER
AICAD_WORLDMAP_DB.web[118] = AICAD_WORLDMAP_DB.web[118] or {} -- Tu Base 3 actual que no se toca

-- Config que base se ve
AICAD_WORLDMAP_DB.config = AICAD_WORLDMAP_DB.config or {showPersonal=true, showShared=false, showWeb=true}

function AICAD_WORLDMAP:SaveNode(x,y,name)
  -- SOLO GUARDA EN BASE 1 PERSONAL, nunca toca 2 y 3
  local mapID=118
  local list=AICAD_WORLDMAP_DB.personal[mapID]
  -- anti duplicado
  for _,n in ipairs(list) do if math.sqrt((n.x-x)^2+(n.y-y)^2)<0.015 then return end end
  table.insert(list, {x=x,y=y,name=name or "Saronita", time=time()})
  print(string.format("|cff00FF00[BASE 1 PERSONAL] Guardado %d,%d Total: %d|r", x*100, y*100, #list))
end

function AICAD_WORLDMAP:GetNodesForRouter()
  -- Router SOLO usa BASE 1 Personal para 45/120
  return AICAD_WORLDMAP_DB.personal[118] or {}
end

function AICAD_WORLDMAP:GetNodesForDisplay()
  -- Display muestra las 3 con colores distintos
  local all={}
  if AICAD_WORLDMAP_DB.config.showPersonal then for _,n in ipairs(AICAD_WORLDMAP_DB.personal[118] or {}) do n.color="YELLOW"; table.insert(all,n) end end
  if AICAD_WORLDMAP_DB.config.showShared then for _,n in ipairs(AICAD_WORLDMAP_DB.shared[118] or {}) do n.color="GREEN"; table.insert(all,n) end end
  if AICAD_WORLDMAP_DB.config.showWeb then for _,n in ipairs(AICAD_WORLDMAP_DB.web[118] or {}) do n.color="GRAY"; table.insert(all,n) end end
  return all
end
