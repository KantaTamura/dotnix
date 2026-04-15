if vim.loader then
	vim.loader.enable()
end

do
	local ok, err = pcall(require, "core.lazynvim")
	if not ok then
		vim.notify(("Error loading core.lazynvim: %s"):format(err), vim.log.levels.ERROR)
	end
end

local core_modules = {
	"options",
	"autocmd",
	"keymaps",
}
for _, module in ipairs(core_modules) do
	local ok, err = pcall(require, "core." .. module)
	if not ok then
		vim.notify(("Error loading core.%s: %s"):format(module, err), vim.log.levels.ERROR)
	end
end

local env_module_map = {
	{ cond = vim.g.vscode,                                    module = "vscode" },
	{ cond = vim.g.neovide,                                   module = "neovide" },
	{ cond = vim.fn.has("wsl") == 1,                          module = "clipboard-wsl" },
	{ cond = os.getenv("SSH_CLIENT") or os.getenv("SSH_TTY"), module = "clipboard-osc" },
}
for _, entry in ipairs(env_module_map) do
	if entry.cond then
		local ok, err = pcall(require, "env." .. entry.module)
		if not ok then
			vim.notify(("Error loading env.%s: %s"):format(entry.module, err), vim.log.levels.ERROR)
		end
	end
end
