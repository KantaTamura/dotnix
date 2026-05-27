local wezterm = require("wezterm")

local Shell = {}

-- default shell
function Shell.setup(config)
    if wezterm.target_triple == "x86_64-pc-windows-msvc" then
        config.default_prog = { "pwsh" }
    elseif wezterm.target_triple == "x86_64-unknown-linux-gnu" then
        config.default_prog = { "zsh" }
    end
end

return Shell
