local present, lspconfig = pcall(require, "lspconfig")

if not present then
	return
end

local M = {}
local utils = require("core.utils")

-- export on_attach & capabilities for custom lspconfigs

M.on_attach = function(client, bufnr)
	client.server_capabilities.documentFormattingProvider = false
	client.server_capabilities.documentRangeFormattingProvider = false

	utils.load_mappings("lspconfig", { buffer = bufnr })
end

M.capabilities = vim.lsp.protocol.make_client_capabilities()

M.capabilities.textDocument.completion.completionItem = {
	documentationFormat = { "markdown", "plaintext" },
	snippetSupport = true,
	preselectSupport = true,
	insertReplaceSupport = true,
	labelDetailsSupport = true,
	deprecatedSupport = true,
	commitCharactersSupport = true,
	tagSupport = { valueSet = { 1 } },
	resolveSupport = {
		properties = {
			"documentation",
			"detail",
			"additionalTextEdits",
		},
	},
}

local servers = {
	"bashls",
	-- "diagnosticls",
	"dockerls",
	"jedi_language_server",
	"jsonls",
	"sqls",
	"sumneko_lua",
	"terraformls",
	"tflint",
	"yamlls",
}

local server_settings = {
	["sumneko_lua"] = {
		Lua = {
			diagnostics = {
				globals = { "vim" },
			},
			workspace = {
				library = {
					[vim.fn.expand("$VIMRUNTIME/lua")] = true,
					[vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true,
				},
				maxPreload = 100000,
				preloadFileSize = 10000,
			},
		},
	},
}

for _, server in ipairs(servers) do
	local settings = server_settings[server] or {}
	lspconfig[server].setup({
		on_attach = M.on_attach,
		capabilities = M.capabilities,
		settings = settings,
	})
end

return M
