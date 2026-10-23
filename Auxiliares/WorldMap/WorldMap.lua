-- Añade esto al final de WorldMap.lua - Zoom para WEB TGA sobre mapa Blizzard

local zoom = 1.0
local webFrame = CreateFrame("Frame", "AICADWebOverlay", WorldMapDetailFrame)
webFrame:SetAllPoints(WorldMapDetailFrame)
webFrame:Hide()

local tex = webFrame:CreateTexture(nil, "OVERLAY")
tex:SetAllPoints(webFrame)
tex:SetTexture("Interface\\AddOns\\AICAD_GIA\\Auxiliares\\Media\\WEB\\Corona de Hielo Herboristeria.tga")

-- Botón [ - ] Alejar
local btnMinus = CreateFrame("Button", nil, WorldMapFrame, "UIPanelButtonTemplate")
btnMinus:SetWidth(25) btnMinus:SetHeight(25)
btnMinus:SetPoint("TOPLEFT", WorldMapDetailFrame, "TOPRIGHT", 10, 0)
btnMinus:SetText("-")
btnMinus:SetScript("OnClick", function()
  zoom = math.max(0.5, zoom - 0.1)
  webFrame:SetScale(zoom)
  print("Zoom: "..math.floor(zoom*100).."%")
end)

-- Botón [ + ] Acercar
local btnPlus = CreateFrame("Button", nil, WorldMapFrame, "UIPanelButtonTemplate")
btnPlus:SetWidth(25) btnPlus:SetHeight(25)
btnPlus:SetPoint("TOPLEFT", btnMinus, "BOTTOMLEFT", 0, -5)
btnPlus:SetText("+")
btnPlus:SetScript("OnClick", function()
  zoom = math.min(2.0, zoom + 0.1)
  webFrame:SetScale(zoom)
  print("Zoom: "..math.floor(zoom*100).."%")
end)

-- Mostrar WEB TGA
SLASH_WEBMAP1="/webmap"
SlashCmdList["WEBMAP"]=function()
  if webFrame:IsShown() then webFrame:Hide() else webFrame:Show() end
end
