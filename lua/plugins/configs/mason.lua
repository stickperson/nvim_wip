local present, mason = pcall(require, "mason")

if not present then
  vim.notify("mason not installed")
  return
end

local present, mlsp = pcall(require, 'mason-lspconfig')
if not present then
  vim.notify("mason-lspconfig not installed")
  return
end

vim.api.nvim_create_augroup("_mason", { clear = true })
vim.api.nvim_create_autocmd("Filetype", {
  pattern = "mason",
  callback = function()
    -- require("base46").load_highlight "mason"
  end,
  group = "_mason",
})

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

-- vim.api.nvim_create_user_command("MasonInstallAll", function()
--   vim.cmd("MasonInstall " .. table.concat(options.ensure_installed, " "))
-- end, {})

mason.setup(options)
local servers = {
  'bashls',
  'dockerls',
  'jedi_language_server',
  'jsonls',
  'sqls',
  'sumneko_lua',
  'terraformls',
  'tflint',
  'yamlls',
}

mlsp.setup {
  automatic_installation = true,
  ensure_installed = servers,
}


-- local lspconfig = require "lspconfig"
-- for _, server in ipairs(servers) do
--   lspconfig[server].setup {}
-- end

