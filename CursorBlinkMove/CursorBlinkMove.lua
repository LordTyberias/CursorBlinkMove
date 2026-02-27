-- CursorBlinkMove.lua (Retail)
-- Blinkender Glow um den Cursor bei schneller Bewegung + 5s Nachlauf
-- Debug-Modus mit Prints + Farbe einstellbar (SavedVariables)

local ADDON = ...
CursorBlinkMoveDB = CursorBlinkMoveDB or {}
local L = _G.CursorBlinkMove_L or {}

-- ===== Defaults =====
local defaults = {
  enabled = true,

  speedThreshold = 2200,   -- px/s ab wann "schnell"
  keepBlinkingFor = 5.0,   -- Sekunden Nachlauf
  blinkEvery = 0.20,       -- volle Blink-Periode (sek). 0.20 = 5 Hz
  size = 72,               -- etwas größer, damit man es sicher sieht

  -- KNALLIGES ROT (Default)
  color = { r = 1.0, g = 0.0, b = 0.0, a = 1.0 },

  -- Debug
  debug = false,
  debugThrottle = 0.25,    -- min. Sekunden zwischen Debug-Speed-Prints

  -- Texture (färbbar via VertexColor)
  texture = "Interface\\Cooldown\\star4",
}

local function applyDefaults()
  for k, v in pairs(defaults) do
    if CursorBlinkMoveDB[k] == nil then
      if type(v) == "table" then
        CursorBlinkMoveDB[k] = {}
        for kk, vv in pairs(v) do
          CursorBlinkMoveDB[k][kk] = vv
        end
      else
        CursorBlinkMoveDB[k] = v
      end
    end
  end
end
applyDefaults()

-- Ensure default color is valid (FF0000) + alpha disabled
do
  CursorBlinkMoveDB.color = CursorBlinkMoveDB.color or {}
  if type(CursorBlinkMoveDB.color.r) ~= "number" then CursorBlinkMoveDB.color.r = 1 end
  if type(CursorBlinkMoveDB.color.g) ~= "number" then CursorBlinkMoveDB.color.g = 0 end
  if type(CursorBlinkMoveDB.color.b) ~= "number" then CursorBlinkMoveDB.color.b = 0 end
  CursorBlinkMoveDB.color.a = 1
end

local function clamp01(x)
  x = tonumber(x)
  if not x then return 0 end
  if x < 0 then return 0 end
  if x > 1 then return 1 end
  return x
end

local function dprint(...)
  if CursorBlinkMoveDB.debug then
    print("|cffFF3333" .. (L.DEBUG_PREFIX or "CursorBlinkMove DEBUG") .. "|r:", ...)
  end
end

-- ===== Glow Frame =====
local glow = CreateFrame("Frame", ADDON .. "GlowFrame", UIParent)
glow:SetFrameStrata("TOOLTIP")
glow:SetClampedToScreen(true)
glow:Hide()

local tex = glow:CreateTexture(nil, "OVERLAY")
tex:SetAllPoints(true)
tex:SetTexture(CursorBlinkMoveDB.texture)
tex:SetBlendMode("ADD")

-- Exposed so Options UI can refresh visuals live
function CursorBlinkMove_RefreshVisual()
  glow:SetSize(CursorBlinkMoveDB.size, CursorBlinkMoveDB.size)
  local c = CursorBlinkMoveDB.color
  -- Alpha is disabled -> always 1
  tex:SetVertexColor(c.r, c.g, c.b, 1)
end
CursorBlinkMove_RefreshVisual()

local function getCursorXY()
  local x, y = GetCursorPosition()
  local scale = UIParent:GetEffectiveScale()
  return x / scale, y / scale
end

-- ===== State =====
local lastX, lastY, lastT

-- Ignore window after login/enter world (prevents false trigger)
local ignoreUntil = GetTime() + 1.0

-- Filters against cursor "teleport" on focus changes / alt-tab / loading
local MAX_DT_RESET = 0.35      -- if dt bigger than this -> reset tracking
local JUMP_DIST = 500          -- pixels; big cursor jump
local JUMP_DT_MAX = 0.08       -- seconds; if jump happens within this -> treat as teleport

local activeUntil = 0
local nextToggleAt = 0
local glowOn = false

local lastDebugAt = 0
local lastActiveState = false

local function setGlowVisible(on)
  glowOn = on
  if on then
    if not glow:IsShown() then glow:Show() end
    tex:SetAlpha(1)
  else
    if glow:IsShown() then
      tex:SetAlpha(0)
    end
  end
end

local function stopGlow()
  setGlowVisible(false)
  glow:Hide()
end

local function ResetTracking(now, x, y, reason)
  lastX, lastY, lastT = x, y, now
  activeUntil = 0
  nextToggleAt = 0
  glowOn = false
  lastActiveState = false
  stopGlow()
  dprint("ResetTracking:", reason or "unknown")
end

