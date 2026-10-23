-- Core\Main.lua - Init Naerzone 30300 - Safe - FINAL FIX
AICAD_GIA = AICAD_GIA or {}

function AICAD_GIA:OnInitialize()
  -- DB ya inicializada por Config.lua
  if not AICAD_GIA_DB then
    AICAD_GIA:InitDB()
  end
  
  print("|cffffcc00[AICAD GIA v1.0 - Naerzone 3.3.5a] Cargado - /aicad para opciones|r")
  print("|cffffcc00Base: "..(AICAD_GIA:GetMapBase() or 3).." | Modo: "..(AICAD_GIA:GetRouteMode() or "GOLD").." | TomTom OFF|r")

  SLASH_AICAD1 = "/aicad"
  SLASH_AICAD2 = "/aicadbase"
  SlashCmdList["AICAD"] = function(msg)
    msg = (msg or ""):lower()
    msg = string.gsub(msg, "^%s+", "") -- trim fix 30300
    msg = string.gsub(msg, "%s+$", "")
    
    if msg == "1" then 
      AICAD_GIA:SetMapBase(1)
    elseif msg == "2" then 
      AICAD_GIA:SetMapBase(2)
    elseif msg == "3" then 
      AICAD_GIA:SetMapBase(3)
    elseif msg == "gold" then
      if AICAD_GIA_DB then AICAD_GIA_DB.routeMode = "GOLD" end
      print("|cffffcc00[AICAD] Modo GOLD|r")
    elseif msg == "level" or msg == "leveling" then
      if AICAD_GIA_DB then AICAD_GIA_DB.routeMode = "LEVELING_1_450" end
      print("|cffffcc00[AICAD] Modo LEVELING 1-450|r")
    else
      -- 30300 necesita 2 llamadas para abrir bien
      if InterfaceOptionsFrame_OpenToCategory then
        InterfaceOptionsFrame_OpenToCategory("AICAD GIA")
        InterfaceOptionsFrame_OpenToCategory("AICAD GIA")
      end
      print("|cffffcc00[AICAD] Comandos: /aicad 1=Personal 2=Gathermate 3=WEB | /aicad gold | /aicad level|r")
    end
  end
end

local f = CreateFrame("Frame")
f:RegisterEvent("PLAYER_LOGIN")
f:SetScript("OnEvent", function(self, event)
  if event == "PLAYER_LOGIN" then
    AICAD_GIA:OnInitialize()
    self:UnregisterEvent("PLAYER_LOGIN")
  end
end)
