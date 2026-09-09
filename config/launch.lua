local platform = require('utils.platform')

---@type Config
local options = {
   default_prog = {},
   launch_menu = {},
}

if platform.is_win then
   -- resolve Git Bash relative to the current user, instead of hardcoding a username
   local user_profile = os.getenv('USERPROFILE') or ('C:\\Users\\' .. (os.getenv('USERNAME') or ''))
   local git_bash_path = user_profile .. '\\scoop\\apps\\git\\current\\bin\\bash.exe'

   options.default_prog = { 'pwsh', '-NoLogo' }
   options.launch_menu = {
      { label = 'PowerShell Core', args = { 'pwsh', '-NoLogo' } },
      { label = 'PowerShell Desktop', args = { 'powershell' } },
      { label = 'Command Prompt', args = { 'cmd' } },
      { label = 'Nushell', args = { 'nu' } },
      -- NOTE: only valid if Git was installed via `scoop install git`.
      -- If you installed Git another way (e.g. official installer), update this path
      -- (typically 'C:\\Program Files\\Git\\bin\\bash.exe').
      { label = 'Git Bash', args = { git_bash_path } },
   }
elseif platform.is_mac then
   options.default_prog = { '/opt/homebrew/bin/fish', '-l' }
   options.launch_menu = {
      { label = 'Bash', args = { 'bash', '-l' } },
      { label = 'Fish', args = { '/opt/homebrew/bin/fish', '-l' } },
      { label = 'Nushell', args = { '/opt/homebrew/bin/nu', '-l' } },
      { label = 'Zsh', args = { 'zsh', '-l' } },
   }
elseif platform.is_linux then
   options.default_prog = { 'fish', '-l' }
   options.launch_menu = {
      { label = 'Bash', args = { 'bash', '-l' } },
      { label = 'Fish', args = { 'fish', '-l' } },
      { label = 'Zsh', args = { 'zsh', '-l' } },
   }
end

return options
