-- Settings.lua 30300
local panel = CreateFrame("Frame", "NodeSightSettings", InterfaceOptionsFramePanelContainer)
panel.name = "NodeSight Skada 1-450"
InterfaceOptions_AddCategory(panel)
local title = panel:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
title:SetPoint("TOPLEFT", 16, -16)
title:SetText("AICAD GIA - NodeSight Auxiliar Skada HD 1-450")
