local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

local lazy_opts = {
	defaults = {
		lazy = true,
	},
	checker = {
		enabled = true,
		notify = true,
		frequency = 24,
	},
	performance = {
		cache = {
			enabled = true,
		},
	},
	change_detection = {
		notify = false,
	},
}

require("lazy").setup("plugins", lazy_opts)
