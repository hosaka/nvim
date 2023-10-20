local cmp = require("cmp")

vim.api.nvim_set_hl(0, "GhostText", { link = "Comment", default = true })

cmp.setup({
  sources = {
    { name = "nvim_lsp" },
    { name = "luasnip" },
  },
  {
    { name = "buffer" },
    -- { name = "path"},
  },
  mapping = cmp.mapping.preset.insert({
    ["<CR>"] = cmp.mapping.confirm({ select = false }),
  }),
  snippet = {
    expand = function(args)
      require("luasnip").lsp_expand(args.body)
    end,
  },
  -- pre-select first item
  -- completion = {
  --   completeopt = "menu,menuone,noinsert",
  -- },
  formatting = {
    fields = { "abbr", "menu", "kind" },
    format = function(entry, item)
      local short_name = {
        nvim_lsp = "lsp",
        nvim_lua = "nvim",
        luasnip = "snip",
      }

      local menu_name = short_name[entry.source.name] or entry.source.name
      item.menu = string.format("[%s]", menu_name)
      return item
    end,
  },
  experimental = {
    -- NOTE: set this to false if using copilot.lua
    ghost_text = {
      hl_group = "GhostText",
    },
  },
})

cmp.setup.cmdline(":", {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = "path" },
  }, {
    {
      name = "cmdline",
      options = {
        ignore_cmds = { "man", "!" },
      },
    },
  }),
})