local ev = CreateFrame("Frame")
ev:RegisterEvent("PLAYER_ENTERING_WORLD")
ev:SetScript("OnEvent", function()
  ignoreUntil = GetTime() + 1.0
  lastT = nil
  stopGlow()
  dprint("Ignore window start (PLAYER_ENTERING_WORLD)")
end)

-- Exposed helper for options UI: trigger blinking for X seconds
function CursorBlinkMove_TestBlink(seconds)
  seconds = tonumber(seconds) or 2.0
  local now = GetTime()
  activeUntil = now + seconds
  nextToggleAt = 0
  if not glow:IsShown() then glow:Show() end
  dprint("TestBlink:", seconds, "seconds; activeUntil=", ("%.2f"):format(activeUntil))
end

-- ===== Driver =====
local driver = CreateFrame("Frame", ADDON .. "Driver", UIParent)
driver:SetScript("OnUpdate", function(_, elapsed)
  if not CursorBlinkMoveDB.enabled then
    if glow:IsShown() then stopGlow() end
    return
  end

  local now = GetTime()
  local x, y = getCursorXY()

  glow:ClearAllPoints()
  glow:SetPoint("CENTER", UIParent, "BOTTOMLEFT", x, y)

  if not lastT then
    lastX, lastY, lastT = x, y, now
    return
  end

  local dt = now - lastT
  local speed = 0
  local dist = 0

  -- Ignore window after entering world (login/reload/zone)
  if now < ignoreUntil then
    lastX, lastY, lastT = x, y, now
    if glow:IsShown() then stopGlow() end
    return
  end

  -- If dt is too large (game paused / loading / tabbed out), reset tracking
  if dt <= 0 or dt > MAX_DT_RESET then
    ResetTracking(now, x, y, "dt_reset")
    return
  end

  local dx = x - lastX
  local dy = y - lastY
  dist = math.sqrt(dx * dx + dy * dy)

  -- Cursor teleport/jump filter (common on alt-tab / focus change)
  if dist >= JUMP_DIST and dt <= JUMP_DT_MAX then
    ResetTracking(now, x, y, ("jump_filter dist=%.0f dt=%.3f"):format(dist, dt))
    return
  end

  speed = dist / dt

  if CursorBlinkMoveDB.debug and (now - lastDebugAt) >= CursorBlinkMoveDB.debugThrottle then
    lastDebugAt = now
    dprint(("speed=%.0f px/s threshold=%.0f activeRemaining=%.2f"):format(
      speed, CursorBlinkMoveDB.speedThreshold, math.max(0, activeUntil - now)
    ))
  end

  if speed >= CursorBlinkMoveDB.speedThreshold then
    activeUntil = now + CursorBlinkMoveDB.keepBlinkingFor
    if not lastActiveState then
      dprint("FAST detected -> start/extend active window until", ("%.2f"):format(activeUntil))
    end
  end

  local active = (now < activeUntil)

  if active ~= lastActiveState then
    lastActiveState = active
    if active then
      dprint("ACTIVE = true (begin blinking)")
      nextToggleAt = 0
      setGlowVisible(false)
    else
      dprint("ACTIVE = false (stop blinking)")
      stopGlow()
    end
  end

  if active then
    if not glow:IsShown() then glow:Show() end

    if nextToggleAt == 0 or now >= nextToggleAt then
      setGlowVisible(not glowOn)

      local half = CursorBlinkMoveDB.blinkEvery * 0.5
      if half < 0.02 then half = 0.02 end
      nextToggleAt = now + half

      dprint("TOGGLE glow ->", glowOn and "ON" or "OFF", "nextToggleAt", ("%.2f"):format(nextToggleAt))
    end
  end

  lastX, lastY, lastT = x, y, now
end)

-- ===== Open Options Helper =====
local function OpenCursorBlinkMoveOptions()
  -- Prefer the real Settings CategoryID exported by Options.lua
  local catID = _G.CursorBlinkMove_CategoryID

  if Settings and Settings.OpenToCategory and type(catID) == "number" then
    Settings.OpenToCategory(catID)
    Settings.OpenToCategory(catID) -- Blizzard quirk: calling twice helps sometimes
    return true
  end

  -- Fallback: try by addon title string on builds that still accept it
  local name = (L.ADDON_TITLE or "CursorBlinkMove")
  if Settings and Settings.OpenToCategory then
    local ok = pcall(Settings.OpenToCategory, name)
    if ok then
      pcall(Settings.OpenToCategory, name)
      return true
    end
  end

  -- Old Interface Options fallback (older clients)
  if InterfaceOptionsFrame_OpenToCategory then
    InterfaceOptionsFrame_OpenToCategory(name)
    InterfaceOptionsFrame_OpenToCategory(name)
    return true
  end

  return false
end

