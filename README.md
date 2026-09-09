<h2 align="center">My WezTerm Config</h2>

<p align="center">
  Personal WezTerm configuration based on <a href="https://github.com/KevinSilvester/wezterm-config">KevinSilvester/wezterm-config</a>
</p>

---

## Customizations

This fork includes the following customizations optimized for **Belgian AZERTY keyboard**, tested on **macOS** and **Windows (native + WSL)**:

- ✨ **Copy/Paste**: Changed to standard Mac shortcuts (`Cmd+C` / `Cmd+V`)
- 🔄 **Tab Switching**: Browser-style shortcuts (`Ctrl+Tab` / `Ctrl+Shift+Tab`)
- 🇧🇪 **AZERTY-friendly**: Removed reliance on hard-to-reach bracket keys

---

## Setup

```bash
git clone https://github.com/gheroufosse/wezterm-config.git ~/.config/wezterm
```

### Optional Configuration

- **Change default shell**: Edit [`config/launch.lua`](./config/launch.lua) to set your preferred shell
- **SSH/WSL domains**: Configure custom domains in [`config/domains.lua`](./config/domains.lua)

### Requirements

- **WezTerm** (Nightly recommended)
  ```bash
  # macOS
  brew install --cask wezterm@nightly

  # Windows
  scoop bucket add extras
  scoop install wezterm-nightly
  ```

- **Fish Shell** (default shell on macOS/Linux)
  ```bash
  brew install fish
  ```
  > **Note**: This config uses Fish as the default shell on macOS/Linux. On Windows the default is PowerShell Core (`pwsh`) — see [`config/launch.lua`](./config/launch.lua) to change either.

- **JetBrainsMono Nerd Font**
  ```bash
  # macOS
  brew install --cask font-jetbrains-mono-nerd-font

  # Windows
  scoop bucket add nerd-fonts
  scoop install JetBrainsMono-NF
  ```

- **WSL** (Windows only, for the `wsl:ubuntu-*` domains in [`config/domains.lua`](./config/domains.lua))
  ```powershell
  wsl --install -d Ubuntu
  ```
  > Update the `distribution` field in `config/domains.lua` to match the name shown by `wsl -l -v`.

