local M = {}
local wezterm = require("wezterm") --[[@as Wezterm]]

local terminal = nil

M.set_paste_terminal = wezterm.action_callback(function(window, pane)
  local panes = window:active_tab():panes()
  local pane_list = {}

  for _, p in ipairs(panes) do
    local id = p:pane_id()
    local title = p:get_title()
    table.insert(pane_list, string.format("%s - %s", id, title))
  end

  window:perform_action(
    wezterm.action.PromptInputLine {
      description = "Select a Pane by ID:\n" .. table.concat(pane_list, "\n"),
      action = wezterm.action_callback(function(window, pane, id)
        if id and tonumber(id) then
          terminal = tonumber(id)
          wezterm.log_info("Pane Set", "Target pane set to ID: " .. id, nil, 3000)
        else
          wezterm.log_warn("Error", "Invalid pane ID entered", nil, 3000)
        end
      end),
    },
    pane
  )
end)

M.paste_selection = wezterm.action_callback(function(window, pane)
  local selection = window:get_selection_text_for_pane(pane)
  if terminal then
    local target_pane = wezterm.mux.get_pane(terminal)
    if target_pane then
      target_pane:send_paste(selection)
      window:perform_action(wezterm.action.SendKey { key = "Enter" }, target_pane)
    else
      wezterm.log_error("Invalid target pane ID: " .. tostring(terminal), nil, 3000)
    end
  else
    wezterm.log_error("No target pane set", nil, 3000)
  end
end)

return M
