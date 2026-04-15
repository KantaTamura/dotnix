-- when opening a file, restore cursor location
vim.api.nvim_create_autocmd({ "BufReadPost" }, {
	pattern = { "*" },
	callback = function()
		vim.api.nvim_exec('silent! normal! g`"zv', false)
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
	{ "FocusGained", "BufEnter", "CursorHold", "CursorHoldI", "TermClose", "TermLeave" },
	{ group = ar_grp, command = "checktime" }
)

----------------------------------------------------------------------
-- LSP ドキュメントハイライト
--  - 自動（CursorHold/CursorMoved）
--  - 手動（<Leader>h で強調 / <Leader>H で解除）
----------------------------------------------------------------------

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('DocHighlight', { clear = true }),
  callback = function(args)
    local bufnr  = args.buf
    local client = vim.lsp.get_client_by_id(args.data.client_id)

    -- この LSP が documentHighlightProvider を持たなければ何もしない
    if not (client and client.server_capabilities.documentHighlightProvider) then
      return
    end

    ------------------------------------------------------------------
    -- 1. ハイライト色の定義
    ------------------------------------------------------------------
    -- 通常（自動）: 目立ちすぎない色
    local function set_normal_hl()
      vim.cmd [[hi! link LspReferenceText  CursorLine]]
      vim.cmd [[hi! link LspReferenceRead  CursorLine]]
      vim.cmd [[hi! link LspReferenceWrite CursorLine]]
    end

    -- 強調（手動）: ガツンと目立つ色
    local function set_strong_hl()
      vim.cmd [[hi! link LspReferenceText  IncSearch]]
      vim.cmd [[hi! link LspReferenceRead  IncSearch]]
      vim.cmd [[hi! link LspReferenceWrite IncSearch]]
    end

    set_normal_hl()       -- 起動時は通常色

    ------------------------------------------------------------------
    -- 2. 自動ハイライト（従来どおり）
    ------------------------------------------------------------------
    local aug = vim.api.nvim_create_augroup('DocHL_' .. bufnr, { clear = false })

    vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
      buffer = bufnr,
      group  = aug,
      callback = function()
        -- 手動モード中は自動ハイライトしない
        if not vim.b.doc_highlight_persistent then
          vim.lsp.buf.document_highlight()
        end
      end,
    })

    vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
      buffer = bufnr,
      group  = aug,
      callback = function()
        -- 手動モード中はクリアしない
        if not vim.b.doc_highlight_persistent then
          vim.lsp.buf.clear_references()
        end
      end,
    })

    ------------------------------------------------------------------
    -- 3. キーバインド（手動ハイライトの開始／終了）
    ------------------------------------------------------------------
    local function map(lhs, rhs, desc)
      vim.keymap.set('n', lhs, rhs, { buffer = bufnr, desc = desc })
    end

    -- <Leader>h で「強調ハイライトを付けて保持」
    map('<leader>hl', function()
      vim.b.doc_highlight_persistent = false
      vim.lsp.buf.clear_references()
      vim.b.doc_highlight_persistent = true
      set_strong_hl()
      vim.lsp.buf.document_highlight()
    end, 'LSP: 強調ハイライト開始')

    -- <Leader>H で解除して通常色に戻す
    map('<leader>Hl', function()
      vim.b.doc_highlight_persistent = false
      vim.lsp.buf.clear_references()
      set_normal_hl()
    end, 'LSP: 強調ハイライト解除')

    ------------------------------------------------------------------
    -- 4. LSP Detach 時の後片付け
    ------------------------------------------------------------------
    vim.api.nvim_create_autocmd('LspDetach', {
      buffer = bufnr,
      once   = true,
      callback = function()
        vim.b.doc_highlight_persistent = nil
        vim.api.nvim_clear_autocmds { group = aug, buffer = bufnr }
      end,
    })
  end,
})
