-- Auxiliares\WorldMap\Settings.lua - Panel DB Elegible - Router AI - 30300
AICAD_WORLDMAP_DB = AICAD_WORLDMAP_DB or {}
AICAD_ROUTER_DB = AICAD_ROUTER_DB or {usePersonal=true, useGatherMate=true, useWeb=false, modeGold=true, modeLevel=false}

local panel = CreateFrame("Frame", "AICADWorldMapPanel", InterfaceOptionsFramePanelContainer)
panel.name = "AICAD Router AI"
InterfaceOptions_AddCategory(panel)

local title = panel:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
title:SetPoint("TOPLEFT", 16, -16)
title:SetText("AICAD GIA - Router AI - Base de Datos Elegible")

local function AddCheck(name, label, x, y, varTable, varName)
  local cb = CreateFrame("CheckButton", name, panel, "InterfaceOptionsCheckButtonTemplate")
  cb:SetPoint("TOPLEFT", x, y)
  _G[name.."Text"]:SetText(label)
  cb:SetChecked(varTable[varName])
  cb:SetScript("OnClick", function(self) varTable[varName]=self:GetChecked() end)
  return cb
end

local t1 = panel:CreateFontString(nil, "OVERLAY", "GameFontNormal")
t1:SetPoint("TOPLEFT", 16, -40)
t1:SetText("Base de Datos (Elegible):")

AddCheck("AICAD_DB1", "Base de Datos Personal (auto-save al pasar - tu screenshot)", 16, -60, AICAD_ROUTER_DB, "usePersonal")
AddCheck("AICAD_DB2", "Base de Datos GatherMate / Perfiles AICAD_GIA", 16, -85, AICAD_ROUTER_DB, "useGatherMate")
AddCheck("AICAD_DB3", "Base de Datos WEB (Auxiliares/Media/WEB/*.tga)", 16, -110, AICAD_ROUTER_DB, "useWeb")

local t2 = panel:CreateFontString(nil, "OVERLAY", "GameFontNormal")
t2:SetPoint("TOPLEFT", 16, -140)
t2:SetText("Forma de Uso (Elegible):")

AddCheck("AICAD_MODE1", "[✓] Ruta Oro - Max oro/hora", 16, -160, AICAD_ROUTER_DB, "modeGold")
AddCheck("AICAD_MODE2", "[ ] Subir Profesiones 1-450", 16, -185, AICAD_ROUTER_DB, "modeLevel")

local desc = panel:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
desc:SetPoint("TOPLEFT", 16, -220)
desc:SetWidth(500) desc:SetJustifyH("LEFT")
desc:SetText("Ejemplo: Activar solo Personal ✓ + Ruta Oro ✓ = /route gold solo con tus nodos farmeados\nComandos: /wm on/off | /aicad | /route gold | /route level")
