-- CursorBlinkMove_Options.lua (Retail Settings UI - Canvas panel, no AddInitializer)
local ADDON = ...
local L = _G.CursorBlinkMove_L or {}
local ICON_PATH = "Interface\\AddOns\\CursorBlinkMove\\CBM_WoW_Icon_final"

-- Account-wide saved variables (TOC: ## SavedVariables: CursorBlinkMoveDB)
CursorBlinkMoveDB = CursorBlinkMoveDB or {}

local function dflt(key, val)
  if CursorBlinkMoveDB[key] == nil then CursorBlinkMoveDB[key] = val end
end

dflt("enabled", true)
dflt("speedThreshold", 20000)
dflt("keepBlinkingFor", 4.0)
dflt("blinkEvery", 0.15)
dflt("size", 80)
dflt("color", { r = 1, g = 0, b = 0, a = 1 }) -- a bleibt in DB, wird aber nicht mehr benutzt
dflt("debug", false)

-- Ensure color is ALWAYS valid + default FF0000
local function EnsureDefaultColor()
  CursorBlinkMoveDB.color = CursorBlinkMoveDB.color or {}
  if type(CursorBlinkMoveDB.color.r) ~= "number" then CursorBlinkMoveDB.color.r = 1 end
  if type(CursorBlinkMoveDB.color.g) ~= "number" then CursorBlinkMoveDB.color.g = 0 end
  if type(CursorBlinkMoveDB.color.b) ~= "number" then CursorBlinkMoveDB.color.b = 0 end
  CursorBlinkMoveDB.color.a = 1 -- alpha disabled
end
EnsureDefaultColor()

local function clamp(x, lo, hi)
  x = tonumber(x)
  if not x then return lo end
  if x < lo then return lo end
  if x > hi then return hi end
  return x
end

local function round(x, step)
  step = step or 1
  return math.floor((x / step) + 0.5) * step
end

local function notifyChanged()
  if type(CursorBlinkMove_RefreshVisual) == "function" then
    CursorBlinkMove_RefreshVisual()
  end
end

local function CreateDivider(parent, y)
  local line = parent:CreateTexture(nil, "ARTWORK")
  line:SetColorTexture(1, 1, 1, 0.08)
  line:SetPoint("TOPLEFT", 16, y)
  line:SetPoint("TOPRIGHT", -16, y)
  line:SetHeight(1)
end

local function CreateHeader(parent, text, y)
  local fs = parent:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
  fs:SetPoint("TOPLEFT", 16, y)
  fs:SetText(text)
  return fs
end

local function ShowTooltip(owner, text)
  if not text or text == "" then return end
  GameTooltip:SetOwner(owner, "ANCHOR_RIGHT")
  -- Your build: SetText(text, r, g, b, a, wrap)
  GameTooltip:SetText(text, 1, 1, 1, 1, true)
  GameTooltip:Show()
end

local function HideTooltip()
  GameTooltip:Hide()
end

local function CreateCheckbox(parent, labelText, tooltipText, y, get, set)
  local cb = CreateFrame("CheckButton", nil, parent, "UICheckButtonTemplate")
  cb:SetPoint("TOPLEFT", 16, y)
  cb.text:SetText(labelText)
  cb:SetChecked(get())

  cb:SetScript("OnClick", function(self)
    set(self:GetChecked() and true or false)
    notifyChanged()
  end)

  cb:SetScript("OnEnter", function() ShowTooltip(cb, tooltipText) end)
  cb:SetScript("OnLeave", HideTooltip)

  return cb
end

-- Unique slider naming so OptionsSliderTemplate globals exist
local SLIDER_ID = 0
local function NextSliderName()
  SLIDER_ID = SLIDER_ID + 1
  return "CursorBlinkMoveSlider" .. SLIDER_ID
end

local function CreateSlider(parent, nameText, tooltipText, y, minV, maxV, step, formatValue, get, set, snapStep)
  local label = parent:CreateFontString(nil, "ARTWORK", "GameFontNormal")
  label:SetPoint("TOPLEFT", 16, y)
  label:SetText(nameText)

  local valueFS = parent:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
  valueFS:SetPoint("TOPRIGHT", -16, y)
  valueFS:SetText("")

  local sliderName = NextSliderName()
  local slider = CreateFrame("Slider", sliderName, parent, "OptionsSliderTemplate")
  slider:SetPoint("TOPLEFT", 16, y - 22)
  slider:SetPoint("TOPRIGHT", -16, y - 22)
  slider:SetMinMaxValues(minV, maxV)
  slider:SetValueStep(step)
  slider:SetObeyStepOnDrag(true)

  local low = _G[sliderName .. "Low"]
  local high = _G[sliderName .. "High"]
  local text = _G[sliderName .. "Text"]
  if low then low:SetText(tostring(minV)) end
  if high then high:SetText(tostring(maxV)) end
  if text then text:SetText("") end

  local function refresh()
    local current = get()
    local v = clamp(current, minV, maxV)
    if v ~= current then set(v) end
    slider:SetValue(v)
    valueFS:SetText(formatValue(v))
  end

  slider:SetScript("OnValueChanged", function(_, val)
    local v = clamp(val, minV, maxV)
    if snapStep then v = round(v, snapStep) end
    v = clamp(v, minV, maxV)
    set(v)
    valueFS:SetText(formatValue(v))
    notifyChanged()
  end)

  slider:SetScript("OnEnter", function() ShowTooltip(slider, tooltipText) end)
  slider:SetScript("OnLeave", HideTooltip)

  refresh()
  return slider, refresh
end

local function CreateColorRow(parent, y)
  EnsureDefaultColor()

  local label = parent:CreateFontString(nil, "ARTWORK", "GameFontNormal")
  label:SetPoint("TOPLEFT", 16, y)
  label:SetText(L.OPT_COLOR_LABEL or "Glow Color")

  local swatchBorder = CreateFrame("Frame", nil, parent, "BackdropTemplate")
  swatchBorder:SetSize(28, 28)
  swatchBorder:SetPoint("TOPLEFT", 16, y - 28)
  swatchBorder:SetBackdrop({
    edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
    edgeSize = 12,
  })

  local swatchArea = CreateFrame("Frame", nil, swatchBorder)
  swatchArea:SetPoint("CENTER")
  swatchArea:SetSize(20, 20)

  -- checkerboard background directly on swatchArea (so overlay ALWAYS wins)
  local tileN = 5
  local tileSize = 20 / tileN
  for yy = 1, tileN do
    for xx = 1, tileN do
      local t = swatchArea:CreateTexture(nil, "BACKGROUND")
      t:SetSize(tileSize, tileSize)
      t:SetPoint("TOPLEFT", (xx - 1) * tileSize, -((yy - 1) * tileSize))
      local isLight = ((xx + yy) % 2 == 0)
      if isLight then
        t:SetColorTexture(0.85, 0.85, 0.85, 1)
      else
        t:SetColorTexture(0.65, 0.65, 0.65, 1)
      end
    end
  end

  -- Always opaque preview (this MUST be visible now)
  local swatchColor = swatchArea:CreateTexture(nil, "OVERLAY")
  swatchColor:SetAllPoints(true)

  local function applySwatch()
    EnsureDefaultColor()
    local c = CursorBlinkMoveDB.color
    swatchColor:SetColorTexture(c.r, c.g, c.b, 1)
  end
  applySwatch()

  local btnPick = CreateFrame("Button", nil, parent, "UIPanelButtonTemplate")
  btnPick:SetSize(120, 22)
  btnPick:SetPoint("LEFT", swatchBorder, "RIGHT", 12, 0)
  btnPick:SetText(L.OPT_PICK_COLOR or "Pick Color")

  local btnTest = CreateFrame("Button", nil, parent, "UIPanelButtonTemplate")
  btnTest:SetSize(120, 22)
  btnTest:SetPoint("TOPLEFT", btnPick, "BOTTOMLEFT", 0, -6)
  btnTest:SetText(L.OPT_TEST_BLINK or "Test Blink")
  btnTest:SetScript("OnClick", function()
    if type(CursorBlinkMove_TestBlink) == "function" then
      CursorBlinkMove_TestBlink(2.0)
    else
      print("|cff00ff00" .. (L.ADDON_PREFIX or "CursorBlinkMove") .. "|r:", L.MSG_TESTBLINK_MISSING or "TestBlink function not found.")
    end
  end)

  btnPick:SetScript("OnClick", function()
    EnsureDefaultColor()
    local c = CursorBlinkMoveDB.color

    local function commit(r, g, b)
      CursorBlinkMoveDB.color.r = clamp(r, 0, 1)
      CursorBlinkMoveDB.color.g = clamp(g, 0, 1)
      CursorBlinkMoveDB.color.b = clamp(b, 0, 1)
      CursorBlinkMoveDB.color.a = 1 -- alpha disabled
      applySwatch()
      notifyChanged()
    end

    local function CP_SetRGB(r, g, b)
      if type(ColorPickerFrame_SetColorRGB) == "function" then
        ColorPickerFrame_SetColorRGB(r, g, b)
        return
      end
      if ColorPickerFrame and type(ColorPickerFrame.SetColorRGB) == "function" then
        ColorPickerFrame:SetColorRGB(r, g, b)
        return
      end
    end

    local function CP_GetRGB()
      if ColorPickerFrame and type(ColorPickerFrame.GetColorRGB) == "function" then
        return ColorPickerFrame:GetColorRGB()
      end
      if type(ColorPickerFrame_GetColorRGB) == "function" then
        return ColorPickerFrame_GetColorRGB()
      end
      return c.r, c.g, c.b
    end

    CP_SetRGB(c.r, c.g, c.b)

    -- Disable opacity handling completely
    ColorPickerFrame.hasOpacity = false
    ColorPickerFrame.opacity = nil
    ColorPickerFrame.previousValues = { c.r, c.g, c.b, 1 }

    local function applyFromPicker()
      local r, g, b = CP_GetRGB()
      commit(r, g, b)
    end

    -- Your build requires swatchFunc
    ColorPickerFrame.swatchFunc = applyFromPicker
    -- Backward compat
    ColorPickerFrame.func = applyFromPicker
    ColorPickerFrame.opacityFunc = nil
    ColorPickerFrame.cancelFunc = function(prev)
      if prev then
        commit(prev[1], prev[2], prev[3])
      end
    end

    ColorPickerFrame:Hide()
    ColorPickerFrame:Show()
  end)

  return applySwatch
end

local function BuildPanel(panel)
  panel:Hide()
  panel.name = L.ADDON_TITLE or "CursorBlinkMove"
  
    -- Addon icon (top-right)
if not panel._cbmIcon then
  local icon = panel:CreateTexture(nil, "ARTWORK")
  icon:SetSize(64, 64)
  icon:SetPoint("TOPRIGHT", -16, -16)
  icon:SetTexture(ICON_PATH)

  -- No crop (prevents looking cut off)
  icon:SetTexCoord(0, 1, 0, 1)

  panel._cbmIcon = icon
else
  panel._cbmIcon:SetTexture(ICON_PATH)
  panel._cbmIcon:SetTexCoord(0, 1, 0, 1)
end

  local y = -16
  CreateHeader(panel, L.ADDON_TITLE or "CursorBlinkMove", y)
  y = y - 24
  CreateDivider(panel, y)
  y = y - 16

  CreateCheckbox(
    panel,
    L.OPT_ENABLED_DESC or "Enable CursorBlinkMove",
    "",
    y,
    function() return CursorBlinkMoveDB.enabled end,
    function(v) CursorBlinkMoveDB.enabled = v end
  )
  y = y - 44

  local _, refreshThreshold = CreateSlider(
    panel,
    L.OPT_THRESHOLD_NAME or "Threshold (px/s)",
    L.OPT_THRESHOLD_DESC or "",
    y,
    8000, 32000, 50,
    function(v) return string.format("%.0f", v) end,
    function() return CursorBlinkMoveDB.speedThreshold end,
    function(v) CursorBlinkMoveDB.speedThreshold = v end,
    50
  )
  y = y - 62

  local _, refreshDuration = CreateSlider(
    panel,
    L.OPT_DURATION_NAME or "Duration (s)",
    L.OPT_DURATION_DESC or "",
    y,
    0, 15, 0.5,
    function(v) return string.format("%.1f s", v) end,
    function() return CursorBlinkMoveDB.keepBlinkingFor end,
    function(v) CursorBlinkMoveDB.keepBlinkingFor = v end,
    0.5
  )
  y = y - 62

  local _, refreshRate = CreateSlider(
    panel,
    L.OPT_RATE_NAME or "Rate / Period (s)",
    L.OPT_RATE_DESC or "",
    y,
    0.05, 1.0, 0.01,
    function(v) return string.format("%.2f s", v) end,
    function() return CursorBlinkMoveDB.blinkEvery end,
    function(v) CursorBlinkMoveDB.blinkEvery = v end,
    0.01
  )
  y = y - 62

  local _, refreshSize = CreateSlider(
    panel,
    L.OPT_SIZE_NAME or "Size (px)",
    L.OPT_SIZE_DESC or "",
    y,
    24, 160, 1,
    function(v) return string.format("%.0f px", v) end,
    function() return CursorBlinkMoveDB.size end,
    function(v) CursorBlinkMoveDB.size = v end,
    1
  )
  y = y - 62

  CreateDivider(panel, y + 10)
  y = y - 8

  local colorHeader = panel:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
  colorHeader:SetPoint("TOPLEFT", 16, y)
  colorHeader:SetText(L.OPT_COLOR_SECTION or "Color")
  y = y - 34

  local applySwatch = CreateColorRow(panel, y)

  panel:SetScript("OnShow", function()
    EnsureDefaultColor()
    if type(CursorBlinkMove_RefreshVisual) == "function" then
      CursorBlinkMove_RefreshVisual()
    end
    if applySwatch then applySwatch() end
    if refreshThreshold then refreshThreshold() end
    if refreshDuration then refreshDuration() end
    if refreshRate then refreshRate() end
    if refreshSize then refreshSize() end
  end)
end

local function RegisterPanel()
  if Settings and Settings.RegisterCanvasLayoutCategory and Settings.RegisterAddOnCategory then
    local panel = CreateFrame("Frame", nil, UIParent)
    BuildPanel(panel)

    local category = Settings.RegisterCanvasLayoutCategory(panel, L.ADDON_TITLE or "CursorBlinkMove")
	Settings.RegisterAddOnCategory(category)

	-- Export CategoryID so /cbm can open it safely
	_G.CursorBlinkMove_CategoryID = category and category.ID or nil
	return
  end

  if InterfaceOptions_AddCategory then
    local panel = CreateFrame("Frame", nil, UIParent)
    BuildPanel(panel)
    InterfaceOptions_AddCategory(panel)
    return
  end

  print("|cff00ff00" .. (L.ADDON_PREFIX or "CursorBlinkMove") .. "|r:", L.MSG_SETTINGS_UNAVAILABLE or "Settings UI not available in this client.")
end

local f = CreateFrame("Frame")
f:RegisterEvent("ADDON_LOADED")
f:SetScript("OnEvent", function(_, _, name)
  if name == ADDON then
    RegisterPanel()
  end
end)