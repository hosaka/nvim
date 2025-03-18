require("lspconfig.ui.windows").default_options.border = "rounded"

-- vim.api.nvim_create_autocmd("LspAttach", {
--   callback = function(event)
--     local opts = { buffer = event.buf }
--     vim.notify("Lsp Attached")
--   end,
-- })

-- default attach for all lsp servers
local default_on_attach = function(client, buffer)
  -- use mini.completion
  -- vim.bo[buffer].omnifunc = "v:lua.MiniCompletion.completefunc_lsp"

  --- Map a key, unless lsp method is not supported
  ---@param lhs string
  ---@param rhs string|function
  ---@param opts? vim.keymap.set.Opts | { mode: string | string[] }
  ---@param has? string
  local map = function(lhs, rhs, opts, has)
    if has ~= nil then
      if not client.supports_method(has) then
        return
      end
    end
    opts.buffer = buffer
    Hosaka.keymap.map(lhs, rhs, opts)
  end

  --- Map a key with <Leader> prefix, unless lsp method is not supported
  ---@param lhs string
  ---@param rhs string|function
  ---@param opts? vim.keymap.set.Opts | { mode: string | string[] }
  ---@param has? string
  local mapl = function(lhs, rhs, opts, has)
    map("<Leader>" .. lhs, rhs, opts, has)
  end

  --- Map a toggle, unless lsp method is not supported
  ---@param lhs string
  ---@param name string
  ---@param get fun():boolean
  ---@param set fun(state:boolean)
  ---@param has? string
  local mapt = function(lhs, name, get, set, has)
    if has ~= nil then
      if not client.supports_method(has) then
        return
      end
    end
    Hosaka.toggle({
      name = name,
      get = get,
      set = set,
    }):mapl(lhs, { buffer = buffer })
  end

  map("K", [[<cmd>lua vim.lsp.buf.hover()<cr>]], { desc = "Hover popup" })
  map("gd", [[<cmd>lua vim.lsp.buf.definition()<cr>]], { desc = "Go to definition" }, "textDocument/definition")
  map("gD", [[<cmd>lua vim.lsp.buf.declaration()<cr>]], { desc = "Go to declaration" }, "textDocument/declaration")
  map(
    "gI",
    [[<cmd>lua vim.lsp.buf.implementation()<cr>]],
    { desc = "Go to implementation" },
    "textDocument/implementation"
  )
  map(
    "gY",
    [[<cmd>lua vim.lsp.buf.type_definition()<cr>]],
    { desc = "Go to type definition" },
    "textDocument/typeDefinition"
  )
  map("gK", [[<cmd>lua vim.lsp.buf.signature_help()<cr>]], { desc = "Signature help" }, "textDocument/signatureHelp")
  map(
    "<C-k>",
    [[<cmd>lua vim.lsp.buf.signature_help()<cr>]],
    { mode = "i", desc = "Signature help" },
    "textDocument/signatureHelp"
  )
  mapl(
    "ca",
    [[<cmd>lua vim.lsp.buf.code_action()<cr>]],
    { mode = { "n", "x" }, desc = "Action popup" },
    "textDocument/codeAction"
  )
  mapl("cr", [[<cmd>lua vim.lsp.buf.rename()<cr>]], { desc = "Rename symbol" }, "textDocument/rename")
  mapl("cR", [[<cmd>lua vim.lsp.buf.references()<cr>]], { desc = "Find references" }, "textDocument/references")
  mapl(
    "cd",
    [[<cmd>lua vim.diagnostic.open_float()<cr>]],
    { desc = "Diagnostic popup" },
    "textDocument/publishDiagnostics"
  )
  mapl("cD", function()
    vim.diagnostic.setqflist()
    -- expand source lines in for quickfix items
    require("quicker").refresh()
  end, { desc = "Diagnostic quickfix" }, "textDocument/publishDiagnostics")

  mapt("od", "diagnostics", function()
    return vim.diagnostic.is_enabled()
  end, function()
    require("mini.basics").toggle_diagnostic()
  end, "textDocument/publishDiagnostics")

  -- note: assuming using lsp_lines plugin
  mapt("oD", "line diagnostics", function()
    return not vim.diagnostic.config().virtual_lines
  end, function(state)
    vim.diagnostic.config({ virtual_text = state, virtual_lines = not state })
  end, "textDocument/publishDiagnostics")

  if vim.lsp.inlay_hint then
    mapt("oh", "inlay hints", function()
      return vim.lsp.inlay_hint.is_enabled({ bufnr = buffer })
    end, function(state)
      vim.lsp.inlay_hint.enable(state, { bufnr = buffer })
    end, "textDocument/inlayHint")
  end

  local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
  ---@diagnostic disable-next-line: duplicate-set-field
  function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
    opts = opts or {}
    opts.border = opts.border or "rounded"
    return orig_util_open_floating_preview(contents, syntax, opts, ...)
  end