For more detailed installation instructions, see the [original repository](https://github.com/KevinSilvester/wezterm-config).

---

## Key Bindings

Most key bindings use <kbd>SUPER</kbd> and <kbd>SUPER_REV</kbd> (super reversed) modifiers:

- On **macOS**:
  - <kbd>SUPER</kbd> ⇨ <kbd>Cmd</kbd>
  - <kbd>SUPER_REV</kbd> ⇨ <kbd>Cmd</kbd>+<kbd>Ctrl</kbd>
  - <kbd>LEADER</kbd> ⇨ <kbd>Cmd</kbd>+<kbd>Ctrl</kbd>+<kbd>Space</kbd>
- On **Windows/Linux**:
  - <kbd>SUPER</kbd> ⇨ <kbd>Alt</kbd> <sub>(kept off the Windows key to avoid OS shortcut conflicts)</sub>
  - <kbd>SUPER_REV</kbd> ⇨ <kbd>Alt</kbd>+<kbd>Ctrl</kbd>
  - <kbd>LEADER</kbd> ⇨ <kbd>Alt</kbd>+<kbd>Ctrl</kbd>+<kbd>Space</kbd>

### Miscellaneous/Useful

| Keys                              | Action                                      |
| --------------------------------- | ------------------------------------------- |
| <kbd>F1</kbd>                     | `ActivateCopyMode`                          |
| <kbd>F2</kbd>                     | `ActivateCommandPalette`                    |
| <kbd>F3</kbd>                     | `ShowLauncher`                              |
| <kbd>F4</kbd>                     | `ShowLauncher` <sub>(tabs only)</sub>       |
| <kbd>F5</kbd>                     | `ShowLauncher` <sub>(workspaces only)</sub> |
| <kbd>F11</kbd>                    | `ToggleFullScreen`                          |
| <kbd>F12</kbd>                    | `ShowDebugOverlay`                          |
| <kbd>Cmd</kbd>+<kbd>f</kbd>       | Search Text                                 |
| <kbd>Cmd</kbd>+<kbd>Ctrl</kbd>+<kbd>u</kbd> | Open URL                          |

&nbsp;

### Copy+Paste ✨ **(Modified)**

| Keys                        | Action               |
| --------------------------- | -------------------- |
| <kbd>Cmd</kbd>+<kbd>c</kbd> | Copy to Clipboard    |
| <kbd>Cmd</kbd>+<kbd>v</kbd> | Paste from Clipboard |

&nbsp;

### Cursor Movements

| Keys                           | Action                  |
| ------------------------------ | ----------------------- |
| <kbd>Cmd</kbd>+<kbd>←</kbd>    | Move cursor to Line Start |
| <kbd>Cmd</kbd>+<kbd>→</kbd>    | Move cursor to Line End   |
| <kbd>Cmd</kbd>+<kbd>⌫</kbd>    | Clear Line              |

&nbsp;

### Tabs

#### Tabs: Spawn+Close

| Keys                                        | Action                                |
| ------------------------------------------- | ------------------------------------- |
| <kbd>Cmd</kbd>+<kbd>t</kbd>                 | `SpawnTab` <sub>(DefaultDomain)</sub> |
| <kbd>Cmd</kbd>+<kbd>Ctrl</kbd>+<kbd>t</kbd> | `SpawnTab` <sub>(WSL:Ubuntu)</sub>    |
| <kbd>Cmd</kbd>+<kbd>Ctrl</kbd>+<kbd>w</kbd> | `CloseCurrentTab`                     |

#### Tabs: Navigation ✨ **(Modified)**

| Keys                                          | Action         |
| --------------------------------------------- | -------------- |
| <kbd>Ctrl</kbd>+<kbd>Tab</kbd>                | Next Tab       |
| <kbd>Ctrl</kbd>+<kbd>Shift</kbd>+<kbd>Tab</kbd> | Previous Tab |
| <kbd>Cmd</kbd>+<kbd>Ctrl</kbd>+<kbd>[</kbd>   | Move Tab Left  |
| <kbd>Cmd</kbd>+<kbd>Ctrl</kbd>+<kbd>]</kbd>   | Move Tab Right |

#### Tabs: Toggle Tab-bar

| Keys                        | Action         |
| --------------------------- | -------------- |
| <kbd>Cmd</kbd>+<kbd>9</kbd> | Toggle tab bar |

#### Tabs: Title

| Keys                                        | Action             |
| ------------------------------------------- | ------------------ |
| <kbd>Cmd</kbd>+<kbd>0</kbd>                 | Rename Current Tab |
| <kbd>Cmd</kbd>+<kbd>Ctrl</kbd>+<kbd>0</kbd> | Undo Rename        |

&nbsp;

### Windows

| Keys                        | Action               |
| --------------------------- | -------------------- |
| <kbd>Cmd</kbd>+<kbd>n</kbd> | `SpawnWindow`        |
| <kbd>Cmd</kbd>+<kbd>=</kbd> | Increase Window Size |
| <kbd>Cmd</kbd>+<kbd>-</kbd> | Decrease Window Size |
| <kbd>Cmd</kbd>+<kbd>Ctrl</kbd>+<kbd>Enter</kbd> | Maximize Window |

&nbsp;

### Panes

#### Panes: Split Panes

| Keys                                        | Action                                           |
| ------------------------------------------- | ------------------------------------------------ |
| <kbd>Cmd</kbd>+<kbd>\\</kbd>                | `SplitVertical` <sub>(CurrentPaneDomain)</sub>   |
| <kbd>Cmd</kbd>+<kbd>Ctrl</kbd>+<kbd>\\</kbd> | `SplitHorizontal` <sub>(CurrentPaneDomain)</sub> |

#### Panes: Zoom+Close Pane

| Keys                              | Action                |
| --------------------------------- | --------------------- |
| <kbd>Cmd</kbd>+<kbd>Enter</kbd>   | `TogglePaneZoomState` |
| <kbd>Cmd</kbd>+<kbd>w</kbd>       | `CloseCurrentPane`    |

#### Panes: Navigation

| Keys                                        | Action                  |
| ------------------------------------------- | ----------------------- |
| <kbd>Cmd</kbd>+<kbd>Ctrl</kbd>+<kbd>k</kbd> | Move to Pane (Up)       |
| <kbd>Cmd</kbd>+<kbd>Ctrl</kbd>+<kbd>j</kbd> | Move to Pane (Down)     |
| <kbd>Cmd</kbd>+<kbd>Ctrl</kbd>+<kbd>h</kbd> | Move to Pane (Left)     |
| <kbd>Cmd</kbd>+<kbd>Ctrl</kbd>+<kbd>l</kbd> | Move to Pane (Right)    |
| <kbd>Cmd</kbd>+<kbd>Ctrl</kbd>+<kbd>p</kbd> | Swap with selected Pane |

#### Panes: Scroll Pane

| Keys                        | Action                               |
| --------------------------- | ------------------------------------ |
| <kbd>Cmd</kbd>+<kbd>u</kbd> | Scroll Lines up <sub>5 lines</sub>   |
| <kbd>Cmd</kbd>+<kbd>d</kbd> | Scroll Lines down <sub>5 lines</sub> |
| <kbd>PageUp</kbd>           | Scroll Page up                       |
| <kbd>PageDown</kbd>         | Scroll Page down                     |

&nbsp;

### Background Images

| Keys                                        | Action                       |
| ------------------------------------------- | ---------------------------- |
| <kbd>Cmd</kbd>+<kbd>/</kbd>                 | Select Random Image          |
| <kbd>Cmd</kbd>+<kbd>,</kbd>                 | Cycle to next Image          |
| <kbd>Cmd</kbd>+<kbd>.</kbd>                 | Cycle to previous Image      |
| <kbd>Cmd</kbd>+<kbd>Ctrl</kbd>+<kbd>/</kbd> | Fuzzy select Image           |
| <kbd>Cmd</kbd>+<kbd>b</kbd>                 | Toggle background focus mode |

&nbsp;

### Key Tables

> See: <https://wezfurlong.org/wezterm/config/key-tables.html>

| Keys                                                 | Action        |
| ---------------------------------------------------- | ------------- |
| <kbd>Cmd</kbd>+<kbd>Ctrl</kbd>+<kbd>Space</kbd> → <kbd>f</kbd> | `resize_font` |
| <kbd>Cmd</kbd>+<kbd>Ctrl</kbd>+<kbd>Space</kbd> → <kbd>p</kbd> | `resize_pane` |

#### Key Table: `resize_font`

| Keys           | Action                          |
| -------------- | ------------------------------- |
| <kbd>k</kbd>   | `IncreaseFontSize`              |
| <kbd>j</kbd>   | `DecreaseFontSize`              |
| <kbd>r</kbd>   | `ResetFontSize`                 |
| <kbd>q</kbd>   | `PopKeyTable` <sub>(exit)</sub> |
| <kbd>Esc</kbd> | `PopKeyTable` <sub>(exit)</sub> |

#### Key Table: `resize_pane`

| Keys           | Action                                         |
| -------------- | ---------------------------------------------- |
| <kbd>k</kbd>   | `AdjustPaneSize` <sub>(Direction: Up)</sub>    |
| <kbd>j</kbd>   | `AdjustPaneSize` <sub>(Direction: Down)</sub>  |
| <kbd>h</kbd>   | `AdjustPaneSize` <sub>(Direction: Left)</sub>  |
| <kbd>l</kbd>   | `AdjustPaneSize` <sub>(Direction: Right)</sub> |
| <kbd>q</kbd>   | `PopKeyTable` <sub>(exit)</sub>                |
| <kbd>Esc</kbd> | `PopKeyTable` <sub>(exit)</sub>                |

---

## Credits

Based on [KevinSilvester/wezterm-config](https://github.com/KevinSilvester/wezterm-config)

### Features from Original

- **Background Image Selector** with cycling and fuzzy search
- **GPU Adapter Selector** for optimal performance
- Custom tab titles and status bars
- Comprehensive key bindings

For full documentation of the base configuration, see the [original repository](https://github.com/KevinSilvester/wezterm-config).
