-- Core\Main.lua - Init Naerzone 30300 - Safe - FINAL v1.2 - Scanner Prox + WEB solo mostrar
AICAD_GIA = AICAD_GIA or {}

function AICAD_GIA:OnInitialize()
  if not AICAD_GIA_DB then
    AICAD_GIA:InitDB()
  end
  
  if AICAD_GIA_DB then
    if AICAD_GIA_DB.autoScan == nil then AICAD_GIA_DB.autoScan = true end
    AICAD_GIA_DB.personal = AICAD_GIA_DB.personal or {}
    if _G["AICAD_WORLDMAP_DB"] then
      _G["AICAD_WORLDMAP_DB"].personal = _G["AICAD_WORLDMAP_DB"].personal or {}
    end
  end
  
  print("|cffffcc00[AICAD GIA v1.0 - Naerzone 3.3.5a] Cargado - /aicad para opciones|r")
  print("|cffffcc00Base: "..(AICAD_GIA:GetMapBase() or 3).." | Modo: "..(AICAD_GIA:GetRouteMode() or "GOLD").." | TomTom OFF|r")
  print("|cff00ff00[AICAD] Scanner ON - Solo pasar cerca guarda en Base 1 Personal | Base 3 WEB solo muestra|r")

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
      if _G["AICAD_WORLDMAP_DB"] and _G["AICAD_WORLDMAP_DB"].personal then
        _G["AICAD_WORLDMAP_DB"].personal[mapID] = {}
        print("|cffff0000[AICAD] Base 1 Personal limpiada mapa: "..mapID.." | Base 3 WEB no tocada|r")
      end
    elseif msg == "scan on" then
      if AICAD_GIA_DB then AICAD_GIA_DB.autoScan = true end
      print("|cff00ff00[AICAD] Scanner proximidad ON - Guarda en Base 1|r")
    elseif msg == "scan off" then
      if AICAD_GIA_DB then AICAD_GIA_DB.autoScan = false end
      print("|cffff0000[AICAD] Scanner proximidad OFF|r")
    else
      if InterfaceOptionsFrame_OpenToCategory then
        InterfaceOptionsFrame_OpenToCategory("AICAD GIA")
        InterfaceOptionsFrame_OpenToCategory("AICAD GIA")
      end
      print("|cffffcc00[AICAD] Comandos: /aicad 1=Personal(Escribe) 2=Gathermate(Lectura) 3=WEB(Solo muestra) | gold | level | clear | scan on/off|r")
    end
  end
end

-- === GOD FIX: Nunca guarda si estás en Base 3 WEB - WEB solo mostrar ===
function AICAD_GIA:SavePersonalNode(mapID, x, y, name)
  if not mapID or not x or not y or x == 0 then return end
  if not AICAD_GIA_DB then return end
  if AICAD_GIA_DB.autoScan == false then return end
  if AICAD_GIA:GetMapBase() == 3 then return end -- BLINDADO: WEB no se modifica
  
  _G["AICAD_WORLDMAP_DB"] = _G["AICAD_WORLDMAP_DB"] or {personal={}}
  _G["AICAD_WORLDMAP_DB"].personal = _G["AICAD_WORLDMAP_DB"].personal or {}
  _G["AICAD_WORLDMAP_DB"].personal[mapID] = _G["AICAD_WORLDMAP_DB"].personal[mapID] or {}
  
  for _, n in ipairs(_G["AICAD_WORLDMAP_DB"].personal[mapID]) do
    if math.abs(n.x - x) < 0.008 and math.abs(n.y - y) < 0.008 then return end
  end
  
  table.insert(_G["AICAD_WORLDMAP_DB"].personal[mapID], {x=x, y=y, name=name, time=time()})
  print("|cff00ff00[AICAD] + Personal sin minar: "..(name or "Nodo").." en "..string.format("%.1f, %.1f", x*100, y*100).." | /aicad 1 para ver en M|r")
end

local f = CreateFrame("Frame")
f:RegisterEvent("PLAYER_LOGIN")
f:SetScript("OnEvent", function(self, event)
  if event == "PLAYER_LOGIN" then
    AICAD_GIA:OnInitialize()
    self:UnregisterEvent("PLAYER_LOGIN")
  end
end)

-- === SCANNER PROXIMIDAD - Solo pasar cerca ===
local scanFrame = CreateFrame("Frame")
scanFrame.lastScan = 0
scanFrame:SetScript("OnUpdate", function(self, elapsed)
  if not AICAD_GIA_DB or not AICAD_GIA_DB.autoScan then return end
  if AICAD_GIA:GetMapBase() == 3 then return end -- No escanear si WEB solo muestra
  self.lastScan = self.lastScan + elapsed
  if self.lastScan < 1.5 then return end
  self.lastScan = 0
  
  local mapID = GetCurrentMapAreaID and GetCurrentMapAreaID() or nil
  if not mapID or mapID == 0 then return end
  
  local x, y = GetPlayerMapPosition("player")
  if not x or x == 0 then return end
  
  if GameTooltip and GameTooltip:IsVisible() then
    local gtt = _G["GameTooltipTextLeft1"]
    if gtt then
      local name = gtt:GetText()
      if name then
        local lname = string.lower(name)
        if string.find(lname, "hierba") or string.find(lname, "flor") or string.find(lname, "espina") or string.find(lname, "terocone") or string.find(lname, "felweed") or string.find(lname, "dreaming glory") or string.find(lname, "nightmare vine") or string.find(lname, "veta") or string.find(lname, "filon") or string.find(lname, "adamantita") or string.find(lname, "khorium") then
          AICAD_GIA:SavePersonalNode(mapID, x, y, name)
        end
      end
    end
  end
end)
