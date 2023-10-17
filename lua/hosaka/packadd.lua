local packadd = function(plugin)
	vim.cmd(string.format([[%s %s]], "packadd", plugin))
	pcall(require, "hosaka.config." .. plugin)
end

local packadd_defer = function(plugin)
	vim.schedule(function()
		packadd(plugin)
	end)
end

packadd("plenary")
packadd("nvim-treesitter")