end

-- Default LSP capabilities
---@param override? lsp.ClientCapabilities
---@return lsp.ClientCapabilities
local default_capabilities = function(override)
  return require("blink.cmp").get_lsp_capabilities(override)
end

-- Default LSP handler
---@param server string
local default_handler = function(server)
  require("lspconfig")[server].setup({
    on_attach = default_on_attach,
    capabilities = default_capabilities(),
  })
end

local handlers = {
  -- this will be the default handler and will be called for each installed server
  -- that doesn't have a dedicated handler
  default_handler,

  -- handler overrides for specific servers
  lua_ls = function()
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
      capabilities = default_capabilities(),
      settings = {
        Lua = {
          hint = {
            enable = true,
          },
          telemetry = {
            enable = false,
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
      capabilities = default_capabilities({
        textDocument = {
          foldingRange = {
            dynamicRegistration = false,
            lineFoldingOnly = true,
          },
        },
      }),
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
      capabilities = default_capabilities(),
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

  -- python
  ruff = function()
    require("lspconfig").ruff.setup({
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
      capabilities = default_capabilities(),
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
      capabilities = default_capabilities(),
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

  -- javascript/typescript
  eslint = function()
    require("lspconfig").eslint.setup({
      on_attach = default_on_attach,
      capabilities = default_capabilities(),
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
  ts_ls = function()
    require("lspconfig").ts_ls.setup({
      on_attach = function(client, buffer)
        default_on_attach(client, buffer)
        vim.keymap.set("n", "<Leader>co", function()
          vim.lsp.buf.code_action({
            apply = true,
            context = {
              ---@diagnostic disable-next-line: assign-type-mismatch
              only = { "source.organizeImports.ts" },
              diagnostics = {},
            },
          })
        end, { buffer = buffer, desc = "Organize imports" })
        vim.keymap.set("n", "<Leader>cu", function()
          vim.lsp.buf.code_action({
            apply = true,
            context = {
              ---@diagnostic disable-next-line: assign-type-mismatch
              only = { "source.removeUnused.ts" },
              diagnostics = {},
            },
          })
        end, { buffer = buffer, desc = "Remove unused imports" })
      end,
      capabilities = default_capabilities(),
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

  -- solidity
  solidity_ls_nomicfoundation = function()
    require("lspconfig").solidity_ls_nomicfoundation.setup({
      on_attach = default_on_attach,
      capabilities = default_capabilities(),
      root_dir = require("lspconfig").util.root_pattern("foundry.toml", ".git"),
    })
  end,

  -- markdown-oxide
  markdown_oxide = function()
    require("lspconfig").markdown_oxide.setup({
      on_attach = function(client, buffer)
        default_on_attach(client, buffer)

        -- code lens for ui reference counters
        if client.server_capabilities.codeLensProvider then
          vim.api.nvim_create_autocmd({ "TextChanged", "InsertLeave", "CursorHold", "BufEnter" }, {
            buffer = buffer,
            callback = function()
              vim.lsp.codelens.refresh()
            end,
          })
        end

        -- open daily notes with `Daily today`, `Daily two days ago`, `Daily next monday`
        vim.api.nvim_create_user_command("Daily", function(args)
          -- use client id to execute a command, instead of vim.lsp.buf.execute_command()
          local oxide_client = vim.lsp.get_client_by_id(client.id)
          if oxide_client then
            oxide_client.request("workspace/executeCommand", {
              command = "jump",
              arguments = { args.args },
            })
          end
        end, { desc = "Open daily notes", nargs = "*" })
      end,
      capabilities = default_capabilities({
        -- this allows creating unresolved files and resolving completions for unindexed code blocks
        workspace = {
          didChangeWatchedFiles = {
            dynamicRegistration = true,
          },
        },
      }),
    })
  end,

  -- zig
  zls = function()
    require("lspconfig").zls.setup({
      on_attach = default_on_attach,
      capabilities = default_capabilities(),
      settings = {
        zls = {
          -- neovim already provides basic syntax highlighting
          semantic_tokens = "partial",
        },
      },
    })
  end,
}

require("mason-lspconfig").setup({
  -- automatic_installation = true,
  ensure_installed = {
    "lua_ls",
    "marksman",
  },
  handlers = handlers,
})
