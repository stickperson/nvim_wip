local present, null_ls = pcall(require, "null-ls")

if not present then
	vim.notify("null-ls not present")
	return
end

local b = null_ls.builtins

local sources = {

	-- webdev stuff
	-- b.formatting.deno_fmt,
	-- b.formatting.prettier,

	-- Lua
	b.formatting.stylua,

	-- Shell
	b.formatting.shfmt,
	b.diagnostics.shellcheck.with({ diagnostics_format = "#{m} [#{c}]" }),

	-- Python
	b.diagnostics.flake8,
	b.diagnostics.mypy,
	b.formatting.black,
}

null_ls.setup({
	debug = false,
	sources = sources,
})
