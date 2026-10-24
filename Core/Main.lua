-- Core\Main.lua - Init Naerzone 30300 - Safe - FINAL + Scanner Proximidad GOD
AICAD_GIA = AICAD_GIA or {}

function AICAD_GIA:OnInitialize()
  -- DB ya inicializada por Config.lua
  if not AICAD_GIA_DB then
    AICAD_GIA:InitDB()
  end
  
  -- Activa modo proximidad por defecto
  if AICAD_GIA_DB then
    if AICAD_GIA_DB.autoScan == nil then AICAD_GIA_DB.autoScan = true end
    AICAD_GIA_DB.personal = AICAD_GIA_DB.personal or {}
  end
  
  print("|cffffcc00[AICAD GIA v1.0 - Naerzone 3.3.5a] Cargado - /aicad para opciones|r")
  print("|cffffcc00Base: "..(AICAD_GIA:GetMapBase() or 3).." | Modo: "..(AICAD_GIA:GetRouteMode() or "GOLD").." | TomTom OFF|r")
  print("|cff00ff00[AICAD] Scanner Proximidad ON - Solo pasa cerca del nodo para guardar|r")

  SLASH_AICAD1 = "/aicad"
  SLASH_AICAD2 = "/aicadbase"
  SlashCmdList["AICAD"] = function(msg)
    msg = (msg or ""):lower()
    msg = string.gsub(msg, "^%s+", "")
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
    elseif msg == "clear" then
      local mapID = GetCurrentMapAreaID and GetCurrentMapAreaID() or 0
      if AICAD_GIA_DB and AICAD_GIA_DB.personal then
        AICAD_GIA_DB.personal[mapID] = {}
        print("|cffff0000[AICAD] Base personal limpiada mapa: "..mapID.."|r")
      end
    elseif msg == "scan on" then
      if AICAD_GIA_DB then AICAD_GIA_DB.autoScan = true end
      print("|cff00ff00[AICAD] Scanner proximidad ON|r")
    elseif msg == "scan off" then
      if AICAD_GIA_DB then AICAD_GIA_DB.autoScan = false end
      print("|cffff0000[AICAD] Scanner proximidad OFF|r")
    else
      if InterfaceOptionsFrame_OpenToCategory then
        InterfaceOptionsFrame_OpenToCategory("AICAD GIA")
        InterfaceOptionsFrame_OpenToCategory("AICAD GIA")
      end
      print("|cffffcc00[AICAD] Comandos: /aicad 1=Personal 2=Gathermate 3=WEB | /aicad gold | level | clear | scan on/off|r")
    end
  end
end

-- === SCANNER PROXIMIDAD GOD - Solo pasar cerca, no necesita minar ===
function AICAD_GIA:SavePersonalNode(mapID, x, y, name)
  if not mapID or not x or not y or x == 0 then return end
  AICAD_GIA_DB.personal = AICAD_GIA_DB.personal or {}
  AICAD_GIA_DB.personal[mapID] = AICAD_GIA_DB.personal[mapID] or {}
  
  -- evita duplicados a 10 yardas aprox
  for _, n in ipairs(AICAD_GIA_DB.personal[mapID]) do
    if math.abs(n.x - x) < 0.008 and math.abs(n.y - y) < 0.008 then return end
  end
  
  table.insert(AICAD_GIA_DB.personal[mapID], {x=x, y=y, name=name, time=time()})
  print("|cff00ff00[AICAD] + Nodo personal sin minar: "..(name or "Hierba").." en "..string.format("%.1f, %.1f", x*100, y*100).." | M para ver|r")
end

local f = CreateFrame("Frame")
f:RegisterEvent("PLAYER_LOGIN")
f:SetScript("OnEvent", function(self, event)
  if event == "PLAYER_LOGIN" then
    AICAD_GIA:OnInitialize()
    self:UnregisterEvent("PLAYER_LOGIN")
  end
end)

-- Frame de escaneo cada 1.5 seg
local scanFrame = CreateFrame("Frame")
scanFrame.lastScan = 0
scanFrame:SetScript("OnUpdate", function(self, elapsed)
  if not AICAD_GIA_DB or not AICAD_GIA_DB.autoScan then return end
  self.lastScan = self.lastScan + elapsed
  if self.lastScan < 1.5 then return end
  self.lastScan = 0
  
  local mapID = GetCurrentMapAreaID and GetCurrentMapAreaID() or nil
  if not mapID or mapID == 0 then return end
  
  local x, y = GetPlayerMapPosition("player")
  if not x or x == 0 then return end
  
  -- Detecta si pasas mouse sobre nodo (tooltip visible)
  if GameTooltip and GameTooltip:IsVisible() then
    local gtt = _G["GameTooltipTextLeft1"]
    if gtt then
      local name = gtt:GetText()
      if name then
        local lname = name:lower()
        -- Palabras clave hierbas/minas TBC/WOTLK
        if string.find(lname, "hierba") or string.find(lname, "flor") or string.find(lname, "espina") or string.find(lname, "terocone") or string.find(lname, "felweed") or string.find(lname, "dreaming glory") or string.find(lname, "veta") or string.find(lname, "filon") or string.find(lname, "adamantita") then
          AICAD_GIA:SavePersonalNode(mapID, x, y, name)
        end
      end
    end
  end
end)
