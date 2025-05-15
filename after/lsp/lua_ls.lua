return {
  on_attach = function(client, buffer)
    -- todo: don't open quickfix list in case of multiple definitions
    -- luals treats `local x = function() end` as two definitions of `x`
  end,
  capabilities = {},
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
}
