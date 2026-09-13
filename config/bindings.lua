local wezterm = require('wezterm')
local platform = require('utils.platform')
local backdrops = require('utils.backdrops')
local act = wezterm.action

local mod = {}

if platform.is_mac then
   mod.SUPER = 'SUPER'
   mod.SUPER_REV = 'SUPER|CTRL'
elseif platform.is_win or platform.is_linux then
   mod.SUPER = 'ALT' -- to not conflict with Windows key shortcuts
   mod.SUPER_REV = 'ALT|CTRL'
end

-- stylua: ignore
---@type Key[]
local keys = {
   -- misc/useful --
   { key = 'F1', mods = 'NONE', action = act.ActivateCopyMode },
   { key = 'F2', mods = 'NONE', action = act.ActivateCommandPalette },
   { key = 'F3', mods = 'NONE', action = act.ShowLauncher },
   { key = 'F4', mods = 'NONE', action = act.ShowLauncherArgs({ flags = 'FUZZY|TABS' }) },
   {
      key = 'F5',
      mods = 'NONE',
      action = act.ShowLauncherArgs({ flags = 'FUZZY|WORKSPACES' }),
   },
   { key = 'F11', mods = 'NONE',    action = act.ToggleFullScreen },
   { key = 'F12', mods = 'NONE',    action = act.ShowDebugOverlay },
   { key = 'f',   mods = mod.SUPER, action = act.Search({ CaseInSensitiveString = '' }) },
   {
      key = 'u',
      mods = mod.SUPER_REV,
      action = wezterm.action.QuickSelectArgs({
         label = 'open url',
         patterns = {
            '\\((https?://\\S+)\\)',
            '\\[(https?://\\S+)\\]',
            '\\{(https?://\\S+)\\}',
            '<(https?://\\S+)>',
            '\\bhttps?://\\S+[)/a-zA-Z0-9-]+'
         },
         action = wezterm.action_callback(function(window, pane)
            local url = window:get_selection_text_for_pane(pane)
            wezterm.log_info('opening: ' .. url)
            wezterm.open_with(url)
         end),
      }),
   },

   -- newline without submit (e.g. chat/REPL apps like Claude Code) --
   -- pi's TUI reads raw shift+enter (kitty protocol) or falls back to ctrl+j (LF, 0x0A);
   -- it does NOT understand the ESC+CR (\x1b\r) hack other REPLs use, so branch on
   -- foreground process name. Works the same on macOS/Windows/Linux (incl. WSL).
   {
      key = 'Enter',
      mods = 'SHIFT',
      action = wezterm.action_callback(function(window, pane)
         local proc = pane:get_foreground_process_name() or ''
         local info = pane.get_foreground_process_info and pane:get_foreground_process_info()
         local argv0 = info and info.argv and info.argv[1] or ''
         if argv0 == 'pi' or argv0:match('[/\\]pi$') then
            window:perform_action(act.SendString('\n'), pane)
         else
            window:perform_action(act.SendString('\x1b\r'), pane)
         end
      end),
   },

   -- cursor movement --
   { key = 'LeftArrow',  mods = mod.SUPER,     action = act.SendString('\u{1b}OH') },
   { key = 'RightArrow', mods = mod.SUPER,     action = act.SendString('\u{1b}OF') },
   { key = 'Backspace',  mods = mod.SUPER,     action = act.SendString('\u{15}') },

   -- copy/paste --
   { key = 'c',          mods = mod.SUPER,     action = act.CopyTo('Clipboard') },
   { key = 'v',          mods = mod.SUPER,     action = act.PasteFrom('Clipboard') },

   { key = 'n',          mods = 'CTRL|SHIFT',  action = act.SendString('\u{2660}') },
   { key = 's',          mods = 'CTRL|SHIFT',  action = act.SendString('\u{203D}') },

   -- tabs --
   -- tabs: spawn+close
   { key = 't',          mods = mod.SUPER,     action = act.SpawnTab('DefaultDomain') },
   { key = 't',          mods = mod.SUPER_REV, action = act.SpawnTab({ DomainName = 'wsl:ubuntu-fish' }) },
   { key = 'w',          mods = mod.SUPER_REV, action = act.CloseCurrentTab({ confirm = false }) },

   -- tabs: navigation
   { key = 'Tab',        mods = 'CTRL',        action = act.ActivateTabRelative(1) },
   { key = 'Tab',        mods = 'CTRL|SHIFT',  action = act.ActivateTabRelative(-1) },
   { key = '[',          mods = mod.SUPER_REV, action = act.MoveTabRelative(-1) },
   { key = ']',          mods = mod.SUPER_REV, action = act.MoveTabRelative(1) },

   -- tab: title
   { key = '0',          mods = mod.SUPER,     action = act.EmitEvent('tabs.manual-update-tab-title') },
   { key = '0',          mods = mod.SUPER_REV, action = act.EmitEvent('tabs.reset-tab-title') },

   -- tab: hide tab-bar
   { key = '9',          mods = mod.SUPER,     action = act.EmitEvent('tabs.toggle-tab-bar'), },

   -- window --
   -- window: spawn windows
   { key = 'n',          mods = mod.SUPER,     action = act.SpawnWindow },
   { key = 'q',          mods = mod.SUPER,     action = act.QuitApplication },

   -- font size --
   { key = '-', mods = mod.SUPER, action = act.DecreaseFontSize },
   { key = '=', mods = mod.SUPER, action = act.IncreaseFontSize },

   -- window: zoom window
   {
      key = '-',
      mods = mod.SUPER_REV,
      action = wezterm.action_callback(function(window, _pane)
         local dimensions = window:get_dimensions()
         -- on Windows 11 (the only OS I'm able to test this on), `is_full_screen` is always false (it's a bug).
         -- Calling `set_inner_size` when the window is actually in fullscreen will cause the
         -- program UI to completely freeze.
         if platform.is_win or dimensions.is_full_screen then
            return
         end
         local new_width = dimensions.pixel_width - 50
         local new_height = dimensions.pixel_height - 50
         window:set_inner_size(new_width, new_height)
      end)
   },
   {
      key = '=',
      mods = mod.SUPER_REV,
      action = wezterm.action_callback(function(window, _pane)
         local dimensions = window:get_dimensions()
         -- on Windows 11 (the only OS I'm able to test this on), `is_full_screen` is always false (it's a bug).
         -- Calling `set_inner_size` when the window is actually in fullscreen will cause the
         -- program UI to completely freeze.
         if platform.is_win or dimensions.is_full_screen then
            return
         end
         local new_width = dimensions.pixel_width + 50
         local new_height = dimensions.pixel_height + 50
         window:set_inner_size(new_width, new_height)
      end)
   },
   {
      key = 'Enter',
      mods = mod.SUPER_REV,
      action = wezterm.action_callback(function(window, _pane)
         window:maximize()
      end)
   },

   -- background controls --
   {
      key = [[/]],
      mods = mod.SUPER,
      action = wezterm.action_callback(function(window, _pane)
         backdrops:random(window)
      end),
   },
   {
      key = [[,]],
      mods = mod.SUPER,
      action = wezterm.action_callback(function(window, _pane)
         backdrops:cycle_back(window)
      end),
   },
   {
      key = [[.]],
      mods = mod.SUPER,
      action = wezterm.action_callback(function(window, _pane)
         backdrops:cycle_forward(window)
      end),
   },
   {
      key = [[/]],
      mods = mod.SUPER_REV,
      action = act.InputSelector({
         title = 'InputSelector: Select Background',
         choices = backdrops:choices(),
         fuzzy = true,
         fuzzy_description = 'Select Background: ',
         action = wezterm.action_callback(function(window, _pane, idx)
            if not idx then
               return
            end
            ---@diagnostic disable-next-line: param-type-mismatch
            backdrops:set_img(window, tonumber(idx))
         end),
      }),
   },
   {
      key = 'b',
      mods = mod.SUPER,
      action = wezterm.action_callback(function(window, _pane)
         backdrops:toggle_focus(window)
      end)
   },

   -- panes --
   -- panes: split panes
   {
      key = [[\]],
      mods = mod.SUPER,
      action = act.SplitVertical({ domain = 'CurrentPaneDomain' }),
   },
   {
      key = [[\]],
      mods = mod.SUPER_REV,
      action = act.SplitHorizontal({ domain = 'CurrentPaneDomain' }),
   },

   -- panes: zoom+close pane
   { key = 'Enter', mods = mod.SUPER,     action = act.TogglePaneZoomState },
   { key = 'w',     mods = mod.SUPER,     action = act.CloseCurrentPane({ confirm = false }) },

   -- panes: navigation
   { key = 'k',     mods = mod.SUPER_REV, action = act.ActivatePaneDirection('Up') },
   { key = 'j',     mods = mod.SUPER_REV, action = act.ActivatePaneDirection('Down') },
   { key = 'h',     mods = mod.SUPER_REV, action = act.ActivatePaneDirection('Left') },
   { key = 'l',     mods = mod.SUPER_REV, action = act.ActivatePaneDirection('Right') },
   {
      key = 'p',
      mods = mod.SUPER_REV,
      action = act.PaneSelect({ alphabet = '1234567890', mode = 'SwapWithActiveKeepFocus' }),
   },

   -- panes: scroll pane
   { key = 'u',        mods = mod.SUPER, action = act.ScrollByLine(-5) },
   { key = 'd',        mods = mod.SUPER, action = act.ScrollByLine(5) },
   { key = 'PageUp',   mods = 'NONE',    action = act.ScrollByPage(-0.75) },
   { key = 'PageDown', mods = 'NONE',    action = act.ScrollByPage(0.75) },

   -- key-tables --
   -- resizes fonts
   {
      key = 'f',
      mods = 'LEADER',
      action = act.ActivateKeyTable({
         name = 'resize_font',
         one_shot = false,
         timeout_milliseconds = 1000,
      }),
   },
   -- resize panes
   {
      key = 'p',
      mods = 'LEADER',
      action = act.ActivateKeyTable({
         name = 'resize_pane',
         one_shot = false,
         timeout_milliseconds = 1000,
      }),
   },
}