-- ===== Slash Commands =====
SLASH_CursorBlinkMove1 = "/cbm"
SlashCmdList["CursorBlinkMove"] = function(msg)
  local L = _G.CursorBlinkMove_L or {}
  msg = msg or ""
  local cmd, a, b, c, d = msg:match("^(%S+)%s*(%S*)%s*(%S*)%s*(%S*)%s*(%S*)")
  cmd = (cmd or ""):lower()

  local prefix = "|cff00ff00" .. (L.ADDON_PREFIX or "CursorBlinkMove") .. "|r:"

  -- /cbm              -> open options
  -- /cbm options      -> print command list
  -- /cbm settings     -> print command list
  -- /cbm help         -> print command list
  if cmd == "" then
    if not OpenCursorBlinkMoveOptions() then
      print(prefix, (L.MSG_SETTINGS_UNAVAILABLE or "Settings UI not available in this client."))
    end
    return
  end

  if cmd == "options" or cmd == "settings" or cmd == "help" then
    print(prefix, L.CMD_HELP_HEADER or "commands:")
    print(L.CMD_HELP_STATUS or "  /cbm status")
    print(L.CMD_HELP_COLOR or "  /cbm color r g b [a]     (0..1)")
    print(L.CMD_HELP_THRESHOLD or "  /cbm threshold <px/s>")
    print(L.CMD_HELP_DURATION or "  /cbm duration <sec>")
    print(L.CMD_HELP_RATE or "  /cbm rate <sec>")
    print(L.CMD_HELP_SIZE or "  /cbm size <px>")
    print(L.CMD_HELP_ONOFF or "  /cbm on | /cbm off")
    print(L.CMD_HELP_TEST or "  /cbm test [sec]")
    return
  end

  if cmd == "debug" then
    local v = (a or ""):lower()
    if v == "on" then
      CursorBlinkMoveDB.debug = true
      print(prefix, (L.CMD_DEBUG_IS or "debug is"), "ON")
    elseif v == "off" then
      CursorBlinkMoveDB.debug = false
      print(prefix, (L.CMD_DEBUG_IS or "debug is"), "OFF")
    else
      print(prefix, (L.CMD_DEBUG_IS or "debug is"), CursorBlinkMoveDB.debug and "ON" or "OFF")
    end
    return
  end

  if cmd == "color" then
    local r = clamp01(a)
    local g = clamp01(b)
    local bb = clamp01(c)
    CursorBlinkMoveDB.color.r, CursorBlinkMoveDB.color.g, CursorBlinkMoveDB.color.b, CursorBlinkMoveDB.color.a = r, g, bb, 1
    CursorBlinkMove_RefreshVisual()
    print(prefix, (L.CMD_COLOR_SET or "color ="), ("%.2f %.2f %.2f"):format(r, g, bb))
    return
  end

  if cmd == "threshold" then
    local v = tonumber(a)
    if v and v > 0 then
      CursorBlinkMoveDB.speedThreshold = v
      print(prefix, (L.CMD_THRESHOLD_SET or "threshold ="), v)
    end
    return
  end

  if cmd == "duration" then
    local v = tonumber(a)
    if v and v >= 0 then
      CursorBlinkMoveDB.keepBlinkingFor = v
      print(prefix, (L.CMD_DURATION_SET or "duration ="), v)
    end
    return
  end

  if cmd == "rate" then
    local v = tonumber(a)
    if v and v > 0 then
      CursorBlinkMoveDB.blinkEvery = v
      print(prefix, (L.CMD_RATE_SET or "rate (period) ="), v)
    end
    return
  end

  if cmd == "size" then
    local v = tonumber(a)
    if v and v > 0 then
      CursorBlinkMoveDB.size = v
      CursorBlinkMove_RefreshVisual()
      print(prefix, (L.CMD_SIZE_SET or "size ="), v)
    end
    return
  end

  if cmd == "test" then
    local sec = tonumber(a) or 2.0
    CursorBlinkMove_TestBlink(sec)
    print(prefix, (L.CMD_TESTBLINK_FOR or "test blink for"), sec, "s")
    return
  end

  if cmd == "on" then
    CursorBlinkMoveDB.enabled = true
    print(prefix, (L.CMD_ENABLED or "enabled"))
    return
  end

  if cmd == "off" then
    CursorBlinkMoveDB.enabled = false
    stopGlow()
    print(prefix, (L.CMD_DISABLED or "disabled"))
    return
  end

  if cmd == "status" then
    local c0 = CursorBlinkMoveDB.color
    print(prefix, (L.STATUS_TITLE or "status:"))
    print(L.STATUS_ENABLED or "  enabled:", CursorBlinkMoveDB.enabled and "true" or "false")
    print(L.STATUS_THRESHOLD or "  threshold:", CursorBlinkMoveDB.speedThreshold, "px/s")
    print(L.STATUS_DURATION or "  duration:", CursorBlinkMoveDB.keepBlinkingFor, "s")
    print(L.STATUS_RATE or "  rate (period):", CursorBlinkMoveDB.blinkEvery, "s")
    print(L.STATUS_SIZE or "  size:", CursorBlinkMoveDB.size, "px")
    print((L.STATUS_COLOR or "  color:") .. (" %.2f %.2f %.2f"):format(c0.r, c0.g, c0.b))
    return
  end

  print(prefix, (L.CMD_UNKNOWN or "unknown command. /cbm help"))
end