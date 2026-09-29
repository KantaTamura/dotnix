return {
	{
		"nvim-mini/mini.ai",
		version = "*",
		event = "VeryLazy",
		opts = {},
	},
	{
		"echasnovski/mini.indentscope",
		version = "*",
		event = { "BufReadPost", "BufNewFile" },
		keys = {
			{ "<leader>is", "<cmd>IndentScope<cr>", desc = "show [I]ndent [S]cope" },
		},
		opts = {
			symbol = "│", -- or "|", "¦", "┆", "┊", ""
		},
	},
	{
		"echasnovski/mini.pairs",
		version = "*",
		event = "InsertEnter",
		config = function()
			require('mini.pairs').setup()
		end
	}
}
