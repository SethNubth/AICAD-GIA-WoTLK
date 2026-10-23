-- Core\Media.lua - Media HD 1024x1024 - Safe Blizzard

AICAD_GIA = AICAD_GIA or {}
AICAD_GIA.Media = {}

AICAD_GIA.Media.Maps = {
  ["Sholazar"] = "Interface\\AddOns\\AICAD_GIA\\Media\\Maps\\Sholazar.tga",
  ["Icecrown"] = "Interface\\AddOns\\AICAD_GIA\\Media\\Maps\\Icecrown.tga",
  ["StormPeaks"] = "Interface\\AddOns\\AICAD_GIA\\Media\\Maps\\StormPeaks.tga",
  ["Wintergrasp"] = "Interface\\AddOns\\AICAD_GIA\\Media\\Maps\\Wintergrasp.tga",
}

AICAD_GIA.Media.Icons = {
  ["Saronite"] = "Interface\\AddOns\\AICAD_GIA\\Media\\Icons\\Saronite.tga",
  ["Titanium"] = "Interface\\AddOns\\AICAD_GIA\\Media\\Icons\\Titanium.tga",
  ["Herb"] = "Interface\\AddOns\\AICAD_GIA\\Media\\Icons\\Herb.tga",
}

function AICAD_GIA.Media:Register()
  if not LibStub then return end
  local LSM = LibStub("LibSharedMedia-3.0", true)
  if not LSM then return end
  for name, path in pairs(self.Maps) do
    LSM:Register("background", "AICAD_"..name, path)
  end
end

local f = CreateFrame("Frame")
f:RegisterEvent("ADDON_LOADED")
f:SetScript("OnEvent", function(self, event, addon)
  if addon == "AICAD_GIA" then
    AICAD_GIA.Media:Register()
    self:UnregisterEvent("ADDON_LOADED")
  end
end)
