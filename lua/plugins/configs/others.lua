local M = {}

local utils = require("core.utils")

M.autopairs = function()
	local present1, autopairs = pcall(require, "nvim-autopairs")
	local present2, cmp = pcall(require, "cmp")

	if not (present1 and present2) then
		return
	end

	local options = {
		fast_wrap = {},
		disable_filetype = { "TelescopePrompt", "vim" },
	}

	autopairs.setup(options)

	local cmp_autopairs = require("nvim-autopairs.completion.cmp")
	cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
end

M.blankline = function()
	local present, blankline = pcall(require, "indent_blankline")

	if not present then
		return
	end

	local options = {
		indentLine_enabled = 1,
		filetype_exclude = {
			"help",
			"terminal",
			"alpha",
			"packer",
			"lspinfo",
			"TelescopePrompt",
			"TelescopeResults",
			"mason",
			"",
		},
		buftype_exclude = { "terminal" },
		show_trailing_blankline_indent = false,
		show_first_indent_level = false,
		show_current_context = true,
		show_current_context_start = true,
	}

	blankline.setup(options)
end

M.comment = function()
	local present, nvim_comment = pcall(require, "Comment")

	if not present then
		return
	end

	local options = {}
	nvim_comment.setup(options)
end

M.luasnip = function()
	local present, luasnip = pcall(require, "luasnip")

	if not present then
		return
	end

	local options = {
		history = true,
		updateevents = "TextChanged,TextChangedI",
	}

	luasnip.config.set_config(options)
	require("luasnip.loaders.from_vscode").lazy_load({ paths = vim.g.luasnippets_path or "" })
	require("luasnip.loaders.from_vscode").lazy_load()

	vim.api.nvim_create_autocmd("InsertLeave", {
		callback = function()
			if
				require("luasnip").session.current_nodes[vim.api.nvim_get_current_buf()]
				and not require("luasnip").session.jump_active
			then
				require("luasnip").unlink_current()
			end
		end,
	})
end

M.gitsigns = function()
	local present, gitsigns = pcall(require, "gitsigns")

	if not present then
		return
	end

	local options = {
		on_attach = function(bufnr)
			utils.load_mappings("gitsigns", { buffer = bufnr })
		end,
	}

	gitsigns.setup(options)
end

M.packer_init = function()
	return {
		auto_clean = true,
		compile_on_sync = true,
		git = { clone_timeout = 6000 },
		display = {
			working_sym = "ﲊ",
			error_sym = "✗ ",
			done_sym = " ",
			removed_sym = " ",
			moved_sym = "",
			open_fn = function()
				return require("packer.util").float({ border = "single" })
			end,
		},
	}
end

return M
