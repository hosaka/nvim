local lspconfig = require("lspconfig")

vim.diagnostic.config({
  float = {
    border = "single",
  },
  -- underline = false,
  severity_sort = true,
  -- don't update diagnostics when typing
  update_in_insert = false,
})

-- vim.api.nvim_create_autocmd("LspAttach", {
--   callback = function(event)
--     local opts = { buffer = event.buf }
--     vim.notify("Lsp Attached")
--   end,
-- })

-- default attach for all lsp servers
local default_on_attach = function(client, buffer)
  vim.notify("Lsp Attached")
end

-- default setup for all lsp servers
local default_setup = function(server)
  lspconfig[server].setup({})
end

-- default capabilities (lsp completion)
local default_capabilities = require("cmp_nvim_lsp").default_capabilities()

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
          -- lsp specific extras go here
        end,
        capabilities = default_capabilities,
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
