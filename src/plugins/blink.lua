require("blink.cmp").setup({
  completion = {
    accept = {
      auto_brackets = {
        enabled = true,
      },
    },
    documentation = {
      -- triggered with <C-Space> by default
      -- auto_show = true,
      window = {
        border = "rounded",
        winblend = vim.o.pumblend,
      },
    },
    menu = {
      border = "rounded",
      winblend = vim.o.pumblend,
      draw = {
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
      },
    },
  },
  signature = {
    enabled = true,
    window = {
      winblend = vim.o.pumblend,
      border = "rounded",
    },
  },
  sources = {
    default = { "lazydev", "lsp", "path", "snippets", "buffer", "cmdline" },
    providers = {
      lazydev = {
        name = "LazyDev",
        module = "lazydev.integrations.blink",
        -- prioritize lazydev completions
        score_offset = 100,
      },
    },
  },
})
