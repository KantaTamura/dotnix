-- general config
vim.opt.guifont = "PlemolJP Console:h14"

-- keybindings
vim.keymap.set("v", "<sc-c>", '"+y', { desc = "Copy selection to system clipboard" })
vim.keymap.set("i", "<sc-v>", '<Esc>"+p', { desc = "Paste from system clipboard" })
vim.keymap.set("n", "<sc-v>", '"+p', { desc = "Paste from system clipboard" })

-- terminal color
vim.g.terminal_color_0 = "#45475a"
vim.g.terminal_color_1 = "#f38ba8"
vim.g.terminal_color_2 = "#a6e3a1"
vim.g.terminal_color_3 = "#f9e2af"
vim.g.terminal_color_4 = "#89b4fa"
vim.g.terminal_color_5 = "#f5c2e7"
vim.g.terminal_color_6 = "#94e2d5"
vim.g.terminal_color_7 = "#bac2de"
vim.g.terminal_color_8 = "#585b70"
vim.g.terminal_color_9 = "#f38ba8"
vim.g.terminal_color_10 = "#a6e3a1"
vim.g.terminal_color_11 = "#f9e2af"
vim.g.terminal_color_12 = "#89b4fa"
vim.g.terminal_color_13 = "#f5c2e7"
vim.g.terminal_color_14 = "#94e2d5"
vim.g.terminal_color_15 = "#a6adc8"
