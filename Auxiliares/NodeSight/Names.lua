-- Auxiliares\NodeSight\Names.lua - 1-450 FULL Classic + TBC + WotLK - Naerzone 30300 - FINAL
ns = ns or {}
AICAD_MEDIA = AICAD_MEDIA or {}

-- Normaliza
ns.Plain = function(name)
  if not name then return "" end
  return string.lower(name)
end

-- Clasificador 1-450
ns.NodeKind = function(name)
  if not name then return "herb" end
  local low = string.lower(name)
  
  -- Hierbas 1-450
  if low:find("peacebloom") or low:find("silverleaf") or low:find("earthroot") or low:find("mageroyal") or low:find("briarthorn") 
  or low:find("stranglekelp") or low:find("bruiseweed") or low:find("steelbloom") or low:find("grave moss") or low:find("kingsblood") 
  or low:find("liferoot") or low:find("fadeleaf") or low:find("goldthorn") or low:find("khadgar") or low:find("wintersbite") 
  or low:find("firebloom") or low:find("purple lotus") or low:find("sungrass") or low:find("blindweed") or low:find("ghost mushroom") 
  or low:find("gromsblood") or low:find("golden sansam") or low:find("dreamfoil") or low:find("mountain silversage") or low:find("plaguebloom") 
  or low:find("icecap") or low:find("black lotus") or low:find("felweed") or low:find("dreaming glory") or low:find("terocone") 
  or low:find("ragveil") or low:find("netherbloom") or low:find("nightmare vine") or low:find("mana thistle") or low:find("goldclover") 
  or low:find("tiger lily") or low:find("adder") or low:find("talandra") or low:find("lichbloom") or low:find("icethorn") 
  or low:find("frost lotus") or low:find("flor") or low:find("pacificadora") or low:find("hojaplata") or low:find("vidarra") then
    return "herb"
  end
  
  -- Menas 1-450
  if low:find("copper") or low:find("tin") or low:find("silver") or low:find("iron") or low:find("gold") 
  or low:find("mithril") or low:find("truesilver") or low:find("thorium") or low:find("fel iron") or low:find("adamantite") 
  or low:find("khorium") or low:find("cobalt") or low:find("saronite") or low:find("titanium") or low:find("vein") 
  or low:find("deposit") or low:find("cobre") or low:find("esta") or low:find("plata") or low:find("hierro") 
  or low:find("mitril") or low:find("veraplata") or low:find("torio") or low:find("cobalto") or low:find("saronita") or low:find("titanio") then
    return "mine"
  end
  
  return "herb"
end

-- Icono HD usando tu Media Skada
ns.NodeIcon = function(name)
  if not name then return AICAD_MEDIA["Default"] end
  local low = string.lower(name)
  
  if low:find("titan") then return AICAD_MEDIA["Titanium"] or AICAD_MEDIA["Titanio"] end
  if low:find("saron") then return AICAD_MEDIA["Saronite"] or AICAD_MEDIA["Saronita"] end
  if low:find("cobalto") or low:find("cobalt") then return AICAD_MEDIA["Cobalt"] or AICAD_MEDIA["Cobalto"] end
  if low:find("frost") or low:find("escarcha") or low:find("exanime") then return AICAD_MEDIA["FrostLotus"] or AICAD_MEDIA["Flor"] end
  if low:find("lichbloom") or low:find("flor exanime") then return AICAD_MEDIA["Lichbloom"] or AICAD_MEDIA["Flor"] end
  if low:find("icethorn") or low:find("espina") then return AICAD_MEDIA["Icethorn"] end
  if low:find("talandra") then return AICAD_MEDIA["Talandra"] end
  if low:find("goldclover") then return AICAD_MEDIA["Goldclover"] end
  if low:find("adder") then return AICAD_MEDIA["Adder"] end
  
  local kind = ns.NodeKind(name)
  if kind == "mine" then return AICAD_MEDIA["Mine"] end
  return AICAD_MEDIA["Herb"] or AICAD_MEDIA["Flor"] or "Interface\\Minimap\\Tracking\\Herbs"
end

ns.TREASURE = { icon = "Interface\\Icons\\INV_Misc_Treasure_01" }
ns.RARES, ns.FRIENDLY, ns.TOO_HARD = {}, {}, {}
ns.skills, ns.professions, ns.TooHard, ns.NodeSkill = {}, {}, function() return false end, function() return 0 end

print("|cff00ff00[AICAD Names] 1-450 FULL conectado a Media HD|r")
