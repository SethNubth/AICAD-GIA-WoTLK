-- Core\Locale.lua - Naerzone 30300 - esMX/ptBR/enUS - Safe - FINAL
AICAD_GIA = AICAD_GIA or {}
AICAD_GIA.L = AICAD_GIA.L or {}
AICAD_L = AICAD_L or AICAD_GIA.L -- compat para WorldMap y Router viejos

local L = AICAD_GIA.L
local locale = GetLocale() or "enUS"

if locale == "esMX" or locale == "esES" or locale:find("es") then
  L["MINING"] = "Mineria"
  L["HERBALISM"] = "Herboristeria"
  L["GOLD_MODE"] = "ORO - Saronita/Titanio"
  L["LEVELING_MODE"] = "SUBIR - 1-450"
  L["ORIGINAL_BASE"] = "Original Personal"
  L["GATHERMATE_BASE"] = "GatherMate2"
  L["WEB_BASE"] = "WEB Altertime"
elseif locale == "ptBR" or locale:find("pt") then
  L["MINING"] = "Mineracao"
  L["HERBALISM"] = "Herborismo"
  L["GOLD_MODE"] = "OURO - Saronita/Titanio"
  L["LEVELING_MODE"] = "UPAR - 1-450"
  L["ORIGINAL_BASE"] = "Original Pessoal"
  L["GATHERMATE_BASE"] = "GatherMate2"
  L["WEB_BASE"] = "WEB Altertime"
else
  L["MINING"] = "Mining"
  L["HERBALISM"] = "Herbalism"
  L["GOLD_MODE"] = "GOLD - Saronite/Titanium"
  L["LEVELING_MODE"] = "LEVELING - 1-450"
  L["ORIGINAL_BASE"] = "Original Personal"
  L["GATHERMATE_BASE"] = "GatherMate2"
  L["WEB_BASE"] = "WEB Altertime"
end

-- Debug opcional
if AICAD_GIA_DB and AICAD_GIA_DB.debug then
  print("|cffffcc00[AICAD Locale] "..locale.." cargado|r")
end
