local options = {
	-- line
	number         = true,
	relativenumber = true,
	signcolumn     = "yes",

	-- backup/undo
	backup         = false,
	swapfile       = false,
	undofile       = true,
	undodir        = vim.fn.stdpath("state") .. "/undo",

	-- search
	incsearch      = true,
	hlsearch       = true,
	ignorecase     = true,
	smartcase      = true,
	inccommand     = "nosplit",

	-- clipboard
	clipboard      = "unnamedplus",

	-- mouse
	mouse          = "a",

	-- color
	termguicolors  = true,

	-- performance
	updatetime     = 250,
	timeout        = true,
	timeoutlen     = 300,
	redrawtime     = 1500,

	-- indent/tab
	autoindent     = true,
	breakindent    = true,
	expandtab      = false,
	tabstop        = 4,
	shiftwidth     = 4,

	-- vim doc
	helplang       = { "ja", "en" },

	-- file
	autoread       = true,
	hidden         = true,

	-- statusline
	laststatus     = 2,

	-- completion
	completeopt    = { "menuone", "noinsert", "noselect" },

	-- split
	splitright     = true,

	-- UI
	cursorline     = true,
	scrolloff      = 8,
	sidescrolloff  = 8,
	wrap           = false,
	list           = true,
	listchars      = {
		tab      = "  ",
		trail    = "•",
		extends  = "",
		precedes = "",
		eol      = " ",
		nbsp     = "␣",
	},
}

for key, value in pairs(options) do
	vim.opt[key] = value
end

pcall(function() vim.opt.shortmess:append("c") end)

local undodir = vim.opt.undodir:get()[1]
if vim.fn.isdirectory(undodir) == 0 then
	vim.fn.mkdir(undodir, "p")
end
