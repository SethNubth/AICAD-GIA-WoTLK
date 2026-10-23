-- Core\Media.lua - Texturas HD Skada sin Libs + GatherMate2 Import - Naerzone 30300 FINAL
AICAD_MEDIA = AICAD_MEDIA or {}

-- Herboristeria - Rasganorte
AICAD_MEDIA["Flor"] = "Interface\\Icons\\INV_Misc_Herb_Lichbloom"
AICAD_MEDIA["Lichbloom"] = "Interface\\Icons\\INV_Misc_Herb_Lichbloom"
AICAD_MEDIA["Flor Exanime"] = "Interface\\Icons\\INV_Misc_Herb_Lichbloom"
AICAD_MEDIA["FrostLotus"] = "Interface\\Icons\\INV_Misc_Herb_FrostLotus"
AICAD_MEDIA["Flor de Escarcha"] = "Interface\\Icons\\INV_Misc_Herb_FrostLotus"
AICAD_MEDIA["Frost Lotus"] = "Interface\\Icons\\INV_Misc_Herb_FrostLotus"
AICAD_MEDIA["Icethorn"] = "Interface\\Icons\\INV_Misc_Herb_IceThorn"
AICAD_MEDIA["Espina de Hielo"] = "Interface\\Icons\\INV_Misc_Herb_IceThorn"
AICAD_MEDIA["Goldclover"] = "Interface\\Icons\\INV_Misc_Herb_GoldClover"
AICAD_MEDIA["Talandra"] = "Interface\\Icons\\INV_Misc_Herb_TalandrasRose"
AICAD_MEDIA["Adder"] = "Interface\\Icons\\INV_Misc_Herb_AdderStongue"

-- Mineria - Rasganorte - ORO
AICAD_MEDIA["Titanium"] = "Interface\\Icons\\inv_ore_titanium_01"
AICAD_MEDIA["Titanio"] = "Interface\\Icons\\inv_ore_titanium_01"
AICAD_MEDIA["Veta de Titanio"] = "Interface\\Icons\\inv_ore_titanium_01"
AICAD_MEDIA["Titanium Vein"] = "Interface\\Icons\\inv_ore_titanium_01"
AICAD_MEDIA["Saronite"] = "Interface\\Icons\\inv_ore_saronite_01"
AICAD_MEDIA["Saronita"] = "Interface\\Icons\\inv_ore_saronite_01"
AICAD_MEDIA["Veta de Saronita"] = "Interface\\Icons\\inv_ore_saronite_01"
AICAD_MEDIA["Cobalt"] = "Interface\\Icons\\inv_ore_cobalt_01"
AICAD_MEDIA["Cobalto"] = "Interface\\Icons\\inv_ore_cobalt_01"

-- Fallback generico
AICAD_MEDIA["Herb"] = "Interface\\Minimap\\Tracking\\Herbs"
AICAD_MEDIA["Mine"] = "Interface\\Minimap\\Tracking\\MineralMarker"
AICAD_MEDIA["Default"] = "Interface\\Icons\\INV_Misc_Map_01"
AICAD_MEDIA["SkadaIcon"] = "Interface\\Icons\\INV_Misc_Herb_Lichbloom"

-- SOPORTE GATHERMATE2 - Para que cliente pueda importar su base
AICAD_MEDIA["GatherMateSupport"] = true

function AICAD_GIA_ImportGatherMate2()
  if not IsAddOnLoaded("GatherMate2") then
    print("|cffffcc00[AICAD] GatherMate2 no instalado - Usa Base 1 Personal o 3 WEB TGA|r")
    return false
  end
  AICAD_GIA_IMPORTED = AICAD_GIA_IMPORTED or {}
  local c = 0
  if GatherMate2DB then
    for k,v in pairs(GatherMate2DB) do c = c + 1 end
  end
  print("|cff00ff00[AICAD] GatherMate2 detectado: "..c.." zonas → Base 2 activa|r")
  AICAD_GIA_DB = AICAD_GIA_DB or {}
  AICAD_GIA_DB.mapBase = 2
  return true
end

print("|cff00ff00[AICAD Media] Texturas HD + GatherMate2 Base 2 disponible|r")
