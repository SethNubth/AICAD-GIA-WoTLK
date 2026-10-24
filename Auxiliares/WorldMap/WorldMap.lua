function WorldMap:ShowZone(mapID)
  self:Clear()
  if not mapID then
    if GetCurrentMapAreaID then 
      local ok, id = pcall(GetCurrentMapAreaID)
      if ok then mapID = id end
    end
    mapID = mapID or 485
  end
  
  local all = {}
  -- 1. Lee tu Base 1 Personal (ID numérico) - lo que guarda Main.lua solo pasar
  if AICAD_WORLDMAP_DB and AICAD_WORLDMAP_DB.personal and AICAD_WORLDMAP_DB.personal[mapID] then
    for _, n in ipairs(AICAD_WORLDMAP_DB.personal[mapID]) do table.insert(all, n) end
  end
  -- 2. Lee también NodeSight (nombre texto) para que no pierdas nada
  if NodeSightDB and NodeSightDB.nodes then
    local zoneName = GetRealZoneText() or GetZoneText()
    if NodeSightDB.nodes[zoneName] then
      for _, n in ipairs(NodeSightDB.nodes[zoneName]) do
        -- convierte x,y de NodeSight a formato WorldMap
        table.insert(all, {x=n.x, y=n.y, name=n.icon or "Nodo"})
      end
    end
  end
  
  if #all == 0 then return end
  local parent = WorldMapDetailFrame or WorldMapButton or WorldMapFrame
  local pw = parent:GetWidth() if pw == 0 or not pw then pw = 1002 end
  local ph = parent:GetHeight() if ph == 0 or not ph then ph = 668 end
  
  for _, node in ipairs(all) do
    local x = node.x or 0.5; local y = node.y or 0.5
    if x > 1 then x = x / 100 end; if y > 1 then y = y / 100 end
    if x >= 0 and x <= 1 and y >= 0 and y <= 1 then
      local pin = self:GetPin()
      pin.tex:SetTexture(GetIcon(node.name))
      pin:ClearAllPoints()
      pin:SetPoint("CENTER", parent, "TOPLEFT", x * pw, -y * ph)
      pin:Show()
    end
  end
  print("|cff00ff00[AICAD] Mostrando "..#all.." nodos en mapa "..mapID.." | Solo pasar OK|r")
end
