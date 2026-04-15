return {
	--
	-- ref. https://github.com/vim-jp/vimdoc-ja
	{
		"vim-jp/vimdoc-ja",
		lazy = true,
		keys = {
			{ "h", mode = "c", desc = "open [H]elp" },
		},
	},
	--
	-- ref. https://github.com/folke/which-key.nvim
	{
		"folke/which-key.nvim",
		lazy = true,
		cmd = {
			"WhichKey",
		},
		opts = {},
	},
	--
	-- ref. https://github.com/simeji/winresizer
	{
		"simeji/winresizer",
		event = { "BufReadPre", "BufNewFile" },
	},
	--
	-- ref. https://github.com/folke/trouble.nvim
	{
		"folke/trouble.nvim",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = { "nvim-tree/nvim-web-devicons" },
		opts = {
			-- your configuration comes here
			-- or leave it empty to use the default settings
			-- refer to the configuration section below
		},
	},
	--
	-- ref. https://github.com/folke/todo-comments.nvim
	{
		"folke/todo-comments.nvim",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = {
			-- your configuration comes here
			-- or leave it empty to use the default settings
			-- refer to the configuration section below
		}
	},
	--
	-- ref. https://github.com/github/copilot.vim
	-- ref. https://github.com/zbirenbaum/copilot.lua
	{
		"zbirenbaum/copilot.lua",
		event = "InsertEnter",
		cond = function()
			return not vim.g.vscode
		end,
		config = function()
			require("copilot").setup({
				suggestion = { enabled = false },
				panel = { enabled = false },
			})
		end,
		-- filetypes = {
		--     markdown = true,
		--     help = true,
		-- },
	},
	{
		"zbirenbaum/copilot-cmp",
		event = { "InsertEnter", "LspAttach" },
		dependencies = {
			"zbirenbaum/copilot.lua",
		},
		config = function()
			require("copilot_cmp").setup()
		end,
	},
	{
		"CopilotC-Nvim/CopilotChat.nvim",
		branch = "canary",
		cmd = { "CopilotChatOpen" },
		dependencies = {
			{ "zbirenbaum/copilot.lua" }, -- or github/copilot.vim
			{ "nvim-lua/plenary.nvim" }, -- for curl, log wrapper
		},
		build = "make tiktoken", -- Only on MacOS or Linux
		opts = {
			debug = true,        -- Enable debugging
			-- See Configuration section for rest
		},
		-- See Commands section for default commands if you want to lazy load on them
	},
	-- {
	-- 	"yetone/avante.nvim",
	-- 	event = { "InsertEnter", "LspAttach" },
	-- 	dependencies = {
	-- 		"stevearc/dressing.nvim",
	-- 		"nvim-lua/plenary.nvim",
	-- 		"MunifTanjim/nui.nvim",
	-- 		"hrsh7th/nvim-cmp",
	-- 		"nvim-tree/nvim-web-devicons",
	-- 		"zbirenbaum/copilot.lua",
	-- 	},
	-- 	opts = {
	-- 		provider = "copilot",
	-- 		auto_suggestions_provider = "copilot",
	--
	-- 		behaviour = {
	-- 			auto_suggestions = false,
	-- 			auto_set_highlight_group = true,
	-- 			auto_set_keymaps = true,
	-- 			auto_apply_diff_after_generation = false,
	-- 			support_paste_from_clipboard = false,
	-- 			minimize_diff = true,
	-- 		},
	--
	-- 		windows = {
	-- 			position = "right",
	-- 			wrap = true,
	-- 			width = 30,
	-- 		},
	-- 	},
	-- },
	--
	{
		"ravitemer/mcphub.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		cmd = "MCPHub",
		build = "bundled_build.lua", -- Use this and set use_bundled_binary = true in opts  (see Advanced configuration)
		config = function()
			require("mcphub").setup({
				use_bundled_binary = true,
			})
		end,
	},
	-- ref. https://github.com/nvim-pack/nvim-spectre
	{
		'nvim-pack/nvim-spectre',
		dependencies = {
			'nvim-lua/plenary.nvim'
		},
		cmd = "Spectre",
	},
	--
	-- ref. https://github.com/akinsho/toggleterm.nvim
	{
		'akinsho/toggleterm.nvim',
		event = { "BufReadPre", "BufNewFile" },
		opts = {
			insert_mappings = false,
			direction = "float",
			autochdir = true,
		},
		config = function(_, opts)
			require("toggleterm").setup(opts)
			-- keymaps
			vim.keymap.set("n", "<C-;>", "<cmd>ToggleTerm<CR>", { desc = "Toggle terminal" })
			vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })
		end,
	},
	{
		"rcarriga/nvim-notify",
		event = { "VeryLazy" },
		dependencies = { "nvim-lua/plenary.nvim" },
	},
	{
		"folke/noice.nvim",
		event = { "VeryLazy" },
		dependencies = {
			-- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
			"MunifTanjim/nui.nvim",
			-- OPTIONAL:
			--   `nvim-notify` is only needed, if you want to use the notification view.
			--   If not available, we use `mini` as the fallback
			"rcarriga/nvim-notify",
		},
		config = function()
			require("noice").setup({
				lsp = {
					-- override markdown rendering so that **cmp** and other plugins use **Treesitter**
					override = {
						["vim.lsp.util.convert_input_to_markdown_lines"] = true,
						["vim.lsp.util.stylize_markdown"] = true,
						["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
					},
					signature = {
						enabled = false,
					},
					hover = {
						enabled = false,
					},
				},
				-- you can enable a preset for easier configuration
				presets = {
					bottom_search = true, -- use a classic bottom cmdline for search
					command_palette = true, -- position the cmdline and popupmenu together
					long_message_to_split = true, -- long messages will be sent to a split
					inc_rename = false, -- enables an input dialog for inc-rename.nvim
					lsp_doc_border = false, -- add a border to hover docs and signature help
				},
			})
		end,
	},
	{
		"MeanderingProgrammer/render-markdown.nvim",
		dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.nvim' },
		ft = { "markdown" }
	},
	{
		"wintermute-cell/gitignore.nvim",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		keys = {
			{ "<leader>gi", "<cmd>Gitignore<CR>", desc = "Generate .gitignore" },
		},
		config = function()
			require("gitignore")
		end,
	},
	{
		"lambdalisue/vim-suda",
		event = { "BufReadPre", "BufNewFile" },
	},
	{
		'beeender/richclip.nvim',
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			require("richclip").setup({
				set_g_clipboard = false,
			})
			vim.keymap.set({ 'v' }, '<Leader>rc', ":'<,'>RichClip copy<CR>", { desc = 'RichClip copy (HTML)' })
		end,
	},
	{
		"ellisonleao/dotenv.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			require("dotenv").setup({
				enable_on_load = true,
			})
		end,
	},
}
