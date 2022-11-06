local wezterm = require 'wezterm';
local launch_menu = {}

if wezterm.target_triple == 'x86_64-pc-windows-msvc' then

  -- Enumerate any WSL distributions that are installed and add those to the menu
  local success, wsl_list, wsl_err =
    wezterm.run_child_process { 'wsl.exe', '-l' }
  -- `wsl.exe -l` has a bug where it always outputs utf16:
  -- https://github.com/microsoft/WSL/issues/4607
  -- So we get to convert it
  wsl_list = wezterm.utf16_to_utf8(wsl_list)

  for idx, line in ipairs(wezterm.split_by_newlines(wsl_list)) do
    -- Skip the first line of output; it's just a header
    if idx > 1 then
      -- Remove the "(Default)" marker from the default line to arrive
      -- at the distribution name on its own
      local distro = line:gsub(' %(Default%)', '')
      distro = distro:gsub(' %(Standard)', '')

      -- Add an entry that will spawn into the distro with the default shell
      table.insert(launch_menu, {
        label = line,
        args = { 'wsl.exe', '--distribution', distro, "--cd", "~" },
      })
    end
  end

  table.insert(launch_menu, {
    label = 'GitBash',
    args = { 'C:/Program Files/Git/bin/bash.exe', '-i', '-l'  },
  })

  table.insert(launch_menu, {
    label = 'PowerShell',
    args = { 'powershell.exe', '-NoLogo' },
  })

end

return {
    default_prog ={"wsl.exe", "--cd", "~"},
    launch_menu = launch_menu,
    font = wezterm.font("UbuntuMono NF"),
    -- font = wezterm.font("FiraCode Mono NF"),
    font_size = 12,
    color_scheme = "Gruvbox Dark",
}
