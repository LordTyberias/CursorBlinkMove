# AGENTS.md — CursorBlinkMove (CBM)

This document is for contributors and automated agents (CI helpers, code assistants, etc.).  
It describes project goals, rules, and how to safely modify the addon.

---

## Project Summary

**CursorBlinkMove (CBM)** is a World of Warcraft Retail addon that blinks a glowing indicator around the cursor when the mouse is moved quickly. It is designed to be:

- lightweight
- safe (avoid taint / protected calls)
- compatible with modern Retail Settings UI
- account-wide (SavedVariables)

---

## Core Goals

1. **Never cause UI errors or taint** during normal gameplay.
2. **Keep the addon minimal**: no external libraries required.
3. **Account-wide configuration** only.
4. **Retail-first** (Interface 12.x), with graceful fallbacks where possible.
5. **Stable behavior across focus changes** (login / reload / Alt+Tab / resolution change).

---

## Repo / File Responsibilities

- `CursorBlinkMove.lua`
  - Runtime behavior (tracking, speed detection, blinking, slash commands)
  - Provides `CursorBlinkMove_RefreshVisual()` and `CursorBlinkMove_TestBlink()`

- `CursorBlinkMove_Options.lua`
  - Settings UI panel (Retail Settings “Canvas layout category”)
  - Exports category ID to `_G.CursorBlinkMove_CategoryID` for reliable opening from `/cbm`

- `Localization.lua`
  - All user-facing strings

- `CursorBlinkMove.toc`
  - Metadata, files list, icon texture, SavedVariables

- `CBM_WoW_Icon_final.tga`
  - Addon icon used in TOC and settings panel

---

## Coding Rules

### 1) No hard dependency on optional events or APIs
Some clients differ. If you add event listeners:
- Only register events that are guaranteed to exist,
- or validate them first (e.g. via `C_EventUtils.IsEventValid` when available),
- otherwise don’t register them.

### 2) SavedVariables are account-wide
Use:
- `## SavedVariables: CursorBlinkMoveDB`

Never switch to per-character storage.

### 3) Avoid expensive work in OnUpdate
OnUpdate runs frequently. Keep it lean:
- minimal allocations
- no string formatting unless debug is enabled and throttled
- no table creation per frame

### 4) Be careful with Settings UI APIs
Retail Settings are evolving.
- Prefer `Settings.RegisterCanvasLayoutCategory(panel, name)` + `Settings.RegisterAddOnCategory(category)`
- Export the category ID for opening from chat commands
- Avoid calling undocumented mixins like `AddInitializer` unless confirmed present

### 5) Don’t break localization
All user-facing strings should come from `Localization.lua` via `L`.

---

## Behavior Constraints

### Cursor false-trigger protection
The addon should avoid blinking on:
- login / reload UI
- zoning / loading screens
- focus changes (Alt+Tab)
- “cursor teleport” samples or dt spikes

Preferred approach:
- short suspend windows that still track cursor position
- dt and jump-distance filters
- do not create “first-sample speed spikes”

If modifying this logic:
- ensure the cursor does not blink immediately upon entering world
- ensure normal fast movement still triggers reliably

---

## Testing Checklist (Manual)

1. **Fresh install**
   - Delete `WTF/Account/<name>/SavedVariables/CursorBlinkMove.lua`
   - Login: no immediate blink
   - Default color is **red (FF0000)**

2. **Settings UI**
   - `/cbm` opens settings
   - Sliders move and persist
   - Color swatch updates correctly
   - “Test Blink” works

3. **Chat commands**
   - `/cbm options` prints help
   - `/cbm status` prints current values
   - `/cbm on` `/cbm off` work

4. **Alt+Tab**
   - Alt+Tab out/in: should not trigger blinking
   - After returning, normal fast movement still triggers

5. **Reload**
   - `/reload` should not cause immediate blinking

---

## Release Notes Guidance

When preparing a release:
- bump `## Version:` in the TOC
- ensure `## Interface:` includes the supported values
- update README if commands or settings changed
- avoid changing SavedVariables shape without migration notes

---

## Contribution Notes

- Keep changes small and easy to review.
- When changing behavior, include:
  - what you changed
  - why
  - how to test
- If adding a new localization string, add it for:
  - English fallback
  - German at minimum (`deDE`)
  - other locales can fall back to English if missing
