return {
  on_attach = function(client, buffer)
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
}
