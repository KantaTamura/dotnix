return {
	{
		"tpope/vim-fugitive",
		event = { "BufReadPre", "BufNewFile" },
		keys = {
			{ "git", mode = "c", "<cmd>Git<cr>", desc = "OpenGit" },
		},
		dependencies = { "tpope/vim-rhubarb" },
	},
	{
		"sindrets/diffview.nvim",
		cmd = { "DiffviewOpen" },
		opts = {
			default_args = {
				DiffviewOpen = { "--imply-local" },
			}
		},
	},
	{
		"lewis6991/gitsigns.nvim",
		event = { "BufReadPre", "BufNewFile" },
		opts = {
			-- See `:help gitsigns.txt`
			signs = {
				add          = { text = "┆" },
				change       = { text = "┆" },
				delete       = { text = "" },
				topdelete    = { text = "" },
				changedelete = { text = "~" },
				untracked    = { text = "┆" },
			},
		},
	},
	{
		"kdheepak/lazygit.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		event = { "BufReadPre", "BufNewFile" },
		cmd = { "LazyGit" },
		keys = {
			{ "<leader>l", mode = "n", "<cmd>LazyGit<CR>", desc = "open [L]azygit" },
		}
	},
}
