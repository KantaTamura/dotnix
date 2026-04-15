-- configure alpha-nvim
local ascii = {
	arch = {
		[[      /\      ]],
		[[     /  \     ]],
		[[    /\   \    ]],
		[[   / > ω <\   ]],
		[[  /   __   \  ]],
		[[ / __|  |__-\ ]],
		[[/_-''    ''-_\]],
	},
	artix = {
		[[      /\      ]],
		[[     /  \     ]],
		[[    /`'.,\    ]],
		[[   /> ω < \   ]],
		[[  /      ,`\  ]],
		[[ /   ,.'`.  \ ]],
		[[/.,'`     `'.\]],
	},
}

local function button(sc, txt, keybind)
	local sc_ = sc:gsub("%s", ""):gsub("SPC", "<leader>")
	local opts = {
		position = "center",
		text = txt,
		shortcut = sc,
		cursor = 6,
		width = 19,
		align_shortcut = "right",
		hl_shortcut = "Number",
		hl = "Function",
	}
	if keybind then
		opts.keymap = { "n", sc_, keybind, { noremap = true, silent = true } }
	end
	return {
		type = "button",
		val = txt,
		on_press = function()
			local key = vim.api.nvim_replace_termcodes(sc_, true, false, true)
			vim.api.nvim_feedkeys(key, "normal", false)
		end,
		opts = opts,
	}
end

return {
	-- ┌──────────────────────────────────────────────────┐
	-- │  start menu                                      │
	-- └──────────────────────────────────────────────────┘
	{
		"goolord/alpha-nvim",
		event = "VimEnter",
		cond = true,
		dependencies = {
			"nvim-tree/nvim-web-devicons",
		},
		config = function()
			local status, alpha = pcall(require, "alpha")
			if not status then
				return
			end
			local header = {
				type = "text",
				val = ascii.artix,
				opts = {
					position = "center",
					hl = "Comment",
				},
			}
			local buttons = {
				type = "group",
				val = {
					button("f", "󰱼  Search", ":Telescope find_files<CR>"),
					button("e", "  New", ":ene<CR>"),
					button("p", "  Project", ":Telescope project<CR>"),
					button("c", "  Config", ":e $HOME/.config/nvim/init.lua | :cd %:p:h | :silent !pwd<CR>"),
					button("n", "  Notes", ":e $HOME/notes/home.md | :cd %:p:h | :silent !pwd<CR>"),
					button("q", "  Quit", ":qa<CR>"),
				},
				opts = {
					position = "center",
					spaceing = 1,
				},
			}
			local message = {
				type = "text",
				val = "Hello, Neovim!",
				opts = {
					position = "center",
					hl = "String",
				},
			}
			local section = {
				header = header,
				buttons = buttons,
				message = message,
				footer = {
					type = "text",
					val = {},
					opts = {
						position = "center",
						hl = "Comment",
					},
				},
			}
			local opts = {
				layout = {
					{ type = "padding", val = function() return math.floor(vim.o.lines * 0.25) end },
					section.header,
					{ type = "padding", val = 1 },
					section.message,
					{ type = "padding", val = 2 },
					section.buttons,
					{ type = "padding", val = 1 },
					section.footer,
				},
				opts = {},
			}
			-- alpha.setup(require "alpha.themes.dashboard".config)
			alpha.setup(opts)

			vim.api.nvim_create_autocmd("User", {
				pattern = "LazyVimStarted",
				callback = function()
					local stats = require("lazy").stats()
					-- local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
					local ms = stats.startuptime
					local version = " v" ..
						vim.version().major .. "." .. vim.version().minor .. "." .. vim.version().patch
					local plugins = "⚡plugins " .. stats.loaded .. "/" .. stats.count .. " in " .. ms .. "ms"
					local footer = version .. "\t" .. plugins .. "\n"
					section.footer.val = footer
					pcall(vim.cmd.AlphaRedraw)
				end,
			})
			vim.api.nvim_create_autocmd('User', {
				pattern = 'AlphaReady',
				desc = 'disable status, tabline and cmdline for alpha',
				callback = function()
					vim.go.laststatus = 0
					vim.opt.showtabline = 0
					vim.opt.cmdheight = 0
				end,
			})
			vim.api.nvim_create_autocmd('BufUnload', {
				buffer = 0,
				desc = 'enable status, tabline and cmdline after alpha',
				callback = function()
					vim.go.laststatus = 2
					vim.opt.showtabline = 2
					vim.opt.cmdheight = 1
				end,
			})
		end
	},
	-- ┌──────────────────────────────────────────────────┐
	-- │  tab, buffer line                                │
	-- └──────────────────────────────────────────────────┘
	{
		"akinsho/bufferline.nvim",
		dependencies = {
			"nvim-tree/nvim-web-devicons",
			"catppuccin/nvim",
		},
		event = { "BufReadPre", "BufNewFile" },
		cond = true,
		config = function()
			vim.keymap.set("n", "<Tab>", "<Cmd>BufferLineCycleNext<CR>", {})
			vim.keymap.set("n", "<S-Tab>", "<Cmd>BufferLineCyclePrev<CR>", {})
			vim.keymap.set("n", "<leader>cr", "<Cmd>BufferLineCloseRight<CR>", {})
			vim.keymap.set("n", "<leader>cl", "<Cmd>BufferLineCloseLeft<CR>", {})
			local bufferline = require("bufferline")
			require("bufferline").setup {
				highlights = require("catppuccin.special.bufferline").get_theme(),
				options = {
					-- mode = "tabs",
					style_preset = bufferline.style_preset.minimal,
					always_show_bufferline = false,
					show_buffer_close_icons = false,
					show_close_icon = false,
					color_icons = true,
					diagnostics = "nvim_lsp",
				},
			}
		end,
	},
	-- ┌──────────────────────────────────────────────────┐
	-- │  status line                                     │
	-- └──────────────────────────────────────────────────┘
	{
		"nvim-lualine/lualine.nvim",
		dependencies = {
			"catppuccin/nvim",
		},
		event = "VimEnter",
		cond = true,
		config = function()
			local lualine = require("lualine")
			local colors = require("catppuccin.palettes").get_palette("mocha")

			local conditions = {
				buffer_not_empty = function()
					return vim.fn.empty(vim.fn.expand("%:t")) ~= 1
				end,
				hide_in_width = function()
					return vim.fn.winwidth(0) > 80
				end,
				check_git_workspace = function()
					local filepath = vim.fn.expand("%:p:h")
					local gitdir = vim.fn.finddir(".git", filepath .. ";")
					return gitdir and #gitdir > 0 and #gitdir < #filepath
				end,
			}

			-- Config
			local config = {
				options = {
					-- Disable sections and component separators
					component_separators = "",
					section_separators = "",
					theme = "catppuccin",
					disabled_filetypes = { "NVimTree" },
				},
				sections = {
					-- these are to remove the defaults
					lualine_a = {},
					lualine_b = {},
					lualine_y = {},
					lualine_z = {},
					-- These will be filled later
					lualine_c = {},
					lualine_x = {},
				},
				inactive_sections = {
					-- these are to remove the defaults
					lualine_a = {},
					lualine_b = {},
					lualine_y = {},
					lualine_z = {},
					lualine_c = {},
					lualine_x = {},
				},
			}

			-- Inserts a component in lualine_c at left section
			local function ins_left(component)
				table.insert(config.sections.lualine_c, component)
			end

			-- Inserts a component in lualine_x at right section
			local function ins_right(component)
				table.insert(config.sections.lualine_x, component)
			end

			ins_left {
				function()
					return "▊"
				end,
				color = { fg = colors.blue }, -- Sets highlighting of component
				padding = { left = 0, right = 1 }, -- We don"t need space before this
			}

			ins_left {
				-- mode component
				function()
					return "(^-^)/"
				end,
				color = function()
					-- auto change color according to neovims mode
					local mode_color = {
						n = colors.red,
						i = colors.green,
						v = colors.blue,
						[""] = colors.blue,
						V = colors.blue,
						c = colors.magenta,
						no = colors.red,
						s = colors.orange,
						S = colors.orange,
						[""] = colors.orange,
						ic = colors.yellow,
						R = colors.violet,
						Rv = colors.violet,
						cv = colors.red,
						ce = colors.red,
						r = colors.cyan,
						rm = colors.cyan,
						["r?"] = colors.cyan,
						["!"] = colors.red,
						t = colors.red,
					}
					return { fg = mode_color[vim.fn.mode()] }
				end,
				padding = { right = 1 },
			}

			ins_left {
				"filename",
				file_status = true, -- displays file status (readonly status, modified status)
				path = 1, -- 0 = just filename, 1 = relative path, 2 = absolute path
				color = { gui = "bold" },
			}

			ins_left {
				"branch",
				icon = "",
				color = { fg = colors.violet },
			}

			ins_left {
				"diff",
				-- Is it me or the symbol for modified us really weird
				diff_color = {
					added = { fg = colors.green },
					modified = { fg = colors.orange },
					removed = { fg = colors.red },
				},
				-- symbols = { added = " ", modified = "󰝤 ", removed = " " },
				-- cond = conditions.hide_in_width,
				symbols = { added = "+", modified = "~", removed = "-" }, -- Changes the symbols used by the diff.
			}

			-- Insert mid section. You can make any number of sections in neovim :)
			-- for lualine it"s any number greater then 2
			ins_left {
				function()
					return "%="
				end,
			}

			ins_right {
				"diagnostics",
				sources = { "nvim_diagnostic" },
				symbols = {
					error = " ",
					-- error = " ",
					warn = " ",
					-- info = " ",
					info = " ",
					hint = " "
				},
				diagnostics_color = {
					color_error = { fg = colors.red },
					color_warn = { fg = colors.yellow },
					color_info = { fg = colors.cyan },
				},
			}

			-- Add components to right sections
			ins_right {
				"searchcount",
			}

			ins_right {
				"filetype",
			}

			ins_right {
				"location",
			}

			ins_right {
				-- filesize component
				"filesize",
				cond = conditions.buffer_not_empty,
			}

			ins_right {
				"o:encoding", -- option component same as &encoding in viml
				fmt = string.upper, -- I"m not sure why it"s upper case either ;)
				cond = conditions.hide_in_width,
				color = { fg = colors.green, gui = "bold" },
			}

			ins_right {
				"fileformat",
				fmt = string.upper,
				icons_enabled = false, -- I think icons are cool but Eviline doesn"t have them. sigh
				color = { fg = colors.green, gui = "bold" },
			}

			ins_right {
				function()
					return "▊"
				end,
				color = { fg = colors.blue },
				padding = { left = 1 },
			}

			-- Now don"t forget to initialize lualine
			lualine.setup(config)
		end
	},
	-- ┌──────────────────────────────────────────────────┐
	-- │  color scheme                                    │
	-- └──────────────────────────────────────────────────┘
	{
		"cocopon/iceberg.vim",
		event = "VimEnter",
		cond = false,
		config = function()
			vim.cmd.colorscheme("iceberg")
		end,
	},
	{
		url = "https://codeberg.org/miyakogi/iceberg-tokyo.nvim",
		event = "VimEnter",
		cond = false,
		config = function()
			vim.cmd.colorscheme("iceberg-tokyo")
		end,
	},
	{
		"folke/tokyonight.nvim",
		event = "VimEnter",
		cond = false,
		config = function()
			require("tokyonight").setup({
				style = "night",
			})
			vim.cmd.colorscheme("tokyonight")
		end,
	},
	{
		"catppuccin/nvim",
		event = "VimEnter",
		cond = true,
		config = function()
			require("catppuccin").setup({
				flavour = "mocha",
				integrations = {
					alpha = true,
				}
			})
			vim.cmd.colorscheme("catppuccin")
		end,
	},
}
