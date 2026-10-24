function AICAD_WORLDMAP:GetNodesForDisplay()
  local all={}
  -- BASE1 Personal - editable
  if cfg.showPersonal then
    local list = AICAD_WORLDMAP_DB.personal[118] or {}
    for _,n in ipairs(list) do
      table.insert(all, {x=n.x, y=n.y, displayColor="YELLOW", base="BASE1", canEdit=true})
    end
  end
  -- BASE3 Web Guia - SOLO VER, no editable, solo imagenes
  if cfg.showWeb then
    -- Estos vienen de AICAD_GUIDE.webGuides, no de DB
    for _,g in ipairs(AICAD_GUIDE.webGuides) do
      for _,n in ipairs(g.nodes or {}) do
        table.insert(all, {x=n.x, y=n.y, displayColor="GRAY", base="BASE3", canEdit=false, isGuideImage=true, image=g.image})
      end
    end
  end
  return all
end

function AICAD_WORLDMAP:TryEdit(node)
  if node.base=="BASE3" then
    print("|cffff0000[WEB GUIA] Solo ver, no se edita - Mira imagen ^Herbo 1-95 Durotar^|r")
    return false -- bloquea cualquier edicion
  end
  return true
end
