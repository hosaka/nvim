-- global config table
_G.Config = {}

-- install 'mini.nvim'
vim.pack.add({ "https://github.com/nvim-mini/mini.nvim" })

-- loading helpers
local misc = require("mini.misc")
-- stylua: ignore start
Config.now = function(f) misc.safely("now", f) end
Config.later = function(f) misc.safely("later", f) end
Config.now_if_args = vim.fn.argc(-1) > 0 and Config.now or Config.later
Config.on_event = function(ev, f) misc.safely("event:" .. ev, f) end
Config.on_filetype = function(ft, f) misc.safely("filetype:" .. ft, f) end
-- stylua: ignore end
