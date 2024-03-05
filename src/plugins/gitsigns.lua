local gs = require("gitsigns")
gs.setup({
  signs = {
    add = { text = "+" },
    change = { text = "~" },
    delete = { text = "_" },
    topdelete = { text = "?" },
    changedelete = { text = "~" },
  },
  preview_config = { border = "rounded" },
  diff_opts = {
    linematch = 60,
  },
  on_attach = function(buffer)
    local map = function(mode, lhs, rhs, desc)
      local opts = {}
      opts.desc = desc
      opts.buffer = buffer
      vim.keymap.set(mode, lhs, rhs, opts)
    end

    local mapl = function(mode, suffix, rhs, desc)
      map(mode, "<Leader>" .. suffix, rhs, desc)
    end

    vim.keymap.set("n", "]h", function()
      if vim.wo.diff then
        return "]h"
      end
      vim.schedule(function()
        gs.next_hunk()
      end)
      return "<Ignore>"
    end, { expr = true, desc = "Hunk forward" })

    vim.keymap.set("n", "[h", function()
      if vim.wo.diff then
        return "[h"
      end
      vim.schedule(function()
        gs.prev_hunk()
      end)
      return "<Ignore>"
    end, { expr = true, desc = "Hunk backward" })

    -- hunk text object
    vim.keymap.set({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<cr>")

    mapl("n", "ga", [[<cmd>lua require("gitsigns").stage_hunk()<cr>]], "Add hunk")
    mapl(
      "v",
      "ga",
      [[<cmd>lua require("gitsigns").stage_hunk({vim.fn.line("."), vim.fn.line("v")})<cr>]],
      "Add hunk selection"
    )
    mapl("n", "gA", [[<cmd>lua require("gitsigns").stage_buffer()<cr>]], "Add buffer")
    mapl("n", "gb", [[<cmd>lua require("gitsigns").blame_line()<cr>]], "Blame line")
    mapl("n", "gp", [[<cmd>lua require("gitsigns").preview_hunk()<cr>]], "Preview hunk")
    mapl("n", "gP", [[<cmd>lua require("gitsigns").preview_hunk_inline()<cr>]], "Preview hunk inline")
    mapl("n", "gr", [[<cmd>lua require("gitsigns").reset_hunk()<cr>]], "Reset hunk")
    mapl(
      "v",
      "gr",
      [[<cmd>lua require("gitsigns").reset_hunk({vim.fn.line("."), vim.fn.line("v")})<cr>]],
      "Reset hunk selection"
    )
    mapl("n", "gR", [[<cmd>lua require("gitsigns").reset_buffer()<cr>]], "Reset buffer")
    mapl("n", "gu", [[<cmd>lua require("gitsigns").undo_stage_hunk()<cr>]], "Undo add hunk")
    mapl("n", "gq", [[<cmd>lua require("gitsigns").setqflist()<cr>:open<cr>]], "Quickfix hunks")
    mapl("n", "gs", [[<cmd>lua require("gitsigns").toggle_deleted()<cr>]], "Show deleted hunks")
  end,
})
