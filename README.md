# CursorBlinkMove (CBM)

CursorBlinkMove (CBM) helps you quickly find your mouse cursor by making a glowing indicator blink around it when you move the mouse fast.

It’s lightweight, configurable, and uses account-wide settings.

---

## Features

- **Blinking glow around the cursor** when you move it quickly
- **Configurable trigger threshold** (mouse speed)
- **Configurable blink duration** (how long it keeps blinking after fast movement)
- **Configurable blink rate** (blink period)
- **Configurable glow size**
- **Configurable color** (alpha is intentionally disabled; always opaque)
- **Test button** to preview the effect instantly
- **Account-wide SavedVariables** (same settings for all characters)

---

## Installation

### CurseForge / AddOns folder
1. Download and extract the addon to:
   - `World of Warcraft/_retail_/Interface/AddOns/`
2. Ensure the folder name matches:
   - `CursorBlinkMove`
3. Restart the game (or `/reload`).

---

## Usage

### Open Settings (recommended)
- Type: `/cbm`  
  This opens the addon’s settings page.

### Commands list
- Type: `/cbm options`  
  or: `/cbm settings`  
  or: `/cbm help`

### Chat Commands

- `/cbm on`  
  Enable the addon.

- `/cbm off`  
  Disable the addon.

- `/cbm test [seconds]`  
  Force a blink test (default: 2 seconds).

- `/cbm threshold <px/s>`  
  Set the speed threshold that triggers blinking.

- `/cbm duration <sec>`  
  Set how long blinking continues after fast movement.

- `/cbm rate <sec>`  
  Set the blink period (lower = faster blinking).

- `/cbm size <px>`  
  Set the glow size in pixels.

- `/cbm color r g b`  
  Set glow color using values **0..1** (alpha ignored, always opaque).  
  Example: `/cbm color 1 0 0` (red)

- `/cbm status`  
  Print current settings to chat.

---

## Settings UI

Open via `/cbm`.

You can change:
- Enabled
- Threshold
- Duration (after-move)
- Rate / Period
- Size
- Color picker (opaque)
- Test blink

The addon icon is shown in the top-right of the settings panel.

---

## Notes / Behavior

### Why does the cursor sometimes blink after login or Alt+Tab?
Some clients can produce cursor “teleport” samples or unusual timing right after:
- entering the world (login / reload / zone change)
- window focus changes (Alt+Tab)
- resolution/UI scale changes

CBM includes protective logic to reduce false triggers (suspend windows + tracking filters).  
If you still notice rare false triggers, please report it (see below) with:
- Game version
- Whether it’s windowed/fullscreen
- Whether raw mouse input is enabled
- Any relevant CVars you changed

---

## Files

Typical addon structure:

- `CursorBlinkMove.toc`
- `Localization.lua`
- `CursorBlinkMove.lua`
- `CursorBlinkMove_Options.lua`
- `CBM_WoW_Icon_final.tga`

---

## Localization

CBM supports multiple client locales through `Localization.lua`.  
If you want to improve translations, feel free to open a PR.

---

## Support / Feedback

If you find bugs or want to suggest improvements:
- Open an issue on GitHub (preferred), or
- Comment on CurseForge

Include:
- Steps to reproduce
- Error messages (if any)
- Your locale (e.g., `deDE`, `enUS`)
- Your WoW version

---

## License

Choose a license (MIT recommended) and place it in `LICENSE`.  
If you don’t add a license, the default is “all rights reserved”.
