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
      require("plugins")
    end,
  },

  ["kyazdani42/nvim-web-devicons"] = {
    module = "nvim-web-devicons",
  },
  ["rmehri01/onenord.nvim"] = {},

  ["nvim-lualine/lualine.nvim"] = {
    config = function()
      require("lualine").setup({
        options = {
          theme = "onenord",
        },
        sections = {
          -- include path in filename
          lualine_c = { { "filename", path = 1 } },
        },
        inactive_sections = {
          lualine_c = { { "filename", path = 1 } },
        },
      })
    end,
  },

  -- Start bufferline
  -- Must come after devicons
  ["akinsho/bufferline.nvim"] = {
    config = function()
      require("plugins.configs.bufferline")
      require("core.utils").load_mappings("bufferline")
    end,
  },

  -- Improved buffer handling
  ["moll/vim-bbye"] = {},
  -- End bufferline

  ["lukas-reineke/indent-blankline.nvim"] = {
    opt = true,
    setup = function()
      require("core.lazy_load").on_file_open("indent-blankline.nvim")
      require("core.utils").load_mappings("blankline")
    end,
    config = function()
      require("plugins.configs.others").blankline()
    end,
  },

  -- Start treesitter
  ["nvim-treesitter/nvim-treesitter"] = {
    module = "nvim-treesitter",
    setup = function()
      require("core.lazy_load").on_file_open("nvim-treesitter")
    end,
    cmd = require("core.lazy_load").treesitter_cmds,
    run = ":TSUpdate",
    config = function()
      require("plugins.configs.treesitter")
    end,
  },

  ["nvim-treesitter/nvim-treesitter-textobjects"] = {
    -- run = ":TSUpdate",
    -- after = "nvim-treesitter",
  },

  ["p00f/nvim-ts-rainbow"] = {
    after = "nvim-treesitter",
  },
  -- End treesitter

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
    requires = { "williamboman/mason-lspconfig.nvim" },
    config = function()
      require("plugins.configs.mason")
    end,
  },

  ["neovim/nvim-lspconfig"] = {
    opt = true,
    setup = function()
      require("core.lazy_load").on_file_open("nvim-lspconfig")
    end,
    config = function()
      require("plugins.configs.lspconfig")
    end,
  },
  ["jose-elias-alvarez/null-ls.nvim"] = {
    after = "nvim-lspconfig",
    config = function()
      require("plugins.configs.null-ls")
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
      require("plugins.configs.cmp")
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
    config = function()
      require("plugins.configs.alpha")
    end,
  },

  ["numToStr/Comment.nvim"] = {
    module = "Comment",
    keys = { "gc", "gb" },
    config = function()
      require("plugins.configs.others").comment()
    end,
    setup = function()
      require("core.utils").load_mappings("comment")
    end,
  },

  ["rcarriga/nvim-notify"] = {
    config = function()
      require("notify").setup({
        background_colour = "#000000",
      })
    end,
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
      require("plugins.configs.nvimtree")
    end,
    setup = function()
      require("core.utils").load_mappings("nvimtree")
    end,
  },

  ["nvim-telescope/telescope.nvim"] = {
    cmd = "Telescope",
    module = "telescope.builtin",
    config = function()
      require("plugins.configs.telescope")
    end,
    setup = function()
      require("core.utils").load_mappings("telescope")
    end,
  },

  ["nvim-telescope/telescope-fzf-native.nvim"] = {
    run = "make",
  },

  -- Only load whichkey after all the gui
  ["folke/which-key.nvim"] = {
    module = "which-key",
    keys = { "<leader>", '"', "'", "`" },
    config = function()
      require("plugins.configs.whichkey")
    end,
    setup = function()
      require("core.utils").load_mappings("whichkey")
    end,
  },

  -- DAP
  ["mfussenegger/nvim-dap"] = {
    module = "dap",
    config = function()
      require("plugins.configs.dap")
    end,
  },

  -- Debugger UI
  ["rcarriga/nvim-dap-ui"] = {
    after = "nvim-dap",
    config = function()
      require("plugins.configs.dap_ui")
    end,
  },
  ["mfussenegger/nvim-dap-python"] = {
    after = "nvim-dap",
    config = function()
      require("plugins.configs.dap_python")
    end,
  },
  -- End DAP

  ["ANGkeith/telescope-terraform-doc.nvim"] = {},

  ["hashivim/vim-terraform"] = {},

  ["ThePrimeagen/harpoon"] = {
    after = "telescope.nvim",
    module = "harpoon.mark",
    setup = function()
      require("core.utils").load_mappings("harpoon")
    end,
  },

  -- Experimenting
  ["shortcuts/no-neck-pain.nvim"] = {
    config = function()
      require("no-neck-pain").setup()
    end,
  },

  ["mbbill/undotree"] = {
    cmd = "UndotreeToggle",
    config = function()
      require("core.utils").load_mappings("undotree")
    end,
  },

  ["phaazon/mind.nvim"] = {
    branch = "v2.2",
    cmd = {
      "MindOpenMain",
    },
    config = function()
      require("mind").setup()
    end,
  },

  -- Improved UI hooks. E.g. lsp rename
  ["stevearc/dressing.nvim"] = {},
}

local final_table = {}

for key, val in pairs(plugins) do
  if val and type(val) == "table" then
    plugins[key] = val.rm_default_opts or plugins[key]
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
        return require("packer.util").float({ border = "single" })
      end,
    },
  }

  packer.init(init_options)
  packer.startup({ final_table })
end