-- Win/Linux only: free Ctrl+W (no longer deletes word) and move that
-- readline shortcut to Ctrl+Backspace instead. Left untouched on macOS.
if not platform.is_mac then
   table.insert(keys, { key = 'Backspace', mods = 'CTRL', action = act.SendString('\u{17}') })
   table.insert(keys, { key = 'w', mods = 'CTRL', action = act.DisableDefaultAssignment })
end

-- Tilde: disable_default_key_bindings=true above swallows dead-key
-- passthrough, so the layout's composing tilde never reaches the terminal.
-- Bind it explicitly to send a literal '~' on both platforms, using the
-- modifier that is actually free on each:
--   macOS    Option+N is the native (dead-key) tilde, so keep that muscle memory.
--   Win/WSL  ALT is already mod.SUPER (see top of file) and AltGr+= is dead,
--            so use Ctrl+N instead.
-- Trade-off: this is a plain literal, not a composing dead key, so accented
-- forms (ñ, ã) are no longer typeable this way. Ctrl+N also shadows
-- readline/fish history-next, which stays available as Down.
if platform.is_mac then
   table.insert(keys, { key = 'n', mods = 'ALT', action = act.SendString('~') })
else
   table.insert(keys, { key = 'n', mods = 'CTRL', action = act.SendString('~') })
