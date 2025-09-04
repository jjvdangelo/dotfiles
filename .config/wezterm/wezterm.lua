local wezterm = require "wezterm"
local config = wezterm.config_builder()

config.automatically_reload_config = true
config.check_for_updates = true

config.color_scheme = "canvas-dark"
-- config.color_scheme = "alabaster-dark" -- ~/.config/wezterm/colors/alabaster-dark.toml
-- config.color_scheme = "Catppuccin Mocha" -- built in

-- config.window_background_opacity = 0.99
-- config.text_background_opacity = 0.99
-- config.macos_window_background_blur = 10
config.win32_system_backdrop = "Auto" -- Auto, Disable, Acrylic, Mica, Tabbed
config.bold_brightens_ansi_colors = true
config.window_decorations = "RESIZE"
config.hide_tab_bar_if_only_one_tab = false
config.tab_and_split_indices_are_zero_based = true
config.scrollback_lines = 5000
config.initial_cols = 120
config.initial_rows = 48

-- Liked:
-- config.font = wezterm.font("M+CodeLat60 Nerd Font Mono", { weight = "DemiBold", italic = false })
-- config.font = wezterm.font("Agave Nerd Font Mono", { weight = "DemiBold", italic = false })
-- config.font = wezterm.font("Agave Nerd Font Mono", { italic = false })
--      config.font_size = 9.5
--      config.line_height = 1.1
config.font = wezterm.font("M+1Code Nerd Font Mono", { weight = "Medium", italic = false })
config.font_size = 9
config.harfbuzz_features = { "calt=0", "clig=0", "liga=0" }

config.audible_bell = "Disabled"
config.visual_bell = { fade_in_duration_ms = 150, fade_out_duration_ms = 150, target = "CursorColor", }

-- keybindings
config.leader = { key = "LeftShift", mods = "CTRL", timeout_milliseconds = 750 }

config.keys = {
    -- Just keeping this here for now as an example.
    { key = "T", mods = "LEADER", action = wezterm.action.SpawnTab "CurrentPaneDomain" },
}

-- domain setup
if wezterm.target_triple == "x86_64-pc-windows-msvc" then
    wezterm.color_scheme_dirs = { os.getenv("USERPROFILE") .. "/.config/wezterm/colors" }

    config.wsl_domains = {
        {
            name = "WSL:Ubuntu",
            distribution = "Ubuntu",
            username = "jim",
            default_cwd = "/home/jim",
        },
    }

    config.unix_domains = {
        {
            name = "wsl",
            serve_command = { "wsl", "wezterm-mux-server", "--daemonize" },
        },
    }

    config.default_domain = "WSL:Ubuntu"
    config.default_mux_server_domain = "WSL:Ubuntu"
    config.default_cwd = "$HOME"
    config.launch_menu = {
        {
            label = "PowerShell",
            args = { "/mnt/c/Program Files/PowerShell/7/pwsh.exe" },
            cwd = "C:\\Users\\Jim",
        },
        {
            label = "WSL:Ubuntu",
            args = { "wsl.exe", "~" },
            cwd = "$HOME",
        },
    }

    for _, vsver in
    ipairs(
        wezterm.glob("Microsoft Visual Studio/20*", "C:/Program Files (x86)")
    )
    do
        local year = vsver:gsub("Microsoft Visual Studio/", "")
        table.insert(config.launch_menu, {
            label = "x64 Native Tools VS " .. year,
            args = {
                "cmd.exe",
                "/k",
                "C:/Program Files (x86)/" .. vsver .. "/BuildTools/VC/Auxiliary/Build/vcvars64.bat",
            },
        })
    end
end

return config
