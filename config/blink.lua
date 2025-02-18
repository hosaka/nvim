local rounded_window = {
  border = "rounded",
  winblend = vim.o.pumblend,
}
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
      window = rounded_window,
    },
    menu = {
      border = rounded_window.border,
      winblend = rounded_window.winblend,
      draw = {
        components = {
          -- kind_icon = {
          --   text = function(ctx)
          --     local icon = ctx.kind_icon
          --     local source = ctx.item.source_name
          --     if source == "LSP" then
          --       icon = MiniIcons.get("lsp", ctx.kind)
          --     elseif source == "Path" then
          --       local label = ctx.item.label
          --       if ctx.kind == "File" then
          --         icon = MiniIcons.get("file", label)
          --       elseif ctx.kind == "Folder" then
          --         icon = MiniIcons.get("directory", label)
          --       end
          --     end
          --     return icon .. ctx.icon_gap
          --   end,
          --   highlight = function(ctx)
          --     local _, hl, _ = require("mini.icons").get("lsp", ctx.kind)
          --     return hl
          --   end,
          -- },
        },
      },
    },
  },
  signature = {
    enabled = true,
    window = rounded_window,
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
      cmdline = {
        -- ignore cmdline completions when executing shell commands (hangs in WSL)
        enabled = function()
          return vim.fn.getcmdtype() ~= ":" or not vim.fn.getcmdline():match("^[%%0-9,'<>%-]*!")
        end,
      },
      path = {
        opts = {
          -- path completion from cwd instead of current buffer's directory
          get_cwd = function()
            return vim.fn.getcwd()
          end,
        },
      },
    },
  },
})
