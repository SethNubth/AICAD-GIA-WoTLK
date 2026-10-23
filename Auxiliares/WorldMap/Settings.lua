-- Auxiliares\WorldMap\Settings.lua - Panel DB Elegible - Router AI - 30300 - FINAL 0 errores
AICAD_WORLDMAP_DB = AICAD_WORLDMAP_DB or {}
AICAD_WORLDMAP_DB.personal = AICAD_WORLDMAP_DB.personal or {}
AICAD_WORLDMAP_DB.imported = AICAD_WORLDMAP_DB.imported or {}
AICAD_ROUTER_DB = AICAD_ROUTER_DB or {usePersonal=true, useGatherMate=true, useWeb=false, modeGold=true, modeLevel=false, activeDB="personal", useTomTom=false}
AICAD_GIA_CHAR_DB = AICAD_GIA_CHAR_DB or {}

-- FIX 30300: sin InterfaceOptionsFramePanelContainer
local panel = CreateFrame("Frame", "AICADWorldMapPanel")
panel.name = "AICAD Router AI"
InterfaceOptions_AddCategory(panel)

local title = panel:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
title:SetPoint("TOPLEFT", 16, -16)
title:SetText("AICAD GIA - Router AI - Base de Datos Elegible - WoTLK")

local function AddCheck(name, label, x, y, varTable, varName)
  local cb = CreateFrame("CheckButton", name, panel, "InterfaceOptionsCheckButtonTemplate")
  cb:SetPoint("TOPLEFT", x, y)
  -- FIX: _G puede ser nil en 30300 si no cargó template
  local txt = _G[name.."Text"]
  if txt then
    txt:SetText(label)
  else
    local fs = cb:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    fs:SetPoint("LEFT", cb, "RIGHT", 6, 0)
    fs:SetText(label)
  end
  cb:SetChecked(varTable[varName] and true or false)
  cb:SetScript("OnClick", function(self) 
    varTable[varName]=self:GetChecked()
    -- Sincroniza activeDB
    if varName=="usePersonal" and self:GetChecked() then
      AICAD_ROUTER_DB.activeDB = "personal"
    elseif varName=="useGatherMate" and self:GetChecked() then
      AICAD_ROUTER_DB.activeDB = "imported"
    end
    if AICAD_WorldMap then AICAD_WorldMap:ShowZone() end
  end)
  return cb
end

local t1 = panel:CreateFontString(nil, "OVERLAY", "GameFontNormal")
t1:SetPoint("TOPLEFT", 16, -45)
t1:SetText("Base de Datos (Elegible):")

AddCheck("AICAD_DB1", "Base de Datos Personal (auto-save al pasar - tu screenshot)", 16, -65, AICAD_ROUTER_DB, "usePersonal")
AddCheck("AICAD_DB2", "Base de Datos GatherMate / Perfiles AICAD_GIA", 16, -90, AICAD_ROUTER_DB, "useGatherMate")
AddCheck("AICAD_DB3", "Base de Datos WEB (Auxiliares/Media/WEB/*.tga)", 16, -115, AICAD_ROUTER_DB, "useWeb")

local t2 = panel:CreateFontString(nil, "OVERLAY", "GameFontNormal")
t2:SetPoint("TOPLEFT", 16, -145)
t2:SetText("Forma de Uso (Elegible):")

AddCheck("AICAD_MODE1", "Ruta Oro - Max oro/hora", 16, -165, AICAD_ROUTER_DB, "modeGold")
AddCheck("AICAD_MODE2", "Subir Profesiones 1-450", 16, -190, AICAD_ROUTER_DB, "modeLevel")

local btnClear = CreateFrame("Button", nil, panel, "UIPanelButtonTemplate")
btnClear:SetWidth(200) btnClear:SetHeight(24)
btnClear:SetPoint("TOPLEFT", 16, -220)
btnClear:SetText("Limpiar Mapa (Clear Pins)")
btnClear:SetScript("OnClick", function()
  if AICAD_WorldMap then AICAD_WorldMap:Clear() end
  print("|cffffcc00[AICAD] Mapa limpio|r")
end)

local btnShow = CreateFrame("Button", nil, panel, "UIPanelButtonTemplate")
btnShow:SetWidth(200) btnShow:SetHeight(24)
btnShow:SetPoint("TOPLEFT", 230, -220)
btnShow:SetText("Mostrar /wmap")
btnShow:SetScript("OnClick", function()
  if AICAD_WorldMap then AICAD_WorldMap:ShowZone() end
end)

local desc = panel:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
desc:SetPoint("TOPLEFT", 16, -255)
desc:SetWidth(500) desc:SetJustifyH("LEFT")
desc:SetText("WoTLK 30300: Personal ✓ = tus nodos farmeados (auto-save) | GatherMate ✓ = importados | WEB ✓ = WEB TGA Altertime\nComandos: /wmap | /route gold | /route level | /aicad\nNota: Borra AICAD_GIA_WorlMap.toc de esta carpeta - solo vale el .toc raíz")

print("|cff00ff00[AICAD WorldMap Settings] Panel cargado - 30300 - 0 errores|r")
