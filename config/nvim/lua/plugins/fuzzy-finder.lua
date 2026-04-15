return {
	{
		"nvim-telescope/telescope.nvim",
		cmd = { "Telescope" },
		event = { "BufReadPre", "BufNewFile" },
		-- keys = {
		-- 	{ "<leader>m", "<cmd>Telescope marks<cr>",     desc = "search by [M]arks" },
		-- 	{ "<leader>g", "<cmd>Telescope live_grep<cr>", desc = "search by [G]rep" },
		-- },
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

			-- keymaps
			--   See `:help telescope.builtin`
			-- file pickers
			vim.keymap.set("n", "<leader>d", require("telescope.builtin").find_files, { desc = "search [F]iles" })
			vim.keymap.set("n", "<leader>gf", require("telescope.builtin").git_files, { desc = "Search [G]it [F]iles" })
			vim.keymap.set("n", "<leader>g", require("telescope.builtin").live_grep, { desc = "search by [G]rep" })
			-- vim pickers
			vim.keymap.set("n", "<leader>b", require("telescope.builtin").buffers, { desc = "Find existing [B]uffers" })
			vim.keymap.set("n", "<leader>hp", require("telescope.builtin").help_tags, { desc = "search [H]elp" })
			vim.keymap.set("n", "<leader>mp", require("telescope.builtin").man_pages, { desc = "search [M]an [P]ages" })
			vim.keymap.set("n", "<leader>m", require("telescope.builtin").marks, { desc = "search by [M]arks" })
			vim.keymap.set("n", "<leader>k", require("telescope.builtin").keymaps, { desc = "search [K]eymaps" })
			-- lsp picker
			vim.keymap.set("n", "<leader>d", require("telescope.builtin").diagnostics,
				{ desc = "[S]earch [D]iagnostics" })
			vim.keymap.set("n", "<leader>gr", require("telescope.builtin").lsp_references,
				{ desc = "LSP references" })
			vim.keymap.set("n", "<leader>hs", require("telescope.builtin").lsp_workspace_symbols,
				{ desc = "LSP workspace symbols" })
			-- extensions
			-- vim.keymap.set("n", "<leader>f", require("telescope").extensions.file_browser.file_browser,
			-- 	{ desc = "file [F]inder" })
			vim.keymap.set("n", "<leader>mf", require("telescope").extensions.media_files.media_files,
				{ desc = "search [M]edia [F]iles" })
			vim.keymap.set("n", "<leader>p", require("telescope").extensions.project.project,
				{ desc = "search [P]roject" })
		end,
	},
}
