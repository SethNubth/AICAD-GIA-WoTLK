-- Auxiliares\NodeSight\Settings.lua - 30300 - FINAL FIX 0 errores
NodeSightDB = NodeSightDB or {}
local ADDON, ns = ...
ns = ns or {}

-- FIX: sin InterfaceOptionsFramePanelContainer en 30300
local panel = CreateFrame("Frame", "NodeSightSettings")
panel.name = "NodeSight Skada 1-450"
InterfaceOptions_AddCategory(panel)

local title = panel:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
title:SetPoint("TOPLEFT", 16, -16)
title:SetText("AICAD GIA - NodeSight Auxiliar Skada HD 1-450")

local info = panel:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
info:SetPoint("TOPLEFT", 16, -45)
info:SetWidth(480)
info:SetJustifyH("LEFT")
info:SetText("Minimap HD - Detecta hierbas y menas 1-450 - Conectado a Core\\Media.lua HD - Comandos: /ns on/off | /ns skada on/off | /ns size 18")

-- Boton ON/OFF
local btnOn = CreateFrame("Button", nil, panel, "UIPanelButtonTemplate")
btnOn:SetWidth(200) btnOn:SetHeight(28)
btnOn:SetPoint("TOPLEFT", 16, -85)
btnOn:SetText("NodeSight ON")
btnOn:SetScript("OnClick", function()
  NodeSightDB.enabled = true
  print("|cff00ff00[NodeSight] ON|r")
end)

local btnOff = CreateFrame("Button", nil, panel, "UIPanelButtonTemplate")
btnOff:SetWidth(200) btnOff:SetHeight(28)
btnOff:SetPoint("TOPLEFT", 230, -85)
btnOff:SetText("NodeSight OFF")
btnOff:SetScript("OnClick", function()
  NodeSightDB.enabled = false
  if ns.ClearAll then ns:ClearAll() end
  print("|cffff0000[NodeSight] OFF|r")
end)

-- Slider Size
local slider = CreateFrame("Slider", "NodeSightSizeSlider", panel, "OptionsSliderTemplate")
slider:SetWidth(200)
slider:SetHeight(20)
slider:SetPoint("TOPLEFT", 16, -130)
slider:SetMinMaxValues(12, 32)
slider:SetValueStep(1)
_G["NodeSightSizeSliderText"]:SetText("Icon Size: "..(NodeSightDB.iconSize or 18))
_G["NodeSightSizeSliderLow"]:SetText("12")
_G["NodeSightSizeSliderHigh"]:SetText("32")
slider:SetValue(NodeSightDB.iconSize or 18)
slider:SetScript("OnValueChanged", function(self, val)
  NodeSightDB.iconSize = math.floor(val)
  _G["NodeSightSizeSliderText"]:SetText("Icon Size: "..NodeSightDB.iconSize)
end)

-- Check Skada Border
local cb = CreateFrame("CheckButton", "NodeSightSkadaCB", panel, "InterfaceOptionsCheckButtonTemplate")
cb:SetPoint("TOPLEFT", 16, -170)
local cbText = _G["NodeSightSkadaCBText"]
if cbText then
  cbText:SetText("Borde Dorado Skada HD 1024 (forma redonda)")
else
  local fs = cb:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  fs:SetPoint("LEFT", cb, "RIGHT", 6, 0)
  fs:SetText("Borde Dorado Skada HD 1024")
end
cb:SetChecked((NodeSightDB.shape or 3) == 3)
cb:SetScript("OnClick", function(self)
  NodeSightDB.shape = self:GetChecked() and 3 or 1
  print(self:GetChecked() and "Skada ON" or "Skada OFF - cuadrado")
end)

local footer = panel:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
footer:SetPoint("TOPLEFT", 16, -210)
footer:SetText("AicadGia v1.0 Final - Naerzone 30300 - 0 errores Lua - /ns | /route")
