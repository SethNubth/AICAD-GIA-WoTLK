-- Auxiliares\Router\Settings.lua - Panel Config 30300 - FIX 0 errores
AICAD_ROUTER_DB = AICAD_ROUTER_DB or {activeDB="personal", useTomTom=false, mode="gold"}

local panel = CreateFrame("Frame", "AICADRouterPanel")
panel.name="AICAD Router AI"
InterfaceOptions_AddCategory(panel)

local title=panel:CreateFontString(nil,"OVERLAY","GameFontNormalLarge")
title:SetPoint("TOPLEFT",16,-16)
title:SetText("AICAD GIA - Router AI - Mapa Blizzard (TomTom OFF)")

local t1=panel:CreateFontString(nil,"OVERLAY","GameFontNormal")
t1:SetPoint("TOPLEFT",16,-45)
t1:SetText("Actualizar a >> Base de Datos:")

local btnP=CreateFrame("Button",nil,panel,"UIPanelButtonTemplate")
btnP:SetWidth(220) btnP:SetHeight(28) btnP:SetPoint("TOPLEFT",16,-65)
btnP:SetText(">> Base Datos Personal")
btnP:SetScript("OnClick", function() 
  if _G["AICAD_Router"] then _G["AICAD_Router"]:ActualizarDB("personal") end
end)

local btnG=CreateFrame("Button",nil,panel,"UIPanelButtonTemplate")
btnG:SetWidth(220) btnG:SetHeight(28) btnG:SetPoint("TOPLEFT",250,-65)
btnG:SetText(">> Base Datos GatherMate")
btnG:SetScript("OnClick", function() 
  if _G["AICAD_Router"] then _G["AICAD_Router"]:ActualizarDB("gathermate") end
end)

local t2=panel:CreateFontString(nil,"OVERLAY","GameFontNormal")
t2:SetPoint("TOPLEFT",16,-105)
t2:SetText("Modo Ruta:")

local btnGold=CreateFrame("Button",nil,panel,"UIPanelButtonTemplate")
btnGold:SetWidth(220) btnGold:SetHeight(28) btnGold:SetPoint("TOPLEFT",16,-125)
btnGold:SetText("Modo Oro - Flor Exanime")
btnGold:SetScript("OnClick", function() 
  AICAD_ROUTER_DB.mode="gold" 
  if _G["AICAD_Router"] then _G["AICAD_Router"]:Build("gold") end
end)

local btnLevel=CreateFrame("Button",nil,panel,"UIPanelButtonTemplate")
btnLevel:SetWidth(220) btnLevel:SetHeight(28) btnLevel:SetPoint("TOPLEFT",250,-125)
btnLevel:SetText("Modo 1-450 - Todo por igual")
btnLevel:SetScript("OnClick", function() 
  AICAD_ROUTER_DB.mode="level" 
  if _G["AICAD_Router"] then _G["AICAD_Router"]:Build("level") end
end)

-- CheckButton FIX 30300 - sin _G["...Text"] que da nil
local cb=CreateFrame("CheckButton","RouterTomTomCB",panel,"InterfaceOptionsCheckButtonTemplate")
cb:SetPoint("TOPLEFT",16,-165)
local cbText = _G["RouterTomTomCBText"]
if cbText then
  cbText:SetText("TomTom ON/OFF (flecha) - OFF = Solo Mapa Blizzard")
else
  local fs = cb:CreateFontString(nil,"OVERLAY","GameFontNormal")
  fs:SetPoint("LEFT", cb, "RIGHT", 6, 0)
  fs:SetText("TomTom ON/OFF - OFF = Solo Mapa Blizzard (M)")
end
cb:SetChecked(AICAD_ROUTER_DB.useTomTom or false)
cb:SetScript("OnClick", function(self)
  AICAD_ROUTER_DB.useTomTom = self:GetChecked() and true or false
  if not AICAD_ROUTER_DB.useTomTom and TomTom then 
    pcall(function() TomTom:ClearAllWaypoints() end) 
  end
  print(AICAD_ROUTER_DB.useTomTom and "|cff00ff00TomTom ON|r" or "|cffff0000TomTom OFF - Solo Blizzard Map|r")
end)

local info=panel:CreateFontString(nil,"OVERLAY","GameFontHighlightSmall")
info:SetPoint("TOPLEFT",16,-210)
info:SetWidth(500)
info:SetJustifyH("LEFT")
info:SetText("Comandos: /route personal | /route gathermate | /route gold | /route level | /route tomtom on/off | Mapa Blizzard (M) - 0 errores Lua")
