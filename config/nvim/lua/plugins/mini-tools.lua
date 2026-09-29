return {
	{
		"echasnovski/mini.ai",
		version = "*",
		event = "VeryLazy",
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
		"echasnovski/mini.comment",
		version = "*",
		event = "VeryLazy",
		-- config = function()
		--     require("mini.comment").setup(
		--         {

		--         }
		--     )
		-- end
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
