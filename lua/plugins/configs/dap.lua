vim.api.nvim_set_hl(0, "DapBreakpoint", { fg = "#e8274b" })
vim.api.nvim_set_hl(0, "DapGreen", { fg = "#00FF00" })
vim.fn.sign_define("DapBreakpoint", { text = "", texthl = "DapBreakpoint", linehl = "" })
vim.fn.sign_define("DapStopped", { text = "", texthl = "DapGreen", linehl = "RedrawDebugComposed" })

-- local dap = require("dap")
-- dap.configurations.python = {
--   {
--     -- The first three options are required by nvim-dap
--     type = 'python'; -- the type here established the link to the adapter definition: `dap.adapters.python`
--     request = 'launch';
--     name = "Launch file (venv enabled)" ;
--     console = "integratedTerminal",
--     program = '${file}';
--     pythonPath = function()
--       local venv_path = os.getenv('VIRTUAL_ENV') or os.getenv('CONDA_PREFIX')
--       if venv_path then
--         return venv_path .. '/bin/python'
--       end
--     end;
--   },
-- }
