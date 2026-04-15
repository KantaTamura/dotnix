return {
	{
		"neovim/nvim-lspconfig",
		cmd = "LspInfo",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			{ "nvim-lua/plenary.nvim" },
			{ "hrsh7th/cmp-nvim-lsp" },
			{
				"williamboman/mason.nvim",
				opts = {},
			},
			{
				"williamboman/mason-lspconfig.nvim",
				opts = {
					automatic_installation = true,
					automatic_enable = false,
					ensure_installed = {
						"gopls",
						"marksman",
						"lua_ls",
						"rust_analyzer",
						"zls",
						"graphql",
						"ruff",
						"clangd",
						"texlab",
						"nil_ls",
						"biome",
						"gh_actions_ls",
					},
				},
			},
			-- for linters and formatters
			{
				"nvimtools/none-ls.nvim",
				config = function()
					local null_ls = require("null-ls")
					null_ls.setup({
						sources = {
							null_ls.builtins.formatting.clang_format,
						}
					})
				end,
			},
			{
				"jay-babu/mason-null-ls.nvim",
				opts = {
					automatic_installation = true,
					ensure_installed = {
						"stylua",
						"gofumpt",
						"golangci_lint",
						"clang-format",
						"prettier",
						"markdownlint-cli2",
						"textlint",
						"cspell",
						"kdlfmt",
					},
					handlers = {},
				},
			},
		},
		config = function()
			local capabilities = require("cmp_nvim_lsp").default_capabilities()

			local on_attach = function(_, bufnr)
				local map = function(mode, lhs, rhs)
					vim.keymap.set(mode, lhs, rhs, { buffer = bufnr })
				end

				map("n", "<leader>f", function() vim.lsp.buf.format { async = true } end,
					"LSP: [F]ormat buffer")

				-- map("n", "K", vim.lsp.buf.hover)
				-- map("n", "gd", vim.lsp.buf.definition)
				map("n", "<leader>r", vim.lsp.buf.rename)
				-- map("n", "ga", vim.lsp.buf.code_action)
			end

			local servers = {
				gopls = {
					settings = {},
					on_attach = function(client, bufnr)
						on_attach(client, bufnr)
						vim.api.nvim_create_autocmd("BufWritePre", {
							pattern = "*.go",
							callback = function()
								vim.lsp.buf.code_action({ context = { only = { "source.organizeImports" } }, apply = true })
							end
						})
					end,
				},
				rust_analyzer = {
					on_attach = function(client, bufnr)
						on_attach(client, bufnr)
						vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
					end,
					settings = {
						["rust_analyzer"] = {
							imports = {
								granularity = { group = "module" },
								prefix = "self",
							},
							cargo = { buildScripts = { enable = true } },
							procMacro = { enable = true },
							checkOnSave = {
								command = "clippy",
								extraArgs = { "--all", "--", "-W", "clippy::all" },
							},
							files = {
								excludeDirs = { "target", ".git" },
							},
						},
					}
				},
				lua_ls = {},
				marksman = {},
				zls = {},
				graphql = {},
				ruff = {},
				clangd = {
					cmd = { "clangd", "--background-index", "--clang-tidy", "--completion-style=detailed", "--header-insertion=iwyu" },
					init_options = {
						fallbackFlags = { "-std=c++20" },
					},
				},
				texlab = {},
				nil_ls = {
					settings = {
						['nil'] = {
							formatting = {
								command = { "nixfmt" },
							},
						},
					}
				},
				biome = {},
			}

			for name, opts in pairs(servers) do
				local cfg = vim.tbl_deep_extend("force", {
					on_attach = on_attach,
					capabilities = capabilities,
				}, opts or {})

				vim.lsp.config(name, cfg)
				vim.lsp.enable(name)
			end
		end
	},
	{
		"hrsh7th/nvim-cmp",
		event = "InsertEnter",
		dependencies = {
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-cmdline",
			"hrsh7th/cmp-nvim-lua",
			"L3MON4D3/LuaSnip",
			"saadparwaiz1/cmp_luasnip",
			"zbirenbaum/copilot.lua",
			"onsails/lspkind.nvim",
		},
		config = function()
			local cmp = require("cmp")
			local luasnip = require("luasnip")
			local lspkind = require("lspkind")

			lspkind.init({
				symbol_map = { Copilot = "" },
			})
			vim.api.nvim_set_hl(0, "CmpItemKindCopilot", { fg = "#6CC644" })

			cmp.setup({
				snippet = {
					expand = function(args) luasnip.lsp_expand(args.body) end,
				},
				mapping = cmp.mapping.preset.insert({
					["<C-Space>"] = cmp.mapping.complete(),
					["<CR>"] = cmp.mapping.confirm({ select = false }),
					["<Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_next_item()
						elseif luasnip.expand_or_jumpable() then
							luasnip.expand_or_jump()
						else
							fallback()
						end
					end, { "i", "s" })
				}),
				sources = {
					{ name = "copilot",  group_index = 2 },
					{ name = "nvim_lsp", group_index = 2 },
					{ name = "luasnip",  group_index = 2 },
					{ name = "path",     group_index = 2 },
					{ name = "nvim_lua", group_index = 2 },
				},
				completion = {
					completeopt = "menu,menuone,preview,noselect"
				},
				window = {
					completion = cmp.config.window.bordered(),
					documentation = cmp.config.window.bordered(),
				},
				formatting = {
					fields = { "abbr", "kind", "menu" },
					format = lspkind.cmp_format({
						mode = "symbol",
						max_width = 50,
						symbol_map = { Copilot = "" },
					})
				},
			})

			cmp.setup.cmdline({ "/", "?" }, {
				mapping = cmp.mapping.preset.cmdline(),
				sources = { { name = "buffer" } },
			})

			cmp.setup.cmdline(":", {
				mapping = cmp.mapping.preset.cmdline(),
				sources = { { name = "cmdline" } },
			})
		end
	},
	{
		"nvimdev/lspsaga.nvim",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			"nvim-tree/nvim-web-devicons",
		},
		config = function()
			require("lspsaga").setup({
				ui = {
					title = false,
					border = "single",
				},
				symbol_in_winbar = {
					enable = true,
					priority = 1000,
				},
				code_action_lightbulb = {
					enable = true,
				},
				show_outline = {
					win_width = 50,
					auto_preview = false,
				},
				definition = {
					keys = {
						edit = 'o',
						vsplit = 'v',
						spilit = 'i',
					},
				},
			})

			local keymap = vim.keymap.set
			-- LSP finder - Find the symbol's definition
			-- If there is no definition, it will instead be hidden
			-- When you use an action in finder like "open vsplit",
			-- you can use <C-t> to jump back
			keymap("n", "gf", "<cmd>Lspsaga finder<CR>")

			keymap({ "n", "v" }, "ga", "<cmd>Lspsaga code_action<CR>")

			-- Peek definition
			-- You can edit the file containing the definition in the floating window
			-- It also supports open/vsplit/etc operations, do refer to "definition_action_keys"
			-- It also supports tagstack
			-- Use <C-t> to jump back
			keymap("n", "gp", "<cmd>Lspsaga peek_definition<CR>")
			keymap("n", "<leader>gp", "<cmd>Lspsaga goto_definition<CR>")

			keymap("n", "gt", "<cmd>Lspsaga peek_type_definition<CR>")
			keymap("n", "<leader>gt", "<cmd>Lspsaga goto_type_definition<CR>")

			-- Go to definition
			-- keymap("n", "gd", "<cmd>Lspsaga goto_definition<CR>")

			-- Show line diagnostics
			-- You can pass argument ++unfocus to
			-- unfocus the show_line_diagnostics floating window
			keymap("n", "<leader>sl", "<cmd>Lspsaga show_line_diagnostics<CR>")

			-- Show buffer diagnostics
			keymap("n", "<leader>sb", "<cmd>Lspsaga show_buf_diagnostics<CR>")

			-- Show workspace diagnostics
			keymap("n", "<leader>sw", "<cmd>Lspsaga show_workspace_diagnostics<CR>")

			-- Show cursor diagnostics
			keymap("n", "<leader>sc", "<cmd>Lspsaga show_cursor_diagnostics<CR>")

			-- Diagnostic jump
			-- You can use <C-o> to jump back to your previous location
			keymap("n", "g]", "<cmd>Lspsaga diagnostic_jump_next<CR>")
			keymap("n", "g[", "<cmd>Lspsaga diagnostic_jump_prev<CR>")

			-- Toggle outline
			keymap("n", "<leader>ou", "<cmd>Lspsaga outline<CR>")

			-- Hover Doc
			-- If there is no hover doc,
			-- there will be a notification stating that
			-- there is no information available.
			-- To disable it just use ":Lspsaga hover_doc ++quiet"
			-- Pressing the key twice will enter the hover window
			-- keymap("n", "K", "<cmd>Lspsaga hover_doc<CR>")
			-- If you want to keep the hover window in the top right hand corner,
			-- you can pass the ++keep argument
			-- Note that if you use hover with ++keep, pressing this key again will
			-- close the hover window. If you want to jump to the hover window
			-- you should use the wincmd command "<C-w>w"
			keymap("n", "K", "<cmd>Lspsaga hover_doc ++keep<CR>")

			-- Call hierarchy
			keymap("n", "<Leader>ci", "<cmd>Lspsaga incoming_calls<CR>")
			keymap("n", "<Leader>co", "<cmd>Lspsaga outgoing_calls<CR>")

			-- keymap("n", "<Leader>t", "<cmd>Lspsaga term_toggle<CR>")
			-- Rename
			-- keymap("n", "<leader>r", "<cmd>Lspsaga lsp_rename ++project<CR>")
		end,
	},
	{
		"ray-x/lsp_signature.nvim",
		event = "InsertEnter",
		config = function()
			local cfg = {} -- add your config here
			require "lsp_signature".setup(cfg)
		end
	},
	{
		"j-hui/fidget.nvim",
		tag = "legacy",
		event = "LspAttach",
		opts = {
			-- options
		},
	},
	{
		"rachartier/tiny-inline-diagnostic.nvim",
		event = "LspAttach",
		priority = 1000, -- needs to be loaded in first
		config = function()
			require('tiny-inline-diagnostic').setup()
			vim.diagnostic.config({ virtual_text = false }) -- Only if needed in your configuration, if you already have native LSP diagnostics
		end
	},
}
