return {
  on_attach = function(client, buffer)
    -- prevents nvim-lspconfig defaults
  end,
  settings = {
    pyright = {
      -- disable organize imports in favour of ruff
      disableOrganizeImports = true,
    },
    python = {
      analysis = {
        -- todo: this not working, both ruff and pyright display diagnostics
        -- ignore all files for analysis to exclusively use ruff for linting
        ignore = { "*" },
      },
    },
  },
}
