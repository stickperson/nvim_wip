local opt = vim.opt
local g = vim.g
local onenord_exists, onenord = pcall(require, "onenord")
if onenord_exists then
	vim.cmd "colorscheme onenord"
	onenord.setup({
		fade_nc = true,
		styles = {
			--   comments = 'italic',
			--   strings = 'NONE',
			--   keywords = 'NONE',
			--   functions = 'italic',
			-- variables = 'bold',
			-- diagnostics = 'bold',
		},
	})
end

g.toggle_theme_icon = "   "
g.theme_switcher_loaded = false

opt.laststatus = 3 -- global statusline
opt.showmode = false

opt.title = true
opt.clipboard = "unnamedplus"
opt.cursorline = true
--
-- Indenting
opt.expandtab = true
opt.shiftwidth = 2
opt.smartindent = true
opt.tabstop = 2
opt.softtabstop = 2

opt.colorcolumn = "120"
opt.fillchars = { eob = " " }
opt.ignorecase = true
opt.smartcase = true
opt.mouse = "a"

-- Numbers
opt.number = true
opt.numberwidth = 2
opt.ruler = false

-- disable nvim intro
opt.shortmess:append("sI")

opt.signcolumn = "yes"
opt.splitbelow = true
opt.splitright = true
opt.termguicolors = true
opt.timeoutlen = 400
opt.undofile = true

-- interval for writing swap file to disk, also used by gitsigns
opt.updatetime = 250

-- go to previous/next line with h,l,left arrow and right arrow
-- when cursor reaches end/beginning of line
opt.whichwrap:append("<>[]hl")

g.mapleader = " "

-- This must come after termguicolor is set to true
local ok, notify = pcall(require, "notify")
if ok then
	vim.notify = notify
end

-- disable some builtin vim plugins
local default_plugins = {
	"2html_plugin",
	"getscript",
	"getscriptPlugin",
	"gzip",
	"logipat",
	"netrw",
	"netrwPlugin",
	"netrwSettings",
	"netrwFileHandlers",
	"matchit",
	"tar",
	"tarPlugin",
	"rrhelper",
	"spellfile_plugin",
	"vimball",
	"vimballPlugin",
	"zip",
	"zipPlugin",
	"tutor",
	"rplugin",
	"syntax",
	"synmenu",
	"optwin",
	"compiler",
	"bugreport",
	"ftplugin",
}

for _, plugin in pairs(default_plugins) do
	g["loaded_" .. plugin] = 1
end

local default_providers = {
	"node",
	"perl",
	"python3",
	"ruby",
}

for _, provider in ipairs(default_providers) do
	vim.g["loaded_" .. provider .. "_provider"] = 0
end

-- Send cursor to last position when opening a file
vim.api.nvim_create_autocmd({ "BufReadPost" }, {
	pattern = { "?*" },
	callback = function()
		local ft = vim.opt_local.filetype:get()
		-- don't apply to git messages
		if ft:match("commit") or ft:match("rebase") then
			return
		end
		-- get position of last saved edit
		local markpos = vim.api.nvim_buf_get_mark(0, '"')
		local line = markpos[1]
		local col = markpos[2]
		-- if in range, go there
		if (line > 1) and (line <= vim.api.nvim_buf_line_count(0)) then
			vim.api.nvim_win_set_cursor(0, { line, col })
		end
	end,
})

local remember_folds = vim.api.nvim_create_augroup("RememberFolds", { clear = true })
vim.api.nvim_create_autocmd({ "BufWinLeave" }, {
	pattern = { "?*" },
	command = "mkview",
	group = remember_folds,
})

vim.api.nvim_create_autocmd({ "BufWinEnter" }, {
	pattern = { "?*" },
	command = "silent! loadview",
	group = remember_folds,
})

vim.api.nvim_create_autocmd({ "BufWritePre" }, {
	pattern = { "*.tf", "*.tfvars" },
	callback = vim.lsp.buf.formatting_sync,
})

-- Use tabs for lua files
vim.api.nvim_create_autocmd("FileType", {
	pattern = "lua",
	callback = function()
		vim.opt_local.shiftwidth = 2
		vim.opt_local.tabstop = 2
		vim.opt_local.expandtab = false
	end
})

pcall(require, "work")
