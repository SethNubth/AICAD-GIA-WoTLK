-- AICAD Save.lua - Guarda persistente en WTF
AICAD_SAVE = {}

function AICAD_SAVE:Export()
  local all = AICAD_WORLDMAP_DB.personal[118] or {}
  print(string.format("|cffFFD700[Save] Exportando %d nodos Zona 118 a SavedVariables...|r", #all))
  -- WoW lo guarda auto en WTF/Account/TU_CUENTA/SavedVariables/AICAD_GIA.lua
end

-- Asegura que la DB existe al cargar
local f = CreateFrame("Frame")
f:RegisterEvent("ADDON_LOADED")
f:SetScript("OnEvent", function(self, event, addon)
  if addon=="AICAD_GIA" then
    AICAD_WORLDMAP_DB = AICAD_WORLDMAP_DB or {}
    AICAD_WORLDMAP_DB.personal = AICAD_WORLDMAP_DB.personal or {}
    AICAD_WORLDMAP_DB.personal[118] = AICAD_WORLDMAP_DB.personal[118] or {}
    local count = #(AICAD_WORLDMAP_DB.personal[118] or {})
    print(string.format("|cff00FF00[AICAD Save] DB Cargada: %d menas en Corona | Modo: %s|r", count, count>=120 and "45/120" or count.."/"..count))
  end
end)

SLASH_AICADSAVEINFO1="/saveinfo"
SlashCmdList["AICADSAVEINFO"]=function()
  local c = #(AICAD_WORLDMAP_DB.personal[118] or {})
  print("Guardado en: WTF/Account/.../SavedVariables/AICAD_GIA.lua - Nodos: "..c)
end
