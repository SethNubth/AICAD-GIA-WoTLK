-- UI\OptionsPanel.lua - Interface Menu Naerzone 30300 - AICAD-GIA-WoTLK v1.0 - Safe Blizzard DMCA - FINAL FIX
AICAD_GIA = AICAD_GIA or {}
AICAD_GIA.OptionsPanel = {}
AICAD_GIA_DB = AICAD_GIA_DB or {mapBase=3, useNodeLists=true, useNodeSight=true, routeMode="GOLD", useRouterAI=true, useTomTom=false, useGatherMate=false, useSkadaMedia=true}
AICAD_GIA_CHAR_DB = AICAD_GIA_CHAR_DB or {}
AICAD_ROUTER_DB = AICAD_ROUTER_DB or {activeDB="personal", mode="gold"}

local function CreateCheckbox(parent, name, text, x, y, varName, defaultVal, callback)
  local cb = CreateFrame("CheckButton", "AICAD_GIA_"..name, parent, "InterfaceOptionsCheckButtonTemplate")
  cb:SetPoint("TOPLEFT", x, y)
  local txt = _G[cb:GetName().."Text"]
  if txt then txt:SetText(text) else
    local fs = cb:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    fs:SetPoint("LEFT", cb, "RIGHT", 5, 0)
    fs:SetText(text)
  end
  local val = AICAD_GIA_DB[varName]
  if val == nil then val = defaultVal end
  cb:SetChecked(val and true or false)
  cb:SetScript("OnClick", function(self)
    AICAD_GIA_DB[varName] = self:GetChecked() and true or false
    if callback then callback(AICAD_GIA_DB[varName]) end
  end)
  return cb
end

