local function switch_colorscheme()
  package.loaded["noctalia"] = nil
  local noctalia = require("noctalia")
  local style = noctalia.colors.base00 == "#1a1b26" and "dark" or "light"
  vim.opt["bg"] = style
end

require("tokyonight").setup({
  style = "moon",
  light_style = "day",
  dim_inactive = true,
})

-- reload on SIGUSR1 signal from Noctalia
vim.loop.new_signal():start("sigusr1", function()
  vim.schedule(function()
    switch_colorscheme()
  end)
end)

switch_colorscheme()
vim.cmd([[colorscheme tokyonight]])
