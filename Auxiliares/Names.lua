-- Auxiliares\NodeSight\Names.lua - 1-450 FULL Classic + TBC + WotLK - Naerzone
ns = ns or {}
ns.NodeKind = function(name)
  if not name then return "treasure" end
  name = name:lower()
  if name:find("peacebloom") or name:find("silverleaf") or name:find("earthroot") or name:find("mageroyal") or name:find("briarthorn") or name:find("stranglekelp") or name:find("bruiseweed") or name:find("wild steelbloom") or name:find("grave moss") or name:find("kingsblood") or name:find("liferoot") or name:find("fadeleaf") or name:find("goldthorn") or name:find("khadgar") or name:find("wintersbite") or name:find("firebloom") or name:find("purple lotus") or name:find("sungrass") or name:find("blindweed") or name:find("ghost mushroom") or name:find("gromsblood") or name:find("golden sansam") or name:find("dreamfoil") or name:find("mountain silversage") or name:find("plaguebloom") or name:find("icecap") or name:find("black lotus") or name:find("felweed") or name:find("dreaming glory") or name:find("terocone") or name:find("ragveil") or name:find("netherbloom") or name:find("nightmare vine") or name:find("mana thistle") or name:find("goldclover") or name:find("tiger lily") or name:find("adder") or name:find("talandra") or name:find("lichbloom") or name:find("icethorn") or name:find("frost lotus") or name:find("pacificadora") or name:find("hojaplata") then
    return "herbs"
  end
  if name:find("copper") or name:find("tin") or name:find("silver") or name:find("iron") or name:find("gold vein") or name:find("mithril") or name:find("truesilver") or name:find("small thorium") or name:find("rich thorium") or name:find("fel iron") or name:find("adamantite") or name:find("khorium") or name:find("cobalt") or name:find("saronite") or name:find("titanium") or name:find("vein") or name:find("deposit") or name:find("cobre") or name:find("esta") or name:find("plata") or name:find("hierro") or name:find("mitril") or name:find("veraplata") or name:find("torio") or name:find("cobalto") or name:find("saronita") then
    return "ore"
  end
  return "treasure"
end
ns.NodeIcon = function(name) return nil end
ns.Plain = function(name) return name and name:lower() or "" end
ns.TREASURE = { icon = "Interface\\Icons\\INV_Misc_Treasure_01" }
ns.RARES, ns.FRIENDLY, ns.TOO_HARD = {}, {}, {}
ns.skills, ns.professions, ns.TooHard, ns.NodeSkill = {}, {}, function() return false end, function() return 0 end
