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
    },
    documentation = {
      border = "rounded",
      -- triggered with <C-Space> by default
      -- auto_show = true,
    },
    signature_help = {
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
  -- todo: kind_icons = require("mini.icons")
})
