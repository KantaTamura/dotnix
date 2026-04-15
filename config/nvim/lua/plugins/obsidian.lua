return {
	{
		"obsidian-nvim/obsidian.nvim",
		version = "*",
		event = {
			"BufReadPre " .. vim.fn.expand("~") .. "/notes/*.md",
			"BufNewFile " .. vim.fn.expand("~") .. "/notes/*.md",
		},
		dependencies = {
			"nvim-lua/plenary.nvim",
			"hrsh7th/nvim-cmp",
			"nvim-telescope/telescope.nvim",
			"folke/snacks.nvim",
			"nvim-treesitter/nvim-treesitter",
			"MeanderingProgrammer/render-markdown.nvim",
		},
		opts = {
			legacy_commands = false,
			workspaces = {
				{
					name = "notes",
					path = vim.fn.expand("~") .. "/notes",
				}
			}
		}
	},
	{
		"oflisback/obsidian-bridge.nvim",
		event = {
			"BufReadPre " .. vim.fn.expand("~") .. "/notes/*.md",
			"BufNewFile " .. vim.fn.expand("~") .. "/notes/*.md",
		},
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-telescope/telescope.nvim",
		},
		config = function()
			vim.opt.conceallevel = 2

			require("obsidian-bridge").setup({
				obsidian_server_address = "https://127.0.0.1:27124",
				cert_path = vim.fn.expand("~") .. "/notes/.ssl/obsidian-rest.crt",
				scroll_sync = true,
			})

			vim.keymap.set("n", "<leader>og", "<cmd>ObsidianBridgeOpenGraph<CR>", { desc = "[O]bsidian open [G]raph" })
			vim.keymap.set("n", "<leader>oc", "<cmd>ObsidianBridgeOpenCurrentActiveFile<CR>",
				{ desc = "[O]bsidian open [C]urrent file" })
		end
	},
}
