local lsp_map = Utils.keymap.get_mapper { mode = "n", desc_prefix = "LSP" }

vim.diagnostic.config {
  underline = true,
  update_in_insert = false,
  virtual_text = {
    severity = { min = vim.diagnostic.severity.WARN },
    prefix = function(diagnostic)
      local icons = Utils.icons.diagnostics
      for d, icon in pairs(icons) do
        if diagnostic.severity == vim.diagnostic.severity[d:upper()] then
          return icon
        end
      end
      return ""
    end,
  },
  severity_sort = true,
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = Utils.icons.diagnostics.Error,
      [vim.diagnostic.severity.WARN] = Utils.icons.diagnostics.Warn,
      [vim.diagnostic.severity.HINT] = Utils.icons.diagnostics.Hint,
      [vim.diagnostic.severity.INFO] = Utils.icons.diagnostics.Info,
    },
    severity = { min = vim.diagnostic.severity.INFO },
  },
}
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("DefaultLspAttach", {}),
  callback = function(args)
    lsp_map { "<leader>k", vim.lsp.buf.signature_help, desc = "Signature Documentation", buffer = args.buf }
    lsp_map { "K", vim.lsp.buf.hover, desc = "Hover Documentation", buffer = args.buf }
    lsp_map { "gD", vim.lsp.buf.declaration, desc = "Goto Declaration", buffer = args.buf }
    lsp_map { "<leader>cr", vim.lsp.buf.rename, desc = "Code Rename", buffer = args.buf }
    lsp_map { "<leader>ca", vim.lsp.buf.code_action, desc = "Code Action", buffer = args.buf }
    lsp_map { "<C-?>", vim.lsp.buf.signature_help, desc = "LSP: Signature", buffer = args.buf, mode = "i" }
  end,
})
vim.lsp.config("*", { root_markers = { ".git", ".envrc" } })
vim.lsp.enable {
  "lua_ls",
  "rust-analyzer",
  "basedpyright",
  "texlab",
  "tinymist",
}

vim.api.nvim_create_user_command("LspLog", function()
  local log_path = vim.lsp.get_log_path()
  vim.cmd("vsplit " .. vim.fn.fnameescape(log_path))
  vim.cmd("normal! G")
  vim.bo.filetype = "lsp-log"
end, { desc = "Open the current LSP log file in a vertical split" })

vim.api.nvim_create_autocmd("FileType", {
  pattern = "lsp-log",
  callback = function()
    vim.opt_local.wrap = false
  end,
})

local function on_enabled_lsp_client(callback, prompt)
  local bufnr = vim.api.nvim_get_current_buf()
  local clients = vim.lsp.get_clients { bufnr = bufnr }
  prompt = prompt or "Select LSP client"

  if vim.tbl_isempty(clients) then
    vim.notify("No LSP clients attached to this buffer", vim.log.levels.WARN)
    return
  end

  if #clients == 1 then
    callback(clients[1])
    return
  end

  vim.ui.select(clients, {
    prompt = prompt,
    format_item = function(client)
      return client.name
    end,
  }, function(client)
    if client then
      callback(client)
    end
  end)
end

vim.api.nvim_create_user_command("LspRestartClient", function()
  on_enabled_lsp_client(function(client)
    vim.lsp.stop_client(client.name)
    vim.cmd("e")
    vim.notify("Restarted LSP client: " .. client.name)
  end)
end, { desc = "Select and restart an LSP client attached to the current buffer" })

vim.api.nvim_create_user_command("LspDisableClient", function()
  on_enabled_lsp_client(function(client)
    vim.lsp.enable(client.name, false)
    vim.notify("Stopped LSP client: " .. client.name)
  end)
end, { desc = "Disable an LSP client attached to the current buffer" })

local function on_configured_client(callback, prompt, only_enabled)
  local config_path = vim.fn.stdpath("config") .. "/lsp"
  local handle = vim.uv.fs_scandir(config_path)
  local servers = {}
  prompt = prompt or "Select LSP client"

  if not handle then
    vim.notify("Could not scan lsp config directory", vim.log.levels.ERROR)
    return
  end

  while true do
    local name, type = vim.uv.fs_scandir_next(handle)
    if not name then
      break
    end

    if type == "file" and name:sub(-4) == ".lua" then
      local server = name:sub(1, -5) -- remove .lua
      if not vim.lsp.is_enabled(server) or not only_enabled then
        table.insert(servers, server)
      end
    end
  end

  if vim.tbl_isempty(servers) then
    vim.notify("No LSP clients found", vim.log.levels.WARN)
    return
  end

  vim.ui.select(servers, {
    prompt = "Select LSP client to enable",
  }, function(choice)
    if not choice then
      return
    end
    callback(choice)
  end)
end

vim.api.nvim_create_user_command("LspEnableClient", function()
  on_configured_client(function(choice)
    vim.lsp.enable(choice, true)
    vim.notify("Enabled LSP: " .. choice)
  end, nil, true)
end, { desc = "Select and enable LSPs configured in lua/lsp/" })
