-- Restore the last cursor position after filetype detection.
local restore_cursor_group = vim.api.nvim_create_augroup("RestoreCursor", { clear = true })

vim.api.nvim_create_autocmd("BufReadPre", {
	group = restore_cursor_group,
	desc = "Restore the last cursor position",
	callback = function(args)
		vim.api.nvim_create_autocmd("FileType", {
			group = restore_cursor_group,
			buffer = args.buf,
			once = true,
			callback = function()
				local filetype = vim.bo[args.buf].filetype
				local line = vim.api.nvim_buf_get_mark(args.buf, '"')[1]
				local line_count = vim.api.nvim_buf_line_count(args.buf)

				if line < 1
					or line > line_count
					or filetype:find("commit", 1, true)
					or filetype == "xxd"
					or filetype == "gitrebase"
					or vim.wo.diff
				then
					return
				end

				vim.api.nvim_buf_call(args.buf, function()
					vim.cmd.normal({ 'g`"', bang = true })
				end)
			end,
		})
	end,
})
-- vim.api.nvim_create_autocmd({ "BufWritePre" }, {
--     buffer = buffer,
--     callback = function()
--         vim.lsp.buf.format { async = false }
--     end
-- })
local ar_grp = vim.api.nvim_create_augroup("AutoRead", { clear = true })
vim.api.nvim_create_autocmd(
	{ "FocusGained", "BufEnter", "TermClose", "TermLeave" },
	{ group = ar_grp, command = "checktime" }
)

----------------------------------------------------------------------
-- LSP ドキュメントハイライト
--  - 自動（CursorHold/CursorMoved/InsertEnter）
--  - 手動（<Leader>h で強調 / <Leader>H で解除）
----------------------------------------------------------------------

local doc_highlight_group = vim.api.nvim_create_augroup("DocHighlight", { clear = true })

local function set_normal_reference_highlight()
	vim.cmd([[hi! link LspReferenceText  CursorLine]])
	vim.cmd([[hi! link LspReferenceRead  CursorLine]])
	vim.cmd([[hi! link LspReferenceWrite CursorLine]])
end

local function set_strong_reference_highlight()
	vim.cmd([[hi! link LspReferenceText  IncSearch]])
	vim.cmd([[hi! link LspReferenceRead  IncSearch]])
	vim.cmd([[hi! link LspReferenceWrite IncSearch]])
end

vim.api.nvim_create_autocmd("LspAttach", {
	group = doc_highlight_group,
	callback = function(args)
		local bufnr = args.buf
		local client = vim.lsp.get_client_by_id(args.data.client_id)

		if not (client and client.server_capabilities.documentHighlightProvider) then
			return
		end

		-- 複数のLSPが同じバッファへattachしても、一組だけ作る。
		if vim.b[bufnr].doc_highlight_configured then
			return
		end
		vim.b[bufnr].doc_highlight_configured = true
		set_normal_reference_highlight()

		vim.api.nvim_create_autocmd("CursorHold", {
			buffer = bufnr,
			group = doc_highlight_group,
			callback = function()
				if not vim.b[bufnr].doc_highlight_persistent then
					vim.lsp.buf.document_highlight()
				end
			end,
		})

		vim.api.nvim_create_autocmd({ "CursorMoved", "InsertEnter" }, {
			buffer = bufnr,
			group = doc_highlight_group,
			callback = function()
				if not vim.b[bufnr].doc_highlight_persistent then
					vim.lsp.util.buf_clear_references(bufnr)
				end
			end,
		})

		vim.keymap.set("n", "<leader>hl", function()
			vim.b[bufnr].doc_highlight_persistent = false
			vim.lsp.util.buf_clear_references(bufnr)
			vim.b[bufnr].doc_highlight_persistent = true
			set_strong_reference_highlight()
			vim.lsp.buf.document_highlight()
		end, { buffer = bufnr, desc = "LSP: 強調ハイライト開始" })

		vim.keymap.set("n", "<leader>Hl", function()
			vim.b[bufnr].doc_highlight_persistent = false
			vim.lsp.util.buf_clear_references(bufnr)
			set_normal_reference_highlight()
		end, { buffer = bufnr, desc = "LSP: 強調ハイライト解除" })

		vim.api.nvim_create_autocmd("LspDetach", {
			buffer = bufnr,
			group = doc_highlight_group,
			callback = function()
				-- LspDetach処理の完了後に、対応クライアントが残っているか確認する。
				vim.schedule(function()
					if not vim.api.nvim_buf_is_valid(bufnr) then
						return
					end

					local clients = vim.lsp.get_clients({
						bufnr = bufnr,
						method = "textDocument/documentHighlight",
					})
					if #clients > 0 then
						return
					end

					vim.lsp.util.buf_clear_references(bufnr)
					vim.b[bufnr].doc_highlight_persistent = nil
					vim.b[bufnr].doc_highlight_configured = nil
					vim.api.nvim_clear_autocmds({ group = doc_highlight_group, buffer = bufnr })
				end)
			end,
		})
	end,
})
