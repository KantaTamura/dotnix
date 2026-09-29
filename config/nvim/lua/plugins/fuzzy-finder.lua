return {
	{
		"nvim-telescope/telescope.nvim",
		cmd = { "Telescope" },
		keys = {
			{ "<leader>d",  "<cmd>Telescope diagnostics<cr>",           desc = "Search diagnostics" },
			{ "<leader>ff", "<cmd>Telescope find_files<cr>",            desc = "Find files" },
			{ "<leader>gf", "<cmd>Telescope git_files<cr>",             desc = "Search Git files" },
			{ "<leader>g",  "<cmd>Telescope live_grep<cr>",             desc = "Search by grep" },
			{ "<leader>b",  "<cmd>Telescope buffers<cr>",               desc = "Find existing buffers" },
			{ "<leader>hp", "<cmd>Telescope help_tags<cr>",             desc = "Search help" },
			{ "<leader>mp", "<cmd>Telescope man_pages<cr>",             desc = "Search man pages" },
			{ "<leader>m",  "<cmd>Telescope marks<cr>",                 desc = "Search marks" },
			{ "<leader>k",  "<cmd>Telescope keymaps<cr>",               desc = "Search keymaps" },
			{ "<leader>gr", "<cmd>Telescope lsp_references<cr>",        desc = "LSP references" },
			{ "<leader>hs", "<cmd>Telescope lsp_workspace_symbols<cr>", desc = "LSP workspace symbols" },
			{ "<leader>mf", "<cmd>Telescope media_files<cr>",           desc = "Search media files" },
			{ "<leader>p",  "<cmd>Telescope project<cr>",               desc = "Search projects" },
		},
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons",
			"nvim-telescope/telescope-ui-select.nvim",
			"nvim-telescope/telescope-file-browser.nvim",
			"nvim-telescope/telescope-media-files.nvim",
			"nvim-telescope/telescope-project.nvim",
			{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
		},
		config = function()
			local telescope = require("telescope")
			local actions   = require("telescope.actions")

			-- options
			telescope.setup({
				defaults = {
					path_display = { "truncate " },
					file_ignore_patterns = {
						"^.git/",
						"^.cache/",
					},
					mappings = {
						i = {
							["<C-u>"] = false,
							["<C-d>"] = false,
							["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
						},
					},
				},
				extensions = {
					["ui-select"] = {
						require("telescope.themes").get_dropdown {
							-- even more opts
						}

						-- pseudo code / specification for writing custom displays, like the one
						-- for "codeactions"
						-- specific_opts = {
						--   [kind] = {
						--     make_indexed = function(items) -> indexed_items, width,
						--     make_displayer = function(widths) -> displayer
						--     make_display = function(displayer) -> function(e)
						--     make_ordinal = function(e) -> string
						--   },
						--   -- for example to disable the custom builtin "codeactions" display
						--      do the following
						--   codeactions = false,
						-- }
					},
					file_browser = {
						theme = "ivy",
						-- disables netrw and use telescope-file-browser in its place
						hijack_netrw = true,
						mappings = {
							["i"] = {
								-- your custom insert mode mappings
							},
							["n"] = {
								-- your custom normal mode mappings
							},
						},
					},
					media_files = {
						-- filetypes whitelist
						-- defaults to {"png", "jpg", "mp4", "webm", "pdf"}
						filetypes = { "png", "webp", "jpg", "jpeg", "pdf" },
						-- use ripgrep (rg) instead of `fd`
						find_cmd = "rg",
					},
				}
			})

			-- load extensions
			telescope.load_extension("fzf")
			telescope.load_extension("ui-select")
			telescope.load_extension("file_browser")
			telescope.load_extension("media_files")
			telescope.load_extension("project")

		end,
	},
}
