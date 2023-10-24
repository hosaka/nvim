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
  vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = buffer, desc = "Lsp hover" })
  vim.keymap.set("n", "gK", vim.lsp.buf.signature_help, { buffer = buffer, desc = "Lsp signature help" })
  vim.keymap.set("i", "<C-k>", vim.lsp.buf.signature_help, { buffer = buffer, desc = "Lsp signature help" })
  vim.keymap.set("n", "gI", vim.lsp.buf.implementation, { buffer = buffer, desc = "Lsp implementation" })
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
              -- common globals
              globals = { "vim" },
              -- disables workspace diagnostics
              workspaceDelay = -1,
            },
            workspace = {
              checkThirdParty = false,
              ignoreSubmodules = false,
              ignoreDir = { "./misc" },
              library = {
                -- make the server aware of neovim runtime files
                vim.fn.expand("$VIMRUNTIME/lua"),
                vim.fn.stdpath("config") .. "/lua",
              },
            },
          },
        },
      })
    end,

    -- json
    jsonls = function()
      require("lspconfig").jsonls.setup({
        on_attach = function(client, buffer)
          default_on_attach(client, buffer)
        end,
        on_new_config = function(config)
          -- lazy load schemastore when needed
          config.settings.json.schemas = config.settings.json.schemas or {}
          vim.list_extend(config.settings.json.schemas, require("schemastore").json.schemas())
        end,
        capabilities = {
          default_capabilities,
          textDocument = {
            foldingRange = {
              dynamicRegistration = false,
              lineFoldingOnly = true,
            },
          },
        },
        settings = {
          json = {
            format = { enable = true },
            validate = { enable = true },
          },
        },
      })
    end,

    -- yaml
    yamlls = function()
      require("lspconfig").yamlls.setup({
        -- TODO: this doesn't run on lsp attach for some reason
        on_attach = function(client, buffer)
          default_on_attach(client, buffer)

          if vim.fn.has("nvim-0.10") == 0 then
            client.server_capabilities.documentFormattingProvider = true
          end
        end,
        on_new_config = function(config)
          -- lazy load schemastore when needed
          config.settings.yaml.schemas =
            vim.tbl_deep_extend("force", config.settings.yaml.schemas or {}, require("schemastore").yaml.schemas())
        end,
        capabilities = default_capabilities,
        settings = {
          yaml = {
            format = { enable = true },
            keyOrdering = false,
            schemaStore = { enable = false, url = "", validate = true },
          },
          redhat = { telemetry = { enabled = false } },
        },
      })
    end,

    -- toml
    taplo = function()
      require("lspconfig").taplo.setup({
        on_attach = function(client, buffer) end,
        capabilities = default_capabilities,
      })
    end,

    --docker
    dockerls = function()
      require("lspconfig").dockerls.setup({
        on_attach = function(client, buffer)
          default_on_attach(client, buffer)
        end,
        capabilities = default_capabilities,
      })
    end,

    -- python
    pyright = function()
      require("lspconfig").pyright.setup({
        on_attach = function(client, buffer)
          default_on_attach(client, buffer)
        end,
        capabilities = default_capabilities,
      })
    end,
    ruff_lsp = function()
      require("lspconfig").ruff_lsp.setup({
        on_attach = function(client, buffer)
          default_on_attach(client, buffer)

          -- disable hover in favor of pyright
          client.server_capabilities.hoverProvide = false

          vim.keymap.set("n", "<Leader>co", function()
            vim.lsp.buf.code_action({
              apply = true,
              context = {
                only = { "source.organizeImports" },
                diagnostics = {},
              },
            })
          end, { buffer = buffer, desc = "Organize imports" })
        end,
        capabilities = default_capabilities,
      })
    end,

    --golang
    gopls = function()
      require("lspconfig").gopls.setup({
        on_attach = function(client, buffer)
          default_on_attach(client, buffer)

          -- workaround for gopls not supporting semanticTokensProvider
          -- see https://github.com/golang/go/issues/54531#issuecomment-1464982242
          if not client.server_capabilities.semanticTokensProvider then
            local semantic = client.config.capabilities.textDocument.semanticTokens
            client.server_capabilities.semanticTokensProvider = {
              full = true,
              legend = {
                tokenTypes = semantic.tokenTypes,
                tokenModifiers = semantic.tokenModifiers,
              },
              range = true,
            }
          end
        end,
        capabilities = default_capabilities,
        settings = {
          gopls = {
            gofumpt = true,
            analyses = {
              fieldalignment = true,
              nilness = true,
              unusedparams = true,
              unusedwrite = true,
              useany = true,
            },
            hints = {
              assignVariableTypes = true,
              compositeLiteralFields = true,
              compositeLiteralTypes = true,
              constantValues = true,
              functionTypeParameters = true,
              parameterNames = true,
              rangeVariableTypes = true,
            },
            directoryFilters = { "-.git", "-.node_modules", "-.vscode", "-.idea" },
            semanticTokens = true,
            staticcheck = true,
            usePlaceholders = true,
          },
        },
      })
    end,

    -- rust
    rust_analyzer = function()
      require("lspconfig").rust_analyzer.setup({
        on_attach = function(client, buffer)
          default_on_attach(client, buffer)
        end,
        capabilities = default_capabilities,
        settings = {
          cargo = {
            features = "all",
          },
          check = {
            command = "clippy",
            extraArgs = { "--no-deps" },
          },
          procMacro = {
            ignored = {
              ["async-trait"] = { "async_trait" },
              ["napi-derive"] = { "napi" },
              ["async-recursion"] = { "async_recursion" },
            },
          },
        },
      })
    end,

    -- tailwind
    tailwindcss = function()
      require("lspconfig").tailwindcss.setup({
        on_attach = function(client, buffer)
          default_on_attach(client, buffer)
        end,
        capabilities = default_capabilities,
      })
    end,

    -- javascript/typescript
    tsserver = function()
      require("lspconfig").tsserver.setup({
        on_attach = function(client, buffer)
          default_on_attach(client, buffer)
          vim.keymap.set("n", "<Leader>co", function()
            vim.lsp.buf.code_action({
              apply = true,
              context = {
                only = { "source.organizeImports.ts" },
                diagnostics = {},
              },
            })
          end, { buffer = buffer, desc = "Organize imports" })
          vim.keymap.set("n", "<Leader>cu", function()
            vim.lsp.buf.code_action({
              apply = true,
              context = {
                only = { "source.removeUnused.ts" },
                diagnostics = {},
              },
            })
          end, { buffer = buffer, desc = "Remove unused imports" })
        end,
        capabilities = default_capabilities,
        settings = {
          typescript = {
            format = {
              indentSize = vim.o.shiftwidth,
              convertTabsToSpace = vim.o.expandtab,
              tabSize = vim.o.tabstop,
            },
            inlayHints = {
              includeInlayEnumMemberValueHints = true,
              includeInlayFunctionLikeReturnTypeHints = true,
              includeInlayFunctionParameterTypeHints = true,
              includeInlayParameterNameHints = "all",
              includeInlayParameterNameHintsWhenArgumentMatchesName = true,
              includeInlayPropertyDeclarationTypeHints = true,
              includeInlayVariableTypeHints = true,
              includeInlayVariableTypeHintsWhenTypeMatchesName = true,
            },
          },
          javascript = {
            format = {
              indentSize = vim.o.shiftwidth,
              convertTabsToSpace = vim.o.expandtab,
              tabSize = vim.o.tabstop,
            },
            inlayHints = {
              includeInlayEnumMemberValueHints = true,
              includeInlayFunctionLikeReturnTypeHints = true,
              includeInlayFunctionParameterTypeHints = true,
              includeInlayParameterNameHints = "all",
              includeInlayParameterNameHintsWhenArgumentMatchesName = true,
              includeInlayPropertyDeclarationTypeHints = true,
              includeInlayVariableTypeHints = true,
              includeInlayVariableTypeHintsWhenTypeMatchesName = true,
            },
          },
          completions = {
            completeFunctionCalls = true,
          },
        },
      })
    end,
  },
})
