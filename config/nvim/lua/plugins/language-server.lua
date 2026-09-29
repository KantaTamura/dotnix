return {
	{
		"williamboman/mason.nvim",
		cmd = {
			"Mason",
			"MasonInstall",
			"MasonUninstall",
			"MasonUninstallAll",
			"MasonUpdate",
			"MasonLog",
		},
		build = ":MasonUpdate",
		dependencies = {
			"williamboman/mason-lspconfig.nvim",
			"jay-babu/mason-null-ls.nvim",
			"nvimtools/none-ls.nvim",
		},
		config = function()
			require("mason").setup()
			require("mason-lspconfig").setup({
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
					"biome",
					"gh_actions_ls",
					"ts_ls",
				},
			})
			require("mason-null-ls").setup({
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
			})
		end,
	},
	{
		"nvimtools/none-ls.nvim",
		ft = { "c", "cpp", "cs", "java", "cuda", "proto" },
		dependencies = { "nvim-lua/plenary.nvim" },
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
		"neovim/nvim-lspconfig",
		cmd = "LspInfo",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			{ "hrsh7th/cmp-nvim-lsp" },
		},
		config = function()
			-- Mason をロードしなくても、インストール済みサーバーを見つけられるようにする。
			local mason_bin = vim.fs.joinpath(vim.fn.stdpath("data"), "mason", "bin")
			if vim.fn.isdirectory(mason_bin) == 1 then
				local path_separator = vim.fn.has("win32") == 1 and ";" or ":"
				vim.env.PATH = mason_bin .. path_separator .. (vim.env.PATH or "")
			end

			local capabilities = require("cmp_nvim_lsp").default_capabilities()
			local gopls_organize_imports_group = vim.api.nvim_create_augroup("GoplsOrganizeImports", { clear = true })

			local on_attach = function(_, bufnr)
				local map = function(mode, lhs, rhs, desc)
					vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
				end

				map("n", "<leader>f", function() vim.lsp.buf.format { async = true } end,
					"LSP: [F]ormat buffer")

				-- map("n", "K", vim.lsp.buf.hover)
				-- map("n", "gd", vim.lsp.buf.definition)
				map("n", "<leader>r", vim.lsp.buf.rename, "LSP: Rename symbol")
				-- map("n", "ga", vim.lsp.buf.code_action)
			end

			local servers = {
				gopls = {
					settings = {},
					on_attach = function(client, bufnr)
						on_attach(client, bufnr)
						vim.api.nvim_clear_autocmds({ group = gopls_organize_imports_group, buffer = bufnr })
						vim.api.nvim_create_autocmd("BufWritePre", {
							group = gopls_organize_imports_group,
							buffer = bufnr,
							callback = function()
								vim.lsp.buf.code_action({
									context = { only = { "source.organizeImports" } },
									apply = true,
									filter = function(_, client_id)
										return client_id == client.id
									end,
								})
							end,
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
				nixd = {
					settings = {
						nixd = {
							formatting = {
								command = { "nixfmt" },
							},
							nixpkgs = {
								expr = "import <nixpkgs> { }",
							},
						},
					},
				},
				biome = {},
				ts_ls = {},
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
		cmd = { "Lspsaga" },
		keys = {
			{ "gf",         "<cmd>Lspsaga finder<cr>",                     desc = "LSP finder" },
			{ "ga",         "<cmd>Lspsaga code_action<cr>",                mode = { "n", "v" }, desc = "LSP code action" },
			{ "gp",         "<cmd>Lspsaga peek_definition<cr>",            desc = "Peek definition" },
			{ "<leader>gp", "<cmd>Lspsaga goto_definition<cr>",            desc = "Go to definition" },
			{ "gt",         "<cmd>Lspsaga peek_type_definition<cr>",       desc = "Peek type definition" },
			{ "<leader>gt", "<cmd>Lspsaga goto_type_definition<cr>",       desc = "Go to type definition" },
			{ "<leader>sl", "<cmd>Lspsaga show_line_diagnostics<cr>",      desc = "Line diagnostics" },
			{ "<leader>sb", "<cmd>Lspsaga show_buf_diagnostics<cr>",       desc = "Buffer diagnostics" },
			{ "<leader>sw", "<cmd>Lspsaga show_workspace_diagnostics<cr>", desc = "Workspace diagnostics" },
			{ "<leader>sc", "<cmd>Lspsaga show_cursor_diagnostics<cr>",    desc = "Cursor diagnostics" },
			{ "g]",         "<cmd>Lspsaga diagnostic_jump_next<cr>",       desc = "Next diagnostic" },
			{ "g[",         "<cmd>Lspsaga diagnostic_jump_prev<cr>",       desc = "Previous diagnostic" },
			{ "<leader>ou", "<cmd>Lspsaga outline<cr>",                    desc = "LSP outline" },
			{ "K",          "<cmd>Lspsaga hover_doc ++keep<cr>",           desc = "LSP hover" },
			{ "<leader>ci", "<cmd>Lspsaga incoming_calls<cr>",             desc = "Incoming calls" },
			{ "<leader>co", "<cmd>Lspsaga outgoing_calls<cr>",             desc = "Outgoing calls" },
		},
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

		end,
	},
	{
		"ray-x/lsp_signature.nvim",
		event = "LspAttach",
		config = function()
			local cfg = {} -- add your config here
			require "lsp_signature".setup(cfg)
		end
	},
	{
		"j-hui/fidget.nvim",
		version = "*",
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
