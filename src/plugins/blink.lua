require("blink.cmp").setup({
  accept = {
    auto_brackets = {
      enabled = true,
    },
  },
  trigger = {
    signature_help = {
      enabled = true,
    },
  },
  windows = {
    autocomplete = {
      border = "rounded",
      winblend = vim.o.pumblend,
      -- draw = {
      --   components = {
      --     kind_icon = {
      --       text = function(ctx)
      --         local icon = ctx.kind_icon
      --         local source = ctx.item.source_name
      --         if source == "LSP" then
      --           icon = MiniIcons.get("lsp", ctx.kind)
      --         elseif source == "Path" then
      --           local label = ctx.item.label
      --           if ctx.kind == "File" then
      --             icon = MiniIcons.get("file", label)
      --           elseif ctx.kind == "Folder" then
      --             icon = MiniIcons.get("directory", label)
      --           end
      --         end
      --         return icon .. ctx.icon_gap
      --       end,
      --     },
      --   },
      -- },
    },
    documentation = {
      border = "rounded",
      winblend = vim.o.pumblend,
      -- triggered with <C-Space> by default
      -- auto_show = true,
    },
    signature_help = {
      winblend = vim.o.pumblend,
      border = "rounded",
    },
  },
  sources = {
    completion = {
      enabled_providers = { "lsp", "path", "snippets", "buffer", "lazydev" },
    },
    providers = {
      -- don't show luals require statements when lazydev has items
      lsp = { fallback_for = { "lazydev" } },
      lazydev = { name = "LazyDev", module = "lazydev.integrations.blink" },
    },
  },
})
