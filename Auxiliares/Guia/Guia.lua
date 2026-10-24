-- Auxiliares/Guia/Guia.lua - GUIA WEB SOLO VER - No toca DB
AICAD_GUIDE = AICAD_GUIDE or {}
AICAD_GUIDE.webGuides = {
  herbo_durotar = {
    path = "Interface\\AddOns\\AicadGia\\Auxiliares\\Guia\\Images\\Herboristeria\\1-95_Durotar.tga",
    zone="Durotar", range="1-95", prof="Herboristeria"
  },
  mineria_barrens = {
    path = "Interface\\AddOns\\AicadGia\\Auxiliares\\Guia\\Images\\Mineria\\1-75_Durotar_Cobre.tga",
    zone="Barrens", range="1-75", prof="Mineria"
  },
  -- añade más aquí: herbo_barrens, mineria_etc
}

function AICAD_GUIDE:ShowGuide(key)
  local g = self.webGuides[key]
  if not g then 
    print("|cffff0000[GUIA] Guia no encontrada: "..tostring(key).."|r")
    print("|cffFFD700Disponibles: herbo_durotar, mineria_barrens|r")
    return 
  end
  
  -- Solo ver, no toca AICAD_WORLDMAP_DB
  if not GuiaFrame then
    print("|cffff0000[GUIA] GuiaFrame no existe, crea el frame en UI/|r")
    return
  end

  GuiaFrame.texture:SetTexture(g.path)
  GuiaFrame.title:SetText(string.format("%s %s %s", g.prof, g.range, g.zone))
  GuiaFrame:Show()
  
  print(string.format("|cff00FF00[GUIA WEB] Viendo %s %s %s - Solo ver, imagen: %s|r", 
    g.prof, g.range, g.zone, g.path))
end

-- Comando: /aicadguia herbo_durotar
SLASH_AICADGUIA1="/aicadguia"
SlashCmdList["AICADGUIA"]=function(msg)
  msg = msg and string.lower(msg:trim()) or ""
  if msg=="" then 
    print("|cffFFD700Usa: /aicadguia herbo_durotar | /aicadguia mineria_barrens|r")
    return 
  end
  AICAD_GUIDE:ShowGuide(msg)
end
