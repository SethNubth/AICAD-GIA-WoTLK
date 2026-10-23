-- Auxiliares\Router\Settings.lua - Panel Configuración - 30300
local panel = CreateFrame("Frame", "AICADRouterPanel", InterfaceOptionsFramePanelContainer)
panel.name="AICAD Router AI"
InterfaceOptions_AddCategory(panel)

local title=panel:CreateFontString(nil,"OVERLAY","GameFontNormalLarge")
title:SetPoint("TOPLEFT",16,-16)
title:SetText("AICAD GIA - Router AI - Mapa Blizzard")

local t1=panel:CreateFontString(nil,"OVERLAY","GameFontNormal")
t1:SetPoint("TOPLEFT",16,-45)
t1:SetText("Actualizar a >> Base de Datos:")

local btnP=CreateFrame("Button",nil,panel,"UIPanelButtonTemplate")
btnP:SetWidth(220) btnP:SetHeight(28) btnP:SetPoint("TOPLEFT",16,-65)
btnP:SetText(">> Base Datos Personal")
btnP:SetScript("OnClick", function() AICAD_Router:ActualizarDB("personal") end)

local btnG=CreateFrame("Button",nil,panel,"UIPanelButtonTemplate")
btnG:SetWidth(220) btnG:SetHeight(28) btnG:SetPoint("TOPLEFT",250,-65)
btnG:SetText(">> Base Datos GatherMate")
btnG:SetScript("OnClick", function() AICAD_Router:ActualizarDB("gathermate") end)

local t2=panel:CreateFontString(nil,"OVERLAY","GameFontNormal")
t2:SetPoint("TOPLEFT",16,-105)
t2:SetText("Modo Ruta:")

local btnGold=CreateFrame("Button",nil,panel,"UIPanelButtonTemplate")
btnGold:SetWidth(220) btnGold:SetHeight(28) btnGold:SetPoint("TOPLEFT",16,-125)
btnGold:SetText("Modo Oro - Flor Exanime")
btnGold:SetScript("OnClick", function() AICAD_ROUTER_DB.mode="gold" AICAD_Router:Build("gold") end)

local btnLevel=CreateFrame("Button",nil,panel,"UIPanelButtonTemplate")
btnLevel:SetWidth(220) btnLevel:SetHeight(28) btnLevel:SetPoint("TOPLEFT",250,-125)
btnLevel:SetText("Modo 1-450 - Todo por igual")
btnLevel:SetScript("OnClick", function() AICAD_ROUTER_DB.mode="level" AICAD_Router:Build("level") end)

local cb=CreateFrame("CheckButton","RouterTomTomCB",panel,"InterfaceOptionsCheckButtonTemplate")
cb:SetPoint("TOPLEFT",16,-165)
_G["RouterTomTomCBText"]:SetText("TomTom ON/OFF (flecha)")
cb:SetChecked(AICAD_ROUTER_DB.useTomTom)
cb:SetScript("OnClick", function(self)
  AICAD_ROUTER_DB.useTomTom=self:GetChecked()
  if not self:GetChecked() and TomTom then TomTom:ClearAllWaypoints() end
end)

local info=panel:CreateFontString(nil,"OVERLAY","GameFontHighlightSmall")
info:SetPoint("TOPLEFT",16,-210)
info:SetWidth(500)
info:SetJustifyH("LEFT")
info:SetText("Comandos: /route personal | /route gathermate | /route gold | /route level | /route tomtom on/off | Usa Mapa Blizzard (M)")
