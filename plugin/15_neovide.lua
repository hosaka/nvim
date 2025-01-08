if vim.g.neovide == nil then
  return
end

-- fonts are configured in ~/.config/neovide/config.toml
vim.opt.winblend = 30
vim.opt.pumblend = 30

-- note: add a picker for these
vim.g.neovide_cursor_vfx_mode = "pixiedust"
vim.g.neovide_hide_mouse_when_typing = true

vim.g.neovide_scale_factor = 1.0
local change_scale_factor = function(delta)
  vim.g.neovide_scale_factor = vim.g.neovide_scale_factor * delta
end

vim.keymap.set("n", "<C-=>", function()
  change_scale_factor(1.25)
end)

vim.keymap.set("n", "<C-->", function()
  change_scale_factor(1 / 1.25)
end)

-- read mise env and append it to vim.ENV
-- can be done automatically or using Mise command
require("hosaka.mise").setup({
  autoload = true,
})
