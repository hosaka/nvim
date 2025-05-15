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
      vim.keymap.set("n", "<Leader>rR", [[<cmd>RustLsp runnables<cr>]], { buffer = buffer, desc = "Runnables (rust)" })
      vim.keymap.set(
        "n",
        "<Leader>ce",
        [[<cmd>RustLsp explainError<cr>]],
        { buffer = buffer, desc = "Explain error (rust)" }
      )
      vim.keymap.set("n", "<Leader>ec", [[<cmd>RustLsp openCargo<cr>]], { buffer = buffer, desc = "Cargo.toml (rust)" })
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
