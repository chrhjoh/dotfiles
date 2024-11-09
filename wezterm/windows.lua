require("wezterm")

M = {}

function M.add_window_configurations(config)
    config.window_decorations = "RESIZE"
    config.window_padding = {
        left = 0,
        right = 0,
        top = 10,
        bottom = 0,
    }
end

return M
