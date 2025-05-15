return {
  on_attach = function(client, buffer)
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
}
