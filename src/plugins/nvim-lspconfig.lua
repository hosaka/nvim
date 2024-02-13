vim.diagnostic.config({
  float = {
    border = "rounded",
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
  local map = function(mode, lhs, rhs, desc, has)
    -- skips the keymap if lsp method is not supported
    if has ~= nil then
      if not client.supports_method(has) then
        return
      end
    end

    local opts = {}
    opts.desc = desc
    opts.buffer = buffer

    vim.keymap.set(mode, lhs, rhs, opts)
  end

  local mapl = function(mode, suffix, rhs, desc, has)
    map(mode, "<Leader>" .. suffix, rhs, desc, has)
  end

  map("n", "K", [[<cmd>lua vim.lsp.buf.hover()<cr>]], "Hover popup")
  map("n", "gd", [[<cmd>lua vim.lsp.buf.definition()<cr>]], "Go to definition", "textDocument/definition")
  map("n", "gD", [[<cmd>lua vim.lsp.buf.declaration()<cr>]], "Go to declaration", "textDocument/declaration")
  map("n", "gI", [[<cmd>lua vim.lsp.buf.implementation()<cr>]], "Go to implementation", "textDocument/implementation")
  map("n", "gY", [[<cmd>lua vim.lsp.buf.type_definition()<cr>]], "Go to type definition", "textDocument/typeDefinition")
  map("n", "gK", [[<cmd>lua vim.lsp.buf.signature_help()<cr>]], "Signature help", "textDocument/signatureHelp")
  map("i", "<C-k>", [[<cmd>lua vim.lsp.buf.signature_help()<cr>]], "Signature help", "textDocument/signatureHelp")

  mapl({ "n", "x" }, "ca", [[<cmd>lua vim.lsp.buf.code_action()<cr>]], "Action popup", "textDocument/codeAction")
  mapl("n", "cr", [[<cmd>lua vim.lsp.buf.rename()<cr>]], "Rename symbol", "textDocument/rename")
  mapl("n", "cR", [[<cmd>lua vim.lsp.buf.references()<cr>]], "Find references", "textDocument/references")

  local format_cmd = [[<cmd>lua require("conform").format({ lsp_fallback = true })<cr>]]
  mapl("n", "cf", format_cmd, "Format buffer")
  mapl("x", "cf", format_cmd, "Format selection")

  if vim.lsp.inlay_hint then
    mapl("n", "ch", function()
      vim.lsp.inlay_hint.enable(buffer, not vim.lsp.inlay_hint.is_enabled(buffer))
    end, "Toggle inlay hints", "textDocument/inlayHint")
  end

  local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
  ---@diagnostic disable-next-line: duplicate-set-field
  function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
    opts = opts or {}
    opts.border = opts.border or "rounded"
    return orig_util_open_floating_preview(contents, syntax, opts, ...)
  end
end

-- default capabilities (lsp completion)
local default_capabilities = require("cmp_nvim_lsp").default_capabilities()

-- default setup for all lsp servers
local default_setup = function(server)
  require("lspconfig")[server].setup({
    on_attach = default_on_attach,
    capabilities = default_capabilities,
  })
end

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
        handlers = {
          -- don't open quickfix list in case of multiple definitions
          -- luals treats `local x = function()` as two definitions of `x`
          ["textDocument/definition"] = function(err, result, ctx, config)
            if type(result) == "table" then
              result = { result[1] }
            end
            vim.lsp.handlers["textDocument/definition"](err, result, ctx, config)
          end,
        },
        on_attach = default_on_attach,
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
              -- noisy missing-fields warnings
              disable = { "missing-fields" },
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
        on_attach = default_on_attach,
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
        on_attach = default_on_attach,
        capabilities = default_capabilities,
      })
    end,

    --docker
    dockerls = function()
      require("lspconfig").dockerls.setup({
        on_attach = default_on_attach,
        capabilities = default_capabilities,
      })
    end,

    -- python
    pyright = function()
      require("lspconfig").pyright.setup({
        on_attach = default_on_attach,
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
      -- note: attach is handled by `rustaceanvim` itself
      vim.g.rustaceanvim = {
        server = {
          on_attach = function(client, buffer)
            default_on_attach(client, buffer)
            vim.keymap.set(
              "n",
              "<Leader>rr",
              [[<cmd>RustLsp runnables last<cr>]],
              { buffer = buffer, desc = "Run last (rust)" }
            )
            vim.keymap.set(
              "n",
              "<Leader>rR",
              [[<cmd>RustLsp runnables<cr>]],
              { buffer = buffer, desc = "Runnables (rust)" }
            )
            vim.keymap.set(
              "n",
              "<Leader>ce",
              [[<cmd>RustLsp explainError<cr>]],
              { buffer = buffer, desc = "Explain error (rust)" }
            )
            vim.keymap.set(
              "n",
              "<Leader>ec",
              [[<cmd>RustLsp openCargo<cr>]],
              { buffer = buffer, desc = "Cargo.toml (rust)" }
            )
            vim.keymap.set("n", "J", [[<cmd>RustLsp joinLines<cr>]], { buffer = buffer, desc = "Join lines (rust)" })
          end,
          default_settings = {
            ["rust-analyzer"] = {
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
          },
        },
        tools = {
          float_win_config = {
            border = "rounded",
          },
        },
      }
    end,

    -- tailwind
    tailwindcss = function()
      require("lspconfig").tailwindcss.setup({
        on_attach = default_on_attach,
        capabilities = default_capabilities,
      })
    end,

    -- javascript/typescript
    eslint = function()
      require("lspconfig").eslint.setup({
        on_attach = default_on_attach,
        capabilities = default_capabilities,
        filetypes = {
          "javascript",
          "javascriptreact",
          "javascript.jsx",
          "typescript",
          "typescriptreact",
          "typescript.tsx",
          -- note: enable as needed
          -- "vue",
          -- "svelte",
          -- "astro",
        },
        settings = {
          workingDirectories = {
            mode = "auto",
          },
        },
      })
    end,
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

require("lspconfig.ui.windows").default_options.border = "rounded"