end

-- Backslash: same disable_default_key_bindings issue as tilde above — '\'
-- key is only ever bound as a physical key (pane split shortcuts), never as
-- a literal char to send. On layouts without a direct backslash key
-- (e.g. Belgian/French AZERTY on Mac), nothing produces it.
--   macOS  Shift+Option+: (physical key that carries ':' and '/' on
--          Belgian/French AZERTY — same physical position as US Period).
--          Must use the `phys:` prefix here, not the bare mapped char:
--          wezterm's default key_map_preference='Mapped' resolves
--          `key=':'` to whatever character macOS *reports after* applying
--          Option, but Option is a compose/dead-key modifier on macOS, so
--          Shift+Option+this-key never actually produces a literal ':'
--          keysym for wezterm to match. `phys:Period` matches the raw
--          physical key regardless of what glyph Option would compose.
--   WSL    Same mapped-char trap applies here too: Shift held means the OS
--          reports '|' (the shifted glyph), not '\', so key='\\' would
--          never match with SHIFT in mods. On Belgian/French AZERTY,
--          backslash also needs AltGr (a compose modifier, same issue as
--          Option on macOS). Alt+\ and Alt+Ctrl+\ are both already taken
--          (pane split via mod.SUPER / mod.SUPER_REV), so use
--          phys:Backslash with Ctrl+Shift instead — free, and matches the
--          physical key regardless of what glyph any modifier composes.
if platform.is_mac then
   table.insert(keys, { key = 'phys:Period', mods = 'SHIFT|ALT', action = act.SendString('\\') })
else
   table.insert(keys, { key = 'phys:Backslash', mods = 'CTRL|SHIFT', action = act.SendString('\\') })
end

-- stylua: ignore
---@type table<string, Key[]>
local key_tables = {
   resize_font = {
      { key = 'k',      action = act.IncreaseFontSize },
      { key = 'j',      action = act.DecreaseFontSize },
      { key = 'r',      action = act.ResetFontSize },
      { key = 'Escape', action = 'PopKeyTable' },
      { key = 'q',      action = 'PopKeyTable' },
   },
   resize_pane = {
      { key = 'k',      action = act.AdjustPaneSize({ 'Up', 1 }) },
      { key = 'j',      action = act.AdjustPaneSize({ 'Down', 1 }) },
      { key = 'h',      action = act.AdjustPaneSize({ 'Left', 1 }) },
      { key = 'l',      action = act.AdjustPaneSize({ 'Right', 1 }) },
      { key = 'Escape', action = 'PopKeyTable' },
      { key = 'q',      action = 'PopKeyTable' },
   },
}

---@type MouseBinding[]
local mouse_bindings = {
   -- Ctrl-click will open the link under the mouse cursor
   {
      event = { Up = { streak = 1, button = 'Left' } },
      mods = 'CTRL',
      action = act.OpenLinkAtMouseCursor,
   },
}

---@type Config
return {
   disable_default_key_bindings = true,
   -- disable_default_mouse_bindings = true,
   leader = { key = 'Space', mods = mod.SUPER_REV },
   keys = keys,
   key_tables = key_tables,
   mouse_bindings = mouse_bindings,
}
