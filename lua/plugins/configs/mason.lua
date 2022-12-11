local present, mason = pcall(require, "mason")

if not present then
	vim.notify("mason not installed")
	return
end

local ok, mlsp = pcall(require, "mason-lspconfig")
if not ok then
	vim.notify("mason-lspconfig not installed")
	return
end

local options = {
	ui = {
		icons = {
			package_pending = " ",
			package_installed = " ",
			package_uninstalled = " ﮊ",
		},

		keymaps = {
			toggle_server_expand = "<CR>",
			install_server = "i",
			update_server = "u",
			check_server_version = "c",
			update_all_servers = "U",
			check_outdated_servers = "C",
			uninstall_server = "X",
			cancel_installation = "<C-c>",
		},
	},

	max_concurrent_installers = 10,
}

local ensure_installed = {
	"autopep8",
	"black",
	"debugpy",
	"flake8",
	"gopls",
	"hadolint",
	"mypy",
	"stylua",
}

vim.api.nvim_create_user_command("MasonInstallAll", function()
  vim.cmd("MasonInstall " .. table.concat(ensure_installed, " "))
end, {})


mason.setup(options)
local servers = {
	"bashls",
	"diagnosticls",
	"dockerls",
	"jedi_language_server",
	"jsonls",
	-- "lua-language-server",
	"sqls",
	"sumneko_lua",
	"terraformls",
	"tflint",
	"yamlls",
}

mlsp.setup({
	automatic_installation = true,
	ensure_installed = servers,
})
