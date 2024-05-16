local wezterm = require 'wezterm'
local mux = wezterm.mux

local config = wezterm.config_builder()
-- TODO: take of the function somewhere in a separate file
-- wezterm.gui is not available to the mux server, so take care to
-- do something reasonable when this config is evaluated by the mux

function get_appearance()
    if wezterm.gui then
        return wezterm.gui.get_appearance()
    end

    return 'Dark'
end

local function set_nvim_color_scheme(new_value)
    -- Path to the theme config file
    local config_path =
    '/home/art/.config/nvim/lua/packer-setup/after/plugin/colorscheme.lua'                     -- Path to your theme config file
    -- Read the content of the config file
    local file = io.open(config_path, "r+b")
    local lines = {}
    if file then
        for line in file:lines() do
            -- Find and update the dark_variant line
            if line:match("dark_variant") then
                line = string.gsub(line, '".-"', '"' .. new_value .. '"')
            end
            table.insert(lines, line)
        end
        file:close()

        -- Write the modified content back to the config file
        file = io.open(config_path, "w")
        if file then
            for _, line in ipairs(lines) do
                file:write(line .. "\n")
            end
            file:close()
        end
    end
end

function scheme_for_appearance(appearance)
    if appearance:find 'Dark' then
        set_nvim_color_scheme('main')
        return 'Rosé Pine (Gogh)'
    else
        set_nvim_color_scheme('dawn')
        return 'Rosé Pine Dawn (Gogh)'
    end
end

wezterm.on("gui-startup", function()
    local tab, pane, window = mux.spawn_window {}
    window:gui_window():maximize()
end)

--config.color_scheme =  'Rosé Pine (Gogh)'
-- config.color_scheme = scheme_for_appearance(get_appearance())
config.color_scheme = 'tokyonight_night'
config.window_background_opacity = 0.8
config.colors = {
    foreground = "#CBE0F0",
    background = "#011628",
    split = "#547998",
}

config.force_reverse_video_cursor = false
config.window_decorations = 'RESIZE'
config.hide_tab_bar_if_only_one_tab = true

config.font = wezterm.font_with_fallback {
    {
        family = 'Ubuntu Mono',
        weight = 'Regular',
        harfbuzz_features = { 'calt=0', 'clig=0', 'liga=0' },
    },
}

config.keys = {
    {
        key = 'n',
        mods = 'SHIFT|CTRL',
        action = wezterm.action.ToggleFullScreen,
    },
}

return config