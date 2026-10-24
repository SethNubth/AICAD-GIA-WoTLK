-- DIBUJA TODO LO GUARDADO - FIX HD
function ns.DrawSaved()
  if not db.enabled then return end
  ns.ClearAll()
  local map = GetRealZoneText() or GetZoneText()
  if not NodeSightDB.nodes[map] then return end
  
  local px, py = GetPlayerMapPosition("player")
  if px==0 and py==0 then px=0.5; py=0.5 end
  
  for _,node in ipairs(NodeSightDB.nodes[map]) do
    -- MINIMAPA: solo si estás cerca (150 yardas)
    local dx = (node.x - px) * 800
    local dy = (node.y - py) * 800
    if math.abs(dx)<130 and math.abs(dy)<130 then
      local f = ns.GetMiniFrame()
      f.tex:SetTexture(node.icon)
      f:SetPoint("CENTER", Minimap, "CENTER", dx, -dy)
      if db.shape==3 then f.border:Show() else f.border:Hide() end
      f:SetWidth(db.iconSize); f:SetHeight(db.iconSize)
      f:Show()
    end
    -- WORLD MAP: siempre que abras M
    if WorldMapFrame:IsVisible() and db.worldIcons then
      local wf = ns.GetWorldFrame()
      wf.tex:SetTexture(node.icon)
      wf:SetPoint("CENTER", WorldMapDetailFrame, "TOPLEFT", node.x*WorldMapDetailFrame:GetWidth(), -node.y*WorldMapDetailFrame:GetHeight())
      wf:SetWidth(db.iconSize+4); wf:SetHeight(db.iconSize+4)
      wf:Show()
    end
  end
end
