local M = {}
local wezterm = require('wezterm') --[[@as Wezterm]]
local actions = wezterm.action

M.terminal = nil

-- TODO: callback/function that sets the terminal to paste to
--
-- TODO: callback/function that pastes to that terminal
--
-- TODO: function resolves the terminal when it is not specified

return M
