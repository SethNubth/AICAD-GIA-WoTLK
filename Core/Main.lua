-- Core\Main.lua - Init Naerzone 30300 - Safe

AICAD_GIA = AICAD_GIA or {}

function AICAD_GIA:OnInitialize()
  print("|cffffcc00[AICAD GIA v1.0 - Naerzone 3.3.5a] Cargado - /aicad para opciones|r")
  SLASH_AICAD1 = "/aicad"
  SLASH_AICAD2 = "/aicadbase"
  SlashCmdList["AICAD"] = function(msg)
    msg = msg:lower()
    if msg == "1" then AICAD_GIA:SetMapBase(1)
    elseif msg == "2" then AICAD_GIA:SetMapBase(2)
    elseif msg == "3" then AICAD_GIA:SetMapBase(3)
    else
      InterfaceOptionsFrame_OpenToCategory("AICAD GIA |cffffcc00v1.0 - Naerzone|")
    end
  end
end

local f = CreateFrame("Frame")
f:RegisterEvent("PLAYER_LOGIN")
f:SetScript("OnEvent", function()
  AICAD_GIA:OnInitialize()
end)
