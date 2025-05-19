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
        winblend = vim.o.winblend,
      },
    },
    list = {
      selection = {
        preselect = true,
        auto_insert = false,
      },
    },
    menu = {
      winblend = vim.o.winblend,
      draw = {
        columns = {
          { "kind_icon" },
          -- label and label_description are combined by colorful-menu.nvim
          { "label", gap = 1 },
        },
        components = {
          label = {
            text = function(ctx)
              return require("colorful-menu").blink_components_text(ctx)
            end,
            highlight = function(ctx)
              return require("colorful-menu").blink_components_highlight(ctx)
            end,
          },
          kind_icon = {
            text = function(ctx)
              local icon, _, _ = require("mini.icons").get("lsp", ctx.kind)
              return icon
            end,
            -- (optional) use highlights from mini.icons
            highlight = function(ctx)
              local _, hl, _ = require("mini.icons").get("lsp", ctx.kind)
              return hl
            end,
          },
          kind = {
            -- (optional) use highlights from mini.icons
            highlight = function(ctx)
              local _, hl, _ = require("mini.icons").get("lsp", ctx.kind)
              return hl
            end,
          },
        },
      },
    },
  },
  fuzzy = {
    prebuilt_binaries = {
      force_version = "v1.3.1",
    },
  },
  signature = {
    enabled = true,
    window = {
      winblend = vim.o.winblend,
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
      snippets = {
        -- hide snippets after trigger character such as dot
        should_show_items = function(ctx)
          return ctx.trigger.initial_kind ~= "trigger_character"
        end,
      },
    },
  },
})
