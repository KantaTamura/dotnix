-- set <space> as the leader key
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Modes
--   normal_mode = "n",
--   insert_mode = "i",
--   visual_mode = "v",
--   visual_block_mode = "x",
--   term_mode = "t",
--   command_mode = "c",

-- quick quit and write nvim
vim.keymap.set({ "n" }, "<leader>qq", "<cmd>q<CR>", { desc = "Quit the current file" })
vim.keymap.set({ "n" }, "<leader>w", "<cmd>w<CR>", { desc = "Save the current file" })

-- buffer indenting
vim.keymap.set({ "v" }, "<", "<gv", { desc = "Indent left" })
vim.keymap.set({ "v" }, ">", ">gv", { desc = "Indent right" })

-- move windows
vim.keymap.set({ "n" }, "<C-h>", "<C-w>h", { desc = "Go to left window", remap = true })
vim.keymap.set({ "n" }, "<C-j>", "<C-w>j", { desc = "Go to lower window", remap = true })
vim.keymap.set({ "n" }, "<C-k>", "<C-w>k", { desc = "Go to upper window", remap = true })
vim.keymap.set({ "n" }, "<C-l>", "<C-w>l", { desc = "Go to right window", remap = true })

-- resize windows
vim.keymap.set({ "n" }, "<C-Up>", "<cmd>resize +2<CR>", { desc = "Increase window height" })
vim.keymap.set({ "n" }, "<C-Down>", "<cmd>resize -2<CR>", { desc = "Decrease window height" })
vim.keymap.set({ "n" }, "<C-Left>", "<cmd>vertical resize +2<CR>", { desc = "Increase window width" })
vim.keymap.set({ "n" }, "<C-Right>", "<cmd>vertical resize -2<CR>", { desc = "Decrease window width" })

-- smart search
-- ref. https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
vim.keymap.set({ "n", "x", "o" }, "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next search result" })
vim.keymap.set({ "n", "x", "o" }, "N", "'nN'[v:searchforward]", { expr = true, desc = "Previous search result" })

-- -- open lazy
-- vim.keymap.set({ "n" }, "<leader>l", function()
-- 	return require("lazy").home()
-- end, { desc = "Open lazy" })

-- format
vim.keymap.set({ "n" }, "<leader>f", "<cmd>lua vim.lsp.buf.format { async = false }<CR>",
	{ noremap = true, silent = true })
