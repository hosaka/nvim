require("gitsigns").setup({
  on_attach = function(buffer)
    local gs = require("gitsigns")
    local function map(mode, l, r, opts)
      opts = opts or {}
      opts.buffer = buffer
      vim.keymap.set(mode, l, r, opts)
    end
    map("n", "]h", function()
      vim.schedule(function()
        gs.next_hunk()
      end)
    end, { expr = true, desc = "Next hunk" })
    map("n", "[h", function()
      vim.schedule(function()
        gs.prev_hunk()
      end)
    end, { expr = true, desc = "Prev hunk" })
  end,
})
