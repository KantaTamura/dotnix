return {
	"nvim-tree/nvim-tree.lua",
	event = "VimEnter",
	dependencies = {
		"nvim-tree/nvim-web-devicons",
	},
	config = function()
		local nvimtree = require("nvim-tree")

		-- configure nvim-tree
		nvimtree.setup({
			hijack_cursor = true,
			sort_by = "case_sensitive",
			view = {
				width = 38,
				signcolumn = "yes",
				relativenumber = false,
			},
			-- change folder arrow icons
			renderer = {
				highlight_git = true,
				highlight_modified = "name",
				highlight_opened_files = "name",
				icons = {
					glyphs = {
						git = {
							unstaged = "!",
							renamed = "»",
							untracked = "?",
							deleted = "✘",
							staged = "✓",
							unmerged = "",
							ignored = "◌",
						},
					},
				},
			},
			-- disable window_picker for
			-- explorer to work well with
			-- window splits
			actions = {
				open_file = {
					window_picker = {
						enable = false,
					},
					quit_on_open = true,
				},
			},
			filters = {
				custom = { ".DS_Store" },
			},
			git = {
				ignore = false,
			},
		})

		-- set keymaps
		vim.keymap.set("n", "<C-n>", "<cmd>NvimTreeFindFileToggle<CR>", { desc = "Toggle file explorer" }) -- toggle file explorer
		vim.keymap.set(
			"n",
			"<leader>ef",
			"<cmd>NvimTreeFindFileToggle<CR>",
			{ desc = "Toggle file explorer on current file" }
		)                                                                                                   -- toggle file explorer on current file
		vim.keymap.set("n", "<leader>ec", "<cmd>NvimTreeCollapse<CR>", { desc = "Collapse file explorer" }) -- collapse file explorer
		vim.keymap.set("n", "<leader>er", "<cmd>NvimTreeRefresh<CR>", { desc = "Refresh file explorer" })   -- refresh file explorer

		-- local api = require("nvim-tree.api")
		--
		-- local function opts(desc)
		--     return { desc = "Tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
		-- end
		--
		-- vim.keymap.set("n", "a", api.fs.create, opts("Create"), { desc = "Create New File" })
		-- vim.keymap.set("n", "r", api.fs.rename, opts("Rename"), { desc = "Rename File" })
		-- vim.keymap.set("n", "D", api.fs.remove, opts("Delete"), { desc = "Delete File" })

		-- auto close
		local function is_modified_buffer_open(buffers)
			for _, v in pairs(buffers) do
				if v.name:match("NvimTree_") == nil then
					return true
				end
			end
			return false
		end

		vim.api.nvim_create_autocmd("BufEnter", {
			nested = true,
			callback = function()
				if
					#vim.api.nvim_list_wins() == 1
					and vim.api.nvim_buf_get_name(0):match("NvimTree_") ~= nil
					and is_modified_buffer_open(vim.fn.getbufinfo({ bufmodified = 1 })) == false
				then
					vim.cmd("quit")
				end
			end,
		})

		local function open_nvim_tree_on_start(data)
			local is_dir = vim.fn.isdirectory(data.file) == 1
			local is_empty = data.file == "" and vim.bo[data.buf].buftype == ""

			if not (is_dir or is_empty) then
				return
			end

			if is_dir then
				vim.cmd.cd(data.file)
			end

			require("nvim-tree.api").tree.open({ focus = true })
		end

		vim.api.nvim_create_autocmd("VimEnter", {
			callback = open_nvim_tree_on_start,
		})
	end,
}
