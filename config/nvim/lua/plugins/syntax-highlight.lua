local parsers = {
	"go",
	"gosum",
	"gomod",
	"gowork",
	"lua",
	"python",
	"rust",
	"typescript",
	"tsx",
	"vimdoc",
	"vim",
	"kotlin",
	"dockerfile",
	"json",
	"json5",
	"terraform",
	"hcl",
	"bash",
	"c",
	"html",
	"javascript",
	"jsdoc",
	"luadoc",
	"luap",
	"markdown",
	"markdown_inline",
	"query",
	"regex",
	"yaml",
	"zig",
	"bibtex",
	"latex",
}

local treesitter_filetypes = {
	"bash",
	"bib",
	"c",
	"dockerfile",
	"go",
	"gomod",
	"gosum",
	"gowork",
	"hcl",
	"help",
	"html",
	"javascript",
	"javascriptreact",
	"json",
	"json5",
	"jsonc",
	"kotlin",
	"lua",
	"luadoc",
	"markdown",
	"python",
	"query",
	"regex",
	"rust",
	"sh",
	"terraform",
	"tex",
	"typescript",
	"typescriptreact",
	"vim",
	"yaml",
	"zig",
}

return {
	{
		"nvim-treesitter/nvim-treesitter-refactor",
		enabled = false,
	},
	{
		-- Highlight, edit, and navigate code
		"nvim-treesitter/nvim-treesitter",
		branch = "main",
		lazy = false,
		build = ":TSUpdate",
		cond = true,
		config = function()
			vim.treesitter.language.register("json", "jsonc")
			require("nvim-treesitter").install(parsers)

			vim.api.nvim_create_autocmd("FileType", {
				pattern = treesitter_filetypes,
				callback = function()
					local ok = pcall(vim.treesitter.start)
					if ok then
						vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
					end
				end,
			})

			-- Diagnostic keymaps
			vim.keymap.set("n", "[d", function()
				vim.diagnostic.jump({ count = -vim.v.count1, float = true })
			end, { desc = "Go to previous diagnostic message", silent = true })
			vim.keymap.set("n", "]d", function()
				vim.diagnostic.jump({ count = vim.v.count1, float = true })
			end, { desc = "Go to next diagnostic message", silent = true })
			vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "Open floating diagnostic message" })
			vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostics list" })
		end,
	},
}
