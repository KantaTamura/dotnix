return {
	{
		"echasnovski/mini.ai",
		version = "*",
		event = { "BufReadPre", "BufNewFile" },
	},
	{
		"echasnovski/mini.indentscope",
		version = "*",
		event = { "BufReadPre", "BufNewFile" },
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
		event = { "BufReadPre", "BufNewFile" },
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
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			require('mini.pairs').setup()
		end
	}
}
