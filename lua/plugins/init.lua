local plugins = {
  ["nvim-lua/plenary.nvim"] = { module = "plenary" },

  ["lewis6991/impatient.nvim"] = {},

  ["wbthomason/packer.nvim"] = {
    cmd = {
    "PackerSnapshot",
    "PackerSnapshotRollback",
    "PackerSnapshotDelete",
    "PackerInstall",
    "PackerUpdate",
    "PackerSync",
    "PackerClean",
    "PackerCompile",
    "PackerStatus",
    "PackerProfile",
    "PackerLoad",
  },

    config = function()
      require "plugins"
    end,
  },

  ["kyazdani42/nvim-web-devicons"] = {
    module = "nvim-web-devicons",
  },
  ["rmehri01/onenord.nvim"] = {},

  ["nvim-lualine/lualine.nvim"] = {
    config = function()
      require('lualine').setup {
        options = {
          theme = "onenord"
        }
      }
    end
  },

  -- Must come after devicons
  ["akinsho/bufferline.nvim"] = {
    config = function ()
      require("plugins.configs.bufferline")
    end
  },

  -- ["moll/vim-bbye"] = {},

  ["lukas-reineke/indent-blankline.nvim"] = {
    opt = true,
    setup = function()
      require("core.lazy_load").on_file_open "indent-blankline.nvim"
      require("core.utils").load_mappings "blankline"
    end,
    config = function()
      require("plugins.configs.others").blankline()
    end,
  },
  ["nvim-treesitter/nvim-treesitter"] = {
    module = "nvim-treesitter",
    setup = function()
      require("core.lazy_load").on_file_open "nvim-treesitter"
    end,
    cmd = require("core.lazy_load").treesitter_cmds,
    run = ":TSUpdate",
    config = function()
      require "plugins.configs.treesitter"
    end,
  },

  -- git stuff
  ["lewis6991/gitsigns.nvim"] = {
    ft = "gitcommit",
    setup = function()
      require("core.lazy_load").gitsigns()
    end,
    config = function()
      require("plugins.configs.others").gitsigns()
    end,
  },

  -- lsp stuff
  ["williamboman/mason.nvim"] = {
    requires = {"williamboman/mason-lspconfig.nvim"},
    -- cmd = require("core.lazy_load").mason_cmds,
    config = function()
      require "plugins.configs.mason"
    end,
  },

  ["neovim/nvim-lspconfig"] = {
    opt = true,
    setup = function()
      require("core.lazy_load").on_file_open "nvim-lspconfig"
    end,
    config = function()
      require "plugins.configs.lspconfig"
    end,
  },
 ["jose-elias-alvarez/null-ls.nvim"] = {
    after = "nvim-lspconfig",
    config = function()
      require "plugins.configs.null-ls"
    end,
 },

  -- load luasnips + cmp related in insert mode only

  ["rafamadriz/friendly-snippets"] = {
    module = { "cmp", "cmp_nvim_lsp" },
    event = "InsertEnter",
  },

  ["hrsh7th/nvim-cmp"] = {
    after = "friendly-snippets",
    config = function()
      require "plugins.configs.cmp"
    end,
  },

  ["L3MON4D3/LuaSnip"] = {
    wants = "friendly-snippets",
    after = "nvim-cmp",
    config = function()
      require("plugins.configs.others").luasnip()
    end,
  },

  ["saadparwaiz1/cmp_luasnip"] = { after = "LuaSnip" },
  ["hrsh7th/cmp-nvim-lua"] = { after = "cmp_luasnip" },
  ["hrsh7th/cmp-nvim-lsp"] = { after = "cmp-nvim-lua" },
  ["hrsh7th/cmp-buffer"] = { after = "cmp-nvim-lsp" },
  ["hrsh7th/cmp-path"] = { after = "cmp-buffer" },

  -- misc plugins
  ["windwp/nvim-autopairs"] = {
    after = "nvim-cmp",
    config = function()
      require("plugins.configs.others").autopairs()
    end,
  },

  ["goolord/alpha-nvim"] = {
    disable = true,
    config = function()
      require "plugins.configs.alpha"
    end,
  },

  ["numToStr/Comment.nvim"] = {
    module = "Comment",
    keys = { "gc", "gb" },
    config = function()
      require("plugins.configs.others").comment()
    end,
    setup = function()
      require("core.utils").load_mappings "comment"
    end,
  },

  ["rcarriga/nvim-notify"] = {
    config = function()
      require("notify").setup({
        background_colour = "#000000"
      })
    end
  },

  ["ellisonleao/glow.nvim"] = {
    ft = "markdown",
    -- config = require("glow").setup()
  },

  -- file managing , picker etc
  ["kyazdani42/nvim-tree.lua"] = {
    ft = "alpha",
    cmd = { "NvimTreeToggle", "NvimTreeFocus" },
    config = function()
      require "plugins.configs.nvimtree"
    end,
    setup = function()
      require("core.utils").load_mappings "nvimtree"
    end,
  },

  ["nvim-telescope/telescope.nvim"] = {
    cmd = "Telescope",
    config = function()
      require "plugins.configs.telescope"
    end,
    setup = function()
      require("core.utils").load_mappings "telescope"
    end,
  },

  -- Only load whichkey after all the gui
  ["folke/which-key.nvim"] = {
    module = "which-key",
    keys = { "<leader>", '"', "'", "`" },
    config = function()
      require "plugins.configs.whichkey"
    end,
    setup = function()
      require("core.utils").load_mappings "whichkey"
    end,
  },
}

local final_table = {}

for key, val in pairs(plugins) do
	if val and type(val) == "table" then
		plugins[key] = val.rm_default_opts and user_plugins[key] or plugins[key]
		plugins[key][1] = key
		final_table[#final_table + 1] = plugins[key]
	end
end

local present, packer = pcall(require, "packer")
if present then
  local init_options = {
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
        return require("packer.util").float { border = "single" }
      end,
    },
  }

  packer.init(init_options)
  packer.startup { final_table }
  -- packer.startup(function(use)
  --   for _, plugin in pairs(final_table) do
  --     use(plugin)
  --   end
  -- end)
end
-- return require('packer').startup(function(use)
-- 	for _, plugin in pairs(final_table) do
-- 		use(plugin)
-- 	end
--   -- use 'wbthomason/packer.nvim'
--   -- My plugins here
--   -- use 'foo1/bar1.nvim'
--   -- use 'foo2/bar2.nvim'
-- 
--   -- Automatically set up your configuration after cloning packer.nvim
--   -- Put this at the end after all plugins
--   -- if packer_bootstrap then
--   --   require('packer').sync()
--   -- end
-- end)
