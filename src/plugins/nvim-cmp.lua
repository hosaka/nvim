local cmp = require("cmp")

-- vim.api.nvim_set_hl(0, "GhostText", { link = "Comment", default = true })

cmp.setup({
  sources = {
    { name = "nvim_lsp" },
    { name = "nvim_lsp_signature_help" },
  },
  {
    { name = "buffer" },
    -- { name = "path"},
  },
  mapping = cmp.mapping.preset.insert({
    ["<CR>"] = cmp.mapping.confirm({ select = false, behavior = cmp.ConfirmBehavior.Replace }),
    -- select next item, expand a snippet or navigate to the next placeholder
    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif vim.snippet.jumpable(1) then
        vim.schedule(function()
          vim.snippet.jump(1)
        end)
      else
        fallback()
      end
    end, { "i", "s" }),
    -- select previous item, or navigate to the previous placeholder
    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif vim.snippet.jumpable(-1) then
        vim.schedule(function()
          vim.snippet.jump(-1)
        end)
      else
        fallback()
      end
    end, { "i", "s" }),
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
    ["<C-f>"] = cmp.mapping.scroll_docs(4),
  }),
  snippet = {
    expand = function(args)
      vim.snippet.expand(args.body)
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
        nvim_lsp_signature_help = "sig",
        nvim_lua = "nvim",
      }

      local menu_name = short_name[entry.source.name] or entry.source.name
      item.menu = string.format("[%s]", menu_name)
      return item
    end,
  },
  experimental = {
    -- ghost_text = {
    --   hl_group = "GhostText",
    -- },
  },
  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },
})

cmp.setup.cmdline("/", {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = "buffer" },
  }),
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
