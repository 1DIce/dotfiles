local wezterm = require 'wezterm';

return {
    default_prog ={"wsl.exe", "--cd", "~"},
    font = wezterm.font("UbuntuMono NF"),
    -- font = wezterm.font("FiraCode Mono NF"),
    font_size = 12,
    color_scheme = "Gruvbox Dark",
}