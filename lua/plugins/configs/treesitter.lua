local present, treesitter = pcall(require, "nvim-treesitter.configs")

if not present then
	return
end

local options = {
	ensure_installed = {
		"dockerfile",
		"hcl",
		"json",
		"lua",
		"python",
	},

	highlight = {
		enable = true,
		use_languagetree = true,
	},

	-- treesitter messes up indentation for python
	indent = {
		enable = false,
	},
}

treesitter.setup(options)
