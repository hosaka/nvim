local lspconfig = require("lspconfig")
local lsp_defaults = lspconfig.util.default_config

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(event)
    local opts = { buffer = event.buf }
    vim.notify("Lsp Attached")
    -- vim.keymap.set("n", "K", [[<cmd>lua vim.lsp.buf.hover()<cr>]], opts)
    -- vim.keymap.set("n", "gd", [[<cmd>lua vim.lsp.buf.definition()<cr>]], opts)
    -- vim.keymap.set("n", "gD", [[<cmd>lua vim.lsp.buf.declaration()<cr>]], opts)
  end,
})

vim.diagnostic.config({
  float = {
    border = "single",
  },
  -- underline = false,
  severity_sort = true,
  -- don't update diagnostics when typing
  update_in_insert = false,
})

local default_on_attach = function(client, buffer)
  vim.api.nvim_buf_set_option(buffer, "omnifunc", "v:lua.MiniCompletion.completefunc_lsp")
end

local default_setup = function(server)
  require("lspconfig")[server].setup({})
end

require("mason").setup({
  -- prefer existing binaries over the ones installed by mason
  -- PATH = "append",
})

require("mason-lspconfig").setup({
  ensure_installed = {
    "lua_ls",
    "marksman",
  },
  -- automatic_installation = true,
  handlers = {
    default_setup,
    lua_ls = function()
      local runtime_path = vim.split(package.path, ";")
      table.insert(runtime_path, "lua/?.lua")
      table.insert(runtime_path, "lua/?/init.lua")

      require("lspconfig").lua_ls.setup({
        on_attach = function(client, buffer)
          default_on_attach(client, buffer)
          -- lua_ls specific extras go here
        end,
        settings = {
          Lua = {
            hint = {
              enable = true,
            },
            telemetry = {
              enable = false,
            },
            runtime = {
              version = "LuaJIT",
              path = runtime_path,
            },
            diagnostics = {
              -- Get the language server to recognize the `vim` global
              globals = { "vim" },
            },
            workspace = {
              checkThirdParty = false,
              ignoreSubmodules = true,
              library = {
                -- Make the server aware of Neovim runtime files
                vim.fn.expand("$VIMRUNTIME/lua"),
                vim.fn.stdpath("config") .. "/lua",
              },
            },
          },
        },
      })
    end,
  },
})
