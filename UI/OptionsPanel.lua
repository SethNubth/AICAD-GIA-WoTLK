-- UI\OptionsPanel.lua - Interface Menu Naerzone 30300 - AICAD-GIA-WoTLK v1.0 Forever

AICAD_GIA = AICAD_GIA or {}
AICAD_GIA.OptionsPanel = {}

local function CreateCheckbox(parent, name, text, x, y, varName, defaultVal, callback)
  local cb = CreateFrame("CheckButton", "AICAD_GIA_"..name, parent, "InterfaceOptionsCheckButtonTemplate")
  cb:SetPoint("TOPLEFT", x, y)
  _G[cb:GetName().."Text"]:SetText(text)
  cb:SetChecked(AICAD_GIA_DB[varName] ~= nil and AICAD_GIA_DB[varName] or defaultVal)
  
  cb:SetScript("OnClick", function(self)
    AICAD_GIA_DB[varName] = self:GetChecked() and true or false
    if callback then callback(AICAD_GIA_DB[varName]) end
  end)
  return cb
end

function AICAD_GIA.OptionsPanel:CreatePanel()
  -- Panel principal ESC → Interface → AddOns → AICAD GIA
  local panel = CreateFrame("Frame", "AICAD_GIA_OptionsPanel", UIParent)
  panel.name = "AICAD GIA |cffffcc00v1.0 Forever - Naerzone|"
  panel.okay = function() end
  panel.cancel = function() end
  
  -- Título
  local title = panel:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
  title:SetPoint("TOPLEFT", 16, -16)
  title:SetText("AICAD GIA |cffffcc00v1.0 Forever - Naerzone 3.3.5a| |cff888888AICAD-GIA-WoTLK|")
  
  local subtitle = panel:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
  subtitle:SetPoint("TOPLEFT", 16, -36)
  subtitle:SetText("Rutas Mineria/Herboristeria 1-450 + Router AI + WorldMap 3 Bases + Skada Media HD")
  
  -- ===== SECCION 1: WorldMap 3 Bases =====
  local section1 = panel:CreateFontString(nil, "ARTWORK", "GameFontNormal")
  section1:SetPoint("TOPLEFT", 16, -65)
  section1:SetText("|cffffcc00WorldMap - Base:|r (Blizzard WorldMapDetailFrame)")
  
  -- Dropdown Base
  local baseDropdown = CreateFrame("Frame", "AICAD_GIA_BaseDropdown", panel, "UIDropDownMenuTemplate")
  baseDropdown:SetPoint("TOPLEFT", 16, -85)
  UIDropDownMenu_SetWidth(baseDropdown, 280)
  
  local function UpdateBaseText()
    local mode = AICAD_GIA_DB.mapBase or 3
    local texts = {
      [1] = "1. Original Personal (tu base /aicad save)",
      [2] = "2. GatherMate2 (GatherMate2DB auxiliar)",
      [3] = "3. WEB Altertime .TGA 1024x1024 (default)"
    }
    UIDropDownMenu_SetText(baseDropdown, texts[mode])
  end
  
  UIDropDownMenu_Initialize(baseDropdown, function(self, level)
    local info = UIDropDownMenu_CreateInfo()
    
    info.text = "1. Original Personal (tu base)"
    info.func = function()
      AICAD_GIA_DB.mapBase = 1
      UpdateBaseText()
      if AICAD_GIA.WorldMap then AICAD_GIA.WorldMap:RefreshMap() end
      print("|cffffcc00[AICAD GIA] Base: Original Personal|r")
    end
    UIDropDownMenu_AddButton(info)
    
    info.text = "2. GatherMate2 (GatherMate2DB si lo tienes)"
    info.func = function()
      AICAD_GIA_DB.mapBase = 2
      UpdateBaseText()
      if AICAD_GIA.WorldMap then AICAD_GIA.WorldMap:RefreshMap() end
      print("|cffffcc00[AICAD GIA] Base: GatherMate2|r")
    end
    UIDropDownMenu_AddButton(info)
    
    info.text = "3. WEB Altertime .TGA 1024x1024 (Media\\Maps\\)"
    info.func = function()
      AICAD_GIA_DB.mapBase = 3
      UpdateBaseText()
      if AICAD_GIA.WorldMap then AICAD_GIA.WorldMap:RefreshMap() end
      print("|cffffcc00[AICAD GIA] Base: WEB Altertime|r")
    end
    UIDropDownMenu_AddButton(info)
  end)
  
  UpdateBaseText()
  
  -- ===== SECCION 2: Data NodeLists toggle =====
  local section2 = panel:CreateFontString(nil, "ARTWORK", "GameFontNormal")
  section2:SetPoint("TOPLEFT", 16, -135)
  section2:SetText("|cffffcc00Data - NodeLists (Curse):|r")
  
  CreateCheckbox(panel, "UseNodeLists", "Usar NodeLists Curse (HERB_ICONS/ORE_ICONS)", 16, -155, "useNodeLists", true, function(v)
    print("|cffffcc00[AICAD GIA] NodeLists: |r"..(v and "ON" or "OFF"))
  end)
  
  CreateCheckbox(panel, "UseNodeSight", "NodeSight - Mostrar nodos en WorldMap/Minimap", 16, -180, "useNodeSight", true, function(v)
    if AICAD_GIA.NodeSight then
      if v then AICAD_GIA.NodeSight:Enable() else AICAD_GIA.NodeSight:Disable() end
    end
  end)
  
  -- ===== SECCION 3: Routes AI =====
  local section3 = panel:CreateFontString(nil, "ARTWORK", "GameFontNormal")
  section3:SetPoint("TOPLEFT", 16, -215)
  section3:SetText("|cffffcc00Routes AI - Modo:|r (Data\\Routes.lua)")
  
  -- Dropdown Route Mode
  local routeDropdown = CreateFrame("Frame", "AICAD_GIA_RouteDropdown", panel, "UIDropDownMenuTemplate")
  routeDropdown:SetPoint("TOPLEFT", 16, -235)
  UIDropDownMenu_SetWidth(routeDropdown, 280)
  
  local function UpdateRouteText()
    local mode = AICAD_GIA_DB.routeMode or "GOLD"
    UIDropDownMenu_SetText(routeDropdown, mode == "GOLD" and "ORO - Saronita/Titanio Farmeo" or "LEVELING 1-450 - Subir profesion")
  end
  
  UIDropDownMenu_Initialize(routeDropdown, function(self, level)
    local info = UIDropDownMenu_CreateInfo()
    info.text = "ORO - Farmeo Saronita/Titanio (Nivel 80)"
    info.func = function()
      AICAD_GIA_DB.routeMode = "GOLD"
      UpdateRouteText()
      if AICAD_GIA.RouterAI then AICAD_GIA.RouterAI:Refresh() end
    end
    UIDropDownMenu_AddButton(info)
    
    info.text = "LEVELING 1-450 - Subir Mineria/Herbo"
    info.func = function()
      AICAD_GIA_DB.routeMode = "LEVELING_1_450"
      UpdateRouteText()
      if AICAD_GIA.RouterAI then AICAD_GIA.RouterAI:Refresh() end
    end
    UIDropDownMenu_AddButton(info)
  end)
  
  UpdateRouteText()
  
  CreateCheckbox(panel, "UseRouterAI", "RouterAI - Línea amarilla sobre Blizzard Map", 16, -270, "useRouterAI", true)
  
  -- ===== SECCION 4: Auxiliares opcionales =====
  local section4 = panel:CreateFontString(nil, "ARTWORK", "GameFontNormal")
  section4:SetPoint("TOPLEFT", 16, -305)
  section4:SetText("|cffffcc00Auxiliares Opcionales (si se desea usar):|r")
  
  CreateCheckbox(panel, "UseTomTom", "TomTom r240 - Waypoints + flecha auxiliar", 16, -325, "useTomTom", false, function(v)
    print("|cffffcc00[AICAD GIA] TomTom r240: |r"..(v and "ON (auxiliar)" or "OFF (solo linea amarilla)"))
  end)
  
  CreateCheckbox(panel, "UseGatherMate", "GatherMate2 + Data - Importar nodos", 16, -350, "useGatherMate", false)
  
  CreateCheckbox(panel, "UseSkadaMedia", "Skada Media HD - Texturas HD 1024x1024 .TGA", 16, -375, "useSkadaMedia", true)
  
  -- Info final
  local info = panel:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
  info:SetPoint("TOPLEFT", 16, -410)
  info:SetText("Map Blizzard: WorldMapDetailFrame + Minimap | Libs: LibStub + LibSharedMedia-3.0 | Media: Media\\Maps\\*.tga WEB Altertime | GitHub: AICAD-GIA-WoTLK")
  
  -- Registrar en Interface Options Blizzard 30300
  InterfaceOptions_AddCategory(panel)
  
  self.panel = panel
  print("|cffffcc00[AICAD GIA] OptionsPanel cargado - ESC → Interface → AICAD GIA|r")
end

-- Crear al iniciar
local f = CreateFrame("Frame")
f:RegisterEvent("ADDON_LOADED")
f:SetScript("OnEvent", function(self, event, addon)
  if addon == "AICAD_GIA" then
    AICAD_GIA.OptionsPanel:CreatePanel()
    self:UnregisterEvent("ADDON_LOADED")
  end
end)