function AICAD_GIA.OptionsPanel:CreatePanel()
  if self.panel then return end
  -- FIX 30300: sin UIParent, sin InterfaceOptionsFramePanelContainer
  local panel = CreateFrame("Frame", "AICAD_GIA_OptionsPanel")
  panel.name = "AICAD GIA |cffffcc00v1.0 - Naerzone|"
  panel.okay = function() end
  panel.cancel = function() end
  panel.refresh = function() end
  
  local title = panel:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
  title:SetPoint("TOPLEFT", 16, -16)
  title:SetText("AICAD GIA |cffffcc00v1.0 - Naerzone 3.3.5a|")
  
  local subtitle = panel:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
  subtitle:SetPoint("TOPLEFT", 16, -36)
  subtitle:SetWidth(550) subtitle:SetJustifyH("LEFT")
  subtitle:SetText("Rutas Mineria/Herboristeria 1-450 + Router AI + WorldMap 3 Bases + Media HD - WoTLK 30300")

  -- SECCION 1: WorldMap 3 Bases
  local section1 = panel:CreateFontString(nil, "ARTWORK", "GameFontNormal")
  section1:SetPoint("TOPLEFT", 16, -60)
  section1:SetText("|cffffcc00WorldMap - Base:|r (Blizzard WorldMapDetailFrame)")

  local baseDropdown = CreateFrame("Frame", "AICAD_GIA_BaseDropdown", panel, "UIDropDownMenuTemplate")
  baseDropdown:SetPoint("TOPLEFT", 16, -80)
  UIDropDownMenu_SetWidth(baseDropdown, 280)
  
  local function UpdateBaseText()
    local mode = AICAD_GIA_DB.mapBase or 3
    local texts = {[1]="1. Original Personal (tu base /aicad save)", [2]="2. GatherMate2", [3]="3. WEB Altertime .TGA 1024x1024 (default)"}
    UIDropDownMenu_SetText(baseDropdown, texts[mode] or texts[3])
  end
  
  UIDropDownMenu_Initialize(baseDropdown, function(self, level)
    level = level or 1
    local info = UIDropDownMenu_CreateInfo()
    info.notCheckable = false
    
    info.text = "1. Original Personal"
    info.checked = (AICAD_GIA_DB.mapBase == 1)
    info.func = function() AICAD_GIA_DB.mapBase=1 AICAD_ROUTER_DB.activeDB="personal" UpdateBaseText() print("|cffffcc00[AICAD] Base: Personal|r") if AICAD_WorldMap then AICAD_WorldMap:ShowZone() end end
    UIDropDownMenu_AddButton(info, level)
    
    info.text = "2. GatherMate2"
    info.checked = (AICAD_GIA_DB.mapBase == 2)
    info.func = function() AICAD_GIA_DB.mapBase=2 AICAD_ROUTER_DB.activeDB="imported" UpdateBaseText() print("|cffffcc00[AICAD] Base: GatherMate2|r") if AICAD_WorldMap then AICAD_WorldMap:ShowZone() end end
    UIDropDownMenu_AddButton(info, level)
    
    info.text = "3. WEB Altertime .TGA HD"
    info.checked = (AICAD_GIA_DB.mapBase == 3)
    info.func = function() AICAD_GIA_DB.mapBase=3 AICAD_ROUTER_DB.activeDB="imported" UpdateBaseText() print("|cffffcc00[AICAD] Base: WEB HD|r") if AICAD_WorldMap then AICAD_WorldMap:ShowZone() end end
    UIDropDownMenu_AddButton(info, level)
  end)
  UpdateBaseText()

  -- SECCION 2
  local section2 = panel:CreateFontString(nil, "ARTWORK", "GameFontNormal")
  section2:SetPoint("TOPLEFT", 16, -130)
  section2:SetText("|cffffcc00Data - NodeLists:|r")

  CreateCheckbox(panel, "UseNodeLists", "Usar NodeLists Curse (HERB/ORE ICONS)", 16, -150, "useNodeLists", true)
  CreateCheckbox(panel, "UseNodeSight", "NodeSight - Mostrar nodos WorldMap/Minimap", 16, -175, "useNodeSight", true, function(v)
    if ns and ns.EnableNodeSight then if v then ns.EnableNodeSight() else ns.DisableNodeSight() end end
  end)

  -- SECCION 3 Routes AI
  local section3 = panel:CreateFontString(nil, "ARTWORK", "GameFontNormal")
  section3:SetPoint("TOPLEFT", 16, -205)
  section3:SetText("|cffffcc00Routes AI - Modo:|r")

  local routeDropdown = CreateFrame("Frame", "AICAD_GIA_RouteDropdown", panel, "UIDropDownMenuTemplate")
  routeDropdown:SetPoint("TOPLEFT", 16, -225)
  UIDropDownMenu_SetWidth(routeDropdown, 280)
  
  local function UpdateRouteText()
    local mode = AICAD_GIA_DB.routeMode or "GOLD"
    UIDropDownMenu_SetText(routeDropdown, mode=="GOLD" and "ORO - Saronita/Titanio Farmeo" or "LEVELING 1-450")
  end
  
  UIDropDownMenu_Initialize(routeDropdown, function(self, level)
    local info = UIDropDownMenu_CreateInfo()
    info.text = "ORO - Saronita/Titanio (80)"
    info.checked = (AICAD_GIA_DB.routeMode=="GOLD")
    info.func = function() AICAD_GIA_DB.routeMode="GOLD" AICAD_ROUTER_DB.mode="gold" UpdateRouteText() end
    UIDropDownMenu_AddButton(info, level)
    
    info.text = "LEVELING 1-450 - Subir profesion"
    info.checked = (AICAD_GIA_DB.routeMode=="LEVELING_1_450")
    info.func = function() AICAD_GIA_DB.routeMode="LEVELING_1_450" AICAD_ROUTER_DB.mode="level" UpdateRouteText() end
    UIDropDownMenu_AddButton(info, level)
  end)
  UpdateRouteText()

  CreateCheckbox(panel, "UseRouterAI", "RouterAI - Linea amarilla sobre Blizzard Map", 16, -260, "useRouterAI", true)

  -- SECCION 4
  local section4 = panel:CreateFontString(nil, "ARTWORK", "GameFontNormal")
  section4:SetPoint("TOPLEFT", 16, -290)
  section4:SetText("|cffffcc00Auxiliares Opcionales:|r")

  CreateCheckbox(panel, "UseTomTom", "TomTom r240 - Waypoints + flecha (OFF = solo linea)", 16, -310, "useTomTom", false)
  CreateCheckbox(panel, "UseGatherMate", "GatherMate2 + Data - Importar", 16, -335, "useGatherMate", false)
  CreateCheckbox(panel, "UseSkadaMedia", "Media HD - Texturas 1024x1024 .TGA Skada", 16, -360, "useSkadaMedia", true)

  local info = panel:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
  info:SetPoint("TOPLEFT", 16, -395)
  info:SetWidth(550) info:SetJustifyH("LEFT")
  info:SetText("Map: WorldMapDetailFrame + Minimap | Fan Addon - All WoW assets Blizzard | Naerzone 3.3.5a 30300 | /aicad | /wmap | /route gold")

  InterfaceOptions_AddCategory(panel)
  self.panel = panel
  print("|cffffcc00[AICAD GIA] OptionsPanel ESC → Interface → AICAD GIA - 30300 cargado|r")
end

local f = CreateFrame("Frame")
f:RegisterEvent("ADDON_LOADED")
f:SetScript("OnEvent", function(self, event, addon)
  if addon == "AicadGia" or addon == "AICAD_GIA" then
    AICAD_GIA.OptionsPanel:CreatePanel()
    self:UnregisterEvent("ADDON_LOADED")
  end
end)
