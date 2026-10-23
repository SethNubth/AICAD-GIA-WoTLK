-- Core\Locale.lua - Naerzone 30300 - esMX/ptBR/enUS - Safe

AICAD_GIA = AICAD_GIA or {}
AICAD_GIA.L = {}

local L = AICAD_GIA.L
local locale = GetLocale()

if locale == "esMX" or locale == "esES" then
  L["MINING"] = "Mineria"
  L["HERBALISM"] = "Herboristeria"
  L["GOLD_MODE"] = "ORO - Saronita/Titanio"
  L["LEVELING_MODE"] = "SUBIR - 1-450"
  L["ORIGINAL_BASE"] = "Original Personal"
  L["GATHERMATE_BASE"] = "GatherMate2"
  L["WEB_BASE"] = "WEB Altertime"
elseif locale == "ptBR" then
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
