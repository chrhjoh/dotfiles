return {
  -- Autocompletion
  'hrsh7th/nvim-cmp',
  event = 'InsertEnter',
  dependencies = {
    -- Snippet Engine & its associated nvim-cmp source
    'L3MON4D3/LuaSnip',
    'saadparwaiz1/cmp_luasnip',

    -- Adds LSP completion capabilities
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-buffer',
    'hrsh7th/cmp-path',
    'f3fora/cmp-spell',

    -- Adds a number of user-friendly snippets
    'rafamadriz/friendly-snippets',

    'onsails/lspkind.nvim',
  },
  config = function()
    local cmp = require('cmp')
    local luasnip = require('luasnip')
    require('luasnip.loaders.from_vscode').lazy_load()
    luasnip.config.setup {}

    cmp.setup {
      window = { completion = { scrolloff = 1 }, documentation = { max_height = 20 * 20 / vim.o.lines } },
      snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
      },
      completion = {
        completeopt = 'menuone,noinsert',
      },
      mapping = cmp.mapping.preset.insert {
        ['<Down>'] = cmp.mapping(function(fallback)
          cmp.close()
          fallback()
        end, { 'i' }),
        ['<Up>'] = cmp.mapping(function(fallback)
          cmp.close()
          fallback()
        end, { 'i' }),
        ['<C-n>'] = cmp.mapping.select_next_item(),
        ['<C-p>'] = cmp.mapping.select_prev_item(),
        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-c>'] = cmp.mapping.complete { reason = cmp.ContextReason.Auto },
        ['<C-y>'] = cmp.mapping.confirm {
          behavior = cmp.ConfirmBehavior.Replace,
          select = true,
        },
        ['<Tab>'] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item { behavior = require('cmp.types').cmp.SelectBehavior.Select }
          elseif luasnip.expand_or_locally_jumpable() then
            luasnip.expand_or_jump()
          else
            fallback()
          end
        end, { 'i', 's' }),
        ['<S-Tab>'] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item { behavior = require('cmp.types').cmp.SelectBehavior.Select }
          elseif luasnip.locally_jumpable(-1) then
            luasnip.jump(-1)
          else
            fallback()
          end
        end, { 'i', 's' }),
      },
      sources = {
        { name = 'lazydev', group_index = 0 },
        { name = 'nvim_lsp', group_index = 1 },
        { name = 'path', group_index = 1 },
        { name = 'luasnip', group_index = 1 },
        {
          name = 'spell',
          group_index = 3,
          option = {
            keep_all_entries = false,
            enable_in_context = function()
              return true
            end,
          },
        },
        { name = 'buffer', group_index = 5 },
      },

      enabled = function()
        return not vim.g.cmp_disable
      end,

      formatting = {
        format = function(entry, item)
          local color_item = require('nvim-highlight-colors').format(entry, { kind = item.kind })
          item = require('lspkind').cmp_format {
            -- any lspkind format settings here
          }(entry, item)
          if color_item.abbr_hl_group then
            item.kind_hl_group = color_item.abbr_hl_group
            item.kind = color_item.abbr
          end
          return item
        end,
      },
    }
  end,
}
